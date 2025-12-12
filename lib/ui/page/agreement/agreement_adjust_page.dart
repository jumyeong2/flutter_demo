import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/responsive_layout.dart';
import 'agreement_adjust_controller.dart';

class AgreementAdjustPage extends StatelessWidget {
  const AgreementAdjustPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AgreementAdjustController());
    final isMobile = ResponsiveLayout.isMobile(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "주주간 계약 조율",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Obx(
            () => LinearProgressIndicator(
              value: controller.progress,
              backgroundColor: const Color(0xFFE0F2FE),
              color: const Color(0xFF0EA5E9),
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
        // 왼쪽: 카테고리 리스트
        Container(
          width: 280,
          color: Colors.white,
          child: _buildCategoryList(context, controller),
        ),
        // 중간: 질문 목록
        Container(
          width: 320,
          color: const Color(0xFFF0F9FF),
          child: Obx(() {
            if (controller.selectedCategory.value == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.help_outline, size: 48, color: Colors.grey[400]),
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
        // 오른쪽: 질문 상세
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
                        Icons.quiz_outlined,
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

  // 카테고리 리스트 (데스크톱)
  Widget _buildCategoryList(
    BuildContext context,
    AgreementAdjustController controller,
  ) {
    return Obx(
      () => ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12),
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
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFE0F2FE)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF0EA5E9)
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  if (isComplete)
                    Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Color(0xFF10B981),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 16,
                        color: Colors.white,
                      ),
                    )
                  else
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          "${index + 1}",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
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
                                : FontWeight.w600,
                            color: isSelected
                                ? const Color(0xFF0369A1)
                                : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "$answeredCount/$totalCount 완료",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
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

  // 카테고리별 아이콘 매핑
  IconData _getCategoryIcon(String categoryId) {
    switch (categoryId) {
      case "mission":
        return Icons.rocket_launch_rounded;
      case "roles":
        return Icons.people_alt_rounded;
      case "equity":
        return Icons.pie_chart_rounded;
      case "decision":
        return Icons.gavel_rounded;
      case "exit":
        return Icons.exit_to_app_rounded;
      default:
        return Icons.folder_rounded;
    }
  }

  // 카테고리별 그라디언트 색상
  List<Color> _getCategoryGradient(String categoryId) {
    // 모든 카테고리에 통일된 하늘색 적용
    return [Colors.lightBlue, Colors.lightBlue]; // Sky 400 -> Sky 500
  }

  // 카테고리 리스트 (모바일)
  Widget _buildCategoryListMobile(
    BuildContext context,
    AgreementAdjustController controller,
  ) {
    return Obx(() {
      if (controller.categories.isEmpty) {
        return const Center(child: Text("카테고리를 불러오는 중..."));
      }
      return GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.85,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: controller.categories.length,
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
          final progress = totalCount > 0 ? answeredCount / totalCount : 0.0;
          final gradientColors = _getCategoryGradient(category.id);

          return InkWell(
            onTap: () => controller.selectCategory(category),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 상단 아이콘 영역
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradientColors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Stack(
                      children: [
                        // 배경 패턴
                        Positioned(
                          right: -10,
                          top: -10,
                          child: Icon(
                            _getCategoryIcon(category.id),
                            size: 80,
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        // 메인 아이콘
                        Center(
                          child: Icon(
                            _getCategoryIcon(category.id),
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        // 완료 배지
                        if (isComplete)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.check_rounded,
                                size: 16,
                                color: Color(0xFF10B981),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // 하단 텍스트 영역
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            category.label,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 진행률 바
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: progress,
                                  backgroundColor: const Color(0xFFE5E7EB),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    gradientColors[0],
                                  ),
                                  minHeight: 6,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "$answeredCount/$totalCount 완료",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  // 질문 목록 (데스크톱)
  Widget _buildQuestionList(
    BuildContext context,
    AgreementAdjustController controller,
  ) {
    final category = controller.selectedCategory.value!;
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: category.questions.length,
      itemBuilder: (context, index) {
        final question = category.questions[index];
        final isSelected = controller.selectedQuestion.value?.id == question.id;
        final isAnswered =
            controller.answers.containsKey(question.id) &&
            controller.answers[question.id]!.isNotEmpty;

        return Obx(
          () => InkWell(
            onTap: () => controller.selectQuestion(question),
            child: Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFE0F2FE) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF0EA5E9)
                      : (isAnswered
                            ? const Color(0xFF10B981)
                            : Colors.grey[200]!),
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 6,
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
                          ? const Color(0xFF10B981)
                          : Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: isAnswered
                        ? const Icon(Icons.check, size: 18, color: Colors.white)
                        : Center(
                            child: Text(
                              "${index + 1}",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
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
                            : FontWeight.normal,
                        color: isSelected
                            ? const Color(0xFF0369A1)
                            : Colors.black87,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // 질문 목록 (모바일)
  Widget _buildQuestionListMobile(
    BuildContext context,
    AgreementAdjustController controller,
  ) {
    final category = controller.selectedCategory.value!;
    return Column(
      children: [
        // 헤더
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => controller.selectedCategory.value = null,
              ),
              Expanded(
                child: Text(
                  category.label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        // 질문 리스트
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: category.questions.length,
            itemBuilder: (context, index) {
              final question = category.questions[index];
              final isAnswered =
                  controller.answers.containsKey(question.id) &&
                  controller.answers[question.id]!.isNotEmpty;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () => controller.selectQuestion(question),
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: isAnswered
                                ? const Color(0xFF10B981)
                                : Colors.white,
                            shape: BoxShape.circle,
                            border: isAnswered
                                ? null
                                : Border.all(
                                    color: const Color(0xFF0EA5E9),
                                    width: 2,
                                  ),
                          ),
                          child: isAnswered
                              ? const Icon(
                                  Icons.check,
                                  size: 22,
                                  color: Colors.white,
                                )
                              : Center(
                                  child: Text(
                                    "${index + 1}",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0369A1),
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
                        Icon(
                          Icons.chevron_right,
                          color: Colors.grey[400],
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // 질문 상세 (데스크톱)
  Widget _buildQuestionDetail(
    BuildContext context,
    AgreementAdjustController controller,
  ) {
    final question = controller.selectedQuestion.value!;
    final answerController = TextEditingController(
      text: controller.getCurrentAnswer(),
    );

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(32),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              question.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE1F5FE), // Slightly darker background
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFB3E5FC), // Slightly darker border
                  width: 1,
                ),
              ),
              child: TextField(
                controller: answerController,
                maxLines: 8,
                decoration: InputDecoration(
                  hintText: "답변을 입력해주세요...",
                  filled: true,
                  fillColor: Colors.transparent,
                  contentPadding: const EdgeInsets.all(16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF0EA5E9),
                      width: 2,
                    ),
                  ),
                ),
                style: const TextStyle(fontSize: 15, height: 1.6),
                onChanged: (value) {
                  controller.saveAnswer(question.id, value);
                },
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: controller.goToPreviousQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0EA5E9),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Back",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: controller.goToNextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0EA5E9),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 질문 상세 (모바일)
  Widget _buildQuestionDetailMobile(
    BuildContext context,
    AgreementAdjustController controller,
  ) {
    final question = controller.selectedQuestion.value!;
    final answerController = TextEditingController(
      text: controller.getCurrentAnswer(),
    );

    return Column(
      children: [
        // 헤더
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: controller.goToPreviousQuestion,
              ),
              const Expanded(
                child: Text(
                  "질문",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        // 내용
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  question.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFFE1F5FE,
                    ), // Slightly darker background
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFB3E5FC), // Slightly darker border
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: answerController,
                    maxLines: 8,
                    decoration: InputDecoration(
                      hintText: "답변을 입력해주세요...",
                      filled: true,
                      fillColor: Colors.transparent,
                      contentPadding: const EdgeInsets.all(16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF0EA5E9),
                          width: 2,
                        ),
                      ),
                    ),
                    style: const TextStyle(fontSize: 15, height: 1.6),
                    onChanged: (value) {
                      controller.saveAnswer(question.id, value);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        // 버튼
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: controller.goToPreviousQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0EA5E9),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Back",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: controller.goToNextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0EA5E9),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
