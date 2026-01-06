import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/firebase_options.dart';
import 'package:flutter_demo/ui/page/landing/landing_page.dart';
import 'package:get/get.dart';
import 'data/repository/user_repository.dart';
import 'service/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 서비스 및 리포지토리 초기화
  Get.put(AuthService());
  Get.put(UserRepository());

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
        fontFamily: 'Pretendard',
      ),
      home : const LandingPage(),
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
