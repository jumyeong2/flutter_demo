import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'session_consensus_controller.dart';
import '../../../router/routes.dart';

/// SessionConsensusPage: 합의 화면
/// A/B 답변 비교 UI + 질문별 확정 상태 표시
class SessionConsensusPage extends StatelessWidget {
  const SessionConsensusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SessionConsensusController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('합의'),
        actions: [
          Obx(() => Text(
            '${controller.confirmedCount}/10',
            style: const TextStyle(fontSize: 16),
          )),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.allAnswers.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // 진행률 표시
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.blue.shade50,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '확정된 합의',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '${controller.confirmedCount}/10',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (controller.canGenerateDocument)
                    ElevatedButton(
                      onPressed: () {
                        Get.toNamed(Routes.sessionGeneratePath(controller.sessionId.value));
                      },
                      child: const Text('문서 생성하기'),
                    ),
                ],
              ),
            ),
            // 질문 목록
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: controller.questions.map((question) {
                  final answers = controller.allAnswers[question.id] ?? {};
                  final answerA = answers['A'] ?? '';
                  final answerB = answers['B'] ?? '';
                  final isConfirmed = controller.confirmedConsensus[question.id] != null;
                  final consensusText = controller.consensusTexts[question.id] ?? '';

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    color: isConfirmed ? Colors.green.shade50 : null,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  question.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (isConfirmed)
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                            ],
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
                          // A/B 답변 비교
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'A 답변',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        answerA.isEmpty ? '(답변 없음)' : answerA,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'B 답변',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.shade50,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        answerB.isEmpty ? '(답변 없음)' : answerB,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // 합의 문장 입력
                          TextField(
                            decoration: InputDecoration(
                              labelText: '합의 문장',
                              hintText: 'A와 B의 답변을 바탕으로 합의 문장을 작성하세요',
                              border: const OutlineInputBorder(),
                            ),
                            maxLines: 3,
                            enabled: !isConfirmed,
                            controller: TextEditingController(
                              text: consensusText,
                            )..selection = TextSelection.collapsed(
                                offset: consensusText.length,
                              ),
                            onChanged: (value) {
                              controller.updateConsensusText(question.id, value);
                            },
                          ),
                          if (!isConfirmed) ...[
                            const SizedBox(height: 16),
                            Obx(() => ElevatedButton(
                              onPressed: controller.isSaving.value
                                  ? null
                                  : () {
                                      final text = controller.consensusTexts[question.id] ?? '';
                                      controller.confirmConsensus(question.id, text);
                                    },
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 48),
                              ),
                              child: controller.isSaving.value
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : const Text('합의 확정'),
                            )),
                          ],
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      }),
    );
  }
}
