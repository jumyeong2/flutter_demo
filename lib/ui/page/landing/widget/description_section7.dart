import 'package:flutter/material.dart';
import 'landing_section_layout.dart';

class Description7 extends StatelessWidget {
  const Description7({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth <= 1180;
    final isMediumScreen = screenWidth <= 763;
    final isSmallMobile = screenWidth <= 480;

    // 패딩 값 정의 (수정하기 쉽도록 변수로 분리)
    final double horizontalPadding = isSmallMobile ? 0 : 20;

    return LandingSectionLayout(
      height: isSmallMobile ? 1100 : (isSmallScreen ? 1650 : 900),
      backgroundColor: const Color(0xFFF8FAFC),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: isSmallMobile ? 40 : 80),
          child: isSmallScreen
              ? _buildVerticalLayout(isMediumScreen, isSmallMobile)
              : _buildHorizontalLayout(),
        ),
      ),
    );
  }

  // 가로 배치 (1024px 초과)
  Widget _buildHorizontalLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: _buildTextContent(),
          ),
        ),
        const SizedBox(width: 80),
        // Mockup은 고정 크기 유지
        SizedBox(width: 580, child: _buildMockup()),
      ],
    );
  }

  // 세로 배치 (1024px 이하)
  Widget _buildVerticalLayout(bool isMediumScreen, bool isSmallMobile) {
    return Column(
      children: [
        _buildTextContent(
          isSmallScreen: true,
          isMediumScreen: isMediumScreen,
          isSmallMobile: isSmallMobile,
        ),
        SizedBox(height: isSmallMobile ? 40 : 80),
        isSmallMobile
            ? FittedBox(fit: BoxFit.scaleDown, child: _buildMockup())
            : _buildMockup(),
        SizedBox(height: isSmallMobile ? 60 : 80),
        _DownloadButton(isSmallMobile: isSmallMobile),
      ],
    );
  }

  Widget _buildTextContent({
    bool isSmallScreen = false,
    bool isMediumScreen = false,
    bool isSmallMobile = false,
  }) {
    return Column(
      crossAxisAlignment: isSmallScreen
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: isSmallScreen
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            if (!isSmallMobile) ...[
              Container(width: 24, height: 2, color: const Color(0xFF2563EB)),
              const SizedBox(width: 8),
            ],
            Text(
              "FINAL OUTPUT",
              style: TextStyle(
                fontSize: isSmallMobile ? 12 : 14,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF2563EB),
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          "말뿐인 약속은 잊혀집니다.\n'Rulebook'으로 기록하세요.",
          textAlign: isSmallScreen ? TextAlign.center : TextAlign.start,
          style: TextStyle(
            fontSize: isSmallMobile ? 20 : (isMediumScreen ? 24 : 32),
            fontWeight: FontWeight.w900,
            color: const Color(0xFF1E293B),
            height: 1.3,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          isSmallMobile
              ? "합의된 내용을 바탕으로 우리 팀만의 헌법,\n[Rulebook.pdf]를 생성해 드립니다."
              : "동업계약서 쓰기엔 너무 딱딱하고, 말로만 하기엔 불안하신가요?\nCoSync는 우리 팀만의 헌법,\n[Rulebook.pdf]를 생성해 드립니다.",
          textAlign: isSmallScreen ? TextAlign.center : TextAlign.start,
          style: TextStyle(
            fontSize: isSmallMobile ? 13 : 16,
            color: const Color(0xFF64748B),
            height: 1.6,
          ),
        ),
        const SizedBox(height: 40),
        _buildListItem("Mission & Vision", isSmallMobile),
        _buildListItem("R&R (역할과 책임)", isSmallMobile),
        _buildListItem("Compensation (지분)", isSmallMobile),
        _buildListItem("Decision Making", isSmallMobile),
        _buildListItem("Exit Plan (이탈 조건)", isSmallMobile),
        if (!isSmallScreen) ...[
          SizedBox(height: isSmallMobile ? 20 : 30),
          _DownloadButton(isSmallMobile: isSmallMobile),
        ],
      ],
    );
  }

  Widget _buildListItem(String text, bool isSmallMobile) {
    return Container(
      width: isSmallMobile ? double.infinity : 560,
      margin: const EdgeInsets.only(bottom: 6),
      padding: EdgeInsets.symmetric(
        horizontal: isSmallMobile ? 12 : 20,
        vertical: isSmallMobile ? 12 : 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            color: const Color(0xFF2563EB),
            size: isSmallMobile ? 16 : 20,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              fontSize: isSmallMobile ? 13 : 15,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF334155),
            ),
          ),
        ],
      ),
    );
  }
}

