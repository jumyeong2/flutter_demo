import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:get/get.dart';

class AuthService extends GetxService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;

  // 현재 로그인된 사용자 (Reactive)
  final Rx<firebase_auth.User?> currentUser = Rx<firebase_auth.User?>(null);

  @override
  void onInit() {
    super.onInit();
    // Firebase Auth 상태 변경 감지
    currentUser.bindStream(_auth.authStateChanges());
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

