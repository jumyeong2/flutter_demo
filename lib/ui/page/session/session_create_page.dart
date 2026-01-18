import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'session_create_controller.dart';

/// SessionCreatePage: 세션 생성 페이지
class SessionCreatePage extends StatelessWidget {
  const SessionCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SessionCreateController());

    return Scaffold(
      appBar: AppBar(title: const Text('세션 생성')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add_circle_outline, size: 64),
              const SizedBox(height: 24),
              const Text(
                '새 세션을 생성하시겠습니까?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value ? null : controller.createSession,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                ),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : const Text('세션 생성하기'),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
