import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/firebase_options.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'data/repository/user_repository.dart';
import 'data/repository/firestore_repo.dart';
import 'service/auth_service.dart';
import 'service/pending_route_service.dart';
import 'service/company_key_cache_service.dart';
import 'service/deep_link_service.dart';
import 'router/app_pages.dart';
import 'router/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // GetStorage 초기화 (pendingRoutePath 저장용)
  await GetStorage.init();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 서비스 및 리포지토리 초기화
  // 순서 중요: CompanyKeyCacheService -> AuthService -> PendingRouteService -> DeepLinkService
  Get.put(CompanyKeyCacheService());
  Get.put(AuthService()); // AuthService.onInit()에서 CompanyKeyCacheService 사용
  Get.put(PendingRouteService()); // PendingRouteService는 AuthService 이후에 초기화
  Get.put(DeepLinkService()); // DeepLinkService는 PendingRouteService 이후에 초기화
  Get.put(UserRepository());
  Get.put(FirestoreRepository()); // Firestore CRUD 작업용 레포지토리

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(
    analytics: analytics,
  );

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'CoSync',
      debugShowCheckedModeBanner: false,
      scrollBehavior: const AppScrollBehavior(),
      navigatorObservers: [observer],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      // v5 스펙에 따른 라우팅 설정
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      // 딥링크 처리: 웹 환경에서 URL 변경 감지
      onGenerateRoute: (settings) {
        // 웹 환경에서 URL 변경 시 딥링크 처리
        try {
          final deepLinkService = Get.find<DeepLinkService>();
          if (settings.name != null && settings.name!.isNotEmpty) {
            // Entry 페이지가 아닌 경우에만 딥링크 처리
            if (settings.name != Routes.entry) {
              deepLinkService.handleWebUrl(settings.name!);
            }
          }
        } catch (e) {
          // DeepLinkService가 아직 초기화되지 않은 경우 무시
        }
        return null; // GetX의 기본 라우팅 사용
      },
    );
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}
