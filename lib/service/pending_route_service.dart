import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// PendingRouteService: 딥링크 복귀를 위한 pendingRoutePath 관리 서비스
/// GetStorage를 사용하여 앱 재시작 후에도 유지됩니다.
class PendingRouteService extends GetxService {
  final _storage = GetStorage();
  
  static const String _keyPath = 'pendingRoutePath';
  static const String _keyType = 'pendingRouteType';

  /// pendingRoutePath 저장
  /// 
  /// [route] 원래 가려던 full path (경로 + 쿼리 포함)
  /// [routeType] 라우트 타입 ('session'|'teamJoin'|'doc'|'other')
  /// 
  /// 주의: '/' (Entry)는 저장하지 않습니다.
  void savePendingRoute(String route, {String? routeType}) {
    if (route == '/' || route.isEmpty) {
      return; // Entry는 저장하지 않음
    }

    _storage.write(_keyPath, route);
    
    // routeType이 제공되지 않으면 자동 결정
    if (routeType == null) {
      if (route.startsWith('/session/')) {
        routeType = 'session';
      } else if (route.startsWith('/team/join')) {
        routeType = 'teamJoin';
      } else if (route.startsWith('/doc/')) {
        routeType = 'doc';
      } else {
        routeType = 'other';
      }
    }
    _storage.write(_keyType, routeType);
  }

  /// pendingRoutePath 읽기
  String? getPendingRoutePath() {
    return _storage.read<String>(_keyPath);
  }

  /// pendingRouteType 읽기
  String? getPendingRouteType() {
    return _storage.read<String>(_keyType);
  }

  /// pendingRoutePath와 Type 모두 읽기
  Map<String, String?> getPendingRoute() {
    return {
      'path': getPendingRoutePath(),
      'type': getPendingRouteType(),
    };
  }

  /// pendingRoutePath clear
  /// 목적지 페이지가 성공적으로 진입했을 때만 호출합니다.
  void clearPendingRoute() {
    _storage.remove(_keyPath);
    _storage.remove(_keyType);
  }

  /// pendingRoutePath 존재 여부 확인
  bool hasPendingRoute() {
    final path = getPendingRoutePath();
    return path != null && path.isNotEmpty && path != '/';
  }
}
