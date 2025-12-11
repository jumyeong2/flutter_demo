# Overview

## 제품 컨셉
- 공동창업자 간 리스크(지분, R&R, 이탈 등)를 데이터 기반으로 조율하는 웹/모바일 대응 Flutter 앱
- Landing → Onboarding → Agreement → Report 시나리오로, 사용자가 3개 핵심 질문을 체험하고 합의서를 생성하는 데모 흐름 제공

## 사용자 여정 (데모 기준)
- Landing: 영입 문구와 CTA(무료 체험, 샘플 리포트) 제공
- Onboarding: 3단계 체험 소개와 CTA를 통해 합의서 작성 화면으로 이동
- Agreement: 각 질문에 대해 양측 의견을 비교, 합의안 작성, AI 제안으로 신속 조율
- Final modal: 합의 항목이 모두 확정되면 이메일로 PDF 발송을 안내하는 모달 출력
- Sample Report: 샘플 리포트 화면을 별도 라우트로 제공

## 주요 화면/파일
- `lib/ui/page/landing`: 랜딩 섹션(히어로, 프로세스, 데모, 레이더, CTA/푸터)
- `lib/ui/page/onboarding`: 체험 안내 타임라인 및 CTA
- `lib/ui/page/agreement`: 합의 항목 입력/확정, AI 제안, 진행도 표시
- `lib/ui/page/sample`: 샘플 리포트 뷰어
