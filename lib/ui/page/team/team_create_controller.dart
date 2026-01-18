import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/repository/firestore_repo.dart';
import '../../../data/model/company.dart';
import '../../../service/company_key_cache_service.dart';
import '../../../router/routes.dart';

/// TeamCreateController: 팀 생성 페이지 컨트롤러
class TeamCreateController extends GetxController {
  late final FirestoreRepository _repo;
  late final CompanyKeyCacheService _cacheService;

  final RxBool isLoading = false.obs;
  final RxString teamName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _repo = Get.find<FirestoreRepository>();
    _cacheService = Get.find<CompanyKeyCacheService>();
  }

  /// 팀 이름 업데이트
  void updateTeamName(String name) {
    teamName.value = name;
  }

  /// 팀 생성
  /// 
  /// 1. companyKey 생성 (간단 normalize)
  /// 2. companies 문서 생성
  /// 3. members/{uid} 생성 (role A)
  /// 4. users.currentCompanyKey 설정
  /// 5. redirect 있으면 이동 else /dashboard
  Future<void> createTeam() async {
    if (teamName.value.trim().isEmpty) {
      Get.snackbar('오류', '팀 이름을 입력해주세요');
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

      // 1. companyKey 생성 (간단 normalize: 소문자, 공백 제거, 특수문자 제거)
      final normalizedName = teamName.value
          .toLowerCase()
          .replaceAll(RegExp(r'[^a-z0-9]'), '')
          .trim();
      
      if (normalizedName.isEmpty) {
        Get.snackbar('오류', '유효한 팀 이름을 입력해주세요');
        return;
      }

      final companyKey = '${normalizedName}_${DateTime.now().millisecondsSinceEpoch}';

      // 2. companies 문서 생성
      final company = Company(
        companyKey: companyKey,
        name: teamName.value.trim(),
        createdAt: DateTime.now(),
      );
      await _repo.createCompany(company);

      // 3. members/{uid} 생성 (role A)
      final member = CompanyMember(
        uid: user.uid,
        role: 'A',
        joinedAt: DateTime.now(),
      );
      await _repo.setCompanyMember(companyKey, member);

      // 4. users.currentCompanyKey 설정
      await _repo.updateUserCompanyKey(user.uid, companyKey);
      _cacheService.setCachedCompanyKey(companyKey);

      // 5. redirect 있으면 이동 else /dashboard
      final redirect = Get.parameters['redirect'];
      if (redirect != null && redirect.isNotEmpty) {
        Get.offAllNamed(redirect);
      } else {
        Get.offAllNamed(Routes.dashboard);
      }
    } catch (e) {
      Get.snackbar('오류', '팀 생성 실패: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
