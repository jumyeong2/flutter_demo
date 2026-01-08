import 'package:flutter/material.dart';
import 'package:flutter_demo/ui/page/onboarding/onboarding_page.dart';
import 'package:get/get.dart';
import 'landing_section_layout.dart';

class Description8 extends StatelessWidget {
  const Description8({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth <= 1024;
    final isMobileScreen = screenWidth <= 763;
    final isSmallMobile = screenWidth <= 480;

    return LandingSectionLayout(
      height: isSmallMobile ? 460 : 640,
      backgroundColor: const Color(0xFF0F172A), // 깊은 네이비 배경
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "건강한 팀만이\n유니콘이 될 수 있습니다.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isSmallMobile
                              ? 22
                              : isMobileScreen
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
                        isSmallMobile
                            ? "지금의 껄끄러움이 나중의 소송을 막습니다."
                            : "지금의 껄끄러움이 나중의 소송을 막습니다.\n가장 합리적인 비용으로 팀의 안전장치를 마련하세요.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isSmallMobile
                              ? 13
                              : (isMobileScreen
                                    ? 14
                                    : (isSmallScreen ? 16 : 20)),
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.7),
                          height: 1.6,
                        ),
                      ),
                      SizedBox(height: isSmallMobile ? 30 : 38),
                      // CTA 버튼 - 온보딩 페이지로 연결
                      _CTAButton(isSmallMobile: isSmallMobile),
                      SizedBox(height: isSmallMobile ? 12 : 24),
                      // 하단 안내 문구
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (!isSmallMobile) ...[
                            Icon(
                              Icons.check_circle_outline,
                              color: Colors.white.withValues(alpha: 0.4),
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                          ],
                          Flexible(
                            child: Text(
                              "초기 스타트업 단계에 가장 권장됩니다.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isSmallMobile ? 12 : 14,
                                color: Colors.white.withValues(alpha: 0.4),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
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
  final bool isSmallMobile;
  const _CTAButton({this.isSmallMobile = false});

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
        onTap: () {
          // 온보딩 페이지로 이동
          Get.to(() => const OnboardingPage());
        },
        hoverColor: Colors.transparent,
        splashColor: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicWidth(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(
              horizontal: widget.isSmallMobile ? 24 : 48,
              vertical: widget.isSmallMobile ? 16 : 24,
            ),
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
            child: Text(
              "진단 바로 시작하기",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: widget.isSmallMobile ? 15 : 20,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
              softWrap: false,
              overflow: TextOverflow.visible,
            ),
          ),
        ),
      ),
    );
  }
}
