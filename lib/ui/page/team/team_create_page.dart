import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'team_create_controller.dart';

/// TeamCreatePage: 팀 생성 페이지
class TeamCreatePage extends StatelessWidget {
  const TeamCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TeamCreateController());

    return Scaffold(
      appBar: AppBar(title: const Text('팀 생성')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            const Text(
              '팀 이름을 입력하세요',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: '팀 이름',
                border: OutlineInputBorder(),
                hintText: '예: 우리팀',
              ),
              onChanged: controller.updateTeamName,
            ),
            const SizedBox(height: 32),
            Obx(() => ElevatedButton(
              onPressed: controller.isLoading.value ? null : controller.createTeam,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
              ),
              child: controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : const Text('팀 생성하기'),
            )),
          ],
        ),
      ),
    );
  }
}
