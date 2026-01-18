import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/repository/firestore_repo.dart';
import '../../../data/model/company.dart';
import '../../../service/company_key_cache_service.dart';
import '../../../router/routes.dart';

/// TeamJoinController: 팀 가입 페이지 컨트롤러
class TeamJoinController extends GetxController {
  late final FirestoreRepository _repo;
  late final CompanyKeyCacheService _cacheService;

  final RxBool isLoading = false.obs;
  final RxString companyKey = ''.obs;
  final Rx<Company?> company = Rx<Company?>(null);

  @override
  void onInit() {
    super.onInit();
    _repo = Get.find<FirestoreRepository>();
    _cacheService = Get.find<CompanyKeyCacheService>();

    // query.code를 companyKey로 사용
    final code = Get.parameters['code'];
    if (code != null && code.isNotEmpty) {
      companyKey.value = code;
      loadCompany();
    }
  }

  /// 회사 정보 로드
  Future<void> loadCompany() async {
    if (companyKey.value.isEmpty) return;

    try {
      isLoading.value = true;
      final companyData = await _repo.getCompany(companyKey.value);
      company.value = companyData;

      if (companyData == null) {
        Get.snackbar('오류', '팀을 찾을 수 없습니다');
      }
    } catch (e) {
      Get.snackbar('오류', '팀 정보를 불러올 수 없습니다: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// 팀 가입
  /// 
  /// 1. query.code를 companyKey로 사용 (code==companyKey로 통일)
  /// 2. 이미 members/{uid} 있으면 재조인으로 간주하고 members 생성 없이 currentCompanyKey만 설정
  /// 3. 없으면 members 생성 (role B)
  /// 4. redirect 있으면 이동 else /dashboard
  Future<void> joinTeam() async {
    if (companyKey.value.isEmpty) {
      Get.snackbar('오류', '팀 코드가 필요합니다');
      return;
    }

    try {
      isLoading.value = true;

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Get.snackbar('오류', '로그인이 필요합니다');
        Get.offAllNamed(Routes.login);
        return;
      }

      // 회사 존재 확인
      final companyData = await _repo.getCompany(companyKey.value);
      if (companyData == null) {
        Get.snackbar('오류', '팀을 찾을 수 없습니다');
        return;
      }

      // 멤버십 확인
      final existingMember = await _repo.getCompanyMember(companyKey.value, user.uid);

      if (existingMember != null) {
        // 재조인: members 생성 없이 currentCompanyKey만 설정
        await _repo.updateUserCompanyKey(user.uid, companyKey.value);
        _cacheService.setCachedCompanyKey(companyKey.value);
      } else {
        // 새 멤버: members 생성 (role B)
        final member = CompanyMember(
          uid: user.uid,
          role: 'B',
          joinedAt: DateTime.now(),
        );
        await _repo.setCompanyMember(companyKey.value, member);
        await _repo.updateUserCompanyKey(user.uid, companyKey.value);
        _cacheService.setCachedCompanyKey(companyKey.value);
      }

      // redirect 있으면 이동 else /dashboard
      final redirect = Get.parameters['redirect'];
      if (redirect != null && redirect.isNotEmpty) {
        Get.offAllNamed(redirect);
      } else {
        Get.offAllNamed(Routes.dashboard);
      }
    } catch (e) {
      Get.snackbar('오류', '팀 가입 실패: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
