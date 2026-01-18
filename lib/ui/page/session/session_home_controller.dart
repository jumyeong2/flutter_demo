import 'dart:async';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/repository/firestore_repo.dart';
import '../../../data/model/session.dart';
import '../../../router/routes.dart';

/// SessionHomeController: 세션 홈 페이지 컨트롤러
/// sessions/{id} 스트림 구독하여 상태(status, participantStatus)로 단일 CTA를 표시
class SessionHomeController extends GetxController {
  late final FirestoreRepository _repo;

  final RxString sessionId = ''.obs;
  final Rx<Session?> session = Rx<Session?>(null);
  final RxString currentUserId = ''.obs;
  final RxBool isLoading = false.obs;

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
      watchSession();
    }
  }

  @override
  void onClose() {
    _sessionSubscription?.cancel();
    super.onClose();
  }

  /// 세션 실시간 감시
  void watchSession() {
    _sessionSubscription = _repo.watchSession(sessionId.value).listen((snapshot) {
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

  /// 내 완료 개수
  int get myCompletedCount {
    if (session.value == null || currentUserId.value.isEmpty) return 0;
    final participantStatus = session.value!.participantStatus;
    final myStatus = participantStatus[currentUserId.value];
    return myStatus?.completedCount ?? 0;
  }

  /// 상대 완료 개수
  int get otherCompletedCount {
    if (session.value == null || currentUserId.value.isEmpty) return 0;
    
    final participantA = session.value!.participantStatus.keys.firstWhere(
      (uid) => uid != currentUserId.value,
      orElse: () => '',
    );
    
    if (participantA.isEmpty) return 0;
    final otherStatus = session.value!.participantStatus[participantA];
    return otherStatus?.completedCount ?? 0;
  }

  /// CTA 버튼 텍스트 및 이동 경로 결정
  /// 
  /// v5 스펙 16항:
  /// - answering: 내<8 -> /questions, 내>=8&상대<8 -> /wait, 둘다>=8 -> /consensus
  /// - ready_for_consensus -> /consensus
  /// - consensus -> /consensus
  /// - final -> /doc/{finalDocId} or /doc/latest
  Map<String, dynamic>? getCtaAction() {
    final currentSession = session.value;
    if (currentSession == null) return null;

    final status = currentSession.status;
    final myCount = myCompletedCount;
    final otherCount = otherCompletedCount;

    switch (status) {
      case 'answering':
        if (myCount < 8) {
          return {
            'text': '답변 입력하기',
            'route': Routes.sessionQuestionsPath(sessionId.value),
          };
        } else if (otherCount < 8) {
          return {
            'text': '상대 입력 대기',
            'route': Routes.sessionWaitPath(sessionId.value),
          };
        } else {
          return {
            'text': '합의 시작하기',
            'route': Routes.sessionConsensusPath(sessionId.value),
          };
        }

      case 'ready_for_consensus':
        return {
          'text': '합의 시작하기',
          'route': Routes.sessionConsensusPath(sessionId.value),
        };

      case 'consensus':
        return {
          'text': '합의 계속하기',
          'route': Routes.sessionConsensusPath(sessionId.value),
        };

      case 'final':
        if (currentSession.finalDocId != null) {
          return {
            'text': '문서 보기',
            'route': Routes.docViewPath(currentSession.finalDocId!),
          };
        } else {
          return {
            'text': '문서 보기',
            'route': Routes.docLatest,
          };
        }

      default:
        return null;
    }
  }
}
