import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/repository/firestore_repo.dart';
import '../../../service/company_key_cache_service.dart';
import '../../../router/routes.dart';

/// DocLatestController: 최신 문서 페이지 컨트롤러
/// /doc/latest: companyKey = query.companyKey ?? users.currentCompanyKey
class DocLatestController extends GetxController {
  late final FirestoreRepository _repo;
  late final CompanyKeyCacheService _cacheService;

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _repo = Get.find<FirestoreRepository>();
    _cacheService = Get.find<CompanyKeyCacheService>();

    handleLatestDocument();
  }

  /// 최신 문서 처리
  /// 
  /// 1. companyKey = query.companyKey ?? users.currentCompanyKey
  /// 2. null이면 /team/select 안내
  /// 3. companies.latestDocId 없으면 안내 후 /dashboard
  /// 4. 있으면 /doc/:id로 replace 이동
  Future<void> handleLatestDocument() async {
    try {
      isLoading.value = true;

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Get.offAllNamed(Routes.login);
        return;
      }

      // 1. companyKey = query.companyKey ?? users.currentCompanyKey
      String? companyKey;

      // query.companyKey 확인
      // GetX에서는 Get.parameters가 path parameter와 query parameter 모두 포함할 수 있음
      // 하지만 Get.toNamed로 호출될 때 query parameter는 포함되지 않을 수 있으므로
      // Get.currentRoute에서 URI를 파싱하거나, 직접 Get.parameters를 확인
      final queryParams = Get.parameters;
      if (queryParams.containsKey('companyKey')) {
        companyKey = queryParams['companyKey'];
      }
      
      // Get.currentRoute에서도 확인 (full path with query)
      if ((companyKey == null || companyKey.isEmpty) && Get.currentRoute != null) {
        try {
          final currentRoute = Get.currentRoute;
          if (currentRoute != null && currentRoute.contains('?')) {
            final uri = Uri.parse(currentRoute);
            if (uri.queryParameters.containsKey('companyKey')) {
              companyKey = uri.queryParameters['companyKey'];
            }
          }
        } catch (e) {
          // 에러 무시
        }
      }

      // 없으면 users.currentCompanyKey 사용
      if (companyKey == null || companyKey.isEmpty) {
        try {
          final userDoc = await _repo.getUser(user.uid);
          companyKey = userDoc?.currentCompanyKey;
          
          // 로컬 캐시도 확인
          if (companyKey == null || companyKey.isEmpty) {
            companyKey = _cacheService.getCachedCompanyKey();
          }
        } catch (e) {
          // 에러 무시
        }
      }

      // 2. null이면 /team/select 안내
      if (companyKey == null || companyKey.isEmpty) {
        Get.offAllNamed(Routes.teamSelect);
        return;
      }

      // 3. companies.latestDocId 확인
      final company = await _repo.getCompany(companyKey);
      if (company == null) {
        Get.snackbar('오류', '팀을 찾을 수 없습니다');
        Get.offAllNamed(Routes.dashboard);
        return;
      }

      final latestDocId = company.latestDocId;

      // companies.latestDocId 없으면 안내 후 /dashboard
      if (latestDocId == null || latestDocId.isEmpty) {
        Get.snackbar('알림', '아직 생성된 문서가 없습니다');
        Get.offAllNamed(Routes.dashboard);
        return;
      }

      // 4. 있으면 /doc/:id로 replace 이동
      Get.offNamed(Routes.docViewPath(latestDocId));
    } catch (e) {
      Get.snackbar('오류', '문서를 불러올 수 없습니다: $e');
      Get.offAllNamed(Routes.dashboard);
    } finally {
      isLoading.value = false;
    }
  }
}
