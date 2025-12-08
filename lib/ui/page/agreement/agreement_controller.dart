import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/model/agreement_item.dart';

class AgreementController extends GetxController {
  final RxList<AgreementItem> items = <AgreementItem>[
    AgreementItem(
      id: 1,
      category: "역할 및 책임 (R&R)",
      question: "각 창업자의 핵심 역할과 의사결정 권한은 어떻게 나눌까요?",
      description: "C-Level 직함과 최종 결정권이 있는 영역을 명확히 해야 합니다.",
      userA:
          "저는 CEO로서 경영, 투자 유치, 제품 기획 총괄을 맡고 싶습니다. 개발 관련 최종 결정권은 CTO에게 위임합니다.",
      userB: "저는 CTO로서 개발 전반을 맡되, 제품 기획 단계에서도 기술적 거부권(Veto)을 갖고 싶습니다.",
      aiSuggestion:
          "시장 표준 R&R: 경영/자금은 CEO 전결(100%), 기술 스택은 CTO 전결(100%). 단, 제품 로드맵은 5:5 합의를 원칙으로 하되, 데드락(Deadlock) 발생 시 CEO가 최종 결정권(Casting Vote)을 행사하는 구조가 일반적입니다.",
    ),
    AgreementItem(
      id: 2,
      category: "베스팅(Vesting) 기간",
      question: "지분을 온전히 자신의 것으로 만드는 데 몆 년이 걸리게 할까요?",
      description: "보통 창업 멤버의 근속을 유도하기 위해 설정합니다. (표준: 3~4년)",
      userA: "서로 믿는 사이니까 별도 기간 없이 바로 100% 인정하면 좋겠습니다.",
      userB: "혹시 모를 이탈을 대비해 4년 베스팅을 적용해야 안전할 것 같습니다.",
      aiSuggestion:
          "VC 투자 표준: 총 4년(48개월) 베스팅. 최초 1년(Cliff) 근무 시 지분의 25%를 일괄 인정하고, 이후 3년간 매월 1/48(약 2.08%)씩 분할 귀속시키는 조건이 가장 보편적입니다.",
    ),
    AgreementItem(
      id: 4,
      category: "이탈 시 지분 처리 (Bad Leaver)",
      question: "고의적 태만이나 배임으로 인한 퇴사 시 지분은 어떻게 할까요?",
      description: "Bad Leaver 발생 시 지분을 액면가로 회수할지 등에 대한 합의입니다.",
      userA: "징계 해고나 배임의 경우라면 액면가로 전량 회수해야 합니다.",
      userB: "동의합니다. 액면가 회수 조항 넣죠.",
      aiSuggestion:
          "표준 계약 조항: Bad Leaver(횡령, 배임 등) 확정 시, 보유 지분 100%를 '액면가'로 강제 회수(Call Option). 단순 변심 등(Good Leaver)의 경우, 근속 기간에 비례해 베스팅된 지분은 인정하되 잔여 지분만 무상 회수합니다.",
    ),
  ].obs;

  final RxBool showFinalModal = false.obs;
  final RxString email = "".obs;
  final RxBool emailSent = false.obs;

  double get progress {
    int resolvedCount = items.where((i) => i.status == "resolved").length;
    return (resolvedCount / items.length) * 100;
  }

  void handleUserAChange(int id, String value) {
    final index = items.indexWhere((item) => item.id == id);
    if (index != -1) {
      var item = items[index];
      item.userA = value;
      // Note: In GetX reactivity, simple property change on object inside list might not trigger update
      // unless we refresh list or use .obs properties inside model.
      // For simplicity, we will stick to refreshing the specific item or list.
      // Or we can just clone the item.
      if (value.trim() == item.userB.trim()) {
        item.status = "resolved";
      } else {
        item.status = "conflict";
      }
      items[index] = item; // Trigger update
    }
  }

  void handleConsensusChange(int id, String value) {
    final index = items.indexWhere((item) => item.id == id);
    if (index != -1) {
      var item = items[index];
      item.consensus = value;
      items[index] = item;
    }
  }

  void markAsResolved(int id) {
    final index = items.indexWhere((item) => item.id == id);
    if (index != -1) {
      if (items[index].consensus.trim().isEmpty) {
        Get.snackbar(
          "알림",
          "계약 조항으로 들어갈 합의 내용을 입력해주세요.",
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(16),
        );
        return;
      }
      var item = items[index];
      item.status = "resolved";
      items[index] = item; // Trigger update
    }
  }

  void triggerAI(int id) {
    final index = items.indexWhere((item) => item.id == id);
    if (index != -1) {
      var item = items[index];
      item.isAiLoading = true;
      items[index] = item;

      Future.delayed(const Duration(milliseconds: 1200), () {
        final idx = items.indexWhere((item) => item.id == id);
        if (idx != -1) {
          var updatedItem = items[idx];
          updatedItem.consensus = updatedItem.aiSuggestion;
          updatedItem.isAiLoading = false;
          items[idx] = updatedItem;
        }
      });
    }
  }

  void handleSendEmail() {
    if (!email.value.contains("@")) {
      Get.snackbar(
        "오류",
        "올바른 이메일 주소를 입력해주세요.",
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(16),
      );
      return;
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      emailSent.value = true;
    });
  }
}
