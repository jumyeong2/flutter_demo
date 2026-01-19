import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../router/routes.dart';
import '../../../service/pending_route_service.dart';
import '../../../service/company_key_cache_service.dart';
import '../../../data/repository/firestore_repo.dart';

/// AppEntryPage: 앱 진입 시 자동 분기 페이지
/// v5 스펙에 따라 분기 규칙:
/// 1) pendingRoutePath 있으면 Get.offAllNamed(pendingRoutePath) 후 return (clear 금지)
/// 2) 미로그인 -> /landing
/// 3) 로그인 + currentCompanyKey 없음 -> /team/select
/// 4) 로그인 + currentCompanyKey 있음 -> /dashboard
/// 
/// 무한 루프 방지: 모든 Guard는 '/'로 리다이렉트하지 않음
class AppEntryPage extends StatefulWidget {
  const AppEntryPage({super.key});

  @override
  State<AppEntryPage> createState() => _AppEntryPageState();
}

class _AppEntryPageState extends State<AppEntryPage> {
  @override
  void initState() {
    super.initState();
    // 위젯이 빌드된 후 라우팅 처리
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleRouting();
    });
  }

  @override
  Widget build(BuildContext context) {
    // 로딩 중 표시 (개선된 UI)
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: Color(0xFF0F172A),
            ),
            const SizedBox(height: 24),
            const Text(
              '로딩 중...',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 라우팅 분기 처리
  Future<void> _handleRouting() async {
    // 서비스 초기화 대기
    try {
      Get.find<PendingRouteService>();
      Get.find<CompanyKeyCacheService>();
    } catch (e) {
      // 서비스가 아직 초기화되지 않은 경우 잠시 대기
      await Future.delayed(const Duration(milliseconds: 100));
      try {
        Get.find<PendingRouteService>();
        Get.find<CompanyKeyCacheService>();
      } catch (e2) {
        // 여전히 실패하면 랜딩 페이지로 이동
        if (mounted) {
          Get.offAllNamed(Routes.landing);
        }
        return;
      }
    }

    final user = FirebaseAuth.instance.currentUser;

    // 1) pendingRoutePath 우선 처리
    try {
      final pendingRouteService = Get.find<PendingRouteService>();
      final pendingRoutePath = pendingRouteService.getPendingRoutePath();
      
      if (pendingRoutePath != null && pendingRoutePath.isNotEmpty) {
        // pendingRoutePath로 이동 (해당 라우트의 Guard가 실행됨)
        // clear는 목적지 화면에서 성공적으로 진입했을 때만 수행
        if (mounted) {
          Get.offAllNamed(pendingRoutePath);
        }
        return; // clear 금지
      }
    } catch (e) {
      // PendingRouteService가 아직 초기화되지 않은 경우 무시하고 계속 진행
    }

    // 2) 미로그인 -> /landing
    if (user == null) {
      if (mounted) {
        Get.offAllNamed(Routes.landing);
      }
      return;
    }

    // 3) 로그인 상태: currentCompanyKey 확인
    String? companyKey;
    
    try {
      final cacheService = Get.find<CompanyKeyCacheService>();
      final repo = Get.find<FirestoreRepository>();
      
      // 서버에서 먼저 확인 (source of truth)
      try {
        final firestoreUser = await repo.getUser(user.uid);
        if (firestoreUser != null && firestoreUser.currentCompanyKey != null && firestoreUser.currentCompanyKey!.isNotEmpty) {
          companyKey = firestoreUser.currentCompanyKey;
          // 서버 값이 있으면 로컬 캐시도 갱신
          cacheService.setCachedCompanyKey(companyKey!);
        } else {
          // 서버에 값이 없으면 로컬 캐시도 삭제
          cacheService.clearCachedCompanyKey();
        }
      } catch (e) {
        // 서버 조회 실패 시 로컬 캐시 확인 (오프라인 대응)
        companyKey = cacheService.getCachedCompanyKey();
      }
    } catch (e) {
      // CompanyKeyCacheService나 FirestoreRepository가 아직 초기화되지 않은 경우 무시
      // (앱 시작 초기 단계에서 발생할 수 있음)
    }

    // 4) 로그인 + currentCompanyKey 없음 -> /team/select
    if (companyKey == null || companyKey.isEmpty) {
      if (mounted) {
        Get.offAllNamed(Routes.teamSelect);
      }
      return;
    }

    // 5) 로그인 + currentCompanyKey 있음 -> /dashboard
    if (mounted) {
      Get.offAllNamed(Routes.dashboard);
    }
  }
}
