# Architecture

## 기술 스택
- Flutter 3.10+ (Material 3), Dart
- 상태 관리 및 네비게이션: GetX (`GetMaterialApp`, `Get.put`, `Get.to`, `Get.back`)
- Backend 연동: `firebase_core` 초기화 (`lib/firebase_options.dart`), `cloud_firestore` 의존성 포함(현재 데모에서 직접 호출은 없음)
- 반응형 유틸: `ResponsiveLayout`(모바일/태블릿/데스크톱 분기)

## 앱 구동 흐름
- `lib/main.dart`: Firebase 초기화 후 `MyApp` 실행, `GetMaterialApp`으로 전역 스크롤 동작/테마 설정, 홈은 `LandingPage`
- 라우팅: 명시적 네임드 라우트 없이 GetX의 `Get.to`/`Get.back`으로 화면 이동
- 폰트: 테마에서 `fontFamily: 'Pretendard'` 지정(현재 pubspec에 폰트 등록은 없으므로 시스템/웹 기본 폰트로 fallback)

## 코드 구조
- `lib/ui/page/*`: 화면 단위 폴더 (landing, onboarding, agreement, sample)
- `lib/ui/page/<page>/widgets`: 페이지 전용 섹션 컴포넌트
- `lib/ui/widgets`: 공용 위젯(`ResponsiveLayout`)
- `lib/data/model`: 뷰모델/도메인 모델(`AgreementItem`)
- `lib/service`: 현재 비어 있음(향후 API/Firebase 호출 계층으로 확장 가능)

## 상태 관리
- `LandingController`: 데모 스텝/메뉴 토글, CTA 처리(`startTrial` → Onboarding 이동)
- `OnboardingController`: 뒤로가기, 체험 시작 CTA(`Get.to(AgreementPage)`)
- `AgreementController`:
  - `items`(`RxList<AgreementItem>`): 합의 항목 상태 보관. `status`는 `conflict`/`resolved`.
  - 입력 핸들러: `handleUserAChange`, `handleConsensusChange`, `markAsResolved`
  - AI 시뮬레이션: `triggerAI`가 `aiSuggestion`을 합의안에 채우고 로딩 상태 토글
  - 이메일 전송: 단순 유효성 체크 후 `emailSent` 플래그 변경
  - `progress` 게터: 확정된 항목 비율로 진행도 표시

## 반응형/스타일 포인트
- `ResponsiveLayout`: width 기준 분기(모바일 <800, 태블릿 800~1100, 데스크톱 ≥1100). Agreement/Report에서 레이아웃 분기 처리.
- 색상/스타일: 인디고/블루 계열로 일관된 CTA/포인트 컬러, 박스 그림자/라운딩으로 카드형 UI 구성.
