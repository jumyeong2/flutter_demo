import 'dart:async';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/repository/firestore_repo.dart';
import '../../../data/model/session.dart';
import '../../../data/model/adjustment_question.dart';

import '../agreement/agreement_adjust_controller.dart';

/// SessionConsensusController: 합의 화면 컨트롤러
class SessionConsensusController extends GetxController {
  late final FirestoreRepository _repo;

  final RxString sessionId = ''.obs;
  final RxString currentUserId = ''.obs;
  final Rx<Session?> session = Rx<Session?>(null);
  final RxMap<String, Map<String, String>> allAnswers =
      <String, Map<String, String>>{}.obs;
  final RxMap<String, String> consensusTexts = <String, String>{}.obs;
  final RxMap<String, SessionConsensus?> confirmedConsensus =
      <String, SessionConsensus?>{}.obs;
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;

  // 질문 목록
  final List<AdjustmentQuestion> questions = [];

  StreamSubscription<DocumentSnapshot>? _sessionSubscription;

  @override
  void onInit() {
    super.onInit();
    _repo = Get.find<FirestoreRepository>();

    // 현재 사용자 ID
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      currentUserId.value = user.uid;
    }

    // 세션 ID 가져오기 (라우트 파라미터)
    final routeParams = Get.parameters;
    if (routeParams.containsKey('sessionId')) {
      sessionId.value = routeParams['sessionId']!;
      loadQuestions();
      loadSession();
      loadAllAnswers();
      loadConsensus();
      watchSession();
    }
  }

  @override
  void onClose() {
    _sessionSubscription?.cancel();
    super.onClose();
  }

  /// 질문 목록 로드
  void loadQuestions() {
    // 컨트롤러가 없으면 생성하고, 있으면 재사용
    final adjustController = Get.put(AgreementAdjustController());
    questions.clear();
    for (var category in adjustController.categories) {
      questions.addAll(category.questions);
    }
  }

  /// 세션 로드
  Future<void> loadSession() async {
    try {
      final sessionData = await _repo.getSession(sessionId.value);
      session.value = sessionData;
    } catch (e) {
      Get.snackbar('오류', '세션 정보를 불러올 수 없습니다: $e');
    }
  }

  /// 세션 실시간 감시
  void watchSession() {
    _sessionSubscription = _repo.watchSession(sessionId.value).listen((
      snapshot,
    ) {
      if (snapshot.exists) {
        try {
          final data = snapshot.data() as Map<String, dynamic>?;
          if (data != null) {
            final sessionData = Session.fromJson(data, sessionId.value);
            session.value = sessionData;
          }
        } catch (e) {
          print('세션 파싱 오류: $e');
        }
      }
    });
  }

  /// 모든 답변 로드 (A/B 비교용)
  Future<void> loadAllAnswers() async {
    try {
      isLoading.value = true;
      final sessionData = session.value;
      if (sessionData == null) return;

      // participantA와 participantB의 답변 가져오기
      final participantA = sessionData.participantStatus.keys.first;
      final participantB = sessionData.participantStatus.keys.firstWhere(
        (uid) => uid != participantA,
        orElse: () => '',
      );

      if (participantB.isEmpty) return;

      final answerA = await _repo.getSessionAnswer(
        sessionId.value,
        participantA,
      );
      final answerB = await _repo.getSessionAnswer(
        sessionId.value,
        participantB,
      );

      final answersMap = <String, Map<String, String>>{};
      for (var question in questions) {
        answersMap[question.id] = {
          'A': answerA?.answers[question.id] ?? '',
          'B': answerB?.answers[question.id] ?? '',
        };
      }
      allAnswers.value = answersMap;
    } catch (e) {
      Get.snackbar('오류', '답변을 불러올 수 없습니다: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// 합의 로드
  Future<void> loadConsensus() async {
    try {
      final consensusList = await _repo.getSessionConsensusList(
        sessionId.value,
      );
      final consensusMap = <String, SessionConsensus?>{};
      final consensusTextsMap = <String, String>{};

      // 모든 질문에 대해 초기화
      for (var question in questions) {
        consensusMap[question.id] = null;
      }

      // 존재하는 합의만 매핑
      for (var consensus in consensusList) {
        if (consensus.finalText.isNotEmpty) {
          consensusMap[consensus.questionId] = consensus;
          consensusTextsMap[consensus.questionId] = consensus.finalText;
        }
      }

      confirmedConsensus.value = consensusMap;
      consensusTexts.value = consensusTextsMap;
    } catch (e) {
      Get.snackbar('오류', '합의를 불러올 수 없습니다: $e');
    }
  }

  /// 합의 텍스트 업데이트
  void updateConsensusText(String questionId, String text) {
    consensusTexts[questionId] = text;
  }

  /// 합의 확정
  ///
  /// 1) consensus/{questionId} 저장(finalText, decidedAt, decidedBy, version+1)
  /// 2) sessions.confirmedQuestionIds arrayUnion([questionId]) (실패 시 재시도/에러 안내)
  /// 3) (옵션) sessions.consensusConfirmedCount increment(1)
  Future<void> confirmConsensus(String questionId, String finalText) async {
    if (finalText.trim().isEmpty) {
      Get.snackbar('오류', '합의 문장을 입력해주세요');
      return;
    }

    try {
      isSaving.value = true;

      // 기존 합의 조회하여 version 확인
      final existing = await _repo.getSessionConsensus(
        sessionId.value,
        questionId,
      );
      final currentVersion = existing?.version ?? 0;

      // 1) consensus/{questionId} 저장
      final consensus = SessionConsensus(
        sessionId: sessionId.value,
        questionId: questionId,
        finalText: finalText.trim(),
        decidedAt: DateTime.now(),
        decidedBy: currentUserId.value,
        version: currentVersion + 1,
      );
      await _repo.setSessionConsensus(consensus);

      // 2) sessions.confirmedQuestionIds arrayUnion([questionId])
      int retryCount = 0;
      const maxRetries = 3;
      bool success = false;

      while (retryCount < maxRetries && !success) {
        try {
          await _repo.addConfirmedQuestionId(sessionId.value, questionId);
          success = true;
        } catch (e) {
          retryCount++;
          if (retryCount >= maxRetries) {
            Get.snackbar(
              '오류',
              '확정 상태 업데이트 실패: $e\n재시도해주세요.',
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 5),
            );
            return;
          }
          await Future.delayed(Duration(milliseconds: 500 * retryCount));
        }
      }

      // 3) (옵션) sessions.consensusConfirmedCount increment(1)
      try {
        await _repo.incrementConsensusConfirmedCount(sessionId.value);
      } catch (e) {
        // consensusConfirmedCount 업데이트 실패는 무시
        print('consensusConfirmedCount 업데이트 실패: $e');
      }

      // 합의 목록 다시 로드
      await loadConsensus();

      Get.snackbar('성공', '합의가 확정되었습니다');
    } catch (e) {
      Get.snackbar('오류', '합의 확정 실패: $e');
    } finally {
      isSaving.value = false;
    }
  }

  /// 확정된 질문 개수
  int get confirmedCount {
    return session.value?.confirmedQuestionIds.length ?? 0;
  }

  /// 문서 생성 가능 여부 (confirmedQuestionIds.length >= 8)
  bool get canGenerateDocument {
    return confirmedCount >= 8;
  }
}
