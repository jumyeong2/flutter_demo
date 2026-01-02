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
      height: isSmallMobile ? 800 : (isSmallScreen ? 850 : 740),
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 70),
          // 배지 - 텍스트 너비에 맞춤
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallMobile
                  ? 20
                  : (isMobileScreen ? 40 : (isSmallScreen ? 60 : 100)),
            ),
            child: Container(
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
                    '팀 필수 안전장치',
                    style: TextStyle(
                      color: const Color(0xFF64748B),
                      fontSize: isSmallMobile ? 12 : 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: isSmallMobile ? 20 : 48),
          // 히어로 문장 - 주인공
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallMobile
                  ? 20
                  : (isMobileScreen ? 40 : (isSmallScreen ? 60 : 100)),
            ),
            child: Text(
              "공동창업은 아이디어보다\n합의에서 먼저 흔들립니다.",
              style: TextStyle(
                height: 1.4,
                letterSpacing: -1.0,
                fontSize: isSmallMobile
                    ? 22
                    : isMobileScreen
                    ? 26
                    : isSmallScreen
                    ? 36
                    : 58,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF0F172A),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: isSmallMobile ? 20 : 40),
          // 통계 인포그래픽
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallMobile
                  ? 20
                  : (isMobileScreen ? 40 : (isSmallScreen ? 60 : 100)),
            ),
            child: _buildStatisticCard(
              isSmallMobile,
              isMobileScreen,
              isSmallScreen,
            ),
          ),
          SizedBox(height: isSmallMobile ? 40 : 60),
          // 솔루션 정의 - 한 덩어리
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallMobile
                  ? 20
                  : (isMobileScreen ? 40 : (isSmallScreen ? 60 : 100)),
            ),
            child: Column(
              children: [
                Text(
                  "공동창업 합의를 구조화하는 룰북 솔루션",
                  style: TextStyle(
                    fontSize: isSmallMobile ? 14 : (isSmallScreen ? 18 : 24),
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
                        ? 22
                        : isMobileScreen
                        ? 26
                        : isSmallScreen
                        ? 36
                        : 58,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF1D4ED8),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: isSmallMobile ? 48 : 120),
          // 행동 유도 - CTA 바로 위
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallMobile
                  ? 20
                  : (isMobileScreen ? 40 : (isSmallScreen ? 60 : 100)),
            ),
            child: Text(
              "팀이 흔들리기 전에, 지금 기준부터 맞추세요.",
              style: TextStyle(
                fontSize: isSmallMobile ? 14 : 16,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF64748B),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: isSmallMobile ? 12 : 24),
          // 버튼 영역 - 텍스트 너비에 맞춤
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallMobile
                  ? 20
                  : (isMobileScreen ? 40 : (isSmallScreen ? 60 : 100)),
            ),
            child: isMobileScreen
                ? Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
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
                              Flexible(
                                child: Text(
                                  "지금 참여 · 베타 한정 30% 체험가",
                                  style: TextStyle(
                                    fontSize: isSmallMobile ? 13 : 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
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
                        width: double.infinity,
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.description_outlined, size: 20),
                              SizedBox(width: 8),
                              Text(
                                "결과 화면 미리보기 (무료)",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward_ios, size: 16),
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
                              SizedBox(width: 8),
                              Text(
                                "결과 화면 미리보기 (무료)",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward_ios, size: 16),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
          SizedBox(height: isSmallMobile ? 24 : 32),
          // 주요 키워드 나열
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallMobile
                  ? 20
                  : (isMobileScreen ? 40 : (isSmallScreen ? 60 : 100)),
            ),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: isSmallMobile ? 12 : 24,
              runSpacing: isSmallMobile ? 8 : 12,
              children: [
                _buildKeywordItem("지분율", isSmallMobile),
                _buildKeywordItem("기여도", isSmallMobile),
                _buildKeywordItem("권한", isSmallMobile),
                _buildKeywordItem("엑시트", isSmallMobile),
              ],
            ),
          ),
          SizedBox(height: isSmallMobile ? 50 : 70),
        ],
      ),
    );
  }

  Widget _buildStatisticCard(
    bool isSmallMobile,
    bool isMobileScreen,
    bool isSmallScreen,
  ) {
    final percentageSize = isSmallMobile
        ? 26.0
        : (isMobileScreen ? 30.0 : (isSmallScreen ? 38.0 : 48.0));
    final textSize = isSmallMobile
        ? 11.0
        : (isMobileScreen ? 12.0 : (isSmallScreen ? 13.0 : 16.0));
    // 오른쪽 텍스트 높이에 맞춰 아이콘 크기 계산
    final spacing = isSmallMobile ? 4.0 : 6.0;
    final iconSize = percentageSize + spacing + (textSize * 1.4 * 3);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isSmallMobile ? 12 : (isMobileScreen ? 16 : 24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 왼쪽 아이콘
          Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 두 사람 실루엣
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: iconSize * 0.35,
                      color: const Color(0xFF475569),
                    ),
                    Icon(
                      Icons.person_outline,
                      size: iconSize * 0.35,
                      color: const Color(0xFF475569),
                    ),
                  ],
                ),
                // 번개 아이콘 (중앙, 약간 위로)
                Positioned(
                  top: iconSize * 0.15,
                  child: Icon(
                    Icons.bolt,
                    size: iconSize * 0.3,
                    color: const Color(0xFF60A5FA),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: isSmallMobile ? 16 : 24),
          // 오른쪽 텍스트
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "43%",
                style: TextStyle(
                  fontSize: percentageSize,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF1D4ED8),
                  height: 1.0,
                ),
              ),
              SizedBox(height: isSmallMobile ? 4 : 6),
              Text(
                "공동창업자 갈등으로\n스타트업 10곳 중 4곳은\n바이아웃을 경험합니다.",
                style: TextStyle(
                  fontSize: textSize,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF475569),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeywordItem(String text, bool isSmallMobile) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.check_circle,
          size: isSmallMobile ? 14 : 16,
          color: const Color(0xFF2563EB), // Primary Blue
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: isSmallMobile ? 13 : 15,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF475569), // Slate 600
          ),
        ),
      ],
    );
  }
}
