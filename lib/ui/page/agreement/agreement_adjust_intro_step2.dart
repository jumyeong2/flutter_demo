import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/responsive_layout.dart';
import 'agreement_adjust_controller.dart';
import 'agreement_adjust_page.dart';

class AgreementAdjustIntroStep2Page extends StatefulWidget {
  const AgreementAdjustIntroStep2Page({super.key});

  @override
  State<AgreementAdjustIntroStep2Page> createState() =>
      _AgreementAdjustIntroStep2PageState();
}

class _AgreementAdjustIntroStep2PageState
    extends State<AgreementAdjustIntroStep2Page> {
  final _formKey = GlobalKey<FormState>();
  final _companyController = TextEditingController();
  final _startupAgeController = TextEditingController();
  final _industryController = TextEditingController();
  final _teamController = TextEditingController();

  @override
  void dispose() {
    _companyController.dispose();
    _startupAgeController.dispose();
    _industryController.dispose();
    _teamController.dispose();
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
                      "Step 2/2",
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "회사 정보를 입력해주세요",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "조율 과정에 필요한 회사 기본 정보를 입력하면 다음 단계로 넘어갑니다.",
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
                            label: "회사 이름 / Company Name",
                            controller: _companyController,
                            hintText: "예) CoSync, Inc.",
                          ),
                          const SizedBox(height: 16),
                          _buildField(
                            label: "회사 기간 / Startup age",
                            controller: _startupAgeController,
                            hintText: "예) 1.5년",
                          ),
                          const SizedBox(height: 16),
                          _buildField(
                            label: "산업군 / Industry",
                            controller: _industryController,
                            hintText: "예) SaaS / 핀테크 / 커머스",
                          ),
                          const SizedBox(height: 16),
                          _buildField(
                            label: "팀 / Team (Sales / Marketing / CS / …)",
                            controller: _teamController,
                            hintText: "예) Sales 3명, CS 2명",
                          ),
                          const SizedBox(height: 28),
                          Row(
                            children: [
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

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final controller = Get.find<AgreementAdjustController>();
      controller.saveCompanyInfo(
        name: _companyController.text,
        age: _startupAgeController.text,
        ind: _industryController.text,
        team: _teamController.text,
      );

      // 파이어베이스 저장
      await controller.submitFounderInfoToFirebase();
    } catch (e) {
      print("Error saving company info: $e");
    }

    Get.to(() => const AgreementAdjustPage());
  }
}
