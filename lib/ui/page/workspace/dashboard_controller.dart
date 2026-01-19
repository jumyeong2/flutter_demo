import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../service/company_key_cache_service.dart';
import '../../../data/repository/firestore_repo.dart';
import '../../../data/model/session.dart';
import '../../../data/model/company.dart';
import '../../../data/model/document.dart';
import '../../../router/routes.dart';

/// DashboardController: 대시보드 페이지 컨트롤러
class DashboardController extends GetxController {
  late final CompanyKeyCacheService _cacheService;
  late final FirestoreRepository _repo;

  final RxBool isLoading = true.obs;
  final RxString companyKey = ''.obs;
  final Rx<Company?> company = Rx<Company?>(null);
  final RxList<Session> sessions = <Session>[].obs;
  final RxList<CompanyMember> members = <CompanyMember>[].obs;
  final Rx<Document?> latestDocument = Rx<Document?>(null);
  final RxList<Document> documents = <Document>[].obs;

  @override
  void onInit() {
    super.onInit();
    _cacheService = Get.find<CompanyKeyCacheService>();
    _repo = Get.find<FirestoreRepository>();
    
    // currentCompanyKey 확인 및 리다이렉트 처리
    _checkCompanyKey();
  }

  /// currentCompanyKey 확인 및 리다이렉트 처리
  Future<void> _checkCompanyKey() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Get.offAllNamed(Routes.login);
      return;
    }

    // 서버에서 먼저 확인 (source of truth)
    try {
      final firestoreUser = await _repo.getUser(user.uid);
      if (firestoreUser != null && 
          firestoreUser.currentCompanyKey != null && 
          firestoreUser.currentCompanyKey!.isNotEmpty) {
        // 서버 값이 있으면 로컬 캐시도 갱신
        _cacheService.setCachedCompanyKey(firestoreUser.currentCompanyKey!);
        companyKey.value = firestoreUser.currentCompanyKey!;
        // 데이터 로드
        await loadDashboardData();
        return; // 통과
      } else {
        // 서버에 값이 없으면 로컬 캐시도 삭제
        _cacheService.clearCachedCompanyKey();
      }
    } catch (e) {
      // 서버 조회 실패 시 로컬 캐시 확인 (오프라인 대응)
      final cachedKey = _cacheService.getCachedCompanyKey();
      if (cachedKey != null && cachedKey.isNotEmpty) {
        companyKey.value = cachedKey;
        await loadDashboardData();
        return; // 로컬 캐시가 있으면 통과
      }
    }

    // currentCompanyKey가 없으면 팀 선택 페이지로 리다이렉트
    Get.offAllNamed(Routes.teamSelect);
  }

  /// 대시보드 데이터 로드
  Future<void> loadDashboardData() async {
    if (companyKey.value.isEmpty) return;

    try {
      isLoading.value = true;

      // 병렬로 데이터 로드
      await Future.wait([
        _loadCompany(),
        _loadSessions(),
        _loadMembers(),
        _loadDocuments(),
      ]);
    } catch (e) {
      Get.snackbar('오류', '데이터를 불러오는데 실패했습니다: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// 회사 정보 로드
  Future<void> _loadCompany() async {
    try {
      final companyData = await _repo.getCompany(companyKey.value);
      company.value = companyData;
    } catch (e) {
      print('회사 정보 로드 실패: $e');
    }
  }

  /// 세션 목록 로드
  Future<void> _loadSessions() async {
    try {
      final sessionsList = await _repo.getSessionsByCompany(companyKey.value);
      sessions.value = sessionsList;
    } catch (e) {
      print('세션 목록 로드 실패: $e');
    }
  }

  /// 멤버 목록 로드
  Future<void> _loadMembers() async {
    try {
      final membersList = await _repo.getCompanyMembers(companyKey.value);
      members.value = membersList;
    } catch (e) {
      print('멤버 목록 로드 실패: $e');
    }
  }

  /// 문서 목록 로드
  Future<void> _loadDocuments() async {
    try {
      final latestDoc = await _repo.getLatestDocument(companyKey.value);
      latestDocument.value = latestDoc;

      final docsList = await _repo.getDocumentsByCompany(companyKey.value);
      documents.value = docsList;
    } catch (e) {
      print('문서 목록 로드 실패: $e');
    }
  }

  /// 진행 중인 세션 가져오기
  Session? get activeSession {
    return sessions.firstWhereOrNull(
      (session) => session.status != 'final',
    );
  }

  /// 멤버 초대 코드 복사
  Future<void> copyInviteCode() async {
    if (companyKey.value.isEmpty) return;

    try {
      // 웹 환경에서는 클립보드 사용
      // TODO: 웹 클립보드 복사 기능 구현 (예: share_plus 패키지 또는 직접 구현)
      Get.snackbar(
        '초대 코드',
        '초대 코드: ${companyKey.value}',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar('오류', '초대 코드 복사 실패: $e');
    }
  }
}
