import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'settings_team_controller.dart';

/// SettingsTeamPage: 팀 설정 페이지
/// 팀 초대 코드 복사 + 팀 나가기(초기화)
class SettingsTeamPage extends StatelessWidget {
  const SettingsTeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsTeamController());

    return Scaffold(
      appBar: AppBar(title: const Text('팀 설정')),
      body: Obx(() {
        if (controller.isLoading.value && controller.company.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final company = controller.company.value;

        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (company != null) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '팀 정보',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text('팀 이름: ${company.name}'),
                        const SizedBox(height: 8),
                        Text(
                          '팀 코드: ${controller.companyKey.value}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
              // 팀 초대 코드 복사
              ElevatedButton.icon(
                onPressed: controller.copyInviteCode,
                icon: const Icon(Icons.link),
                label: const Text('팀 초대 코드 복사'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                ),
              ),
              const SizedBox(height: 24),
              // 팀 나가기
              OutlinedButton.icon(
                onPressed: () {
                  Get.dialog(
                    AlertDialog(
                      title: const Text('팀 나가기'),
                      content: const Text('정말로 팀을 나가시겠습니까?'),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text('취소'),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.back();
                            controller.leaveTeam();
                          },
                          child: const Text('나가기', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.exit_to_app, color: Colors.red),
                label: const Text(
                  '팀 나가기',
                  style: TextStyle(color: Colors.red),
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
