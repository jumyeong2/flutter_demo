import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../../data/model/adjustment_question.dart';
import 'agreement_page.dart';

class AgreementAdjustController extends GetxController {
  final RxList<AdjustmentCategory> categories = <AdjustmentCategory>[
    AdjustmentCategory(
      id: "mission",
      label: "미션 & 가치",
      questions: [
        AdjustmentQuestion(
          id: "q1",
          title: "우리 팀이 해결하려는 문제와 존재 이유는 무엇인가요?",
          description: "우리 회사가 존재해야 하는 이유와 장기적으로 지키고 싶은 가치 기준을 정리하는 질문입니다.",
        ),
        AdjustmentQuestion(
          id: "q2",
          title: "각 창업자의 핵심 역할과 의사결정 권한은 어떻게 나눌까요?",
          description: "초기 팀 구조에서 누가 어떤 영역의 의사결정권을 갖는지 명확히 정의하는 질문입니다.",
        ),
      ],
    ),
    AdjustmentCategory(
      id: "roles",
      label: "R&R (역할과 책임)",
      questions: [
        AdjustmentQuestion(
          id: "q3",
          title: "각 창업자가 담당해야 하는 구체적 역할 범위는 무엇인가요?",
          description: "업무 중복과 책임 회피를 방지하기 위한 역할 구분을 정의하는 질문입니다.",
        ),
        AdjustmentQuestion(
          id: "q4",
          title: "중복되거나 애매한 업무는 어떤 기준으로 책임자를 지정할까요?",
          description: "모호한 업무 발생 시 책임자 지정 규칙을 합의하는 질문입니다.",
        ),
      ],
    ),
    AdjustmentCategory(
      id: "equity",
      label: "지분 & 수익 구조",
      questions: [
        AdjustmentQuestion(
          id: "q5",
          title: "지분 배분 기준은 무엇이며 향후 어떤 기준으로 조정할까요?",
          description: "기여도 변화에 따른 지분 조정 기준을 설정하기 위한 질문입니다.",
        ),
        AdjustmentQuestion(
          id: "q6",
          title: "지분을 온전히 자신의 것으로 만드는 데 몇 년이 걸리게 할까요?",
          description: "베스팅(Vesting) 기간을 설정하기 위한 질문입니다.",
        ),
      ],
    ),
    AdjustmentCategory(
      id: "decision",
      label: "의사결정 구조",
      questions: [
        AdjustmentQuestion(
          id: "q7",
          title: "중요 의사결정의 종류를 어떻게 분류하고 어떤 방식으로 결정할까요?",
          description: "전결/합의 여부를 기준으로 의사결정 구분 규칙을 만드는 질문입니다.",
        ),
        AdjustmentQuestion(
          id: "q8",
          title: "갈등이 장기화될 경우 어떤 중재 프로세스를 적용할까요?",
          description: "제3자 중재·캐스팅보트 등 갈등 종료 프로세스를 설정하는 질문입니다.",
        ),
      ],
    ),
    AdjustmentCategory(
      id: "exit",
      label: "이탈 및 탈퇴 / M&A",
      questions: [
        AdjustmentQuestion(
          id: "q9",
          title: "고의적 태만·배임 등 중대한 사유로 퇴사할 경우 지분은 어떻게 처리할까요?",
          description: "중대한 위반이 있을 때 지분 회수·축소 기준을 설정하는 질문입니다.",
        ),
        AdjustmentQuestion(
          id: "q10",
          title: "회사를 매각(M&A)할 때 창업자 간 의견이 다르면 어떻게 할까요?",
          description: "매각 의사결정 구조와 반대 의견 조정 방식을 정하는 질문입니다.",
        ),
      ],
    ),
  ].obs;

  final Rx<AdjustmentCategory?> selectedCategory = Rx<AdjustmentCategory?>(
    null,
  );
  final Rx<AdjustmentQuestion?> selectedQuestion = Rx<AdjustmentQuestion?>(
    null,
  );
  final RxMap<String, String> answers = <String, String>{}.obs;

  // Founder Info
  final RxString founderName = "".obs;
  final RxString founderPosition = "".obs;
  final RxString founderEmail = "".obs;
  final RxString founderPhone = "".obs;

