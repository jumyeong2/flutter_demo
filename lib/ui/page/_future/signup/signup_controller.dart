import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/model/user.dart';
import '../../../data/repository/user_repository.dart';
import '../../../service/auth_service.dart';
import '../agreement/agreement_adjust_page.dart';
import 'signup_step2_page.dart';

class SignupController extends GetxController {
  // Services & Repositories
  final AuthService _authService = Get.find<AuthService>();
  final UserRepository _userRepository = Get.find<UserRepository>();

  // Form Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  final positionController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final companyNameController = TextEditingController();
  final companyDurationController = TextEditingController();
  final industryController = TextEditingController();

  // Reactive State
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    positionController.dispose();
    phoneNumberController.dispose();
    companyNameController.dispose();
    companyDurationController.dispose();
    industryController.dispose();
    super.onClose();
  }

  // Step 1 입력값 유효성 검사 (기본 정보)
  bool _validateStep1() {
    if (nameController.text.trim().isEmpty) {
      errorMessage.value = '이름을 입력해주세요.';
      return false;
    }
    if (emailController.text.trim().isEmpty) {
      errorMessage.value = '이메일을 입력해주세요.';
      return false;
    }
    if (!GetUtils.isEmail(emailController.text.trim())) {
      errorMessage.value = '유효한 이메일 형식이 아닙니다.';
      return false;
    }
    if (passwordController.text.isEmpty) {
      errorMessage.value = '비밀번호를 입력해주세요.';
      return false;
    }
    if (passwordController.text.length < 6) {
      errorMessage.value = '비밀번호는 최소 6자 이상이어야 합니다.';
      return false;
    }
    // 영문과 숫자 포함 검사
    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(passwordController.text);
    final hasDigit = RegExp(r'[0-9]').hasMatch(passwordController.text);
    if (!hasLetter || !hasDigit) {
      errorMessage.value = '비밀번호는 영문과 숫자를 모두 포함해야 합니다.';
      return false;
    }
    if (passwordConfirmController.text.isEmpty) {
      errorMessage.value = '비밀번호 확인을 입력해주세요.';
      return false;
    }
    if (passwordController.text != passwordConfirmController.text) {
      errorMessage.value = '비밀번호가 일치하지 않습니다.';
      return false;
    }
    if (phoneNumberController.text.trim().isEmpty) {
      errorMessage.value = '전화번호를 입력해주세요.';
      return false;
    }
    return true;
  }

  // Step 2 입력값 유효성 검사 (회사 정보)
  bool _validateStep2() {
    if (positionController.text.trim().isEmpty) {
      errorMessage.value = '직위를 입력해주세요.';
      return false;
    }
    if (companyNameController.text.trim().isEmpty) {
      errorMessage.value = '회사 이름을 입력해주세요.';
      return false;
    }
    if (companyDurationController.text.trim().isEmpty) {
      errorMessage.value = '회사 기간을 입력해주세요.';
      return false;
    }
    if (industryController.text.trim().isEmpty) {
      errorMessage.value = '산업군을 입력해주세요.';
      return false;
    }
    return true;
  }

  // Step 1에서 Continue 버튼 클릭
  void continueToStep2() {
    // 에러 메시지 초기화
    errorMessage.value = '';

    // Step 1 유효성 검사
    if (!_validateStep1()) {
      return;
    }

    // Step 2로 이동 (Firebase Auth 계정 생성은 Step 2에서 수행)
    Get.to(() => const SignupStep2Page());
  }

  // 회원가입 처리 (Step 2에서 호출)
  Future<void> signUp() async {
    // 에러 메시지 초기화
    errorMessage.value = '';

    // Step 2 유효성 검사
    if (!_validateStep2()) {
      return;
    }

    isLoading.value = true;

    try {
      print('=== 회원가입 시도 ===');
      print('이메일: ${emailController.text.trim()}');
      print('비밀번호 길이: ${passwordController.text.length}');

      // 1. Firebase Auth 회원가입
      final firebaseUser = await _authService.signUpWithEmail(
        emailController.text.trim(),
        passwordController.text,
      );

      if (firebaseUser == null) {
        throw Exception('회원가입에 실패했습니다.');
      }

      print('회원가입 성공: ${firebaseUser.uid}');

      // 2. Firestore에 사용자 정보 저장
      final user = User(
        uid: firebaseUser.uid,
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        position: positionController.text.trim(),
        phoneNumber: phoneNumberController.text.trim(),
        companyName: companyNameController.text.trim(),
        companyDuration: companyDurationController.text.trim(),
        industry: industryController.text.trim(),
        createdAt: DateTime.now(),
      );

      print('Firestore 저장 시작...');
      await _userRepository.createUser(user);
      print('Firestore 저장 완료!');

      // 3. 성공 메시지 표시
      Get.snackbar(
        '회원가입 성공',
        '환영합니다, ${user.name}님!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[600],
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      print('다음 페이지로 이동 시작...');
      // 4. 다음 페이지로 이동
      // 4. 다음 페이지로 이동
      Get.off(() => const AgreementAdjustPage());
      print('다음 페이지로 이동 완료!');
    } catch (e) {
      print('=== 회원가입 에러 ===');
      print('에러 타입: ${e.runtimeType}');
      print('에러 내용: $e');

      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      Get.snackbar(
        '회원가입 실패',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[600],
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void goBack() {
    Get.back();
  }

  void goBackToStep1() {
    Get.back();
  }
}
