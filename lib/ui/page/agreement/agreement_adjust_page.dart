import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/responsive_layout.dart';
import 'agreement_adjust_controller.dart';

class AgreementAdjustPage extends StatelessWidget {
  const AgreementAdjustPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Put controller
    final controller = Get.put(AgreementAdjustController());
    final isMobile = ResponsiveLayout.isMobile(context);

    // Design System Colors
    const Color bgSurface = Color(0xFFF8FAFC); // Slate 50
    const Color textMain = Color(0xFF0F172A);
    const Color success = Color(0xFF16A34A); // Green 600

    return Scaffold(
      backgroundColor: bgSurface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textMain),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "팀 합의 조율",
          style: TextStyle(color: textMain, fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Obx(
            () => LinearProgressIndicator(
              value: controller.progress,
              backgroundColor: const Color(0xFFE2E8F0), // Slate 200
              color: success, // Progress in Green
              minHeight: 4,
            ),
          ),
        ),
      ),
      body: isMobile
          ? _buildMobileLayout(context, controller)
          : _buildDesktopLayout(context, controller),
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    AgreementAdjustController controller,
  ) {
    return Obx(() {
      if (controller.selectedQuestion.value != null) {
        return _buildQuestionDetailMobile(context, controller);
      } else if (controller.selectedCategory.value != null) {
        return _buildQuestionListMobile(context, controller);
      } else {
        return _buildCategoryListMobile(context, controller);
      }
    });
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    AgreementAdjustController controller,
  ) {
    return Row(
      children: [
        // Left: Category List
        Container(
          width: 280,
          color: Colors.white,
          child: _buildCategoryList(context, controller),
        ),
        // Middle: Question List
        Container(
          width: 320,
          color: const Color(0xFFF1F5F9), // Slate 100
          child: Obx(() {
            if (controller.selectedCategory.value == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.category_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "카테고리를 선택해주세요",
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              );
            }
            return _buildQuestionList(context, controller);
          }),
        ),
        // Right: Question Detail
        Expanded(
          child: Obx(() {
            if (controller.selectedQuestion.value == null) {
              return Container(
                color: Colors.white,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.edit_note_rounded,
                        size: 64,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "질문을 선택해주세요",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return _buildQuestionDetail(context, controller);
          }),
        ),
      ],
    );
  }

  // --- Category List (Desktop) ---
  Widget _buildCategoryList(
    BuildContext context,
    AgreementAdjustController controller,
  ) {
    return Obx(
      () => ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        itemCount: controller.categories.length,
        itemBuilder: (context, index) {
          final category = controller.categories[index];
          final isSelected =
              controller.selectedCategory.value?.id == category.id;

          final answeredCount = category.questions
              .where(
                (q) =>
                    controller.answers.containsKey(q.id) &&
                    controller.answers[q.id]!.isNotEmpty,
              )
              .length;
          final totalCount = category.questions.length;
          final isComplete = answeredCount == totalCount;

          return InkWell(
            onTap: () => controller.selectCategory(category),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFF1F5F9)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF0F172A)
                      : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  // Icon / Number
                  if (isComplete)
                    Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Color(0xFFDCFCE7), // Green 100
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 14,
                        color: Color(0xFF16A34A), // Green 600
                      ),
                    )
                  else
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[300]!),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          "${index + 1}",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.label,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: isSelected
                                ? const Color(0xFF0F172A)
                                : const Color(0xFF64748B),
                          ),
                        ),
                        if (isSelected) ...[
                          const SizedBox(height: 4),
                          Text(
                            "$answeredCount/$totalCount 완료",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // --- Category List (Mobile) ---
  Widget _buildCategoryListMobile(
    BuildContext context,
    AgreementAdjustController controller,
  ) {
    return Obx(() {
      if (controller.categories.isEmpty) {
        return const Center(
          child: Text("로딩 중...", style: TextStyle(color: Colors.grey)),
        );
      }
      return ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: controller.categories.length,
        separatorBuilder: (ctx, i) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final category = controller.categories[index];
          final answeredCount = category.questions
              .where(
                (q) =>
                    controller.answers.containsKey(q.id) &&
                    controller.answers[q.id]!.isNotEmpty,
              )
              .length;
          final totalCount = category.questions.length;
          final isComplete = answeredCount == totalCount;

          return InkWell(
            onTap: () => controller.selectCategory(category),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isComplete
                          ? const Color(0xFFDCFCE7)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: isComplete
                          ? const Icon(Icons.check, color: Color(0xFF16A34A))
                          : Text(
                              "${index + 1}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF64748B),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.label,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "$answeredCount/$totalCount 완료",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Color(0xFFCBD5E1)),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  // --- Question List (Desktop) ---
  Widget _buildQuestionList(
    BuildContext context,
    AgreementAdjustController controller,
  ) {
    // Note: Desktop view receives selectedCategory from controller
    final category = controller.selectedCategory.value!;

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 20, left: 8),
          child: Text(
            category.label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
        ),
        ...List.generate(category.questions.length, (index) {
          final question = category.questions[index];
          final isSelected =
              controller.selectedQuestion.value?.id == question.id;
          final isAnswered =
              controller.answers.containsKey(question.id) &&
              controller.answers[question.id]!.isNotEmpty;

          return InkWell(
            onTap: () => controller.selectQuestion(question),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF0F172A) // Selected border Navy
                      : (isAnswered
                            ? const Color(
                                0xFF86EFAC,
                              ) // Answered border Light Green
                            : const Color(0xFFE2E8F0)), // Default border Slate
                  width: isSelected ? 1.5 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isAnswered
                          ? const Color(0xFFDCFCE7)
                          : const Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: isAnswered
                          ? const Icon(
                              Icons.check,
                              size: 16,
                              color: Color(0xFF16A34A),
                            )
                          : Text(
                              "Q${index + 1}",
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF64748B),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      question.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: isSelected
                            ? const Color(0xFF0F172A)
                            : const Color(0xFF475569),
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  // --- Question List (Mobile) ---
  Widget _buildQuestionListMobile(
    BuildContext context,
    AgreementAdjustController controller,
  ) {
    final category = controller.selectedCategory.value!;
    return Column(
      children: [
        // Content Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          color: Colors.white,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => controller.selectedCategory.value = null,
                color: const Color(0xFF0F172A),
              ),
              Expanded(
                child: Text(
                  category.label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Color(0xFFE2E8F0)),

        // List
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: category.questions.length,
            separatorBuilder: (ctx, i) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final question = category.questions[index];
              final isAnswered =
                  controller.answers.containsKey(question.id) &&
                  controller.answers[question.id]!.isNotEmpty;

              return InkWell(
                onTap: () => controller.selectQuestion(question),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isAnswered
                          ? const Color(0xFF86EFAC)
                          : const Color(0xFFE2E8F0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isAnswered
                              ? const Color(0xFFDCFCE7)
                              : const Color(0xFFF1F5F9),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: isAnswered
                              ? const Icon(
                                  Icons.check,
                                  size: 18,
                                  color: Color(0xFF16A34A),
                                )
                              : Text(
                                  "Q${index + 1}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          question.title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0F172A),
                            height: 1.4,
                          ),
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Color(0xFFCBD5E1)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // --- Question Detail (Desktop) ---
  Widget _buildQuestionDetail(
    BuildContext context,
    AgreementAdjustController controller,
  ) {
    final question = controller.selectedQuestion.value!;
    final answerController = TextEditingController(
      text: controller.getCurrentAnswer(),
    );

    // Is this the very last question of the survey?
    final isLastQuestion = controller.isLastQuestion();

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 40),
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "질문 (${question.id.split('_').last})",
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                question.title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                question.description,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF475569),
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),

              // ① Context Guide (Common)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Text(
                  "이 질문은 각자의 생각을 평가하기 위한 것이 아니라,\n팀이 합의해야 할 기준을 드러내기 위한 질문입니다.",
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ② Input Guide Box (Key)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFDCFCE7)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.lightbulb,
                          size: 18,
                          color: Color(0xFF16A34A),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "입력 가이드",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF15803D),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "가능한 한 조건이 드러나게 작성해 주세요.\n(언제 / 얼마 / 어떤 상황에서 / 누가 결정하는지)",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF166534),
                        height: 1.6,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "예시",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF15803D),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "• “○○한 상황에서는 ○○까지 허용”\n• “○○ 이상이면 전원 합의 필요”\n• “○○가 충족되면 방향 재검토”",
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF166534),
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Divider / Input Section
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "기준 입력",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF334155),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "한 문장으로 합의가 되도록, 조건(언제/얼마나/누가)을 포함해 작성해 주세요.",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: answerController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        // ③ Fixed Placeholder
                        hintText: "조건이 드러나는 한 문장으로 작성해 주세요.",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.all(16),
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
                            width: 1.5,
                          ),
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: Color(0xFF0F172A),
                      ),
                      onChanged: (value) {
                        controller.saveAnswer(question.id, value);
                      },
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "한 문장 · 기준 하나 · 2줄 이내",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Helper Text Bottom
              Center(
                child: Text(
                  "입력 내용은 자동 저장됩니다.",
                  style: TextStyle(fontSize: 13, color: Colors.grey[400]),
                ),
              ),
              const SizedBox(height: 20),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: controller.goToPreviousQuestion,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF475569),
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "이전 질문",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      controller.goToNextQuestion();
                      Get.snackbar(
                        "저장됨",
                        "기준이 저장되었습니다",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: const Color(0xFF0F172A),
                        colorText: Colors.white,
                        margin: const EdgeInsets.all(20),
                        duration: const Duration(seconds: 1),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F172A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isLastQuestion ? "저장하기" : "다음 질문",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  // --- Question Detail (Mobile) ---
  Widget _buildQuestionDetailMobile(
    BuildContext context,
    AgreementAdjustController controller,
  ) {
    final question = controller.selectedQuestion.value!;
    final answerController = TextEditingController(
      text: controller.getCurrentAnswer(),
    );
    final isLastQuestion = controller.isLastQuestion();

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          color: Colors.white,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: controller.goToPreviousQuestion,
                color: const Color(0xFF0F172A),
              ),
              const Expanded(
                child: Text(
                  "질문 상세",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Color(0xFFE2E8F0)),

        // Body
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  question.description,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF475569),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 32),

                // Input Card
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "기준 입력",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF334155),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "한 문장으로, 조건이 포함되면 좋아요.",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: answerController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: question.placeholder,
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: const Color(0xFFF1F5F9),
                        contentPadding: const EdgeInsets.all(16),
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
                            width: 1.5,
                          ),
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: Color(0xFF0F172A),
                      ),
                      onChanged: (value) {
                        controller.saveAnswer(question.id, value);
                      },
                    ),
                    const SizedBox(height: 6),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "한 문장 · 기준 하나 · 2줄 이내",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 48),

                // Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.goToNextQuestion();
                      Get.snackbar(
                        "저장됨",
                        "기준이 저장되었습니다",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: const Color(0xFF0F172A),
                        colorText: Colors.white,
                        margin: const EdgeInsets.all(20),
                        duration: const Duration(seconds: 1),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F172A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      isLastQuestion ? "저장하기" : "저장하고 다음",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    "모든 걸 합의하는 단계가 아닙니다.\n지금 기준만 남겨도 충분합니다.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[400],
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
