import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:get/get.dart';
import 'company_key_cache_service.dart';

class AuthService extends GetxService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;

  // 현재 로그인된 사용자 (Reactive)
  final Rx<firebase_auth.User?> currentUser = Rx<firebase_auth.User?>(null);

  @override
  void onInit() {
    super.onInit();
    // Firebase Auth 상태 변경 감지
    currentUser.bindStream(_auth.authStateChanges());
    
    // 로그인 상태 변경 시 currentCompanyKey 동기화
    currentUser.listen((user) {
      if (user != null) {
        // 로그인 상태면 서버에서 currentCompanyKey 동기화
        _syncCompanyKeyFromServer(user.uid);
      } else {
        // 로그아웃 시 로컬 캐시 삭제
        try {
          final cacheService = Get.find<CompanyKeyCacheService>();
          cacheService.clearCachedCompanyKey();
        } catch (e) {
          // CompanyKeyCacheService가 아직 초기화되지 않은 경우 무시
        }
      }
    });
  }

  /// 서버에서 currentCompanyKey 동기화 (비동기, 백그라운드)
  /// 
  /// 실행 위치: AuthService.onInit()에서 authStateChanges 수신 후
  /// 이유: 로그인 상태가 변경될 때마다 자동으로 동기화되므로,
  ///       앱 시작 시뿐만 아니라 로그인/로그아웃 시에도 자동으로 처리됩니다.
  void _syncCompanyKeyFromServer(String uid) {
    try {
      final cacheService = Get.find<CompanyKeyCacheService>();
      cacheService.syncFromServer(uid);
    } catch (e) {
      // CompanyKeyCacheService가 아직 초기화되지 않은 경우 무시
      // (앱 시작 초기 단계에서 발생할 수 있음)
    }
  }

  // 이메일/비밀번호로 회원가입
  Future<firebase_auth.User?> signUpWithEmail(
    String email,
    String password,
  ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('비밀번호가 너무 약합니다.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('이미 사용 중인 이메일입니다.');
      } else if (e.code == 'invalid-email') {
        throw Exception('유효하지 않은 이메일 형식입니다.');
      }
      throw Exception('회원가입 실패: ${e.message}');
    } catch (e) {
      throw Exception('회원가입 중 오류 발생: $e');
    }
  }

  // 이메일/비밀번호로 로그인
  Future<firebase_auth.User?> signInWithEmail(
    String email,
    String password,
  ) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('사용자를 찾을 수 없습니다.');
      } else if (e.code == 'wrong-password') {
        throw Exception('잘못된 비밀번호입니다.');
      } else if (e.code == 'invalid-email') {
        throw Exception('유효하지 않은 이메일 형식입니다.');
      }
      throw Exception('로그인 실패: ${e.message}');
    } catch (e) {
      throw Exception('로그인 중 오류 발생: $e');
    }
  }

  // 로그아웃
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('로그아웃 실패: $e');
    }
  }

  // 현재 로그인된 사용자의 UID 가져오기
  String? get currentUid => _auth.currentUser?.uid;

  // 로그인 여부 확인
  bool get isLoggedIn => _auth.currentUser != null;
}

