import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'doc_latest_controller.dart';
import '../../../router/routes.dart';

/// DocLatestPage: 최신 문서 페이지
/// companyKey 확인 후 latestDocId로 리다이렉트
class DocLatestPage extends StatelessWidget {
  const DocLatestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DocLatestController());

    return Scaffold(
      appBar: AppBar(title: const Text('최신 문서')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  '문서를 불러오는 중...',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          );
        }

        // 문서 없음 처리 화면
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.description_outlined,
                  size: 80,
                  color: Color(0xFFE2E8F0),
                ),
                const SizedBox(height: 24),
                const Text(
                  '문서가 없습니다',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '아직 생성된 문서가 없습니다.\n세션을 완료하면 문서가 생성됩니다.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF64748B),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 48),
                ElevatedButton(
                  onPressed: () {
                    Get.offAllNamed(Routes.sessionCreate);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F172A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '새 세션 시작하기',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
