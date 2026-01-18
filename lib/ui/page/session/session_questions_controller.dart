import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/repository/firestore_repo.dart';
import '../../../data/model/session.dart';
import '../../../router/routes.dart';

/// SessionQuestionsController: 질문 답변 페이지 컨트롤러
class SessionQuestionsController extends GetxController {
  late final FirestoreRepository _repo;

  final RxString sessionId = ''.obs;
  final RxString currentUserId = ''.obs;
  final Rx<Session?> session = Rx<Session?>(null);
  final RxMap<String, String> answers = <String, String>{}.obs;
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;

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
      loadSession();
      loadAnswers();
      watchSession();
    }
  }

  /// 세션 로드
  Future<void> loadSession() async {
    try {
      final sessionData = await _repo.getSession(sessionId.value);
      session.value = sessionData;

      // status가 consensus/final이면 리다이렉트
      if (sessionData != null) {
        final status = sessionData.status;
        if (status == 'consensus' || status == 'final') {
          Get.offNamed(Routes.sessionHomePath(sessionId.value));
        }
      }
    } catch (e) {
      Get.snackbar('오류', '세션 정보를 불러올 수 없습니다: $e');
    }
  }

  /// 세션 실시간 감시
  void watchSession() {
    _repo.watchSession(sessionId.value).listen((snapshot) {
      if (snapshot.exists) {
        try {
          final data = snapshot.data() as Map<String, dynamic>?;
          if (data != null) {
            final sessionData = Session.fromJson(data, sessionId.value);
            session.value = sessionData;

            // status가 consensus/final이면 리다이렉트
            final status = sessionData.status;
            if (status == 'consensus' || status == 'final') {
              Get.offNamed(Routes.sessionHomePath(sessionId.value));
            }
          }
        } catch (e) {
          print('세션 파싱 오류: $e');
        }
      }
    });
  }

  /// 답변 로드
  Future<void> loadAnswers() async {
    try {
      isLoading.value = true;
      final answerData = await _repo.getSessionAnswer(
        sessionId.value,
        currentUserId.value,
      );
      if (answerData != null) {
        answers.value = answerData.answers;
      }
    } catch (e) {
      Get.snackbar('오류', '답변을 불러올 수 없습니다: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// 답변 업데이트
  void updateAnswer(String questionId, String answerText) {
    answers[questionId] = answerText;
  }

  /// 답변 저장
  ///
  /// 1) answers/{uid} upsert(answers map)
  /// 2) completedCount 계산
  /// 3) sessions.participantStatus[uid] 업데이트
  /// 4) completedCount>=8이면 sessions.readyUserIds arrayUnion([uid])
  /// 5) readyUserIds.length>=2 && status=='answering'이면 트랜잭션으로 status='ready_for_consensus' 전환 시도
  Future<void> saveAnswers() async {
    try {
      isSaving.value = true;

      // 1) answers/{uid} upsert(answers map)
      final answer = SessionAnswer(
        sessionId: sessionId.value,
        uid: currentUserId.value,
        answers: Map<String, String>.from(answers),
        updatedAt: DateTime.now(),
      );
      await _repo.setSessionAnswer(answer);

      // 2) completedCount 계산
      final completedCount = answers.length;

      // 3) sessions.participantStatus[uid] 업데이트
      await _repo.updateParticipantCompletedCount(
        sessionId.value,
        currentUserId.value,
        completedCount,
      );

      // 4) completedCount>=8이면 sessions.readyUserIds arrayUnion([uid])
      if (completedCount >= 8) {
        await _repo.addReadyUserId(sessionId.value, currentUserId.value);

        // 5) readyUserIds.length>=2 && status=='answering'이면 트랜잭션으로 status='ready_for_consensus' 전환 시도
        try {
          final transitioned = await _repo.transitionToReadyForConsensus(
            sessionId.value,
          );
          if (!transitioned) {
            // 트랜잭션 실패(이미 다른 클라 전환): 토스트 표시
            Get.snackbar(
              '알림',
              '상대가 이미 합의를 시작했습니다',
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        } catch (e) {
          // 트랜잭션 실패해도 계속 진행
          print('상태 전환 실패: $e');
        }
      }

      Get.snackbar('성공', '답변이 저장되었습니다');
    } catch (e) {
      Get.snackbar('오류', '답변 저장 실패: $e');
    } finally {
      isSaving.value = false;
    }
  }

  /// 완료 개수
  int get completedCount => answers.length;
}
