import 'package:flutter/material.dart';
import 'landing_section_layout.dart';

class Description6 extends StatelessWidget {
  const Description6({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth <= 1024;
    final isMobileScreen = screenWidth <= 763;
    final isSmallMobile = screenWidth <= 480;

    // 반응형 패딩 설정
    double horizontalPadding;
    if (isSmallMobile) {
      horizontalPadding = 0;
    } else if (isMobileScreen) {
      horizontalPadding = 20;
    } else if (isSmallScreen) {
      horizontalPadding = 40;
    } else {
      horizontalPadding = 100;
    }

    return LandingSectionLayout(
      height: null,
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 80),
          Text(
            "데이터가 증명하는 리스크 감소 효과",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isSmallMobile ? 20 : (isSmallScreen ? 24 : 32),
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "막연한 불안감을 명확한 수치로 관리하세요.",
            style: TextStyle(
              fontSize: isSmallMobile ? 14 : 18,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: isSmallMobile ? 40 : 80),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: isSmallScreen
                ? _buildVerticalLayout(isSmallMobile)
              : _buildHorizontalLayout(),
        ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // 가로 배치 (1024px 초과)
  Widget _buildHorizontalLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(flex: 1, child: _buildMockup(false)),
        const SizedBox(width: 80),
        Flexible(flex: 1, child: _buildTextContent(isSmallMobile: false)),
      ],
    );
  }

  // 세로 배치 (1024px 이하)
  Widget _buildVerticalLayout(bool isSmallMobile) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildMockup(isSmallMobile),
          SizedBox(height: isSmallMobile ? 40 : 60),
          _buildTextContent(isSmallScreen: true, isSmallMobile: isSmallMobile),
        ],
      ),
    );
  }

  Widget _buildMockup(bool isSmallMobile) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 500,
        maxHeight: isSmallMobile ? 320 : 400,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 40,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFF2563EB),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'LIVE DATA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: isSmallMobile ? 16 : 24,
                  horizontal: isSmallMobile ? 20 : 36,
                ),
                child: Column(
      children: [
                    SizedBox(height: isSmallMobile ? 0 : 10),
                    Center(
                      child: Icon(
                        Icons.monitor_heart_outlined,
                        size: isSmallMobile ? 50 : 80,
                        color: const Color(0xFF93C5FD),
                      ),
                    ),
                    SizedBox(height: isSmallMobile ? 12 : 20),
                    _StabilityHoverItem(
                      emoji: "💰",
                      label: "보상/지분 합의",
                      status: "안정적 (95점)",
                      color: const Color(0xFF15803D),
                      targetBgColor: const Color(0xFFF0FDF4),
                      isSmallMobile: isSmallMobile,
                    ),
                    const SizedBox(height: 8),
                    _StabilityHoverItem(
                      emoji: "🚪",
                      label: "Exit / 이탈 조건",
                      status: "위험 (32점)",
                      color: const Color(0xFFDC2626),
                      targetBgColor: const Color(0xFFFEF2F2),
                      isSmallMobile: isSmallMobile,
                    ),
                    const SizedBox(height: 8),
                    _StabilityHoverItem(
                      emoji: "🎯",
                      label: "비전 일치도",
                      status: "보통 (70점)",
                      color: const Color(0xFFD97706),
                      targetBgColor: const Color(0xFFFFFBEB),
          isSmallMobile: isSmallMobile,
        ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
      ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextContent({
    bool isSmallScreen = false,
    bool isSmallMobile = false,
  }) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: 500,
      ),
      child: Column(
      crossAxisAlignment: isSmallScreen
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
          const SizedBox(height: 40),
          const Text(
            "RISK RADAR",
              style: TextStyle(
              fontSize: 16,
                fontWeight: FontWeight.w800,
              color: Color(0xFF2563EB),
                letterSpacing: 1.2,
              ),
            ),
          const SizedBox(height: 16),
        Text(
            "팀의 안정성을 점수로 관리하세요.",
          textAlign: isSmallScreen ? TextAlign.center : TextAlign.start,
          style: TextStyle(
              fontSize: isSmallMobile ? 20 : (isSmallScreen ? 24 : 32),
            fontWeight: FontWeight.w900,
            color: const Color(0xFF1E293B),
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
        Text(
            "Team Stability Score",
          style: TextStyle(
              fontSize: isSmallMobile ? 18 : 24,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            "'그냥 느낌이 좀 쎄한데?'라는 감을 데이터로 확인시켜 드립니다.\n5가지 핵심 영역을 시각화하여 어디서 갈등이 터질지\n미리 예측하고 방어합니다.",
            textAlign: isSmallScreen ? TextAlign.center : TextAlign.start,
            style: TextStyle(
              fontSize: isSmallMobile ? 13 : (isSmallScreen ? 14 : 16),
              color: const Color(0xFF64748B),
              height: 1.6,
            ),
            ),
        ],
      ),
    );
  }
}

class _StabilityHoverItem extends StatefulWidget {
  final String emoji;
  final String label;
  final String status;
  final Color color;
  final Color targetBgColor;
  final bool isSmallMobile;

  const _StabilityHoverItem({
    required this.emoji,
    required this.label,
    required this.status,
    required this.color,
    required this.targetBgColor,
    required this.isSmallMobile,
  });

  @override
  State<_StabilityHoverItem> createState() => _StabilityHoverItemState();
}

class _StabilityHoverItemState extends State<_StabilityHoverItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: widget.isSmallMobile ? 12 : 20,
          vertical: widget.isSmallMobile ? 12 : 16,
        ),
            decoration: BoxDecoration(
              color: _isHovered
              ? widget.targetBgColor
              : Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
            ),
        child: Row(
          children: [
            Text(
              widget.emoji,
              style: TextStyle(fontSize: widget.isSmallMobile ? 16 : 20),
          ),
            const SizedBox(width: 8),
            Text(
              widget.label,
              style: TextStyle(
                fontSize: widget.isSmallMobile ? 13 : 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1E293B),
              ),
            ),
            const Spacer(),
            Text(
              widget.status,
            style: TextStyle(
                fontSize: widget.isSmallMobile ? 13 : 16,
                fontWeight: FontWeight.bold,
                color: widget.color,
            ),
          ),
        ],
        ),
      ),
    );
  }
}