  // Company Info
  final RxString companyName = "".obs;
  final RxString startupAge = "".obs;
  final RxString industry = "".obs;
  final RxString teamInfo = "".obs;

  // Save Founder Info
  void saveFounderInfo({
    required String name,
    required String position,
    required String email,
    required String phone,
  }) {
    founderName.value = name;
    founderPosition.value = position;
    founderEmail.value = email;
    founderPhone.value = phone;
  }

  // Save Company Info
  void saveCompanyInfo({
    required String name,
    required String age,
    required String ind,
    required String team,
  }) {
    companyName.value = name;
    startupAge.value = age;
    industry.value = ind;
    teamInfo.value = team;
  }

  Future<void> submitFounderInfoToFirebase() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final docData = {
        'founderName': founderName.value,
        'founderPosition': founderPosition.value,
        'founderEmail': founderEmail.value,
        'founderPhone': founderPhone.value,
        'companyName': companyName.value,
        'startupAge': startupAge.value,
        'industry': industry.value,
        'teamInfo': teamInfo.value,
        'createdAt': FieldValue.serverTimestamp(),
        'source': 'agreement_adjust_intro',
      };

      await firestore.collection('teams').add(docData);
      print('✅ Founder/Company info saved to Firebase');
    } catch (e) {
      print('❌ Failed to save Founder/Company info: $e');
      // Quietly fail or handle error? For now just log.
    }
  }

  // 현재 질문의 답변 가져오기
  String getCurrentAnswer() {
    if (selectedQuestion.value == null) return "";
    return answers[selectedQuestion.value!.id] ?? "";
  }

  // 답변 저장
  void saveAnswer(String questionId, String answer) {
    answers[questionId] = answer;
  }

  // 카테고리 선택
  void selectCategory(AdjustmentCategory category) {
    selectedCategory.value = category;
    selectedQuestion.value = null; // 질문 선택 초기화
  }

  // 질문 선택
  void selectQuestion(AdjustmentQuestion question) {
    selectedQuestion.value = question;
  }

  // 이전 질문으로 이동
  void goToPreviousQuestion() {
    if (selectedQuestion.value == null || selectedCategory.value == null) {
      // 질문이 없으면 카테고리 선택 화면으로
      selectedQuestion.value = null;
      return;
    }

    final questions = selectedCategory.value!.questions;
    final currentIndex = questions.indexWhere(
      (q) => q.id == selectedQuestion.value!.id,
    );

    if (currentIndex > 0) {
      // 같은 카테고리 내 이전 질문
      selectQuestion(questions[currentIndex - 1]);
    } else {
      // 첫 번째 질문이면 카테고리 선택 화면으로
      selectedQuestion.value = null;
    }
  }

  // 다음 질문으로 이동
  void goToNextQuestion() {
    if (selectedQuestion.value == null || selectedCategory.value == null) {
      return;
    }

    final questions = selectedCategory.value!.questions;
    final currentIndex = questions.indexWhere(
      (q) => q.id == selectedQuestion.value!.id,
    );

    if (currentIndex < questions.length - 1) {
      // 같은 카테고리 내 다음 질문
      selectQuestion(questions[currentIndex + 1]);
    } else {
      // 마지막 질문이면 다음 카테고리로
      final categoryIndex = categories.indexWhere(
        (c) => c.id == selectedCategory.value!.id,
      );
      if (categoryIndex < categories.length - 1) {
        selectCategory(categories[categoryIndex + 1]);
        if (categories[categoryIndex + 1].questions.isNotEmpty) {
          selectQuestion(categories[categoryIndex + 1].questions[0]);
        }
      } else {
        // 모든 질문 완료
        Get.to(() => const AgreementPage());
      }
    }
  }

  // 진행률 계산
  double get progress {
    int totalQuestions = 0;
    int answeredQuestions = 0;

    for (var category in categories) {
      totalQuestions += category.questions.length;
      for (var question in category.questions) {
        if (answers.containsKey(question.id) &&
            answers[question.id]!.isNotEmpty) {
          answeredQuestions++;
        }
      }
    }

    return totalQuestions > 0 ? (answeredQuestions / totalQuestions) : 0.0;
  }
}
