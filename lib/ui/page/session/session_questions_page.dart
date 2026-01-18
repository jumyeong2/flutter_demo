import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'session_questions_controller.dart';
import '../../../data/model/adjustment_question.dart';
import '../agreement/agreement_adjust_controller.dart';

/// SessionQuestionsPage: 질문 답변 페이지
class SessionQuestionsPage extends StatefulWidget {
  const SessionQuestionsPage({super.key});

  @override
  State<SessionQuestionsPage> createState() => _SessionQuestionsPageState();
}

class _SessionQuestionsPageState extends State<SessionQuestionsPage> {
  final Map<String, TextEditingController> _textControllers = {};

  @override
  void dispose() {
    // 모든 TextEditingController dispose
    for (var controller in _textControllers.values) {
      controller.dispose();
    }
    _textControllers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SessionQuestionsController());

    // 질문 목록 가져오기 (AgreementAdjustController에서)
    // 컨트롤러가 없으면 생성하고, 있으면 재사용
    final adjustController = Get.put(AgreementAdjustController());
    final allQuestions = <AdjustmentQuestion>[];
    for (var category in adjustController.categories) {
      allQuestions.addAll(category.questions);
    }

    // TextEditingController 초기화
    for (var question in allQuestions) {
      if (!_textControllers.containsKey(question.id)) {
        final answerText = controller.answers[question.id] ?? '';
        _textControllers[question.id] = TextEditingController(text: answerText);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('질문 답변'),
        actions: [
          Obx(
            () => TextButton(
              onPressed: controller.isSaving.value
                  ? null
                  : controller.saveAnswers,
              child: controller.isSaving.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('저장'),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // 진행률 표시
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '진행률',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('${controller.completedCount}/10 완료'),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: controller.completedCount / 10,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // 질문 목록
            ...allQuestions.map(
              (question) => Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (question.description.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          question.description,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      Obx(() {
                        final answerText =
                            controller.answers[question.id] ?? '';
                        final textController = _textControllers[question.id]!;
                        // answers가 변경되면 TextField 업데이트
                        if (textController.text != answerText) {
                          textController.text = answerText;
                          textController.selection = TextSelection.collapsed(
                            offset: answerText.length,
                          );
                        }
                        return TextField(
                          key: ValueKey(question.id),
                          decoration: InputDecoration(
                            labelText: '답변',
                            hintText: question.placeholder,
                            border: const OutlineInputBorder(),
                          ),
                          maxLines: 4,
                          controller: textController,
                          onChanged: (value) {
                            controller.updateAnswer(question.id, value);
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
