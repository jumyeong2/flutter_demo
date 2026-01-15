import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_demo/ui/page/landing/widget/email_signup_modal.dart';
import 'package:flutter_demo/main.dart' as main_app;
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
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isSmallMobile ? 320 : (isMobileScreen ? 400 : (isSmallScreen ? 600 : 800)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "건강한 팀만이\n유니콘이 될 수 있습니다.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
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
                  style: GoogleFonts.inter(
                    fontSize: isSmallMobile
                        ? 13
                        : (isMobileScreen ? 14 : (isSmallScreen ? 16 : 20)),
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.7),
                    height: 1.6,
                  ),
                ),
                SizedBox(height: isSmallMobile ? 30 : 38),
                // CTA 버튼 - 텍스트 너비에 맞춤
                LayoutBuilder(
                    builder: (context, constraints) {
                      // "가장 합리적인 비용으로 팀의 안전장치를 마련하세요." 텍스트 너비 측정
                      final textPainter = TextPainter(
                        text: TextSpan(
                          text: "가장 합리적인 비용으로 팀의 안전장치를 마련하세요.",
                          style: TextStyle(
                            fontSize: isSmallMobile
                                ? 13
                                : (isMobileScreen ? 14 : (isSmallScreen ? 16 : 20)),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        textDirection: TextDirection.ltr,
                      );
                      textPainter.layout();
                      final textWidth = textPainter.size.width;
                      
                      return _CTAButton(
                        isSmallMobile: isSmallMobile,
                        width: textWidth,
                      )
                          .animate()
                          .fadeIn(duration: 800.ms, delay: 400.ms)
                          .slideY(begin: 0.15, end: 0, duration: 800.ms, delay: 400.ms, curve: Curves.easeOutCubic);
                    },
                  ),
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
  final double? width;
  const _CTAButton({this.isSmallMobile = false, this.width});

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
          main_app.MyApp.analytics.logEvent(name: 'lead_modal_open');
          showDialog(
            context: context,
            builder: (context) => const EmailSignupModal(),
          );
        },
        hoverColor: Colors.transparent,
        splashColor: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: widget.width,
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
              "베타 출시 알림 + 30% 쿠폰",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: widget.isSmallMobile ? 15 : 20,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
