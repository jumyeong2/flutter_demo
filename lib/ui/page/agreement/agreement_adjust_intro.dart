import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

import '../../widgets/responsive_layout.dart';
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
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _positionController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFF),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Container(
                padding: EdgeInsets.all(isMobile ? 20 : 32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Step 1/2",
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "창업자 정보를 입력해주세요",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "향후 주주간 계약(SHA) 조율을 위해 회사와 개인 기본 정보를 받아요.",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildField(
                            label: "이름 / Your Name",
                            controller: _nameController,
                            hintText: "예) 홍길동",
                          ),
                          const SizedBox(height: 16),
                          _buildField(
                            label: "직위 / Position (Role)",
                            controller: _positionController,
                            hintText: "예) CEO / CTO / COO",
                          ),
                          const SizedBox(height: 16),
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
                          const SizedBox(height: 16),
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
                          const SizedBox(height: 28),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => Get.back(),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.blue[700],
                                    side: BorderSide(color: Colors.blue[200]!),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
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
                                  onPressed: _handleSubmit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue[600],
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                  ),
                                  child: const Text(
                                    "계속하기",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
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
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
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
            prefixText: prefixText,
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.blue, width: 1.2),
            ),
          ),
        ),
      ],
    );
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;
    Get.to(() => const AgreementAdjustIntroStep2Page());
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
