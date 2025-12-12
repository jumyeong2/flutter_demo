import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'agreement_controller.dart';

class AgreementPopup extends StatelessWidget {
  const AgreementPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AgreementController>();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800, maxHeight: 800),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF), // indigo-50
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.balance,
                        size: 32,
                        color: Color(0xFF4F46E5), // indigo-600
                      ),
                    ),
                  ),
                  const Text(
                    "Co-Founder Agreement",
                    style: TextStyle(
                      fontFamily:
                          'Serif', // Using default serif if custom not avail
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A), // slate-900
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "아래 내용은 법적 구속력을 갖는 계약의 기초가 됩니다.",
                    style: TextStyle(
                      color: Color(0xFF64748B), // slate-500
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            // Divider
            const Divider(height: 1, color: Color(0xFFE2E8F0)),

            // Content List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(32),
                itemCount: controller.allQuestions.length > 3
                    ? 4
                    : controller.allQuestions.length,
                itemBuilder: (context, index) {
                  // Show "More" indicator as the last item if there are more than 3 questions
                  if (index == 3 && controller.allQuestions.length > 3) {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          const Icon(
                            Icons.more_horiz,
                            color: Color(0xFF94A3B8), // slate-400
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "더보기 (...외 ${controller.allQuestions.length - 3}개 조항)",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF64748B), // slate-500
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final question = controller.allQuestions[index];
                  final category = controller.getCategoryForQuestion(
                    question.id,
                  );
                  final consensus = controller.getConsensusAnswer(question.id);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC), // slate-50
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFFE2E8F0),
                      ), // slate-200
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "제 ${index + 1} 조 [$category]",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF64748B), // slate-500
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          consensus.isEmpty ? "(내용 없음)" : consensus,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.6,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF0F172A), // slate-900
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Footer
            LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 600;
                return Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
                  ),
                  child: isMobile
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => Get.back(),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: const Color(0xFF475569),
                                      side: const BorderSide(
                                        color: Color(0xFFE2E8F0),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    child: const Text("닫기"),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Get.dialog(
                                        AlertDialog(
                                          title: const Text("알림"),
                                          content: const Text(
                                            "PDF로 변환하여 메일로 발송했습니다.",
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Get.back(),
                                              child: const Text("확인"),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF4F46E5),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 16,
                                      ),
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      "PDF 내보내기",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "* 본 문서는 변호사 검토 전 초안(Draft) 용도입니다.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF94A3B8), // slate-400
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "* 본 문서는 변호사 검토 전 초안(Draft) 용도입니다.",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF94A3B8), // slate-400
                              ),
                            ),
                            Row(
                              children: [
                                OutlinedButton(
                                  onPressed: () => Get.back(),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFF475569),
                                    side: const BorderSide(
                                      color: Color(0xFFE2E8F0),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  child: const Text("닫기"),
                                ),
                                const SizedBox(width: 12),
                                ElevatedButton(
                                  onPressed: () {
                                    Get.dialog(
                                      AlertDialog(
                                        title: const Text("알림"),
                                        content: const Text(
                                          "PDF로 변환하여 메일로 발송했습니다.",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Get.back(),
                                            child: const Text("확인"),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF4F46E5),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 16,
                                    ),
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    "PDF 내보내기",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
