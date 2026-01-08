import 'package:flutter/material.dart';
import 'package:flutter_demo/main.dart';
import 'package:flutter_demo/ui/page/sample/sample_report.dart';
import 'package:flutter_demo/ui/page/onboarding/onboarding_page.dart';
import 'package:get/get.dart';
import 'landing_section_layout.dart';

class Description1 extends StatelessWidget {
  const Description1({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth <= 1024;
    final isMobileScreen = screenWidth <= 763;
    final isSmallMobile = screenWidth <= 480;

    // 반응형 값 정의 (각 요소별로 수정 가능)
    final isDesktop = screenWidth > 1440;
    final horizontalPadding = isSmallMobile
        ? 20.0
        : isMobileScreen
        ? 40.0
        : isSmallScreen
        ? 60.0
        : (isDesktop ? 200.0 : 120.0);

    final badgeHeight = isSmallMobile ? 32.0 : 36.0;
    final badgeIconSize = isSmallMobile ? 14.0 : 16.0;
    final badgeFontSize = isSmallMobile ? 12.0 : 14.0;

    final spacingAfterBadge = isSmallMobile ? 20.0 : (isDesktop ? 32.0 : 48.0);

    // 데스크탑에서 제목 크기 줄이기
    final mainCopyFontSize = isSmallMobile
        ? 22.0
        : isMobileScreen
        ? 26.0
        : isSmallScreen
        ? 36.0
        : (isDesktop ? 42.0 : 48.0);

    final spacingAfterMainCopy = isSmallMobile
        ? 24.0
        : (isDesktop ? 24.0 : 32.0);

    final subCopyFontSize = isSmallMobile
        ? 14.0
        : isMobileScreen
        ? 16.0
        : isSmallScreen
        ? 20.0
        : (isDesktop ? 18.0 : 22.0);

    final spacingBeforeCTA = isSmallMobile ? 48.0 : (isDesktop ? 80.0 : 96.0);

    final ctaButtonHeight = isSmallMobile ? 56.0 : 60.0;
    final ctaPrimaryFontSize = isSmallMobile ? 15.0 : 16.0;
    final ctaIconSize = isSmallMobile ? 14.0 : 16.0;

    // 데스크탑에서 최대 너비 제한
    final maxContentWidth = isDesktop ? 1200.0 : double.infinity;

    return LandingSectionLayout(
      height: null,
      backgroundColor: const Color(0xFFF8FAFC),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxContentWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: isDesktop ? 100 : 80),
              // 배지 - 텍스트 너비에 맞춤
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Container(
                  height: badgeHeight,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified_user_outlined,
                        color: const Color(0xFF64748B),
                        size: badgeIconSize,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '창업 팀 필수 안전장치',
                        style: TextStyle(
                          color: const Color(0xFF64748B),
                          fontSize: badgeFontSize,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: spacingAfterBadge),
              // 메인 카피 - 화면의 시각적 중심
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Text(
                  "공동창업 팀이 흔들리는 순간은\n대부분 '사업 문제'가 아니라,\n'기준'의 차이에서 시작됩니다",
                  style: TextStyle(
                    height: 1.3,
                    letterSpacing: isDesktop ? -0.8 : -1.0,
                    fontSize: mainCopyFontSize,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF0F172A),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: spacingAfterMainCopy),
              // 서브 카피 - 포지셔닝
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Text(
                  "CoSync는 합의를 계약으로 옮길 수 있도록\n구조화하는 공동창업자 전용 인프라입니다.",
                  style: TextStyle(
                    height: 1.5,
                    fontSize: subCopyFontSize,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF64748B),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: isSmallMobile ? 40 : 60),
              // Before/After 2컬럼
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: isSmallScreen
                    ? _buildBeforeAfterVertical(isSmallMobile)
                    : _buildBeforeAfterHorizontal(isDesktop),
              ),
              SizedBox(height: spacingBeforeCTA),
              // CTA 버튼 영역 - 온보딩 페이지로 연결
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: isMobileScreen
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: SizedBox(
                              width: 150,
                              height: ctaButtonHeight,
                              child: ElevatedButton(
                                onPressed: () {
                                  // 온보딩 페이지로 이동
                                  Get.to(() => const OnboardingPage());
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0F172A),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        "진단 바로 시작하기",
                                        style: TextStyle(
                                          fontSize: isSmallMobile ? 12 : 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: isSmallMobile ? 12 : 14,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: SizedBox(
                              width: 150,
                              height: ctaButtonHeight,
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.to(() => const SampleReportPage());
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  elevation: 0,
                                  side: BorderSide(color: Colors.grey[300]!),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        "결과 화면 미리보기",
                                        style: TextStyle(
                                          fontSize: isSmallMobile ? 13 : 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: isSmallMobile ? 12 : 14,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          SizedBox(
                            width: isDesktop ? 480 : 500,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: () {
                                // 온보딩 페이지로 이동
                                Get.to(() => const OnboardingPage());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0F172A),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      "진단 바로 시작하기",
                                      style: TextStyle(
                                        fontSize: ctaPrimaryFontSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: ctaIconSize,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: isDesktop ? 16 : 12),
                          SizedBox(
                            width: isDesktop ? 480 : 500,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: () {
                                Get.to(() => const SampleReportPage());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                padding: EdgeInsets.zero,
                                elevation: 0,
                                side: BorderSide(color: Colors.grey[300]!),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      "결과 화면 미리보기",
                                      style: TextStyle(
                                        fontSize: ctaPrimaryFontSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: ctaIconSize,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
              SizedBox(height: isDesktop ? 100 : 80),
            ],
          ),
        ),
      ),
    );
  }

  // Before/After 세로 배치 (모바일)
  Widget _buildBeforeAfterVertical(bool isSmallMobile) {
    return Column(
      children: [
        _buildBeforeColumn(isSmallMobile),
        SizedBox(height: isSmallMobile ? 24 : 32),
        Icon(
          Icons.arrow_downward,
          size: isSmallMobile ? 32 : 40,
          color: Colors.grey,
        ),
        SizedBox(height: isSmallMobile ? 24 : 32),
        _buildAfterColumn(isSmallMobile),
      ],
    );
  }

  // Before/After 가로 배치 (데스크톱)
  Widget _buildBeforeAfterHorizontal(bool isDesktop) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: isDesktop ? 5 : 1,
          child: _buildBeforeColumn(false, isDesktop),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isDesktop ? 32 : 24),
          child: Icon(
            Icons.arrow_forward,
            size: isDesktop ? 40 : 48,
            color: Colors.grey,
          ),
        ),
        Expanded(
          flex: isDesktop ? 5 : 1,
          child: _buildAfterColumn(false, isDesktop),
        ),
      ],
    );
  }

