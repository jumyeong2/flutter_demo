import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'landing_section_layout.dart';

class Description4 extends StatelessWidget {
  const Description4({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth <= 1024;
    final isMobileScreen = screenWidth <= 763;
    final isSmallMobile = screenWidth <= 480;

    return LandingSectionLayout(
      height: null,
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 80),
          Text(
            "가장 치명적인 3가지 리스크 해결",
            style: GoogleFonts.montserrat(
              fontSize: isSmallMobile ? 20 : (isSmallScreen ? 24 : 32),
              fontWeight: FontWeight.w900,
            ),
          )
              .animate()
              .fadeIn(duration: 800.ms, delay: 100.ms)
              .slideY(begin: 0.15, end: 0, duration: 800.ms, delay: 100.ms, curve: Curves.easeOutCubic),
          const SizedBox(height: 18),
          Text(
            isSmallScreen
                ? "공동창업팀이 겪는 현실적인 고민들,\n이제 CoSync가 해결해 드립니다."
                : "공동창업팀이 겪는 현실적인 고민들, 이제 CoSync가 해결해 드립니다.",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: isSmallMobile ? 14 : (isSmallScreen ? 16 : 18),
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          )
              .animate()
              .fadeIn(duration: 800.ms, delay: 250.ms)
              .slideY(begin: 0.15, end: 0, duration: 800.ms, delay: 250.ms, curve: Curves.easeOutCubic),
          SizedBox(height: isSmallMobile ? 30 : 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: (isSmallScreen
                ? _buildCardsColumn(isSmallMobile, isMobileScreen, isSmallScreen)
                : _buildCardsRow(isMobileScreen, isSmallScreen))
                .animate()
                .fadeIn(duration: 800.ms, delay: 400.ms)
                .slideY(begin: 0.15, end: 0, duration: 800.ms, delay: 400.ms, curve: Curves.easeOutCubic),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // 가로 배치 (1024px 초과)
  Widget _buildCardsRow(bool isMobileScreen, bool isSmallScreen) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(child: _buildCostCard(false, isMobileScreen, isSmallScreen)),
          const SizedBox(width: 24),
          Flexible(child: _buildInvestmentCard(false, isMobileScreen, isSmallScreen)),
          const SizedBox(width: 24),
          Flexible(child: _buildEmotionCard(false, isMobileScreen, isSmallScreen)),
        ],
      ),
    );
  }

  // 세로 배치 (1024px 이하)
  Widget _buildCardsColumn(bool isSmallMobile, bool isMobileScreenParam, bool isSmallScreenParam) {
      return Column(
      children: [
        _buildCostCard(isSmallMobile, isMobileScreenParam, isSmallScreenParam),
        const SizedBox(height: 24),
        _buildInvestmentCard(isSmallMobile, isMobileScreenParam, isSmallScreenParam),
        const SizedBox(height: 24),
        _buildEmotionCard(isSmallMobile, isMobileScreenParam, isSmallScreenParam),
      ],
    );
  }

  // 비용 절감 카드
  Widget _buildCostCard(bool isSmallMobile, bool isMobileScreen, bool isSmallScreen) {
    return _RiskHoverCard(
      isSmallMobile: isSmallMobile,
      borderColor: Colors.grey.withValues(alpha: 0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF059669).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.savings_outlined,
                  size: isSmallMobile ? 24 : 28,
                  color: const Color(0xFF059669),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '비용 절감',
                style: TextStyle(
                  fontSize: isSmallMobile ? 20 : (isSmallScreen ? 22 : 24),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF059669),
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallMobile ? 20 : 32),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: '주주간 계약서, 전문가에게 바로 맡기면 평균 300만 원입니다. '),
                TextSpan(
                  text: 'CoSync 연 구독',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF059669),
                  ),
                ),
                const TextSpan(text: '으로 쟁점을 정리하면 비용이 획기적으로 줍니다.'),
              ],
            ),
            style: TextStyle(
              fontSize: isSmallMobile ? 14 : 16,
              color: Colors.black87,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '법무비 절감 효과',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF059669),
                ),
              ),
              Text(
                '-90%',
                style: TextStyle(
                  fontSize: isSmallMobile ? 24 : 28,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF059669),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: 0.9,
              backgroundColor: const Color(0xFF059669).withValues(alpha: 0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF059669)),
              minHeight: 12,
            ),
          ),
        ],
      ),
      );
    }

  // 투자 대비 카드
  Widget _buildInvestmentCard(bool isSmallMobile, bool isMobileScreen, bool isSmallScreen) {
    return _RiskHoverCard(
      isSmallMobile: isSmallMobile,
      borderColor: Colors.grey.withValues(alpha: 0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF1D4ED8).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.trending_up_rounded,
                  size: isSmallMobile ? 24 : 28,
                  color: const Color(0xFF1D4ED8),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '투자 대비',
                style: TextStyle(
                  fontSize: isSmallMobile ? 20 : (isSmallScreen ? 22 : 24),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1D4ED8),
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallMobile ? 20 : 32),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: '투자 심사(Due Diligence)에서 '),
                TextSpan(
                  text: '지분 리스크는 탈락 1순위',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1D4ED8),
                  ),
                ),
                const TextSpan(text: '입니다. 필수 항목을 미리 점검하세요.'),
              ],
            ),
            style: TextStyle(
              fontSize: isSmallMobile ? 14 : 16,
              color: Colors.black87,
            ),
          ),
          const Spacer(),
          SizedBox(height: isSmallMobile ? 20 : 32),
          _buildCheckItem(const Color(0xFF1D4ED8), '주주명부(Cap Table)', isSmallMobile),
          const SizedBox(height: 12),
          _buildCheckItem(const Color(0xFF1D4ED8), 'IP 양도 계약', isSmallMobile),
          const SizedBox(height: 12),
          _buildCheckItem(const Color(0xFF1D4ED8), '이탈 방지(Vesting)', isSmallMobile),
        ],
      ),
    );
  }

  // 감정 보호 카드
  Widget _buildEmotionCard(bool isSmallMobile, bool isMobileScreen, bool isSmallScreen) {
    return _RiskHoverCard(
      isSmallMobile: isSmallMobile,
      borderColor: Colors.grey.withValues(alpha: 0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF7C3AED).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.handshake_outlined,
                  size: isSmallMobile ? 24 : 28,
                  color: const Color(0xFF7C3AED),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '감정 보호',
                style: TextStyle(
                  fontSize: isSmallMobile ? 20 : (isSmallScreen ? 22 : 24),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF7C3AED),
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallMobile ? 20 : 32),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: '데이터 기반 의사결정으로 '),
                TextSpan(
                  text: '팀의 신뢰를 지키세요',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF7C3AED),
                  ),
                ),
                const TextSpan(text: '. 객관적 기준이 감정적 갈등을 줄입니다.'),
              ],
            ),
            style: TextStyle(
              fontSize: isSmallMobile ? 14 : 16,
              color: Colors.black87,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF7C3AED).withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '의사결정 갈등 발생 시',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7C3AED).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'CoSync 해결',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF7C3AED),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '"CEO에게 최종 결정권 부여"',
                  style: TextStyle(
                    fontSize: isSmallMobile ? 15 : 17,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckItem(Color color, String text, bool isSmallMobile) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
        ),
          child: Icon(Icons.check, color: color, size: isSmallMobile ? 12 : 14),
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(
            fontSize: isSmallMobile ? 13 : 15,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }
}

class _RiskHoverCard extends StatefulWidget {
  final Widget child;
  final Color borderColor;
  final bool isSmallMobile;

  const _RiskHoverCard({
    required this.child,
    required this.borderColor,
    required this.isSmallMobile,
  });

  @override
  State<_RiskHoverCard> createState() => _RiskHoverCardState();
}

class _RiskHoverCardState extends State<_RiskHoverCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.basic,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(widget.isSmallMobile ? 24 : 32),
        height: widget.isSmallMobile ? 320 : 380,
        width: widget.isSmallMobile ? double.infinity : 350,
        transform: _isHovered
            ? Matrix4.translationValues(0, -5, 0)
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: widget.borderColor),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: _isHovered ? 0.08 : 0.0),
              blurRadius: _isHovered ? 28 : 0,
              offset: Offset(0, _isHovered ? 15 : 0),
            ),
          ],
        ),
        child: widget.child,
      ),
    );
  }
}
