# Feature Flows

## Landing → Onboarding → Agreement
- Landing (`lib/ui/page/landing`): 히어로/프로세스/데모/레이더/룰북 섹션으로 구성. CTA는 무료 체험(`startTrial`)과 샘플 리포트 이동.
- Onboarding (`lib/ui/page/onboarding`): 3단계 체험 설명(질문 진단 → AI 분석 → 리포트 발급)과 CTA로 Agreement 이동.
- Agreement (`lib/ui/page/agreement`): 질문 카드 리스트를 통해 양측 의견 비교, 합의안 작성, 진행도/합의 상태 관리.

## Agreement 화면 동작 상세
- 데이터 모델: `AgreementItem`(카테고리, 질문, 설명, User A/B 의견, 합의안, 상태, AI 제안, 로딩 여부)
- 초기 항목: R&R, 베스팅, 이탈 지분 처리 3개 예시가 `AgreementController.items`에 미리 로드됨.
- 상태 전환:
  - User A 입력 변경 시 User B와 동일하면 `resolved`, 아니면 `conflict`.
  - 합의안 작성 후 "조항 확정" 클릭 시 `resolved`로 전환되고 진행도 업데이트.
  - "수정 하기"로 다시 `conflict` 상태로 복귀 가능.
- AI 제안: `triggerAI`가 로딩 후 `aiSuggestion`을 합의안 텍스트로 채우는 시뮬레이션(실제 API 호출 없음).
- 최종 모달: 모든 항목이 `resolved`면 "합의서 생성" 버튼 활성화 → 이메일 입력 후 발송 알림 표시.

## 샘플 리포트
- `lib/ui/page/sample/sample_report.dart`: 합의 현황 요약, 항목별 상세, 면책 문구를 포함한 정적 리포트 뷰.

## 반응형 UI
- `ResponsiveLayout.isMobile/Tablet/Desktop` 기준으로 카드/그리드/버튼 배치가 변경됨(Agreement, Report, Landing 일부 요소에서 사용).
