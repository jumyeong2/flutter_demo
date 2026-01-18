import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../routes.dart';
import '../../service/company_key_cache_service.dart';

/// SessionGuard: 세션 접근 권한 확인 미들웨어
/// sessions/{sessionId}를 읽고, 멤버십 확인 및 currentCompanyKey 동기화를 수행합니다.
/// 
/// 주의: GetMiddleware의 redirect는 동기 함수이므로,
/// 비동기 검증은 페이지의 onInit에서 수행하도록 안내합니다.
class SessionGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const RouteSettings(name: Routes.login);
    }

    // route에서 sessionId 추출
    final sessionId = _extractSessionId(route);
    if (sessionId == null) {
      return RouteSettings(
        name: Routes.error,
        arguments: {
          'message': '세션 ID를 찾을 수 없습니다',
          'fallbackRoute': Routes.dashboard,
        },
      );
    }

    // 비동기 검증은 페이지의 onInit에서 수행
    // 여기서는 동기적으로 가능한 부분만 처리
    return null;
  }

  /// 비동기 세션 검증 (페이지의 onInit에서 호출)
  /// 
  /// 반환값:
  /// - null: 검증 통과
  /// - RouteSettings: 리다이렉트 필요
  static Future<RouteSettings?> verifySession(
    String sessionId,
    String userId,
    String? currentRoute,
  ) async {
    final firestore = FirebaseFirestore.instance;

    try {
      // sessions/{sessionId} 읽기
      final sessionDoc = await firestore
          .collection('sessions')
          .doc(sessionId)
          .get()
          .timeout(const Duration(seconds: 5));

      // 세션이 없으면 에러 페이지로
      if (!sessionDoc.exists) {
        return RouteSettings(
          name: Routes.error,
          arguments: {
            'message': '세션을 찾을 수 없습니다',
            'fallbackRoute': Routes.dashboard,
          },
        );
      }

      final sessionData = sessionDoc.data()!;
      final sessionCompanyKey = sessionData['companyKey'] as String?;

      // sessionCompanyKey가 null이면 에러 페이지로
      if (sessionCompanyKey == null || sessionCompanyKey.isEmpty) {
        return RouteSettings(
          name: Routes.error,
          arguments: {
            'message': '세션의 팀 정보를 찾을 수 없습니다',
            'fallbackRoute': Routes.dashboard,
          },
        );
      }

      // 멤버십 확인
      final memberDoc = await firestore
          .collection('companies')
          .doc(sessionCompanyKey)
          .collection('members')
          .doc(userId)
          .get()
          .timeout(const Duration(seconds: 5));

      // 멤버가 아니면 팀 가입 화면으로 리다이렉트
      if (!memberDoc.exists) {
        return RouteSettings(
          name: Routes.teamJoinPath(
            code: sessionCompanyKey,
            redirect: currentRoute ?? Routes.sessionHomePath(sessionId),
          ),
        );
      }

      // 멤버면 users.currentCompanyKey와 다를 때 서버 업데이트 및 로컬 캐시 갱신
      try {
        final cacheService = Get.find<CompanyKeyCacheService>();
        final currentCompanyKey = cacheService.getCachedCompanyKey();

        // sessionCompanyKey와 다르면 서버 업데이트
        if (currentCompanyKey != sessionCompanyKey) {
          await cacheService.updateServerCompanyKey(userId, sessionCompanyKey);
        }
      } catch (e) {
        // 서버 업데이트 실패해도 세션 접근은 허용 (로컬 캐시만 갱신)
        try {
          final cacheService = Get.find<CompanyKeyCacheService>();
          cacheService.setCachedCompanyKey(sessionCompanyKey);
        } catch (e2) {
          // 로컬 캐시 갱신 실패는 무시
        }
      }

      // 통과
      return null;
    } on TimeoutException {
      // 타임아웃 시 에러 페이지로
      return RouteSettings(
        name: Routes.error,
        arguments: {
          'message': '네트워크 연결 시간이 초과되었습니다. 다시 시도해주세요.',
          'fallbackRoute': Routes.dashboard,
        },
      );
    } catch (e) {
      // Firestore read 실패 시 에러 페이지로
      return RouteSettings(
        name: Routes.error,
        arguments: {
          'message': '세션 정보를 불러오는 중 오류가 발생했습니다: ${e.toString()}',
          'fallbackRoute': Routes.dashboard,
        },
      );
    }
  }

  /// route 경로에서 sessionId 추출
  String? _extractSessionId(String? route) {
    if (route == null) return null;
    
    // /session/:sessionId 또는 /session/:sessionId/questions 등
    final match = RegExp(r'/session/([^/]+)').firstMatch(route);
    return match?.group(1);
  }
}
