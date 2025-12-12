import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/responsive_layout.dart';
import 'agreement_controller.dart';

class AgreementPage extends StatelessWidget {
  const AgreementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AgreementController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(onPressed: () => Get.back()),
        title: const Text("주주간 계약 조율"),
      ),
      backgroundColor: const Color(0xFFF7FBFF),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1024),
            child: Column(
              children: [
                _buildHeader(context, controller),
                const SizedBox(height: 32),
                Obx(
                  () => Column(
                    children: controller.currentPageQuestions
                        .map(
                          (question) =>
                              _buildQuestionCard(context, controller, question),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: 32),
                _buildNavigationButtons(context, controller),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AgreementController controller) {
    bool isMobile = ResponsiveLayout.isMobile(context);
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.edit_document,
                          color: Colors.indigo,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "공동창업자 주주 간 계약 조율",
                            style: TextStyle(
                              fontSize: isMobile ? 18 : 20,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "각 질문에 대한 양측의 의견을 조율하여 최종 합의안을 작성하세요.",
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: isMobile ? 13 : 14,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isMobile)
                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Page ${controller.currentPage.value + 1}/${controller.totalPages}",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[400],
                        ),
                      ),
                      Text(
                        "${controller.progress.round()}%",
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          if (isMobile) ...[
            const SizedBox(height: 16),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Page ${controller.currentPage.value + 1}/${controller.totalPages}",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    "${controller.progress.round()}%",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          Obx(
            () => ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: controller.progress / 100,
                backgroundColor: Colors.grey[100],
                color: Colors.indigo,
                minHeight: isMobile ? 6 : 8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(
    BuildContext context,
    AgreementController controller,
    question,
  ) {
    bool isMobile = ResponsiveLayout.isMobile(context);
    final category = controller.getCategoryForQuestion(question.id);
    final userAAnswer = controller.getUserAAnswer(question.id);
    final userBAnswer = controller.getUserBAnswer(question.id);
    final hasConflict = controller.hasConflict(question.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasConflict ? Colors.amber[200]! : Colors.indigo[100]!,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: hasConflict ? Colors.amber[100] : Colors.indigo[100],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    hasConflict ? Icons.balance : Icons.gavel,
                    size: 12,
                    color: hasConflict ? Colors.amber[900] : Colors.indigo[900],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    hasConflict ? "조율 필요" : "의견 일치",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: hasConflict
                          ? Colors.amber[900]
                          : Colors.indigo[900],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category & Question
                Row(
                  children: [
                    Icon(
                      _getCategoryIcon(category),
                      size: 20,
                      color: Colors.indigo,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        category,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  question.title,
                  style: TextStyle(
                    fontSize: isMobile ? 18 : 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          question.description,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Opinions
                isMobile
                    ? Column(
                        children: [
                          _opinionBox(
                            "User A (나)",
                            userAAnswer,
                            true,
                            isUserA: true,
                          ),
                          const SizedBox(height: 16),
                          _opinionBox(
                            "User B (공동창업자)",
                            userBAnswer,
                            true,
                            isUserA: false,
                          ),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _opinionBox(
                              "User A (나)",
                              userAAnswer,
                              true,
                              isUserA: true,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _opinionBox(
                              "User B (공동창업자)",
                              userBAnswer,
                              true,
                              isUserA: false,
                            ),
                          ),
                        ],
                      ),
                const SizedBox(height: 24),

                // Consensus Area
                Container(
                  padding: EdgeInsets.all(isMobile ? 16 : 24),
                  decoration: BoxDecoration(
                    color: Colors.indigo[50],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.indigo[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "최종 합의안 (계약 조항)",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF334155),
                            ),
                          ),
                          if (!isMobile)
                            Obx(
                              () => OutlinedButton.icon(
                                onPressed: controller.isAiLoading(question.id)
                                    ? null
                                    : () => controller.triggerAI(question.id),
                                icon: controller.isAiLoading(question.id)
                                    ? const SizedBox(
                                        width: 12,
                                        height: 12,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(Icons.auto_awesome, size: 16),
                                label: Text(
                                  controller.isAiLoading(question.id)
                                      ? "시장 표준 분석 중..."
                                      : "시장 표준(Standard) 제안받기",
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.indigo,
                                  side: BorderSide(color: Colors.indigo[200]!),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      if (isMobile) ...[
                        const SizedBox(height: 12),
                        Obx(
                          () => SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: controller.isAiLoading(question.id)
                                  ? null
                                  : () => controller.triggerAI(question.id),
                              icon: controller.isAiLoading(question.id)
                                  ? const SizedBox(
                                      width: 12,
                                      height: 12,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.auto_awesome, size: 16),
                              label: Text(
                                controller.isAiLoading(question.id)
                                    ? "시장 표준 분석 중..."
                                    : "시장 표준(Standard) 제안받기",
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.indigo,
                                side: BorderSide(color: Colors.indigo[200]!),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      Obx(
                        () => TextField(
                          controller:
                              TextEditingController(
                                  text: controller.getConsensusAnswer(
                                    question.id,
                                  ),
                                )
                                ..selection = TextSelection.fromPosition(
                                  TextPosition(
                                    offset: controller
                                        .getConsensusAnswer(question.id)
                                        .length,
                                  ),
                                ),
                          onChanged: (val) => controller.updateConsensusAnswer(
                            question.id,
                            val,
                          ),
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: "양측의 의견을 조율하여 최종 계약 문구를 작성하세요.",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                          ),
                          style: const TextStyle(fontSize: 15, height: 1.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _opinionBox(
    String label,
    String text,
    bool disabled, {
    required bool isUserA,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUserA
            ? Colors.indigo[50]!.withOpacity(0.5)
            : Colors.amber[50]!.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUserA ? Colors.indigo[100]! : Colors.amber[100]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            text.isEmpty ? "답변이 입력되지 않았습니다." : text,
            style: TextStyle(
              fontSize: 14,
              color: text.isEmpty ? Colors.grey : const Color(0xFF334155),
              height: 1.5,
              fontStyle: text.isEmpty ? FontStyle.italic : FontStyle.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(
    BuildContext context,
    AgreementController controller,
  ) {
    bool isMobile = ResponsiveLayout.isMobile(context);

    return Obx(
      () => Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: controller.currentPage.value > 0
                  ? controller.goToPreviousPage
                  : null,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.indigo,
                side: const BorderSide(color: Colors.indigo, width: 1.5),
                disabledForegroundColor: Colors.grey,
                disabledBackgroundColor: Colors.grey[100],
                padding: EdgeInsets.symmetric(vertical: isMobile ? 16 : 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                "Back",
                style: TextStyle(
                  fontSize: isMobile ? 16 : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: controller.goToNextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: isMobile ? 16 : 20),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                controller.currentPage.value < controller.totalPages - 1
                    ? "Continue"
                    : "Save & Continue",
                style: TextStyle(
                  fontSize: isMobile ? 16 : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    if (category.contains("미션") || category.contains("가치")) {
      return Icons.rocket_launch_rounded;
    } else if (category.contains("R&R") || category.contains("역할")) {
      return Icons.people_alt_rounded;
    } else if (category.contains("지분") || category.contains("수익")) {
      return Icons.pie_chart_rounded;
    } else if (category.contains("의사결정")) {
      return Icons.gavel_rounded;
    } else if (category.contains("이탈") || category.contains("M&A")) {
      return Icons.exit_to_app_rounded;
    }
    return Icons.folder_rounded;
  }
}