  // Before 컬럼
  Widget _buildBeforeColumn(bool isSmallMobile, [bool isDesktop = false]) {
    return Container(
      padding: EdgeInsets.all(isSmallMobile ? 20 : (isDesktop ? 28 : 24)),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(isDesktop ? 16 : 12),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        boxShadow: isDesktop
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: isSmallMobile ? 20 : 24,
                color: const Color(0xFF64748B),
              ),
              SizedBox(width: isSmallMobile ? 8 : 12),
              Text(
                'Before',
                style: TextStyle(
                  fontSize: isSmallMobile ? 16 : 18,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallMobile ? 16 : 20),
          _buildBeforeAfterItem('지분은 나중에 정하자', isSmallMobile),
          SizedBox(height: isSmallMobile ? 12 : 16),
          _buildBeforeAfterItem('역할은 상황 봐서 정하자', isSmallMobile),
          SizedBox(height: isSmallMobile ? 12 : 16),
          _buildBeforeAfterItem('누가 나가면? 그건 생각 안 해봤다', isSmallMobile),
        ],
      ),
    );
  }

  // After 컬럼
  Widget _buildAfterColumn(bool isSmallMobile, [bool isDesktop = false]) {
    return Container(
      padding: EdgeInsets.all(isSmallMobile ? 20 : (isDesktop ? 28 : 24)),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(isDesktop ? 16 : 12),
        border: Border.all(color: const Color(0xFF86EFAC), width: 1),
        boxShadow: isDesktop
            ? [
                BoxShadow(
                  color: const Color(0xFF16A34A).withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.check_circle,
                size: isSmallMobile ? 20 : 24,
                color: const Color(0xFF16A34A),
              ),
              SizedBox(width: isSmallMobile ? 8 : 12),
              Text(
                'After',
                style: TextStyle(
                  fontSize: isSmallMobile ? 16 : 18,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF16A34A),
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallMobile ? 16 : 20),
          _buildBeforeAfterItem('지분 기준 문장으로 확정', isSmallMobile, isAfter: true),
          SizedBox(height: isSmallMobile ? 12 : 16),
          _buildBeforeAfterItem('역할·책임 범위 명시', isSmallMobile, isAfter: true),
          SizedBox(height: isSmallMobile ? 12 : 16),
          _buildBeforeAfterItem('이탈 시 조건 합의 완료', isSmallMobile, isAfter: true),
        ],
      ),
    );
  }

  // Before/After 아이템
  Widget _buildBeforeAfterItem(
    String text,
    bool isSmallMobile, {
    bool isAfter = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          isAfter ? Icons.check : Icons.close,
          size: isSmallMobile ? 16 : 18,
          color: isAfter ? const Color(0xFF16A34A) : const Color(0xFF64748B),
        ),
        SizedBox(width: isSmallMobile ? 8 : 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: isSmallMobile ? 14 : 15,
              fontWeight: FontWeight.w500,
              color: isAfter
                  ? const Color(0xFF166534)
                  : const Color(0xFF475569),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
