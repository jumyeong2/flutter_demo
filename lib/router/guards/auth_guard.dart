import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../service/pending_route_service.dart';
import '../routes.dart';

/// AuthGuard: 로그인 확인 미들웨어
/// 미로그인 사용자를 로그인 화면으로 보내고, pendingRoutePath를 저장합니다.
class AuthGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final user = FirebaseAuth.instance.currentUser;
    
    // 로그인되어 있으면 통과
    if (user != null) {
      return null;
    }

    // 미로그인: pendingRoutePath 저장 (단, '/'는 저장하지 않음)
    if (route != null && route != Routes.entry) {
      try {
        final pendingRouteService = Get.find<PendingRouteService>();
        pendingRouteService.savePendingRoute(route);
      } catch (e) {
        // PendingRouteService가 아직 초기화되지 않은 경우 무시
        // (앱 시작 초기 단계에서 발생할 수 있음)
      }
    }

    // 로그인 화면으로 리다이렉트
    return const RouteSettings(name: Routes.login);
  }
}
