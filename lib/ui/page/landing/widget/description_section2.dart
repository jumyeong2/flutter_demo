import 'package:flutter/material.dart';
import 'landing_section_layout.dart';

class Description2 extends StatelessWidget {
  const Description2({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth <= 1024;
    final isSmallMobile = screenWidth <= 480;

    // 패딩 값 정의
    final horizontalPadding = isSmallMobile ? 20.0 : isSmallScreen ? 40.0 : 100.0;

    return LandingSectionLayout(
      height: null,
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 80),
          // THE REALITY 섹션
          _buildRealitySection(isSmallMobile, isSmallScreen, horizontalPadding),
        ],
      ),
    );
  }

  // THE REALITY 섹션
  Widget _buildRealitySection(bool isSmallMobile, bool isSmallScreen, double horizontalPadding) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // THE REALITY 헤더
          Text(
            'THE REALITY',
            style: TextStyle(
              fontSize: isSmallMobile ? 12 : (isSmallScreen ? 14 : 16),
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1D4ED8),
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: isSmallMobile ? 16 : 24),
          // 43% 통계
          Text(
            '43%',
            style: TextStyle(
              fontSize: isSmallMobile ? 48 : (isSmallScreen ? 64 : 80),
              fontWeight: FontWeight.w900,
              color: const Color(0xFF1E293B),
              height: 1.0,
            ),
          ),
          SizedBox(height: isSmallMobile ? 24 : 32),
          // 첫 번째 문단
          Text.rich(
            TextSpan(
              style: TextStyle(
                fontSize: isSmallMobile ? 16 : (isSmallScreen ? 18 : 20),
                fontWeight: FontWeight.w500,
                color: Colors.black,
                height: 1.6,
              ),
              children: [
                const TextSpan(text: '공동창업자 갈등으로 스타트업 10곳 중 4곳은 '),
                TextSpan(
                  text: '결국 문을 닫거나 쪼개집니다.',
                  style: TextStyle(
                    backgroundColor: Colors.red.withOpacity(0.2),
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isSmallMobile ? 32 : 40),
          // 두 번째 문단 (인용구)
          Text.rich(
            TextSpan(
              style: TextStyle(
                fontSize: isSmallMobile ? 16 : (isSmallScreen ? 18 : 20),
                fontWeight: FontWeight.w500,
                color: Colors.black,
                height: 1.6,
              ),
              children: [
                const TextSpan(text: '이는 개인의 성격 문제가 아니라,\n'),
                const TextSpan(
                  text: '구조의 문제',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: '입니다.'),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isSmallMobile ? 32 : 40),
          // 세 번째 문단
          Text.rich(
            TextSpan(
              style: TextStyle(
                fontSize: isSmallMobile ? 16 : (isSmallScreen ? 18 : 20),
                fontWeight: FontWeight.w400,
                color: Colors.black,
                height: 1.6,
              ),
              children: [
                const TextSpan(
                  text: '우리는 수많은 팀이 \'좋은 관계\'로 시작했지만, 불편한 질문을 미룬 대가로,\n팀이 무너지는 것을 목격했습니다.\n',
                ),
                const TextSpan(
                  text: '서로 믿지 못해서가 아니라,\n',
                ),
                const TextSpan(
                  text: '합의하는 법',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const TextSpan(text: '을 몰랐기 때문입니다.'),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isSmallMobile ? 32 : 40),
          // 네 번째 문단 (솔루션)
          Text.rich(
            TextSpan(
              style: TextStyle(
                fontSize: isSmallMobile ? 16 : (isSmallScreen ? 18 : 20),
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1D4ED8),
                height: 1.6,
              ),
              children: [
                const TextSpan(text: '그래서 CoSync는 합의 이후가 아니라,\n'),
                TextSpan(
                  text: '합의 이전을 구조화합니다.',
                  style: TextStyle(
                    backgroundColor: const Color(0xFF1D4ED8).withOpacity(0.2),
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
