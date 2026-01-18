import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/repository/firestore_repo.dart';
import '../../../data/model/session.dart';
import '../../../service/company_key_cache_service.dart';
import '../../../router/routes.dart';

/// SessionCreateController: 세션 생성 페이지 컨트롤러
class SessionCreateController extends GetxController {
  late final FirestoreRepository _repo;
  late final CompanyKeyCacheService _cacheService;

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _repo = Get.find<FirestoreRepository>();
    _cacheService = Get.find<CompanyKeyCacheService>();
  }

  /// 세션 생성
  /// 
  /// 1. sessions 문서 생성 (confirmedQuestionIds는 반드시 []로 초기화)
  /// 2. 생성 후 /session/:id(홈)로 이동
  Future<void> createSession() async {
    try {
      isLoading.value = true;

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Get.snackbar('오류', '로그인이 필요합니다');
        Get.offAllNamed(Routes.login);
        return;
      }

      // companyKey 가져오기
      final companyKey = _cacheService.getCachedCompanyKey();
      if (companyKey == null || companyKey.isEmpty) {
        Get.snackbar('오류', '팀을 선택해주세요');
        Get.offAllNamed(Routes.teamSelect);
        return;
      }

      // 세션 ID 생성
      final sessionId = DateTime.now().millisecondsSinceEpoch.toString();

      // 세션 생성 (confirmedQuestionIds는 반드시 []로 초기화)
      final session = Session(
        sessionId: sessionId,
        companyKey: companyKey,
        status: 'draft',
        createdAt: DateTime.now(),
        questionSetVersion: 'v1', // 기본 버전
        participantStatus: {}, // 초기에는 비어있음
        readyUserIds: [],
        confirmedQuestionIds: [], // 반드시 []로 초기화
      );

      await _repo.createSession(session);

      // 생성 후 /session/:id(홈)로 이동
      Get.offAllNamed(Routes.sessionHomePath(sessionId));
    } catch (e) {
      Get.snackbar('오류', '세션 생성 실패: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
