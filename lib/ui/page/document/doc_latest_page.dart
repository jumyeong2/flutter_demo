import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'doc_latest_controller.dart';

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
          return const Center(child: CircularProgressIndicator());
        }

        return const Center(
          child: Text('문서를 불러오는 중...'),
        );
      }),
    );
  }
}
