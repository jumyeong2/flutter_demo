import 'package:flutter/material.dart';
import 'landing_section_layout.dart';

class Description7 extends StatelessWidget {
  const Description7({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth <= 1024;
    final isMobileScreen = screenWidth <= 763;

    return LandingSectionLayout(
      height: 560,
      backgroundColor: const Color(0xFF0F172A), // 깊은 네이비 배경
      child: Stack(
        children: [
          // 배경 패턴 효과 (간단한 그리드 또는 그라데이션으로 대체)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.5,
                  colors: [
                    const Color(0xFF1E293B).withValues(alpha: 0.5),
                    const Color(0xFF0F172A),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "건강한 팀만이\n유니콘이 될 수 있습니다.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isMobileScreen
                        ? 24
                        : isSmallScreen
                        ? 32
                        : 46,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.2,
                    letterSpacing: -1.0,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "지금의 껄끄러움이 나중의 소송을 막습니다.\n가장 합리적인 비용으로 팀의 안전장치를 마련하세요.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isMobileScreen
                        ? 14
                        : isSmallScreen
                        ? 16
                        : 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.7),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 38),
                // CTA 버튼
                const _CTAButton(),
                const SizedBox(height: 24),
                // 하단 안내 문구
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: Colors.white.withValues(alpha: 0.4),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "초기 스타트업(법인 설립 전) 단계에 가장 권장됩니다.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.4),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CTAButton extends StatefulWidget {
  const _CTAButton();

  @override
  State<_CTAButton> createState() => _CTAButtonState();
}

class _CTAButtonState extends State<_CTAButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final hoverColor = const Color(0xFF2563EB);
    final baseColor = const Color.fromARGB(255, 32, 73, 186); // 더 진한 파란색

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: () {},
        hoverColor: Colors.transparent,
        splashColor: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
          decoration: BoxDecoration(
            color: _isHovered ? hoverColor : baseColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: (_isHovered ? hoverColor : baseColor).withValues(
                  alpha: 0.3,
                ),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Text(
            "질문 3개로 Rulebook 체험하기 (무료)",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
