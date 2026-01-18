import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'session_home_controller.dart';

/// SessionHomePage: 세션 홈 페이지
/// sessions/{id} 스트림 구독하여 상태(status, participantStatus)로 단일 CTA를 표시
class SessionHomePage extends StatelessWidget {
  const SessionHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SessionHomeController());

    return Scaffold(
      appBar: AppBar(title: const Text('세션 홈')),
      body: Obx(() {
        if (controller.isLoading.value && controller.session.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final session = controller.session.value;
        if (session == null) {
          return const Center(
            child: Text('세션을 불러올 수 없습니다'),
          );
        }

        final ctaAction = controller.getCtaAction();
        final myCount = controller.myCompletedCount;
        final otherCount = controller.otherCompletedCount;

        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '세션 상태: ${session.status}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (session.status == 'answering') ...[
                        Text('내 진행률: $myCount/10'),
                        Text('상대 진행률: $otherCount/10'),
                      ] else if (session.status == 'consensus' ||
                          session.status == 'ready_for_consensus') ...[
                        Text(
                          '확정된 합의: ${session.confirmedQuestionIds.length}/10',
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const Spacer(),
              if (ctaAction != null) ...[
                ElevatedButton(
                  onPressed: () {
                    Get.toNamed(ctaAction['route'] as String);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                  ),
                  child: Text(ctaAction['text'] as String),
                ),
              ],
            ],
          ),
        );
      }),
    );
  }
}
