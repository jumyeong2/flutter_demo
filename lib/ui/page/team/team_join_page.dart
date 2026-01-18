import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'team_join_controller.dart';

/// TeamJoinPage: 팀 가입 페이지
class TeamJoinPage extends StatelessWidget {
  const TeamJoinPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TeamJoinController());

    return Scaffold(
      appBar: AppBar(title: const Text('팀 가입')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Obx(() {
          if (controller.isLoading.value && controller.company.value == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              if (controller.company.value != null) ...[
                const Text(
                  '팀 정보',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '팀 이름: ${controller.company.value!.name}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '팀 코드: ${controller.companyKey.value}',
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else if (controller.companyKey.value.isEmpty) ...[
                const Text(
                  '팀 코드를 입력하세요',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: '팀 코드',
                    border: OutlineInputBorder(),
                    hintText: '팀 코드를 입력하세요',
                  ),
                  onChanged: (value) {
                    controller.companyKey.value = value;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.loadCompany,
                  child: const Text('팀 정보 확인'),
                ),
              ] else ...[
                const Text(
                  '팀을 찾을 수 없습니다',
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
              ],
              const Spacer(),
              Obx(() => ElevatedButton(
                onPressed: (controller.isLoading.value || controller.company.value == null)
                    ? null
                    : controller.joinTeam,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                ),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : const Text('팀 가입하기'),
              )),
            ],
          );
        }),
      ),
    );
  }
}
