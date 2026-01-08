import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

import 'package:flutter_demo/service/auth_service.dart';
import '../../widgets/responsive_layout.dart';
import '../login/login_page.dart';
import 'agreement_adjust_controller.dart';
import 'agreement_adjust_intro_step2.dart';

class AgreementAdjustIntroPage extends StatefulWidget {
  const AgreementAdjustIntroPage({super.key});

  @override
  State<AgreementAdjustIntroPage> createState() =>
      _AgreementAdjustIntroPageState();
}

class _AgreementAdjustIntroPageState extends State<AgreementAdjustIntroPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _positionController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isSigningUp = false;

  @override
  void dispose() {
    _nameController.dispose();
    _positionController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Slate 50
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Container(
                padding: EdgeInsets.all(isMobile ? 24 : 40),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF), // Blue 50
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFDBEAFE)),
                      ),
                      child: const Text(
                        "Step 1/2",
                        style: TextStyle(
                          color: Color(0xFF0F172A), // Blue 600
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "창업자 정보를 입력해주세요",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A), // Navy
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "향후 주주간 계약(SHA) 조율을 위해\n회사와 개인 기본 정보를 받아요.",
                      style: TextStyle(
                        color: Color(0xFF64748B), // Slate 500
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildField(
                            label: "이름 / Your Name",
                            controller: _nameController,
                            hintText: "예) 홍길동",
                          ),
                          const SizedBox(height: 20),
                          _buildField(
                            label: "직위 / Position (Role)",
                            controller: _positionController,
                            hintText: "예) CEO / CTO / COO",
                          ),
                          const SizedBox(height: 20),
                          _buildField(
                            label: "이메일 / Email",
                            controller: _emailController,
                            hintText: "예) founder@startup.com",
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return "이메일을 입력해주세요.";
                              }
                              if (!val.contains("@")) {
                                return "올바른 이메일 형식을 확인해주세요.";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          _buildField(
                            label: "비밀번호 / Password",
                            controller: _passwordController,
                            hintText: "8자 이상 입력해주세요",
                            obscureText: true,
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return "비밀번호를 입력해주세요.";
                              }
                              if (val.length < 8) {
                                return "비밀번호는 8자 이상이어야 합니다.";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          _buildField(
                            label: "연락처 / Mobile number",
                            controller: _phoneController,
                            hintText: "010-1234-5678",
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              _PhoneNumberFormatter(),
                            ],
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return "연락처를 입력해주세요.";
                              }
                              if (!RegExp(r'^010-\d{4}-\d{4}$').hasMatch(val)) {
                                return "010-XXXX-XXXX 형식으로 입력해주세요.";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 40),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => Get.back(),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFF64748B),
                                    side: const BorderSide(
                                      color: Color(0xFFCBD5E1),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 20,
                                    ),
                                  ),
                                  child: const Text(
                                    "뒤로가기",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _isSigningUp
                                      ? null
                                      : _handleSubmit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(
                                      0xFF0F172A,
                                    ), // Navy
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 20,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: _isSigningUp
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                        )
                                      : const Text(
                                          "계속하기 (회원가입)",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "이미 계정이 있으신가요?",
                                style: TextStyle(color: Color(0xFF64748B)),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Get.to(() => const LoginPage()),
                                child: const Text(
                                  "로그인",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A), // Blue 600
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    String? hintText,
    TextInputType keyboardType = TextInputType.text,
    String? prefixText,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF475569), // Slate 600
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          obscureText: obscureText,
          validator:
              validator ??
              (val) {
                if (val == null || val.isEmpty) {
                  return "필수 입력 항목입니다.";
                }
                return null;
              },
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixText: prefixText,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF2563EB), // Blue 600
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSigningUp = true);

    try {
      // 1. 회원가입 (Firebase Auth)
      // AuthService가 GetxService여야 하고 main.dart 등에서 Get.put() 되어있어야 함.
      // 만약 등록 안되어있다면 여기서 put 해줘야 함.
      // 안전을 위해 없으면 put 하는 로직이 필요할 수 있으나, 일반적으로 main에서 처리.
      // 여기서는 그냥 Get.find로 하는데, 에러나면 Get.putAsync 등을 고려해야 함.
      if (!Get.isRegistered<AuthService>()) {
        Get.put(AuthService());
      }
      final authService = Get.find<AuthService>();
      await authService.signUpWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      // 2. 창업자 정보 임시 저장 (Controller)
      final controller = Get.put(AgreementAdjustController());
      controller.saveFounderInfo(
        name: _nameController.text,
        position: _positionController.text,
        email: _emailController.text,
        phone: _phoneController.text,
      );

      // 3. 다음 단계로 이동
      Get.to(() => const AgreementAdjustIntroStep2Page());
    } catch (e) {
      Get.snackbar(
        "회원가입 실패",
        e.toString().replaceAll("Exception: ", ""),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      if (mounted) setState(() => _isSigningUp = false);
    }
  }
}

class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // 숫자만 남기기
    final text = newValue.text.replaceAll(RegExp(r'\D'), '');

    if (text.isEmpty) return newValue;

    // 010-XXXX-XXXX 포맷팅 로직
    String formatted = "";
    if (text.length <= 3) {
      formatted = text;
    } else if (text.length <= 7) {
      formatted = "${text.substring(0, 3)}-${text.substring(3)}";
    } else {
      formatted =
          "${text.substring(0, 3)}-${text.substring(3, 7)}-${text.substring(7, text.length > 11 ? 11 : text.length)}";
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
