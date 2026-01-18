import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../service/company_key_cache_service.dart';
import '../routes.dart';

/// CompanyGuard: 팀 컨텍스트(currentCompanyKey) 확인 미들웨어
/// 팀이 선택되지 않았으면 팀 선택 화면으로 보냅니다.
class CompanyGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const RouteSettings(name: Routes.login);
    }

    // 로컬 캐시에서 먼저 확인 (빠른 분기)
    String? companyKey;
    try {
      final cacheService = Get.find<CompanyKeyCacheService>();
      companyKey = cacheService.getCachedCompanyKey();
      
      // 백그라운드에서 서버 동기화 시도 (캐시는 있지만 서버와 동기화)
      cacheService.syncFromServer(user.uid);
    } catch (e) {
      // CompanyKeyCacheService가 아직 초기화되지 않은 경우 무시
    }

    // 팀 컨텍스트가 없으면 팀 선택 화면으로
    if (companyKey == null || companyKey.isEmpty) {
      return const RouteSettings(name: Routes.teamSelect);
    }

    return null; // 통과
  }
}
