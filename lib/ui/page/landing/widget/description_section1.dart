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
      height: isSmallMobile ? 570 : (isMobileScreen ? 700 : 740),
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: isSmallMobile ? 40 : 70),
          Container(
            height: isSmallMobile ? 32 : 36,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.blue[100]!, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified_user_outlined,
                  color: const Color(0xFF1D4ED8),
                  size: isSmallMobile ? 14 : 16,
                ),
                const SizedBox(width: 8),
                Text(
                  '투자 유치(Due Diligence) 대비 필수 안전장치',
                  style: TextStyle(
                    color: const Color(0xFF1D4ED8),
                    fontSize: isSmallMobile ? 12 : 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: isSmallMobile ? 30 : 48),
          Text(
            "팀이 터지기 전에 막아주는\n공동창업 리스크 관리 솔루션",
            style: TextStyle(
              height: 1.3,
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
          const SizedBox(height: 8),
          Text(
            "'CoSync Rulebook'",
            style: TextStyle(
              fontSize: isSmallMobile
                  ? 20
                  : isMobileScreen
                  ? 24
                  : isSmallScreen
                  ? 24
                  : 46,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF1D4ED8),
            ),
          ),
          SizedBox(height: isSmallMobile ? 30 : 40),
          Text(
            '"우리 사이에 무슨 계약서야?"',
            style: TextStyle(
              fontSize: isSmallMobile ? 14 : 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "안전한 합의로 바꿔드립니다.",
            style: TextStyle(
              fontSize: isSmallMobile ? 18 : (isSmallScreen ? 20 : 24),
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D4ED8),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "변호사를 만나기 전에, 팀 리스크를 수치로 사전 점검하세요.",
            style: TextStyle(
              fontSize: isSmallMobile ? 13 : 16,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isSmallMobile ? 40 : 60),
          isMobileScreen
              ? Column(
                  children: [
                    SizedBox(
                      width: isSmallMobile ? double.infinity : 400,
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
                              "질문 3개로 Rulebook 체험하기 (무료)",
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
                      width: isSmallMobile ? double.infinity : 400,
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
                              "샘플 리포트 보기",
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
                            "질문 3개로 Rulebook 체험하기 (무료)",
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
                            "샘플 리포트 보기",
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
