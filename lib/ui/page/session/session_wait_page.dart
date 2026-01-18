import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'session_wait_controller.dart';
import '../../../router/routes.dart';

/// SessionWaitPage: 대기 화면
/// 상대 진행률 표시 + 초대 링크 재공유
class SessionWaitPage extends StatelessWidget {
  const SessionWaitPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SessionWaitController());

    return Scaffold(
      appBar: AppBar(title: const Text('대기')),
      body: Obx(() {
        final session = controller.session.value;
        if (session == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final myCount = controller.myCompletedCount;
        final otherCount = controller.getOtherCompletedCount();

        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.hourglass_empty, size: 64, color: Colors.orange),
              const SizedBox(height: 24),
              const Text(
                '상대가 답변을 작성하는 중입니다',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        '진행률',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              const Text('내 진행률'),
                              Text(
                                '$myCount/10',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Text('vs'),
                          Column(
                            children: [
                              const Text('상대 진행률'),
                              Text(
                                '$otherCount/10',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      LinearProgressIndicator(
                        value: otherCount / 10,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 48),
              ElevatedButton.icon(
                onPressed: controller.copyInviteLink,
                icon: const Icon(Icons.link),
                label: const Text('초대 링크 복사'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                ),
              ),
              const SizedBox(height: 16),
              // 상대가 8/10 도달하면 합의 시작 버튼 표시
              if (otherCount >= 8 && session.status == 'ready_for_consensus')
                ElevatedButton(
                  onPressed: () {
                    Get.offNamed(Routes.sessionConsensusPath(controller.sessionId.value));
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                  ),
                  child: const Text('합의 시작하기'),
                ),
            ],
          ),
        );
      }),
    );
  }
}
