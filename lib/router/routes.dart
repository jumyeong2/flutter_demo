/// Route Names 상수 정의
/// v5 스펙에 따른 모든 라우트 경로를 상수로 정의합니다.
class Routes {
  Routes._(); // private constructor

  // Entry
  static const String entry = '/';

  // Public
  static const String landing = '/landing';
  static const String sample = '/sample';

  // Auth
  static const String login = '/auth/login';
  static const String signup = '/auth/signup';

  // Team
  static const String teamSelect = '/team/select';
  static const String teamCreate = '/team/create';
  static const String teamJoin = '/team/join';
  static const String teamMemberRequired = '/team/member-required';

  // Workspace
  static const String dashboard = '/dashboard';
  static const String sessionCreate = '/session/create';
  
  // Session (동적 파라미터 포함)
  static const String sessionHome = '/session/:sessionId';
  static const String sessionQuestions = '/session/:sessionId/questions';
  static const String sessionWait = '/session/:sessionId/wait';
  static const String sessionConsensus = '/session/:sessionId/consensus';
  static const String sessionGenerate = '/session/:sessionId/generate';

  // Document
  static const String docLatest = '/doc/latest';
  static const String docView = '/doc/:docId';

  // Settings
  static const String settings = '/settings';
  static const String settingsProfile = '/settings/profile';
  static const String settingsTeam = '/settings/team';
  static const String settingsLogout = '/settings/logout';

  // Error
  static const String error = '/error';
  static const String notFound = '/404';

  // Helper methods for dynamic routes
  /// 세션 홈 경로 생성
  static String sessionHomePath(String sessionId) => '/session/$sessionId';
  
  /// 세션 질문 경로 생성
  static String sessionQuestionsPath(String sessionId) => '/session/$sessionId/questions';
  
  /// 세션 대기 경로 생성
  static String sessionWaitPath(String sessionId) => '/session/$sessionId/wait';
  
  /// 세션 합의 경로 생성
  static String sessionConsensusPath(String sessionId) => '/session/$sessionId/consensus';
  
  /// 세션 문서 생성 경로 생성
  static String sessionGeneratePath(String sessionId) => '/session/$sessionId/generate';
  
  /// 문서 보기 경로 생성
  static String docViewPath(String docId) => '/doc/$docId';
  
  /// 팀 가입 경로 생성 (쿼리 파라미터 포함)
  static String teamJoinPath({
    required String code,
    String? redirect,
  }) {
    final uri = Uri(
      path: teamJoin,
      queryParameters: {
        'code': code,
        if (redirect != null) 'redirect': redirect,
      },
    );
    return uri.toString();
  }
  
  /// 최신 문서 경로 생성 (쿼리 파라미터 포함)
  static String docLatestPath({String? companyKey}) {
    final uri = Uri(
      path: docLatest,
      queryParameters: companyKey != null ? {'companyKey': companyKey} : null,
    );
    return uri.toString();
  }
}
