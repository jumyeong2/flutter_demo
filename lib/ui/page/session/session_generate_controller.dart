import 'package:get/get.dart';
import '../../../data/repository/firestore_repo.dart';
import '../../../data/model/session.dart';
import '../../../data/model/document.dart';
import '../../../service/company_key_cache_service.dart';
import '../../../router/routes.dart';

/// SessionGenerateController: 문서 생성 페이지 컨트롤러
class SessionGenerateController extends GetxController {
  late final FirestoreRepository _repo;
  late final CompanyKeyCacheService _cacheService;

  final RxString sessionId = ''.obs;
  final Rx<Session?> session = Rx<Session?>(null);
  final RxString companyKey = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool isGenerating = false.obs;

  @override
  void onInit() {
    super.onInit();
    _repo = Get.find<FirestoreRepository>();
    _cacheService = Get.find<CompanyKeyCacheService>();

    // 세션 ID 가져오기 (라우트 파라미터)
    final routeParams = Get.parameters;
    if (routeParams.containsKey('sessionId')) {
      sessionId.value = routeParams['sessionId']!;
      loadSession();
    }

    // companyKey 가져오기
    companyKey.value = _cacheService.getCachedCompanyKey() ?? '';
  }

  /// 세션 로드
  Future<void> loadSession() async {
    try {
      isLoading.value = true;
      final sessionData = await _repo.getSession(sessionId.value);
      session.value = sessionData;

      // 게이팅: confirmedQuestionIds >= 8 검증
      if (sessionData != null) {
        final confirmedCount = sessionData.confirmedQuestionIds.length;
        if (confirmedCount < 8) {
          Get.snackbar(
            '오류',
            '합의 확정이 8개 미만입니다. (현재: $confirmedCount개)',
          );
          Get.back();
        }
      }
    } catch (e) {
      Get.snackbar('오류', '세션 정보를 불러올 수 없습니다: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// 문서 생성
  /// 
  /// 1. documents/{docId} 생성(companyKey, sessionId, createdAt, summary1p, decisionLogs, version)
  /// 2. sessions.status='final', sessions.finalDocId=docId
  /// 3. companies.latestDocId=docId 업데이트
  /// 4. 생성 완료 후 /doc/:docId로 이동
  Future<void> generateDocument() async {
    try {
      isGenerating.value = true;

      final sessionData = session.value;
      if (sessionData == null) {
        Get.snackbar('오류', '세션 정보를 불러올 수 없습니다');
        return;
      }

      // 게이팅: confirmedQuestionIds >= 8 검증
      final confirmedCount = sessionData.confirmedQuestionIds.length;
      if (confirmedCount < 8) {
        Get.snackbar(
          '오류',
          '합의 확정이 8개 미만입니다. (현재: $confirmedCount개)',
        );
        return;
      }

      // 모든 합의 조회
      final consensusList = await _repo.getSessionConsensusList(sessionId.value);

      // decisionLogs 생성
      final decisionLogs = consensusList.map((consensus) {
        return DecisionLog(
          questionId: consensus.questionId,
          finalText: consensus.finalText,
          decidedAt: consensus.decidedAt,
          decidedBy: consensus.decidedBy,
        );
      }).toList();

      // summary1p 생성 (임시: 첫 번째 합의 문장 사용)
      final summary1p = consensusList.isNotEmpty
          ? consensusList.first.finalText
          : '';

      // docId 생성
      final docId = DateTime.now().millisecondsSinceEpoch.toString();

      // 1. documents/{docId} 생성
      final document = Document(
        docId: docId,
        companyKey: companyKey.value,
        sessionId: sessionId.value,
        createdAt: DateTime.now(),
        summary1p: summary1p,
        decisionLogs: decisionLogs,
        version: 1,
        latest: true,
      );
      await _repo.createDocument(document);

      // 기존 latest 문서들 false로 변경
      await _updateLatestDocuments(companyKey.value, docId);

      // 2. sessions.status='final', sessions.finalDocId=docId
      await _repo.updateSession(sessionId.value, {
        'status': 'final',
        'finalDocId': docId,
      });

      // 3. companies.latestDocId=docId 업데이트
      await _repo.updateCompanyLatestDocId(companyKey.value, docId);

      // 4. 생성 완료 후 /doc/:docId로 이동
      Get.offAllNamed(Routes.docViewPath(docId));
    } catch (e) {
      Get.snackbar('오류', '문서 생성 실패: $e');
    } finally {
      isGenerating.value = false;
    }
  }

  /// 기존 latest 문서들 false로 변경
  Future<void> _updateLatestDocuments(String companyKey, String newDocId) async {
    try {
      final documents = await _repo.getDocumentsByCompany(companyKey);
      for (var doc in documents) {
        if (doc.latest == true && doc.docId != newDocId) {
          await _repo.updateDocument(doc.docId, {'latest': false});
        }
      }
    } catch (e) {
      // 에러 무시 (latest 업데이트 실패해도 문서 생성은 성공)
      print('latest 문서 업데이트 실패: $e');
    }
  }
}
