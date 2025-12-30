import 'package:flutter/material.dart';
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
      height: isSmallMobile ? 820 : (isSmallScreen ? 950 : 660),
      backgroundColor: const Color(0xFFF8FAFC),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 80),
          Text(
            "감정 싸움 없이 합의하는 4단계 프로세스",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isSmallMobile
                  ? 18
                  : (isMobileScreen ? 20 : (isSmallScreen ? 24 : 32)),
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isSmallScreen
                ? (isSmallMobile
                      ? "CoSync는 객관적인 \n합의를 이끌어냅니다."
                      : "CoSync는 '중간 다리' 역할을 통해 객관적인 \n합의를 이끌어냅니다.")
                : "CoSync는 '중간 다리' 역할을 통해 객관적인 합의를 이끌어냅니다.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isSmallMobile
                  ? 13
                  : (isMobileScreen ? 14 : (isSmallScreen ? 16 : 18)),
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: isSmallMobile ? 40 : 60),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallMobile ? 0 : (isMobileScreen ? 16 : 30),
            ),
            child: _buildCards(isMobileScreen, isSmallScreen, isSmallMobile),
          ),
        ],
      ),
    );
  }

  Widget _buildCards(
    bool isMobileScreen,
    bool isSmallScreen,
    bool isSmallMobile,
  ) {
    final double iconSize = isSmallMobile ? 18 : (isMobileScreen ? 20 : 32);
    final double iconBackgroundSize = isSmallMobile
        ? 48
        : (isMobileScreen ? 40 : 64);
    final double stepFontSize = isSmallMobile ? 13 : (isMobileScreen ? 14 : 20);
    final double descriptionFontSize = isSmallMobile
        ? 11
        : (isMobileScreen ? 11 : 14);
    final double cardHeight = isSmallMobile
        ? 220
        : (isMobileScreen ? 260 : 320);

    // 소형 모바일: 1열 배치
    if (isSmallMobile) {
      return Column(
        children: [
          _ProcessCard(
            step: "1. 진단 (Sync)",
            description: "꼭 필요한 질문에 각자 답변합니다.",
            icon: Icons.chat_bubble_outline_rounded,
            iconSize: iconSize,
            iconBackgroundSize: iconBackgroundSize,
            stepFontSize: stepFontSize,
            descriptionFontSize: descriptionFontSize,
            isSmallMobile: true,
          ),
          const SizedBox(height: 12),
          _ProcessCard(
            step: "2. 리스크 시각화",
            description: "생각 차이를 데이터로 보여줍니다.",
            icon: Icons.bar_chart_rounded,
            iconSize: iconSize,
            iconBackgroundSize: iconBackgroundSize,
            stepFontSize: stepFontSize,
            descriptionFontSize: descriptionFontSize,
            isSmallMobile: true,
          ),
          const SizedBox(height: 12),
          _ProcessCard(
            step: "3. 시장 표준 제안",
            description: "산업 관행 데이터를 제공합니다.",
            icon: Icons.insights_rounded,
            iconSize: iconSize,
            iconBackgroundSize: iconBackgroundSize,
            stepFontSize: stepFontSize,
            descriptionFontSize: descriptionFontSize,
            isSmallMobile: true,
          ),
          const SizedBox(height: 12),
          _ProcessCard(
            step: "4. Rulebook",
            description: "공동창업자 룰북을 생성합니다.",
            icon: Icons.description_outlined,
            iconSize: iconSize,
            iconBackgroundSize: iconBackgroundSize,
            stepFontSize: stepFontSize,
            descriptionFontSize: descriptionFontSize,
            isSmallMobile: true,
          ),
        ],
      );
    }

    // 1024px 이하: 2x2 배치 (모바일 포함)
    if (isSmallScreen) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: _ProcessCard(
                  step: "1. 진단 (Sync)",
                  description: "단순한 설문이 아닙니다. 예민하지만 꼭 필요한 질문에 각자 답변합니다.",
                  icon: Icons.chat_bubble_outline_rounded,
                  iconSize: iconSize,
                  stepFontSize: stepFontSize,
                  descriptionFontSize: descriptionFontSize,
                  height: cardHeight,
                ),
              ),
              SizedBox(width: isMobileScreen ? 12 : 20),
              Expanded(
                child: _ProcessCard(
                  step: "2. 리스크 시각화",
                  description: "생각이 일치하는 부분과 조율이 필요한 부분을 데이터로 명확히 보여줍니다.",
                  icon: Icons.bar_chart_rounded,
                  iconSize: iconSize,
                  iconBackgroundSize: iconBackgroundSize,
                  stepFontSize: stepFontSize,
                  descriptionFontSize: descriptionFontSize,
                  height: cardHeight,
                ),
              ),
            ],
          ),
          SizedBox(height: isMobileScreen ? 12 : 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: _ProcessCard(
                  step: "3. 시장 표준 제안",
                  description:
                      "정답이 아닌 '참고 프레임'을 제공합니다. 산업 관행과 데이터를 비교하여 감정 소모 없이 선택하세요.",
                  icon: Icons.insights_rounded,
                  iconSize: iconSize,
                  iconBackgroundSize: iconBackgroundSize,
                  stepFontSize: stepFontSize,
                  descriptionFontSize: descriptionFontSize,
                  height: cardHeight,
                ),
              ),
              SizedBox(width: isMobileScreen ? 12 : 20),
              Expanded(
                child: _ProcessCard(
                  step: "4. Rulebook",
                  description: "합의된 내용을 바탕으로 법적 효력을 고려한 공동창업자 룰북을 생성합니다.",
                  icon: Icons.description_outlined,
                  iconSize: iconSize,
                  iconBackgroundSize: iconBackgroundSize,
                  stepFontSize: stepFontSize,
                  descriptionFontSize: descriptionFontSize,
                  height: cardHeight,
                ),
              ),
            ],
          ),
        ],
      );
    }

    // 1024px 초과: 4개 가로 배치
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: _ProcessCard(
            step: "1. 진단 (Sync)",
            description: "단순한 설문이 아닙니다. 예민하지만 꼭 필요한 질문에 각자 답변합니다.",
            icon: Icons.chat_bubble_outline_rounded,
            iconSize: iconSize,
            iconBackgroundSize: iconBackgroundSize,
            stepFontSize: stepFontSize,
            descriptionFontSize: descriptionFontSize,
            height: cardHeight,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _ProcessCard(
            step: "2. 리스크 시각화",
            description: "생각이 일치하는 부분과 조율이 필요한 부분을 데이터로 명확히 보여줍니다.",
            icon: Icons.bar_chart_rounded,
            iconSize: iconSize,
            iconBackgroundSize: iconBackgroundSize,
            stepFontSize: stepFontSize,
            descriptionFontSize: descriptionFontSize,
            height: cardHeight,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _ProcessCard(
            step: "3. 시장 표준 제안",
            description:
                "정답이 아닌 '참고 프레임'을 제공합니다. 산업 관행과 데이터를 비교하여 감정 소모 없이 선택하세요.",
            icon: Icons.insights_rounded,
            iconSize: iconSize,
            iconBackgroundSize: iconBackgroundSize,
            stepFontSize: stepFontSize,
            descriptionFontSize: descriptionFontSize,
            height: cardHeight,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _ProcessCard(
            step: "4. Rulebook",
            description: "합의된 내용을 바탕으로 법적 효력을 고려한 공동창업자 룰북을 생성합니다.",
            icon: Icons.description_outlined,
            iconSize: iconSize,
            iconBackgroundSize: iconBackgroundSize,
            stepFontSize: stepFontSize,
            descriptionFontSize: descriptionFontSize,
            height: cardHeight,
          ),
        ),
      ],
    );
  }
}

