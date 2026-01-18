import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'session_generate_controller.dart';

/// SessionGeneratePage: 문서 생성 페이지
class SessionGeneratePage extends StatelessWidget {
  const SessionGeneratePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SessionGenerateController());

    return Scaffold(
      appBar: AppBar(title: const Text('문서 생성')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final session = controller.session.value;
        if (session == null) {
          return const Center(
            child: Text('세션을 불러올 수 없습니다'),
          );
        }

        final confirmedCount = session.confirmedQuestionIds.length;

        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.description, size: 64),
              const SizedBox(height: 24),
              const Text(
                '문서를 생성하시겠습니까?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                '확정된 합의: $confirmedCount/10',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              Obx(() => ElevatedButton(
                onPressed: controller.isGenerating.value
                    ? null
                    : controller.generateDocument,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                ),
                child: controller.isGenerating.value
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 16),
                          Text('문서 생성 중...'),
                        ],
                      )
                    : const Text('문서 생성하기'),
              )),
            ],
          ),
        );
      }),
    );
  }
}
