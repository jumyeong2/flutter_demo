import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import '../../../data/repository/firestore_repo.dart';
import '../../../data/model/company.dart';
import '../../../service/company_key_cache_service.dart';
import '../../../router/routes.dart';

/// SettingsTeamController: 팀 설정 페이지 컨트롤러
class SettingsTeamController extends GetxController {
  late final FirestoreRepository _repo;
  late final CompanyKeyCacheService _cacheService;

  final RxString companyKey = ''.obs;
  final Rx<Company?> company = Rx<Company?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _repo = Get.find<FirestoreRepository>();
    _cacheService = Get.find<CompanyKeyCacheService>();

    // companyKey 가져오기
    companyKey.value = _cacheService.getCachedCompanyKey() ?? '';
    if (companyKey.value.isNotEmpty) {
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
    } catch (e) {
      Get.snackbar('오류', '팀 정보를 불러올 수 없습니다: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// 팀 초대 코드 복사
  /// 초대 링크: /team/join?code={companyKey}
  Future<void> copyInviteCode() async {
    if (companyKey.value.isEmpty) {
      Get.snackbar('오류', '팀 정보를 불러올 수 없습니다');
      return;
    }

    final inviteLink = Routes.teamJoinPath(code: companyKey.value);
    await Clipboard.setData(ClipboardData(text: inviteLink));
    Get.snackbar('성공', '초대 링크가 복사되었습니다', snackPosition: SnackPosition.BOTTOM);
  }

  /// 팀 나가기 (초기화)
  ///
  /// 1. users.currentCompanyKey=null
  /// 2. 로컬 캐시 삭제
  /// 3. Get.offAllNamed('/team/select')
  Future<void> leaveTeam() async {
    try {
      isLoading.value = true;

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Get.offAllNamed(Routes.login);
        return;
      }

      // 1. users.currentCompanyKey=null
      await _cacheService.updateServerCompanyKey(user.uid, null);

      // 2. 로컬 캐시 삭제
      _cacheService.clearCachedCompanyKey();

      // 3. Get.offAllNamed('/team/select')
      Get.offAllNamed(Routes.teamSelect);
    } catch (e) {
      Get.snackbar('오류', '팀 나가기 실패: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
