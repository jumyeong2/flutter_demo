import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LandingController extends GetxController {
  final ScrollController scrollController = ScrollController();

  // 섹션별 GlobalKey 정의
  final GlobalKey processKey = GlobalKey();
  final GlobalKey riskKey = GlobalKey();
  final GlobalKey rulebookKey = GlobalKey();

  void scrollToProcess() {
    if (processKey.currentContext != null) {
      Scrollable.ensureVisible(
        processKey.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void scrollToRisk() {
    if (riskKey.currentContext != null) {
      Scrollable.ensureVisible(
        riskKey.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void scrollToRulebook() {
    if (rulebookKey.currentContext != null) {
      Scrollable.ensureVisible(
        rulebookKey.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
