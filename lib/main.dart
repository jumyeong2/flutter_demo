import 'package:flutter/material.dart';
import 'landing_page.dart';
import 'onboarding_page.dart';
import 'agreement_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Co-founder Sync',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        fontFamily: 'Pretendard', // Assuming a font, or fallback to system
      ),
      home: const App(),
    );
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  String currentView = 'landing'; // 'landing' | 'onboarding' | 'agreement'

  @override
  Widget build(BuildContext context) {
    switch (currentView) {
      case 'landing':
        return LandingPage(
          onStartTrial: () => setState(() => currentView = 'onboarding'),
        );
      case 'onboarding':
        return OnboardingPage(
          onBack: () => setState(() => currentView = 'landing'),
          onStart: () => setState(() => currentView = 'agreement'),
        );
      case 'agreement':
        return const AgreementPage();
      default:
        return LandingPage(
          onStartTrial: () => setState(() => currentView = 'onboarding'),
        );
    }
  }
}
