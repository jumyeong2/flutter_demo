import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../../data/model/adjustment_question.dart';
import 'agreement_page.dart';

class AgreementAdjustController extends GetxController {
  final RxList<AdjustmentCategory> categories = <AdjustmentCategory>[
    AdjustmentCategory(
      id: "mission",
      label: "비전/가치",
      questions: [
        AdjustmentQuestion(
          id: "mission_1",
          title: "우리 팀이 어떤 상황에서도 지키기로 한 ‘금지선’은 무엇인가요?",
          description:
              "갈등이 생겼을 때도 팀을 지켜주는 것은 “하고 싶은 것”보다 “절대 하지 않기로 한 것”입니다. 팀의 금지선 1~3개를 적어주세요.",
          placeholder:
              "예: “불법/편법 영업은 하지 않는다”, “고객 데이터는 무리해서 쓰지 않는다”처럼 ‘행동’으로 쓰기",
        ),
        AdjustmentQuestion(
          id: "mission_2",
          title: "어떤 조건이 오면 ‘지금의 우선순위’를 바꾸겠습니까?",
          description:
              "지금은 괜찮아 보여도, 상황이 바뀌면 팀의 판단 기준이 갈립니다. 우선순위 변경 조건을 기간/수치로 적어주세요.",
          placeholder:
              "예: “런웨이 2개월 이하”, “매출 0원 3개월 지속”, “주 80시간 4주 이상”처럼 측정 가능한 조건",
        ),
      ],
    ),
    AdjustmentCategory(
      id: "decision",
      label: "의사결정 구조",
      questions: [
        AdjustmentQuestion(
          id: "decision_1",
          title: "의견이 갈릴 때, 우리 팀은 어떤 룰로 결론을 냅니까?",
          description:
              "‘더 논의하자’가 반복되면 의사결정이 늦어지고 불만이 쌓입니다. 기한/권한/근거 중 최소 2개를 포함해 적어주세요.",
          placeholder: "예: “48시간 논의 후 결정”, “PM이 최종안 작성”, “지표 2개 충족 시 실행” 등",
        ),
        AdjustmentQuestion(
          id: "decision_2",
          title: "한 명이 강하게 반대할 때, 결정을 멈추는 기준은 무엇인가요?",
          description:
              "‘모두 동의’가 원칙인지, ‘특정 조건에서는 진행’인지 합의가 필요합니다. 거부권(비토) 기준을 명시해 주세요.",
          placeholder: "예: “법적 리스크/브랜드 훼손이면 비토 가능”, “금액 300만원 이상이면 전원 동의” 등",
        ),
      ],
    ),
    AdjustmentCategory(
      id: "roles",
      label: "R&R (역할과 책임)",
      questions: [
        AdjustmentQuestion(
          id: "roles_1",
          title: "맡고 싶지 않은 역할이 있다면 무엇이고, 어떻게 처리하면 괜찮나요?",
          description:
              "역할 회피는 시간이 지나면 “누가 더 했냐” 갈등으로 번집니다. 싫은 역할 1개 + 대안을 적어주세요.",
          placeholder: "예: “CS는 주 2회 로테이션”, “세무는 외주 + 내부 담당 1명”처럼 처리 방식까지",
        ),
        AdjustmentQuestion(
          id: "roles_2",
          title: "역할을 바꾸어야 하는 시점은 언제이며, 어떤 절차로 바꾸나요?",
          description: "성장/피벗/채용 시 역할은 바뀝니다. ‘바꾸는 조건’과 ‘바꾸는 절차’를 적어주세요.",
          placeholder: "예: “매출 2천 이상이면 영업 전담”, “2주 단위로 역할 리뷰 후 재배치” 등",
        ),
      ],
    ),
    AdjustmentCategory(
      id: "finance",
      label: "자본/지분",
      questions: [
        AdjustmentQuestion(
          id: "finance_1",
          title: "런웨이가 줄어들면, 무엇을 어디까지 조정할 수 있나요?",
          description: "‘급여/외주/마케팅/채용’ 중 조정 가능한 항목과 범위를 수치로 적어주세요.",
          placeholder:
              "예: “창업자 급여 월 0~100”, “마케팅 50% 축소”, “외주 중단 기준: 잔고 3천 이하”",
        ),
        AdjustmentQuestion(
          id: "finance_2",
          title: "기여도가 달라졌을 때, 지분/보상을 조정하는 기준이 있나요?",
          description:
              "기여도와 보상/지분은 시간이 갈수록 민감해집니다. 조정이 가능한 조건(가능/불가)과 방식(재협상/베스팅/보너스 등)을 정해 주세요.",
          placeholder: "예: “풀타임 전환 시 베스팅 시작”, “3개월 이상 기여 미달이면 재협상” 등",
        ),
      ],
    ),
    AdjustmentCategory(
      id: "exit",
      label: "이탈/정리",
      questions: [
        AdjustmentQuestion(
          id: "exit_1",
          title: "‘정리해야 한다’고 판단하는 기준은 무엇인가요?",
          description:
              "실패/정리의 기준이 없으면, 누군가는 버티고 누군가는 떠나고 싶어집니다. 기간/지표 기준을 적어주세요.",
          placeholder: "예: “6개월 내 PMF 지표 미달”, “현금 0 + 투자 실패 2회” 등",
        ),
        AdjustmentQuestion(
          id: "exit_2",
          title: "공동창업자 1명이 나가면, 무엇을 어떤 원칙으로 정리하나요?",
          description: "업무/지분/자산/채무/고객데이터 등 ‘정리 대상’이 무엇인지와 원칙을 짧게 합의해두는 질문입니다.",
          placeholder: "예: “업무 인수인계 2주”, “지분은 베스팅 기준 적용”, “채무는 지분비율/합의비율로” 등",
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

  // Firebase Doc ID
  String? currentTeamDocId;

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

      final docRef = await firestore.collection('teams').add(docData);
      currentTeamDocId = docRef.id;
      print(
        '✅ Founder/Company info saved to Firebase with ID: $currentTeamDocId',
      );
    } catch (e) {
      print('❌ Failed to save Founder/Company info: $e');
    }
  }

  Future<void> saveAnswersToFirebase() async {
    if (currentTeamDocId == null) {
      print('❌ No team document ID found to save answers');
      return;
    }

    try {
      final firestore = FirebaseFirestore.instance;
      await firestore.collection('teams').doc(currentTeamDocId).update({
        'answers': answers,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      print('✅ Answers saved to Firebase for ID: $currentTeamDocId');
    } catch (e) {
      print('❌ Failed to save answers: $e');
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
  Future<void> goToNextQuestion() async {
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
        // 답변 파이어베이스에 저장
        await saveAnswersToFirebase();
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

  // 마지막 질문인지 확인
  bool isLastQuestion() {
    if (selectedQuestion.value == null || categories.isEmpty) return false;
    final lastCategory = categories.last;
    if (lastCategory.questions.isEmpty) return false;
    return selectedQuestion.value!.id == lastCategory.questions.last.id;
  }
}
