import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/repository/firestore_repo.dart';
import '../../../data/model/document.dart';
import '../../../service/company_key_cache_service.dart';
import '../../../router/routes.dart';

/// DocViewController: 문서 보기 페이지 컨트롤러
/// /doc/:docId: 문서 없으면 안내 후 /dashboard. companyKey null이면 /error(args). members 검증 후 아니면 /team/join
class DocViewController extends GetxController {
  late final FirestoreRepository _repo;
  late final CompanyKeyCacheService _cacheService;

  final RxString docId = ''.obs;
  final Rx<Document?> document = Rx<Document?>(null);
  final RxBool isLoading = false.obs;
  final RxString companyKey = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _repo = Get.find<FirestoreRepository>();
    _cacheService = Get.find<CompanyKeyCacheService>();

    // 문서 ID 가져오기 (라우트 파라미터)
    final routeParams = Get.parameters;
    if (routeParams.containsKey('docId')) {
      docId.value = routeParams['docId']!;
      loadDocument();
    }
  }

  /// 문서 로드 및 검증
  /// 
  /// 1. 문서 없으면 안내 후 /dashboard
  /// 2. companyKey null이면 /error(args)
  /// 3. members 검증 후 아니면 /team/join?code={companyKey}&redirect=/doc/{docId}
  Future<void> loadDocument() async {
    try {
      isLoading.value = true;

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Get.offAllNamed(Routes.login);
        return;
      }

      // 1. 문서 조회
      final docData = await _repo.getDocument(docId.value);

      // 문서 없으면 안내 후 /dashboard
      if (docData == null) {
        Get.snackbar('오류', '문서를 찾을 수 없습니다');
        Get.offAllNamed(Routes.dashboard);
        return;
      }

      document.value = docData;
      companyKey.value = docData.companyKey;

      // 2. companyKey null이면 /error(args)
      if (companyKey.value.isEmpty) {
        Get.offNamed(
          Routes.error,
          arguments: {
            'message': '문서의 팀 정보를 찾을 수 없습니다',
            'fallbackRoute': Routes.dashboard,
          },
        );
        return;
      }

      // 3. members 검증
      final member = await _repo.getCompanyMember(companyKey.value, user.uid);

      // 멤버가 아니면 /team/join?code={companyKey}&redirect=/doc/{docId}
      if (member == null) {
        Get.offNamed(
          Routes.teamJoinPath(
            code: companyKey.value,
            redirect: Routes.docViewPath(docId.value),
          ),
        );
        return;
      }

      // 멤버면 통과 (문서 표시)
    } catch (e) {
      Get.snackbar('오류', '문서를 불러올 수 없습니다: $e');
      Get.offAllNamed(Routes.dashboard);
    } finally {
      isLoading.value = false;
    }
  }
}
