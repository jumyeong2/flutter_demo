# Setup & Run

## 요구 사항
- Flutter SDK 3.10+ (Dart 포함)
- Firebase 프로젝트 키: `lib/firebase_options.dart`에 각 플랫폼용 설정이 포함되어 있어 추가 설정 없이 로컬 실행 가능(실제 서비스 연동 시 자신의 Firebase 구성으로 재생성 필요)
- iOS/Android 플랫폼 빌드 시 각 플랫폼별 개발 툴체인 준비(Xcode/Android SDK)

## 설치
```bash
flutter pub get
```

## 실행
- 웹: `flutter run -d chrome`
- iOS 시뮬레이터: `flutter run -d ios`
- Android 에뮬레이터/디바이스: `flutter run -d android`

## 구조 탐색
- 진입점: `lib/main.dart` (Firebase 초기화, 테마, 홈 화면 설정)
- 주요 화면: `lib/ui/page/landing`, `lib/ui/page/onboarding`, `lib/ui/page/agreement`, `lib/ui/page/sample`
- 모델: `lib/data/model/agreement_item.dart`

## Firebase 재설정이 필요한 경우
1. Firebase 콘솔에서 새 프로젝트 생성 후 `firebase_core` 가이드에 따라 CLI로 각 플랫폼 앱 등록
2. `flutterfire configure` 실행해 `lib/firebase_options.dart`를 재생성
3. 필요 시 Firestore/Storage 보안 규칙을 환경에 맞게 업데이트
