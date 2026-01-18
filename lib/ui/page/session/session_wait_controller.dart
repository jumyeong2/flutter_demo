import 'dart:async';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import '../../../data/repository/firestore_repo.dart';
import '../../../data/model/session.dart';
import '../../../service/company_key_cache_service.dart';
import '../../../router/routes.dart';

/// SessionWaitController: 대기 화면 컨트롤러
class SessionWaitController extends GetxController {
  late final FirestoreRepository _repo;
  late final CompanyKeyCacheService _cacheService;

  final RxString sessionId = ''.obs;
  final RxString currentUserId = ''.obs;
  final Rx<Session?> session = Rx<Session?>(null);
  final RxString companyKey = ''.obs;

  StreamSubscription<DocumentSnapshot>? _sessionSubscription;

  @override
  void onInit() {
    super.onInit();
    _repo = Get.find<FirestoreRepository>();
    _cacheService = Get.find<CompanyKeyCacheService>();

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
      watchSession();
    }

    // companyKey 가져오기
    companyKey.value = _cacheService.getCachedCompanyKey() ?? '';
  }

  @override
  void onClose() {
    _sessionSubscription?.cancel();
    super.onClose();
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

            // 상대가 8/10 도달하면 자동으로 합의 화면으로 유도
            final otherCount = getOtherCompletedCount();
            if (otherCount >= 8 &&
                sessionData.status == 'ready_for_consensus') {
              Get.offNamed(Routes.sessionConsensusPath(sessionId.value));
            }
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
  int getOtherCompletedCount() {
    if (session.value == null || currentUserId.value.isEmpty) return 0;

    final participantStatus = session.value!.participantStatus;
    for (var entry in participantStatus.entries) {
      if (entry.key != currentUserId.value) {
        return entry.value.completedCount;
      }
    }
    return 0;
  }

  /// 초대 링크 생성
  /// 세션 초대: /team/join?code={companyKey}&redirect=/session/{sessionId}
  String getInviteLink() {
    return Routes.teamJoinPath(
      code: companyKey.value,
      redirect: Routes.sessionHomePath(sessionId.value),
    );
  }

  /// 초대 링크 복사
  Future<void> copyInviteLink() async {
    final link = getInviteLink();
    await Clipboard.setData(ClipboardData(text: link));
    Get.snackbar('성공', '초대 링크가 복사되었습니다', snackPosition: SnackPosition.BOTTOM);
  }
}
