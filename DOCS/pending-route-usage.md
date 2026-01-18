# PendingRoutePath 사용 가이드

## 개요

`PendingRouteService`는 딥링크 복귀를 위한 pendingRoutePath를 관리하는 서비스입니다. GetStorage를 사용하여 앱 재시작 후에도 유지됩니다.

## 사용 방법

### 1. 서비스 초기화

`main.dart`에서 이미 초기화되어 있습니다:

```dart
Get.put(PendingRouteService());
```

### 2. AuthGuard에서 자동 저장

`AuthGuard`가 미로그인 사용자를 감지하면 자동으로 pendingRoutePath를 저장합니다:

```dart
// AuthGuard 내부에서 자동 처리
if (route != null && route != Routes.entry) {
  pendingRouteService.savePendingRoute(route);
}
```

### 3. 로그인/회원가입 성공 후 복귀

로그인 또는 회원가입 성공 시 pendingRoutePath로 복귀합니다:

```dart
// LoginPage 예시
final pendingRouteService = Get.find<PendingRouteService>();
final pendingRoutePath = pendingRouteService.getPendingRoutePath();

if (pendingRoutePath != null && pendingRoutePath.isNotEmpty) {
  Get.offAllNamed(pendingRoutePath); // Guard가 실행되어 검증
} else {
  Get.offAllNamed(Routes.entry); // Entry에서 자동 분기
}
```

### 4. 페이지 진입 성공 시 clear

각 페이지의 `onInit` 또는 `onReady`에서 성공적으로 진입했을 때만 clear합니다:

```dart
import 'package:get/get.dart';
import '../../../service/pending_route_service.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyPageController());
    return Scaffold(...);
  }
}

class MyPageController extends GetxController {
  final _pendingRouteService = Get.find<PendingRouteService>();

  @override
  void onReady() {
    super.onReady();
    // 페이지가 성공적으로 진입했을 때만 clear
    _pendingRouteService.clearPendingRoute();
  }
}
```

또는 StatefulWidget의 경우:

```dart
class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  void initState() {
    super.initState();
    // 페이지가 성공적으로 진입했을 때만 clear
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final pendingRouteService = Get.find<PendingRouteService>();
      pendingRouteService.clearPendingRoute();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(...);
  }
}
```

## 주의사항

1. **clear 시점**: 목적지 페이지가 실제로 진입 성공했을 때만 clear합니다.
2. **Entry('/')는 저장하지 않음**: 무한 루프 방지를 위해 Entry 경로는 저장하지 않습니다.
3. **Guard 실패 시**: Guard가 실패하여 다른 페이지로 리다이렉트되면 clear하지 않습니다 (다시 시도 가능).

## API 참고

### PendingRouteService 메서드

- `savePendingRoute(String route, {String? routeType})`: pendingRoutePath 저장
- `getPendingRoutePath()`: pendingRoutePath 읽기
- `getPendingRouteType()`: pendingRouteType 읽기
- `getPendingRoute()`: path와 type 모두 읽기
- `clearPendingRoute()`: pendingRoutePath clear
- `hasPendingRoute()`: pendingRoutePath 존재 여부 확인
