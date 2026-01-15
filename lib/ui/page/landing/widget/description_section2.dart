import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'landing_section_layout.dart';

class Description2 extends StatelessWidget {
  const Description2({super.key});

  @override
  Widget build(BuildContext context) {
    // Responsive logic
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1024;
    final isSmallScreen = screenWidth <= 1024;
    final isMobileScreen = screenWidth <= 763;
    final isSmallMobile = screenWidth <= 480;

    return LandingSectionLayout(
      height: null,
      backgroundColor: Colors.white,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          padding: EdgeInsets.symmetric(
            horizontal: isSmallMobile ? 20 : (isSmallScreen ? 40 : 60),
            vertical: isSmallScreen ? 60 : 100,
          ),
          child: isSmallScreen
              ? Column(
                  children: [
                    _buildLeftColumn(isSmallMobile, isMobileScreen, isSmallScreen, isDesktop)
                        .animate()
                        .fadeIn(duration: 800.ms, delay: 100.ms)
                        .slideY(begin: 0.15, end: 0, duration: 800.ms, delay: 100.ms, curve: Curves.easeOutCubic),
                    const SizedBox(height: 60),
                    _buildRightColumn(isSmallMobile)
                        .animate()
                        .fadeIn(duration: 800.ms, delay: 300.ms)
                        .slideY(begin: 0.15, end: 0, duration: 800.ms, delay: 300.ms, curve: Curves.easeOutCubic),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: _buildLeftColumn(isSmallMobile, isMobileScreen, isSmallScreen, isDesktop)
                            .animate()
                            .fadeIn(duration: 800.ms, delay: 100.ms)
                            .slideY(begin: 0.15, end: 0, duration: 800.ms, delay: 100.ms, curve: Curves.easeOutCubic),
                      ),
                    ),
                    const SizedBox(width: 60),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: _buildRightColumn(isSmallMobile)
                            .animate()
                            .fadeIn(duration: 800.ms, delay: 300.ms)
                            .slideY(begin: 0.15, end: 0, duration: 800.ms, delay: 300.ms, curve: Curves.easeOutCubic),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildLeftColumn(bool isSmallMobile, bool isMobileScreen, bool isSmallScreen, bool isDesktop) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: isSmallMobile ? 0 : 500,
        maxWidth: 600,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chart & Headline Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Donut Chart - 고정 크기
              const SizedBox(
                width: 100,
                height: 100,
                child: Stack(
                  children: [
                    SizedBox.expand(
                      child: CircularProgressIndicator(
                        value: 0.43,
                        strokeWidth: 12,
                        backgroundColor: Color(0xFFF1F5F9), // Slate 100
                        color: Color(0xFF2563EB), // Blue 600
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Center(
                      child: Text(
                        "43%",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0F172A), // Slate 900
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              // Text Header
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "공동창업자 갈등으로\n스타트업 10곳 중 4곳은",
                      style: GoogleFonts.montserrat(
                        fontSize: isSmallMobile
                            ? 18
                            : isMobileScreen
                                ? 22
                                : isSmallScreen
                                    ? 24
                                    : (isDesktop ? 26 : 28),
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF0F172A),
                        height: 1.4,
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 800.ms, delay: 200.ms)
                        .slideY(begin: 0.15, end: 0, duration: 800.ms, delay: 200.ms, curve: Curves.easeOutCubic),
                    Text(
                      "결국 문을 닫거나 쪼개집니다.",
                      style: GoogleFonts.montserrat(
                        fontSize: isSmallMobile
                            ? 18
                            : isMobileScreen
                                ? 22
                                : isSmallScreen
                                    ? 24
                                    : (isDesktop ? 26 : 28),
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFFDC2626), // Red 600
                        height: 1.4,
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 800.ms, delay: 350.ms)
                        .slideY(begin: 0.15, end: 0, duration: 800.ms, delay: 350.ms, curve: Curves.easeOutCubic),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),

          // Quote
          Container(
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: Color(0xFF3B82F6), // Blue 500
                  width: 4,
                ),
              ),
            ),
            padding: const EdgeInsets.only(left: 20, top: 4, bottom: 4),
            child: const Text(
              '"아름다운 이별은 감정이 아닌 구조로 완성됩니다."',
              style: TextStyle(
                fontSize: 20,
                fontStyle: FontStyle.italic,
                color: Color(0xFF475569), // Slate 600
                fontWeight: FontWeight.w500,
              ),
            ),
          )
              .animate()
              .fadeIn(duration: 800.ms, delay: 500.ms)
              .slideY(begin: 0.15, end: 0, duration: 800.ms, delay: 500.ms, curve: Curves.easeOutCubic),
          const SizedBox(height: 24),

          // Description Text
          Text(
            "공동창업자가 떠나야 하는 순간,\n준비되지 않은 이별은 남은 팀원들에게 가장 큰 리스크가 됩니다.\n\n지속 가능한 비즈니스를 위해서는\n합의 과정의 구조화가 반드시 필요합니다.",
            style: GoogleFonts.inter(
              fontSize: 16,
              height: 1.6,
              color: Color(0xFF475569), // Slate 600
            ),
          )
              .animate()
              .fadeIn(duration: 800.ms, delay: 650.ms)
              .slideY(begin: 0.15, end: 0, duration: 800.ms, delay: 650.ms, curve: Curves.easeOutCubic),
          const SizedBox(height: 48),

          // Mission Box
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 32,
                  horizontal: 24,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF), // Blue 50
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFDBEAFE),
                  ), // Blue 100
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      '"그래서 CoSync는 갈등 이후가 아니라,',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2563EB), // Blue 600
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '합의 이전을 구조화합니다."',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2563EB), // Blue 600
                        decoration: TextDecoration.underline,
                        decorationStyle: TextDecorationStyle.wavy,
                        decorationColor: Color(0xFF60A5FA), // Blue 400
                      ),
                    ),
                  ],
                ),
              ),
              // Overlapping Badge
              Positioned(
                top: -14,
                left: 24,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB), // Blue 600
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'DEPARTURE SOLUTION',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          )
              .animate()
              .fadeIn(duration: 800.ms, delay: 800.ms)
              .slideY(begin: 0.15, end: 0, duration: 800.ms, delay: 800.ms, curve: Curves.easeOutCubic),
        ],
      ),
    );
  }

  Widget _buildRightColumn(bool isSmallMobile) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: isSmallMobile ? 0 : 500,
        maxWidth: 600,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC), // Slate 50
          borderRadius: BorderRadius.circular(32),
        ),
        padding: const EdgeInsets.all(8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Image.asset(
            'assets/buyout.png',
            fit: BoxFit.contain,
            width: double.infinity,
            alignment: Alignment.center,
          ),
        ),
      ),
    );
  }
}
