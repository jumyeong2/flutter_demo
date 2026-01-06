import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/model/adjustment_question.dart';
import 'agreement_adjust_controller.dart';

class AgreementController extends GetxController {
  // Reference to AdjustmentController to get questions and answers
  late final AgreementAdjustController adjustController;

  // Current page (0-4 for 5 pages, 2 questions each)
  final RxInt currentPage = 0.obs;

  // Consensus answers for each question (User A + User B agreement)
  final RxMap<String, String> consensusAnswers = <String, String>{}.obs;

  // User B answers (placeholder/empty for now)
  final RxMap<String, String> userBAnswers = <String, String>{}.obs;

  // AI loading states for each question
  final RxMap<String, bool> aiLoadingStates = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // Get the adjustment controller
    adjustController = Get.find<AgreementAdjustController>();
  }

  // Get all questions as a flat list
  List<AdjustmentQuestion> get allQuestions {
    List<AdjustmentQuestion> questions = [];
    for (var category in adjustController.categories) {
      questions.addAll(category.questions);
    }
    return questions;
  }

  // Get total number of pages (2 questions per page)
  int get totalPages {
    return (allQuestions.length / 2).ceil();
  }

  // Get questions for current page
  List<AdjustmentQuestion> get currentPageQuestions {
    final startIndex = currentPage.value * 2;
    final endIndex = (startIndex + 2).clamp(0, allQuestions.length);
    return allQuestions.sublist(startIndex, endIndex);
  }

  // Get category for a question
  String getCategoryForQuestion(String questionId) {
    for (var category in adjustController.categories) {
      if (category.questions.any((q) => q.id == questionId)) {
        return category.label;
      }
    }
    return "";
  }

  // Get User A answer (from adjustment controller)
  String getUserAAnswer(String questionId) {
    return adjustController.answers[questionId] ?? "";
  }

  // Get User B answer (placeholder for now)
  String getUserBAnswer(String questionId) {
    return userBAnswers[questionId] ?? "공동창업자의 의견이 입력됩니다.";
  }

  // Get consensus answer
  String getConsensusAnswer(String questionId) {
    return consensusAnswers[questionId] ?? "";
  }

  // Update consensus answer
  void updateConsensusAnswer(String questionId, String value) {
    consensusAnswers[questionId] = value;
  }

  // Check if current page is complete (both questions have consensus)
  bool get isCurrentPageComplete {
    for (var question in currentPageQuestions) {
      final consensus = consensusAnswers[question.id] ?? "";
      if (consensus.trim().isEmpty) {
        return false;
      }
    }
    return true;
  }

  // Check if all pages are complete
  bool get isAllPagesComplete {
    for (var question in allQuestions) {
      final consensus = consensusAnswers[question.id] ?? "";
      if (consensus.trim().isEmpty) {
        return false;
      }
    }
    return true;
  }

  // Progress percentage
  double get progress {
    int answeredCount = 0;
    for (var question in allQuestions) {
      if ((consensusAnswers[question.id] ?? "").trim().isNotEmpty) {
        answeredCount++;
      }
    }
    return allQuestions.isEmpty
        ? 0
        : (answeredCount / allQuestions.length) * 100;
  }

  // Go to next page
  void goToNextPage() {
    if (!isCurrentPageComplete) {
      Get.snackbar(
        "알림",
        "모든 질문에 대한 합의안을 작성해주세요.",
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    if (currentPage.value < totalPages - 1) {
      currentPage.value++;
    } else {
      // Last page - show completion or navigate
      Get.snackbar(
        "완료",
        "모든 합의가 완료되었습니다!",
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      // TODO: Navigate to final report or summary
    }
  }

  // Go to previous page
  void goToPreviousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
    }
  }

  // Check if question has conflict (User A != User B)
  bool hasConflict(String questionId) {
    final userA = getUserAAnswer(questionId);
    final userB = getUserBAnswer(questionId);
    return userA.trim() != userB.trim();
  }

  // Check if AI is loading for a question
  bool isAiLoading(String questionId) {
    return aiLoadingStates[questionId] ?? false;
  }

  // Trigger AI suggestion for a question
  void triggerAI(String questionId) {
    aiLoadingStates[questionId] = true;

    // Simulate AI processing delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      // Generate AI suggestion based on question
      final question = allQuestions.firstWhere((q) => q.id == questionId);
      final aiSuggestion = _generateAISuggestion(question);

      consensusAnswers[questionId] = aiSuggestion;
      aiLoadingStates[questionId] = false;
    });
  }

  // Generate AI suggestion based on question ID
  String _generateAISuggestion(AdjustmentQuestion question) {
    switch (question.id) {
      case 'q1': // 우리 팀이 해결하려는 문제와 존재 이유는 무엇인가요?
        return "회사의 미션은 [구체적 문제 영역]에서 [대상 고객]이 겪는 [핵심 페인포인트]를 해결하여 [제공 가치]를 실현하는 것입니다. 우리는 [핵심 가치관 1], [핵심 가치관 2], [핵심 가치관 3]을 바탕으로 의사결정하며, 단기 이익보다 장기적 비전과 고객 가치를 우선시합니다.";

      case 'q2': // 각 창업자의 핵심 역할과 의사결정 권한은 어떻게 나눌까요?
        return "CEO는 경영 전반, 투자 유치, 대외 협력을 총괄하며 최종 경영 책임을 집니다. CTO는 기술 전략, 제품 개발, 인프라 구축을 전담하며 기술 관련 최종 결정권을 갖습니다. 제품 로드맵과 주요 전략은 양측 합의를 원칙으로 하되, 데드락 발생 시 CEO가 최종 결정권(Casting Vote)을 행사합니다.";

      case 'q3': // 각 창업자가 담당해야 하는 구체적 역할 범위는 무엇인가요?
        return "CEO: 사업 전략 수립, 투자 유치, 재무 관리, 인사/조직 관리, 마케팅/영업 총괄. CTO: 기술 아키텍처 설계, 개발팀 관리, 제품 개발 실행, 기술 스택 선정, 보안 및 인프라 관리. 양측은 분기별로 역할 범위를 재검토하여 필요시 조정합니다.";

      case 'q4': // 중복되거나 애매한 업무는 어떤 기준으로 책임자를 지정할까요?
        return "모호한 업무의 책임자는 다음 우선순위로 지정합니다: 1) 해당 분야 전문성이 높은 쪽, 2) 현재 업무 부하가 적은 쪽, 3) 과거 유사 업무 수행 경험이 있는 쪽. 양측 합의가 어려운 경우 CEO가 최종 배정 권한을 가지며, 배정된 책임자는 주 1회 진행상황을 공유합니다.";

      case 'q5': // 지분 배분 기준은 무엇이며 향후 어떤 기준으로 조정할까요?
        return "초기 지분은 [기여도/투자금/역할 중요도]를 종합 평가하여 배분하며, 구체적 비율은 [CEO: X%, CTO: Y%]로 합의합니다. 향후 지분 조정은 이사회 만장일치로만 가능하며, 신규 투자 유치 시 희석률은 기존 지분 비율에 따라 동일하게 적용합니다. 추가 기여에 따른 지분 조정은 연 1회 정기 검토 시점에 논의합니다.";

      case 'q6': // 지분을 온전히 자신의 것으로 만드는 데 몇 년이 걸리게 할까요?
        return "총 4년(48개월) 베스팅을 적용합니다. 최초 1년(Cliff) 근무 완료 시 지분의 25%를 일괄 인정하고, 이후 36개월간 매월 1/48(약 2.08%)씩 균등 분할하여 귀속시킵니다. 1년 이내 퇴사 시 지분은 전액 무상 회수되며, 1년 이후 퇴사 시 근속 기간에 비례한 지분만 인정됩니다.";

      case 'q7': // 중요 의사결정의 종류를 어떻게 분류하고 어떤 방식으로 결정할까요?
        return "의사결정은 3단계로 분류합니다. [전결 사항] 각자 전문 영역 내 일상적 결정(예산 X만원 이하). [합의 사항] 제품 로드맵, 주요 채용, 예산 X만원 초과 지출, 신규 사업 진출. [이사회 사항] 투자 유치, 지분 변경, 회사 매각, 정관 변경. 합의 사항은 양측 동의로 결정하며, 7일 내 합의 실패 시 외부 멘토 또는 이사회 중재를 받습니다.";

      case 'q8': // 갈등이 장기화될 경우 어떤 중재 프로세스를 적용할까요?
        return "의견 충돌 발생 시 다음 단계를 거칩니다: 1단계(0~3일) 양측 직접 협의 및 타협안 모색. 2단계(4~7일) 사전 합의한 외부 멘토 또는 자문위원의 중재 개입. 3단계(8일~) 이사회 소집 및 공식 중재 절차 진행. 최종적으로 합의 불가 시 주주간계약서 제X조에 따른 강제 조정 또는 지분 매수 절차를 진행합니다.";

      case 'q9': // 고의적 태만·배임 등 중대한 사유로 퇴사할 경우 지분은 어떻게 처리할까요?
        return "Bad Leaver(횡령, 배임, 경쟁사 이직, 중대한 의무 위반 등) 확정 시 보유 지분 100%를 액면가(1주당 100원)로 강제 회수(Call Option)합니다. Good Leaver(개인 사정, 건강 문제 등 정당한 사유)의 경우 근속 기간에 비례하여 베스팅된 지분은 인정하되, 미베스팅 지분은 무상 회수합니다. Bad Leaver 판정은 이사회 만장일치로 결정합니다.";

      case 'q10': // 회사를 매각(M&A)할 때 창업자 간 의견이 다르면 어떻게 할까요?
        return "회사 매각은 지분 과반수(50% 초과) 동의로 결정합니다. 소수 주주는 동반 매각 권리(Tag-Along Right)를 보장받아 동일 조건으로 지분을 매각할 수 있습니다. 매각 가격이 투자 유치 후 기업가치의 2배 이상일 경우, 과반 주주는 소수 주주에게 동반 매각 의무(Drag-Along Right)를 부과할 수 있습니다. 매각 대금은 지분 비율에 따라 분배합니다.";

      default:
        return "양측의 의견을 종합하여 다음과 같이 합의합니다: [구체적 합의 내용을 작성해주세요]. 본 조항은 주주간계약서에 명시되며, 양측 서명으로 효력이 발생합니다.";
    }
  }
}