class _DownloadButton extends StatefulWidget {
  final bool isSmallMobile;
  const _DownloadButton({this.isSmallMobile = false});

  @override
  State<_DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<_DownloadButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final activeColor = const Color(0xFF2563EB);
    final idleColor = const Color(0xFF1E293B);

    return InkWell(
      onTap: () {},
      onHover: (value) => setState(() => _isHovered = value),
      hoverColor: Colors.transparent,
      borderRadius: BorderRadius.circular(32),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _isHovered
                  ? const Color.fromARGB(255, 221, 240, 255)
                  : Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.file_download_outlined,
              color: _isHovered ? activeColor : idleColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 20),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontSize: widget.isSmallMobile ? 16 : 14,
              fontWeight: FontWeight.w800,
              color: _isHovered ? activeColor : idleColor,
              fontFamily: 'Pretendard',
            ),
            child: Text(
              widget.isSmallMobile
                  ? "Rulebook 샘플(PDF)"
                  : "Rulebook 샘플 다운로드 (PDF)",
            ),
          ),
        ],
      ),
    );
  }
}

extension on Description7 {
  Widget _buildMockup() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // 태블릿 프레임
        Container(
          width: 580,
          height: 680,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF475569), // 태블릿 베젤 색상
            borderRadius: BorderRadius.circular(40),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  // 문서 본문 내용
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 상단 헤더
                      Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Co-founder Rulebook",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Serif',
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Ver 1.0 | 2024.05.20",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.blue[300],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.description_outlined,
                              color: Colors.grey[300],
                              size: 32,
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1, indent: 32, endIndent: 32),
                      // 본문 섹션 1
                      _buildDocSection(
                        "CHAPTER 3. EQUITY & VESTING",
                        "제3조 (지분 및 베스팅)",
                        "공동창업자 김민준, 이강인은 총 4년의 베스팅 기간을 설정하며, 1년의 클리프 기간을 둔다. 이탈 시 회수 조건은...",
                      ),
                      // 본문 섹션 2
                      _buildDocSection(
                        "CHAPTER 5. EXIT PLAN",
                        "제5조 (이탈 조건)",
                        "자발적 퇴사의 경우 보유 지분의 50%를 액면가로 회사에 반환하며, 이는 남은 창업자들의 리스크를 헷지하기 위함이다...",
                      ),
                    ],
                  ),
                  // 하단 서명 영역 (Stack으로 고정)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(32, 40, 32, 24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withValues(alpha: 0),
                            Colors.white.withValues(alpha: 0.9),
                            Colors.white,
                          ],
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildInitialGroup(),
                          const Spacer(),
                          Stack(
                            alignment: Alignment.bottomCenter,
                            clipBehavior: Clip.none,
                            children: [
                              // 상태 문구
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.green[300],
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "DIGITAL SIGNATURE VERIFIED",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey[400],
                                      letterSpacing: 0.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              // 서명 박스 (텍스트 중앙 위에 배치)
                              Positioned(
                                bottom: 22,
                                child: Container(
                                  width: 120,
                                  height: 58,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.grey.withValues(alpha: 0.4),
                                    ),
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
          ),
        ),
        // Lawyer-friendly 뱃지
        Positioned(
          top: -20,
          right: 45,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD600), // 노란색 뱃지
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Row(
              children: [
                Icon(Icons.star, color: Color(0xFF1E293B), size: 16),
                SizedBox(width: 6),
                Text(
                  "Lawyer-friendly",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDocSection(String chapter, String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            chapter,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: Colors.blue[600],
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF64748B),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialGroup() {
    return SizedBox(
      width: 54,
      height: 32,
      child: Stack(
        children: [
          _buildInitialCircle("김"),
          Positioned(left: 20, child: _buildInitialCircle("이")),
        ],
      ),
    );
  }

  Widget _buildInitialCircle(String initial) {
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Text(
        initial,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: Color(0xFF2563EB),
        ),
      ),
    );
  }
}
