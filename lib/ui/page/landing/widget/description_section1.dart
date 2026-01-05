import 'package:flutter/material.dart';
import 'package:flutter_demo/ui/page/onboarding/onboarding_page.dart';
import 'package:flutter_demo/ui/page/sample/sample_report.dart';
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
    final sectionHeight = isSmallMobile ? 600.0 : isSmallScreen ? 650.0 : 550.0;
    final horizontalPadding = isSmallMobile ? 20.0 : isMobileScreen ? 40.0 : isSmallScreen ? 60.0 : 100.0;
    
    final badgeHeight = isSmallMobile ? 32.0 : 36.0;
    final badgeIconSize = isSmallMobile ? 14.0 : 16.0;
    final badgeFontSize = isSmallMobile ? 12.0 : 14.0;
    
    final spacingAfterBadge = isSmallMobile ? 20.0 : 48.0;
    
    final mainCopyFontSize = isSmallMobile ? 22.0 : isMobileScreen ? 26.0 : isSmallScreen ? 36.0 : 58.0;
    
    final spacingAfterMainCopy = isSmallMobile ? 24.0 : 32.0;
    
    final subCopyFontSize = isSmallMobile ? 14.0 : isMobileScreen ? 16.0 : isSmallScreen ? 20.0 : 24.0;
    
    final spacingBeforeCTA = isSmallMobile ? 48.0 : 64.0;
    
    final ctaButtonHeight = isSmallMobile ? 56.0 : 60.0;
    final ctaPrimaryFontSize = isSmallMobile ? 15.0 : 16.0;
    final ctaSecondaryFontSize = isSmallMobile ? 14.0 : 15.0;
    final ctaIconSize = isSmallMobile ? 14.0 : 16.0;
    
    final bottomSpacing = isSmallMobile ? 50.0 : 70.0;

    return LandingSectionLayout(
      height: sectionHeight,
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 70),
          // 배지 - 텍스트 너비에 맞춤
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Container(
              height: badgeHeight,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
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
                    '팀 필수 안전장치',
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
              "공동창업은 아이디어보다\n기준이 어긋날 때 무너집니다.",
              style: TextStyle(
                height: 1.4,
                letterSpacing: -1.0,
                fontSize: mainCopyFontSize,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF0F172A),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: spacingAfterMainCopy),
          // 서브 카피 - 방향성 제시
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Text(
              "CoSync는 의견이 아닌\n'기준의 차이'를 먼저 드러냅니다.",
              style: TextStyle(
                height: 1.5,
                fontSize: subCopyFontSize,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF64748B),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: spacingBeforeCTA),
          // CTA 버튼 영역
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: isMobileScreen
                ? Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: ctaButtonHeight,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(() => const OnboardingPage());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0F172A),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "지금 바로 진단 시작",
                                style: TextStyle(
                                  fontSize: ctaPrimaryFontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: ctaIconSize,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: ctaButtonHeight,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(() => const SampleReportPage());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
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
                              const Icon(Icons.description_outlined, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                "결과 화면 미리보기 (무료)",
                                style: TextStyle(
                                  fontSize: ctaSecondaryFontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward_ios, size: 16),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(() => const OnboardingPage());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0F172A),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(0, 60),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "지금 바로 진단 시작",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward_ios, size: 16),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(() => const SampleReportPage());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            minimumSize: const Size(0, 60),
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
                              Icon(Icons.description_outlined, size: 20),
                              const SizedBox(width: 8),
                              const Text(
                                "결과 화면 미리보기 (무료)",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(Icons.arrow_forward_ios, size: 16),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
          SizedBox(height: bottomSpacing),
        ],
      ),
    );
  }
}
