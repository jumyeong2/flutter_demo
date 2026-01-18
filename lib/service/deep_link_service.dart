import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'pending_route_service.dart';
import 'auth_service.dart';
import '../router/routes.dart';

/// DeepLinkService: 외부 링크(딥링크) 처리 서비스
/// 앱이 외부 링크로 열릴 때 URL을 파싱하여 적절한 라우트로 이동시킵니다.
class DeepLinkService extends GetxService {
  final _storage = GetStorage();
  late final PendingRouteService _pendingRouteService;
  
  static const String _keyInitialLink = 'initialDeepLink';
  
  StreamSubscription<String>? _linkSubscription;
  
  @override
  void onInit() {
    super.onInit();
    // PendingRouteService는 main.dart에서 이미 초기화되어 있음
    try {
      _pendingRouteService = Get.find<PendingRouteService>();
    } catch (e) {
      // PendingRouteService가 아직 초기화되지 않은 경우
      // onInit이 호출될 때는 이미 초기화되어 있어야 하므로 에러 처리
      print('DeepLinkService: PendingRouteService를 찾을 수 없습니다 - $e');
    }
    _initDeepLink();
  }
  
  @override
  void onClose() {
    _linkSubscription?.cancel();
    super.onClose();
  }
  
  /// 딥링크 초기화
  /// 웹과 모바일 환경을 모두 지원합니다.
  void _initDeepLink() {
    // 웹 환경에서는 window.location을 확인
    // 모바일 환경에서는 플랫폼별 딥링크 처리
    // 현재는 GetX 라우팅을 활용하여 처리
    
    // 앱 시작 시 저장된 초기 링크 확인
    _handleInitialLink();
  }
  
  /// 앱 시작 시 초기 링크 처리
  void _handleInitialLink() {
    try {
      final initialLink = _storage.read<String>(_keyInitialLink);
      if (initialLink != null && initialLink.isNotEmpty) {
        _storage.remove(_keyInitialLink);
        _processDeepLink(initialLink);
      }
    } catch (e) {
      print('DeepLinkService: 초기 링크 처리 오류 - $e');
    }
  }
  
  /// 외부에서 딥링크 처리 요청
  /// 웹: URL 변경 감지 시 호출
  /// 모바일: 앱이 외부 링크로 열릴 때 호출
  Future<void> handleDeepLink(String url) async {
    try {
      // URL 파싱
      final uri = Uri.parse(url);
      
      // 앱 도메인 제거 (예: https://app.example.com/session/123 -> /session/123)
      String path = uri.path;
      if (uri.queryParameters.isNotEmpty) {
        final queryString = uri.queryParameters.entries
            .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
            .join('&');
        path = '$path?$queryString';
      }
      
      // 딥링크 처리
      _processDeepLink(path);
    } catch (e) {
      print('DeepLinkService: 딥링크 처리 오류 - $e');
    }
  }
  
  /// 딥링크 경로 처리
  /// 
  /// 지원하는 링크 형식:
  /// - /team/join?code={teamCode}&redirect={path}
  /// - /session/{sessionId}
  /// - /doc/{docId}
  /// - /doc/latest?companyKey={key}
  void _processDeepLink(String path) {
    if (path.isEmpty || path == '/') {
      return;
    }
    
    try {
      final uri = Uri.parse(path);
      final routePath = uri.path;
      final queryParams = uri.queryParameters;
      
      // 현재 로그인 상태 확인
      bool isLoggedIn = false;
      try {
        isLoggedIn = Get.find<AuthService>().isLoggedIn;
      } catch (e) {
        // AuthService가 아직 초기화되지 않은 경우
        print('DeepLinkService: AuthService를 찾을 수 없습니다 - $e');
      }
      
      if (!isLoggedIn) {
        // 미로그인: pendingRoutePath에 저장하고 로그인 화면으로 이동
        _pendingRouteService.savePendingRoute(path);
        Get.offAllNamed(Routes.login);
      } else {
        // 로그인 상태: 직접 라우팅
        // GetX의 Get.toNamed를 사용하여 라우팅
        // Guard가 자동으로 실행됨
        
        // 동적 경로 처리
        String? targetRoute;
        
        if (routePath.startsWith('/team/join')) {
          // 팀 가입 링크
          final code = queryParams['code'];
          final redirect = queryParams['redirect'];
          if (code != null) {
            targetRoute = Routes.teamJoinPath(code: code, redirect: redirect);
          }
        } else if (routePath.startsWith('/session/')) {
          // 세션 링크: /session/{sessionId} 또는 /session/{sessionId}/...
          final parts = routePath.split('/');
          if (parts.length >= 3) {
            final sessionId = parts[2];
            if (parts.length == 3) {
              targetRoute = Routes.sessionHomePath(sessionId);
            } else if (parts.length == 4) {
              final subPath = parts[3];
              switch (subPath) {
                case 'questions':
                  targetRoute = Routes.sessionQuestionsPath(sessionId);
                  break;
                case 'wait':
                  targetRoute = Routes.sessionWaitPath(sessionId);
                  break;
                case 'consensus':
                  targetRoute = Routes.sessionConsensusPath(sessionId);
                  break;
                case 'generate':
                  targetRoute = Routes.sessionGeneratePath(sessionId);
                  break;
              }
            }
          }
        } else if (routePath.startsWith('/doc/')) {
          // 문서 링크
          if (routePath == '/doc/latest') {
            final companyKey = queryParams['companyKey'];
            targetRoute = Routes.docLatestPath(companyKey: companyKey);
          } else {
            final parts = routePath.split('/');
            if (parts.length >= 3) {
              final docId = parts[2];
              targetRoute = Routes.docViewPath(docId);
            }
          }
        } else {
          // 기타 경로는 그대로 사용
          targetRoute = path;
        }
        
        if (targetRoute != null) {
          Get.offAllNamed(targetRoute);
        } else {
          // 처리할 수 없는 링크는 Entry로 이동
          Get.offAllNamed(Routes.entry);
        }
      }
    } catch (e) {
      print('DeepLinkService: 경로 처리 오류 - $e');
      // 오류 발생 시 Entry로 이동
      Get.offAllNamed(Routes.entry);
    }
  }
  
  /// 웹 환경에서 URL 변경 감지
  /// GetMaterialApp의 onGenerateRoute와 연동하여 사용
  void handleWebUrl(String url) {
    handleDeepLink(url);
  }
}
