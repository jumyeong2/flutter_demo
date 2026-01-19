import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../service/auth_service.dart';
import '../../../service/pending_route_service.dart';
import '../../../router/routes.dart';
import '../agreement/agreement_adjust_intro.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    // 페이지 진입 시 이메일 필드에 자동 포커스
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _emailFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    // 키보드 닫기
    FocusScope.of(context).unfocus();
    
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authService = Get.find<AuthService>();
      await authService.signInWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      // 로그인 성공: pendingRoutePath 복귀 처리
      final pendingRouteService = Get.find<PendingRouteService>();
      final pendingRoutePath = pendingRouteService.getPendingRoutePath();
      
      if (pendingRoutePath != null && pendingRoutePath.isNotEmpty) {
        // pendingRoutePath로 이동 (해당 라우트의 Guard가 실행됨)
        // clear는 목적지 화면에서 성공적으로 진입했을 때만 수행
        Get.offAllNamed(pendingRoutePath);
      } else {
        // pendingRoutePath가 없으면 바로 대시보드로 이동
        // CompanyGuard가 currentCompanyKey가 없으면 자동으로 /team/select로 리다이렉트
        Get.offAllNamed(Routes.dashboard);
      }
    } catch (e) {
      String errorMessage = e.toString();
      
      // Exception: 접두사 제거
      if (errorMessage.startsWith("Exception: ")) {
        errorMessage = errorMessage.substring(11);
      }
      
      // 더 친화적인 에러 메시지로 변환
      if (errorMessage.contains("등록되지 않은 이메일") || 
          errorMessage.contains("user-not-found")) {
        errorMessage = "등록되지 않은 이메일입니다.\n회원가입을 먼저 진행해주세요.";
      } else if (errorMessage.contains("비밀번호가 일치하지 않습니다") || 
                 errorMessage.contains("잘못된 비밀번호") ||
                 errorMessage.contains("wrong-password")) {
        errorMessage = "비밀번호가 일치하지 않습니다.\n다시 확인해주세요.";
      } else if (errorMessage.contains("이메일 또는 비밀번호가 올바르지 않습니다") ||
                 errorMessage.contains("invalid-credential") ||
                 errorMessage.contains("The supplied auth credential")) {
        errorMessage = "이메일 또는 비밀번호가 올바르지 않습니다.\n다시 확인해주세요.";
      } else if (errorMessage.contains("invalid-email") ||
                 errorMessage.contains("유효하지 않은 이메일")) {
        errorMessage = "올바른 이메일 형식을 입력해주세요.";
      } else if (errorMessage.contains("너무 많은 시도") ||
                 errorMessage.contains("too-many-requests")) {
        errorMessage = "너무 많은 시도가 있었습니다.\n잠시 후 다시 시도해주세요.";
      } else if (errorMessage.contains("네트워크") ||
                 errorMessage.contains("network-request-failed")) {
        errorMessage = "네트워크 연결을 확인해주세요.";
      } else if (errorMessage.contains("로그인 실패:")) {
        // Firebase의 원본 메시지가 포함된 경우, 앞부분만 제거
        errorMessage = errorMessage.replaceAll("로그인 실패: ", "");
      } else if (errorMessage.contains("로그인 중 오류 발생:")) {
        errorMessage = errorMessage.replaceAll("로그인 중 오류 발생: ", "");
      }
      
      // 디버깅을 위한 콘솔 출력
      debugPrint("로그인 에러: $e");
      debugPrint("에러 메시지: $errorMessage");
      
      Get.snackbar(
        "로그인 실패",
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 768;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "로그인",
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: _isLoading ? null : () => Get.back(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFE2E8F0), height: 1),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 24.0 : 40.0,
                vertical: 32.0,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Container(
                  padding: const EdgeInsets.all(48),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          "이메일로 로그인",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "계정이 있다면 로그인하고\n팀과 함께 합의를 시작하세요.",
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF64748B),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          enabled: !_isLoading,
                          onFieldSubmitted: (_) {
                            _passwordFocusNode.requestFocus();
                          },
                          autofillHints: const [AutofillHints.email],
                          decoration: InputDecoration(
                            labelText: "이메일",
                            labelStyle: const TextStyle(color: Color(0xFF64748B)),
                            hintText: "example@email.com",
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFE2E8F0),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFE2E8F0),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF0F172A),
                                width: 2,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 1.5,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 2,
                              ),
                            ),
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "이메일을 입력해주세요.";
                            }
                            if (!val.contains("@") || !val.contains(".")) {
                              return "올바른 이메일 형식을 입력해주세요.";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          enabled: !_isLoading,
                          onFieldSubmitted: (_) => _handleLogin(),
                          autofillHints: const [AutofillHints.password],
                          decoration: InputDecoration(
                            labelText: "비밀번호",
                            labelStyle: const TextStyle(color: Color(0xFF64748B)),
                            hintText: "비밀번호 입력",
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFE2E8F0),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFE2E8F0),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF0F172A),
                                width: 2,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 1.5,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 2,
                              ),
                            ),
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              color: Color(0xFF64748B),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: const Color(0xFF64748B),
                                size: 20,
                              ),
                              onPressed: _isLoading
                                  ? null
                                  : () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                              tooltip: _obscurePassword ? '비밀번호 보기' : '비밀번호 숨기기',
                            ),
                          ),
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "비밀번호를 입력해주세요.";
                            }
                            if (val.length < 6) {
                              return "비밀번호는 최소 6자 이상이어야 합니다.";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0F172A),
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: const Color(0xFF94A3B8),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  "로그인",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "계정이 없으신가요?",
                              style: TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 4),
                            TextButton(
                              onPressed: _isLoading
                                  ? null
                                  : () {
                                      Get.to(() => const AgreementAdjustIntroPage());
                                    },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                              ),
                              child: const Text(
                                "회원가입",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // 로딩 중 오버레이
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.1),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