class _ProcessCard extends StatefulWidget {
  final String step;
  final String description;
  final IconData icon;
  final double iconSize;
  final double iconBackgroundSize;
  final double stepFontSize;
  final double descriptionFontSize;
  final double height;
  final bool isSmallMobile;

  const _ProcessCard({
    required this.step,
    required this.description,
    required this.icon,
    this.iconSize = 32,
    this.iconBackgroundSize = 64,
    this.stepFontSize = 20,
    this.descriptionFontSize = 14,
    this.height = 320,
    this.isSmallMobile = false,
  });

  @override
  State<_ProcessCard> createState() => _ProcessCardState();
}

class _ProcessCardState extends State<_ProcessCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final cardContent = MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.basic,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        height: widget.isSmallMobile ? null : widget.height,
        width: widget.isSmallMobile ? double.infinity : null,
        constraints: BoxConstraints(
          maxWidth: widget.isSmallMobile ? double.infinity : 400,
        ),
        transform: _isHovered
            ? Matrix4.translationValues(0, -5, 0)
            : Matrix4.identity(),
        padding: EdgeInsets.symmetric(
          horizontal: widget.isSmallMobile
              ? 20
              : (widget.stepFontSize < 16 ? 12 : 24),
          vertical: widget.isSmallMobile
              ? 24
              : (widget.stepFontSize < 16 ? 24 : 40),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: _isHovered ? 0.08 : 0.04),
              blurRadius: _isHovered ? 28 : 20,
              offset: Offset(0, _isHovered ? 15 : 10),
            ),
          ],
        ),
        child: widget.isSmallMobile
            ? Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: widget.iconBackgroundSize,
                    height: widget.iconBackgroundSize,
                    decoration: BoxDecoration(
                      color: _isHovered
                          ? const Color(0xFF1D4ED8)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      widget.icon,
                      color: _isHovered
                          ? Colors.white
                          : const Color(0xFF1D4ED8),
                      size: widget.iconSize,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.step,
                          style: TextStyle(
                            fontSize: widget.stepFontSize,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.description,
                          style: TextStyle(
                            fontSize: widget.descriptionFontSize,
                            color: Colors.black54,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: widget.iconBackgroundSize,
                    height: widget.iconBackgroundSize,
                    decoration: BoxDecoration(
                      color: _isHovered
                          ? const Color(0xFF1D4ED8)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      widget.icon,
                      color: _isHovered
                          ? Colors.white
                          : const Color(0xFF1D4ED8),
                      size: widget.iconSize,
                    ),
                  ),
                  SizedBox(height: widget.stepFontSize < 16 ? 16 : 32),
                  Text(
                    widget.step,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: widget.stepFontSize,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: widget.descriptionFontSize,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
      ),
    );

    return cardContent;
  }
}
