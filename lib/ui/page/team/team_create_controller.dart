import 'dart:math';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/repository/firestore_repo.dart';
import '../../../data/model/company.dart';
import '../../../data/model/firestore_user.dart';
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

  /// 고유한 companyKey 생성 (랜덤 문자열)
  String _generateCompanyKey() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        8,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  /// 팀 생성
  /// 
  /// 1. companyKey 생성
  /// 2. Company 생성
  /// 3. members/{uid} 생성 (role A - 팀 생성자)
  /// 4. users/{uid}.currentCompanyKey 업데이트
  /// 5. CompanyKeyCacheService에 캐시 저장
  /// 6. 대시보드로 이동
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

      // 고유한 companyKey 생성
      String companyKey = _generateCompanyKey();
      
      // companyKey 중복 확인 (간단한 재시도 로직)
      int retryCount = 0;
      while (retryCount < 5) {
        final existingCompany = await _repo.getCompany(companyKey);
        if (existingCompany == null) {
          break; // 사용 가능한 키
        }
        companyKey = _generateCompanyKey();
        retryCount++;
      }

      // Company 생성
      final company = Company(
        companyKey: companyKey,
        name: teamName.value.trim(),
        createdAt: DateTime.now(),
      );
      await _repo.createCompany(company);

      // 멤버 생성 (role A - 팀 생성자)
      final member = CompanyMember(
        uid: user.uid,
        role: 'A',
        joinedAt: DateTime.now(),
      );
      await _repo.setCompanyMember(companyKey, member);

      // 사용자 문서가 없으면 먼저 생성
      final existingUser = await _repo.getUser(user.uid);
      if (existingUser == null) {
        final firestoreUser = FirestoreUser(
          uid: user.uid,
          email: user.email ?? '',
          createdAt: DateTime.now(),
          currentCompanyKey: companyKey,
        );
        await _repo.setUser(firestoreUser);
      } else {
        // 사용자 문서가 있으면 currentCompanyKey만 업데이트
        await _repo.updateUserCompanyKey(user.uid, companyKey);
      }
      
      // 캐시 저장
      _cacheService.setCachedCompanyKey(companyKey);

      // 대시보드로 이동
      Get.offAllNamed(Routes.dashboard);
    } catch (e) {
      Get.snackbar('오류', '팀 생성 실패: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
