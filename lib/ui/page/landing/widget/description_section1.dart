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

    return LandingSectionLayout(
      height: isSmallMobile ? 570 : (isSmallScreen ? 650 : 740),
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: isSmallMobile ? 40 : 70),
          Container(
            height: isSmallMobile ? 32 : 36,
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
                  size: isSmallMobile ? 14 : 16,
                ),
                const SizedBox(width: 8),
                Text(
                  '투자 유치(Due Diligence) 대비 필수 안전장치',
                  style: TextStyle(
                    color: const Color(0xFF64748B),
                    fontSize: isSmallMobile ? 12 : 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: isSmallMobile ? 30 : 48),
          // 히어로 문장 - 주인공
          Text(
            "공동창업은 아이디어보다\n합의에서 먼저 흔들립니다.",
            style: TextStyle(
              height: 1.5,
              letterSpacing: -1.4,
              fontSize: isSmallMobile
                  ? 24
                  : isMobileScreen
                  ? 28
                  : isSmallScreen
                  ? 38
                  : 58,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF0F172A),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isSmallMobile ? 20 : 32),
          // 솔루션 정의 - 한 덩어리
          Column(
            children: [
              Text(
                "공동창업 합의를 구조화하는 룰북 솔루션",
                style: TextStyle(
                  fontSize: isSmallMobile ? 16 : (isSmallScreen ? 20 : 24),
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                "CoSync Rulebook",
                style: TextStyle(
                  fontSize: isSmallMobile
                      ? 24
                      : isMobileScreen
                      ? 28
                      : isSmallScreen
                      ? 38
                      : 58,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF1D4ED8),
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallMobile ? 40 : 60),
          // 행동 유도 - CTA 바로 위
          Text(
            "팀이 흔들리기 전에, 지금 기준부터 맞추세요.",
            style: TextStyle(
              fontSize: isSmallMobile ? 14 : 16,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF64748B),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isSmallMobile ? 20 : 24),
          isMobileScreen
              ? Column(
                  children: [
                    SizedBox(
                      width: isSmallMobile ? 300 : 400,
                      height: 56,
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
                              "지금 참여 · 베타 한정 30% 체험가",
                              style: TextStyle(
                                fontSize: isSmallMobile ? 14 : 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: isSmallMobile ? 14 : 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: isSmallMobile ? 300 : 400,
                      height: 56,
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
                          children: [
                            Icon(Icons.description_outlined, size: 20),
                            SizedBox(width: 8),
                            Text(
                              "결과 화면 미리보기 (무료)",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Get.to(() => const OnboardingPage());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F172A),
                        foregroundColor: Colors.white,
                        fixedSize: const Size(400, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "우리 팀 Rulebook 만들기",
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
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        Get.to(() => const SampleReportPage());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        minimumSize: const Size(200, 60),
                        elevation: 0,
                        side: BorderSide(color: Colors.grey[300]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.description_outlined, size: 20),
                          SizedBox(width: 8),
                          Text(
                            "결과 화면 미리보기 (무료)",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
