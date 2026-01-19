import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../ui/page/landing/landing_page.dart';
import '../ui/page/sample/sample_report.dart';
import '../ui/page/login/login_page.dart';
import '../router/routes.dart';
import '../router/guards/auth_guard.dart';
import '../router/guards/company_guard.dart';
import '../router/guards/member_guard.dart';
import '../router/guards/session_guard.dart';
import '../ui/page/entry/entry_page.dart';
import '../ui/page/team/team_select_page.dart';
import '../ui/page/team/team_create_page.dart';
import '../ui/page/team/team_join_page.dart';
import '../ui/page/team/team_member_required_page.dart';
import '../ui/page/workspace/dashboard_page.dart';
import '../ui/page/session/session_create_page.dart';
import '../ui/page/session/session_home_page.dart';
import '../ui/page/session/session_wait_page.dart';
import '../ui/page/session/session_consensus_page.dart';
import '../ui/page/session/session_generate_page.dart';
import '../ui/page/document/doc_latest_page.dart';
import '../ui/page/document/doc_view_page.dart';
import '../ui/page/settings/settings_team_page.dart';
import '../ui/page/error/error_page.dart';
import '../ui/page/error/not_found_page.dart';

/// GetPage 라우팅 트리
/// v5 스펙에 따른 모든 라우트와 middlewares를 정의합니다.
class AppPages {
  AppPages._(); // private constructor

  static const initial = Routes.landing;

  static final routes = [
    // Entry (middlewares 없음, 내부 분기만)
    GetPage(
      name: Routes.entry,
      page: () => const AppEntryPage(),
    ),

    // Public (middlewares: [])
    GetPage(
      name: Routes.landing,
      page: () => const LandingPage(),
    ),
    GetPage(
      name: Routes.sample,
      page: () => const SampleReportPage(),
    ),

    // Auth (middlewares: [])
    GetPage(
      name: Routes.login,
      page: () => const LoginPage(),
    ),
    GetPage(
      name: Routes.signup,
      page: () => const SignupPage(), // TODO: SignupPage 생성 필요
    ),

    // Team (middlewares: [AuthGuard])
    GetPage(
      name: Routes.teamSelect,
      page: () => const TeamSelectPage(), // TODO: TeamSelectPage 생성 필요
      middlewares: [AuthGuard()],
    ),
    GetPage(
      name: Routes.teamCreate,
      page: () => const TeamCreatePage(), // TODO: TeamCreatePage 생성 필요
      middlewares: [AuthGuard()],
    ),
    GetPage(
      name: Routes.teamJoin,
      page: () => const TeamJoinPage(), // TODO: TeamJoinPage 생성 필요
      middlewares: [AuthGuard()],
    ),
    GetPage(
      name: Routes.teamMemberRequired,
      page: () => const TeamMemberRequiredPage(),
      middlewares: [AuthGuard()],
    ),

    // Workspace - Dashboard (middlewares: [AuthGuard, CompanyGuard, MemberGuard])
    GetPage(
      name: Routes.dashboard,
      page: () => const DashboardPage(), // TODO: DashboardPage 생성 필요
      middlewares: [
        AuthGuard(),
        CompanyGuard(),
        MemberGuard(),
      ],
    ),
    GetPage(
      name: Routes.sessionCreate,
      page: () => const SessionCreatePage(),
      middlewares: [
        AuthGuard(),
        CompanyGuard(),
        MemberGuard(),
      ],
    ),

    // Session (middlewares: [AuthGuard, SessionGuard])
    GetPage(
      name: Routes.sessionHome,
      page: () => const SessionHomePage(),
      middlewares: [
        AuthGuard(),
        SessionGuard(),
      ],
    ),
    GetPage(
      name: Routes.sessionQuestions,
      page: () => const SessionQuestionsPage(),
      middlewares: [
        AuthGuard(),
        SessionGuard(),
      ],
    ),
    GetPage(
      name: Routes.sessionWait,
      page: () => const SessionWaitPage(),
      middlewares: [
        AuthGuard(),
        SessionGuard(),
      ],
    ),
    GetPage(
      name: Routes.sessionConsensus,
      page: () => const SessionConsensusPage(),
      middlewares: [
        AuthGuard(),
        SessionGuard(),
      ],
    ),
    GetPage(
      name: Routes.sessionGenerate,
      page: () => const SessionGeneratePage(),
      middlewares: [
        AuthGuard(),
        SessionGuard(),
      ],
    ),

    // Document (middlewares: [AuthGuard])
    GetPage(
      name: Routes.docLatest,
      page: () => const DocLatestPage(),
      middlewares: [AuthGuard()],
    ),
    GetPage(
      name: Routes.docView,
      page: () => const DocViewPage(),
      middlewares: [AuthGuard()],
    ),

    // Settings (middlewares: [AuthGuard])
    GetPage(
      name: Routes.settings,
      page: () => const SettingsPage(), // TODO: SettingsPage 생성 필요
      middlewares: [AuthGuard()],
    ),
    GetPage(
      name: Routes.settingsProfile,
      page: () => const SettingsProfilePage(), // TODO: SettingsProfilePage 생성 필요
      middlewares: [AuthGuard()],
    ),
    GetPage(
      name: Routes.settingsTeam,
      page: () => const SettingsTeamPage(),
      middlewares: [
        AuthGuard(),
        CompanyGuard(),
        MemberGuard(),
      ],
    ),
    GetPage(
      name: Routes.settingsLogout,
      page: () => const SettingsLogoutPage(), // TODO: SettingsLogoutPage 생성 필요
      middlewares: [AuthGuard()],
    ),

    // Error (middlewares: [])
    GetPage(
      name: Routes.error,
      page: () => const ErrorPage(),
    ),
    GetPage(
      name: Routes.notFound,
      page: () => const NotFoundPage(),
    ),
  ];
}

// TODO: 아래 페이지들은 추후 구현 필요
// 임시 placeholder 페이지들

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: 실제 회원가입 페이지로 교체
    return Scaffold(
      appBar: AppBar(title: const Text('회원가입')),
      body: const Center(
        child: Text('회원가입 페이지 (구현 예정)\n\n회원가입 성공 후 pendingRoutePath 복귀 처리 필요'),
      ),
    );
  }
  
  // TODO: 회원가입 성공 후 처리 예시
  // Future<void> _handleSignupSuccess() async {
  //   // 1. users/{uid} 문서 생성 (currentCompanyKey = null)
  //   // 2. pendingRoutePath 복귀 처리
  //   final pendingRouteService = Get.find<PendingRouteService>();
  //   final pendingRoutePath = pendingRouteService.getPendingRoutePath();
  //   
  //   if (pendingRoutePath != null && pendingRoutePath.isNotEmpty) {
  //     Get.offAllNamed(pendingRoutePath);
  //   } else {
  //     Get.offAllNamed(Routes.entry);
  //   }
  // }
}




class SessionQuestionsPage extends StatelessWidget {
  const SessionQuestionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('질문 답변')),
      body: const Center(child: Text('질문 답변 페이지 (구현 예정)')),
    );
  }
}




class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: const Center(child: Text('설정 페이지 (구현 예정)')),
    );
  }
}

class SettingsProfilePage extends StatelessWidget {
  const SettingsProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('프로필')),
      body: const Center(child: Text('프로필 페이지 (구현 예정)')),
    );
  }
}


class SettingsLogoutPage extends StatelessWidget {
  const SettingsLogoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('로그아웃')),
      body: const Center(child: Text('로그아웃 페이지 (구현 예정)')),
    );
  }
}

