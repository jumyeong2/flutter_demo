import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'team_select_controller.dart';

/// TeamSelectPage: 팀 선택 페이지
/// Create/Join 선택, 선택 후 currentCompanyKey 확정 흐름
class TeamSelectPage extends StatelessWidget {
  const TeamSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TeamSelectController());

    return Scaffold(
      appBar: AppBar(title: const Text('팀 선택')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '팀을 선택하거나 생성하세요',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 48),
              ElevatedButton.icon(
                onPressed: controller.goToCreate,
                icon: const Icon(Icons.add),
                label: const Text('새 팀 만들기'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: controller.goToJoin,
                icon: const Icon(Icons.group_add),
                label: const Text('팀 가입하기'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
