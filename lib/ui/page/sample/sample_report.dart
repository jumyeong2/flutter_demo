import 'dart:ui'; // For ImageFilter

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_demo/ui/page/landing/widget/email_signup_modal.dart';

// --- 0. Toss Design System Color Palette ---
class _AppColors {
  // Primary (Toss Blue)
  static const blue600 = Color(0xFF3182F6); // Toss Primary Blue

  static const blue50 = Color(0xFFEFF6FF);
  static const blue100 = Color(0xFFDBEAFE);

  // Background (Cool Gray Tone)
  static const bgToss = Color(0xFFF2F4F6); // Toss Background

  // Text (Dark Navy/Gray instead of pure black)
  static const textPrimary = Color(0xFF191F28); // Toss Text Primary
  static const textSub = Color(0xFF8B95A1); // Toss Text Sub

  // Slate
  static const slate900 = Color(0xFF0F172A);
  static const slate50 = Color(0xFFF8FAFC);
  static const slate400 = Color(0xFF94A3B8);
  static const slate500 = Color(0xFF64748B);
  static const slate700 = Color(0xFF334155);

  // Gray Scale
  static const gray50 = Color(0xFFF9FAFB);
  static const gray100 = Color(0xFFF3F4F6);
  static const gray200 = Color(0xFFE5E7EB);

  static const gray400 = Color(0xFF9CA3AF);

  static const gray600 = Color(0xFF4B5563);
  static const gray700 = Color(0xFF374151);

  static const gray900 = Color(0xFF111827);

  // Green
  static const green50 = Color(0xFFF0FDF4);

  static const green600 = Color(0xFF16A34A);

  // Orange
  static const orange50 = Color(0xFFFFF7ED);

  static const orange500 = Color(0xFFF97316);

  // Purple
  static const purple50 = Color(0xFFFAF5FF);

  static const purple600 = Color(0xFF9333EA);
}

// --- 1. Data Models ---
class _Topic {
  final int id;
  final String title;
  final String questionTitle;
  final String questionDesc;
  final String opinionA;
  final String opinionB;
  final String reference;
  final String decision;

  _Topic({
    required this.id,
    required this.title,
    required this.questionTitle,
    required this.questionDesc,
    required this.opinionA,
    required this.opinionB,
    required this.reference,
    required this.decision,
  });
}

// --- 2. Main Page Widget ---
class SampleReportPage extends StatefulWidget {
  const SampleReportPage({super.key});

  @override
  State<SampleReportPage> createState() => _SampleReportPageState();
}

class _SampleReportPageState extends State<SampleReportPage>
    with TickerProviderStateMixin {
  // State
  bool _isModalOpen = false;
  final ScrollController _scrollController = ScrollController();
  
  // Topic별 GlobalKey 맵
  final Map<int, GlobalKey> _topicKeys = {};

  // Constants
  static const String _ctaLabel = "사전신청하고 혜택 받기";
  static const String _ctaSubLabel = "오픈 시 우선 안내드립니다";
  static const String _stageLabel = "아이디어/예비창업(Pre-ceed)";

  final List<_Topic> _topics = [
    _Topic(
      id: 1,
      title: "결론 내리는 룰 (기한/권한/근거)",
      questionTitle: "의견이 갈릴 때, 언제까지 논의하고 누가 확정하며 어떤 근거로 결론을 내리나요?",
      questionDesc: "기한/확정자/근거/기록이 없으면 결정이 늦어지고 불만이 쌓입니다.",
      opinionA: "속도를 위해 최종 확정자는 CEO가 맡는 게 좋습니다.",
      opinionB: "기술/보안 관련은 CTO 동의가 필요하고, 나머지는 CEO가 확정하는 게 맞습니다.",
      reference:
          "초기 팀은 교착(Deadlock) 방지가 최우선입니다. 최종 확정자(캐스팅보트)를 두되, 기술/보안 같은 예외 영역을 함께 정의하는 방식이 흔합니다.",
      decision:
          "의견 불일치 시 48시간 내 논의 후 CEO(PM)가 최종 확정한다. 전환율(+10%) 또는 2주 잔존율(+5%) 중 1개 이상 개선이 예상되면 실행하며, 교착 시 외부 멘토 1회 자문 후 재결정한다.",
    ),
    _Topic(
      id: 2,
      title: "자금 조정 룰 (트리거/우선순위/기한)",
      questionTitle: "어떤 신호(잔고/런웨이)에서 무엇을 어떤 순서로 얼마까지 줄이고, 누가 언제 확정하나요?",
      questionDesc: "트리거와 조정 순서가 없으면 비용/급여에서 갈등이 납니다.",
      opinionA: "런웨이 기준을 먼저 두고, 마케팅부터 줄이는 게 빠릅니다.",
      opinionB: "외주/고정비가 크면 마케팅보다 외주부터 끊어야 합니다. 보호 항목도 필요합니다.",
      reference: "비용 조정은 ‘트리거(수치) → 우선순위(순서) → 보호 항목’이 세트로 있어야 팀 갈등이 줄어듭니다.",
      decision:
          "잔고 3,000만원 이하 또는 런웨이 3개월 이하 시 비용 조정을 발동한다. 1순위는 마케팅 50% 축소, 2순위는 외주 신규 발주 중단(유지 상한 월 200만원)으로 조정한다. 최종 확정은 CEO(재무 산출)+CTO(외주 범위)가 72시간 내 진행한다. 서버/보안 비용은 보호하며, 런웨이 6개월 회복 시 단계적으로 복구한다.",
    ),
    _Topic(
      id: 3,
      title: "이탈 정리 원칙 (인수인계/권한/정산)",
      questionTitle: "공동창업자 1명 이탈 시, 인수인계/권한/지분/채무/데이터를 언제까지 어떤 원칙으로 정리하나요?",
      questionDesc: "이 질문은 감정이 아니라 체크리스트입니다. 핵심 영역을 빠짐없이 확정합니다.",
      opinionA: "이탈 후에도 업무 공백이 생기지 않도록 인수인계를 최우선으로 해야 합니다.",
      opinionB: "권한/데이터 차단이 즉시 되지 않으면 리스크가 큽니다. 정산 기한도 짧게 잡아야 합니다.",
      reference: "실무에선 ‘인수인계(기간/산출물) + 권한 차단(즉시) + 정산 기한(짧게)’을 최소 세트로 둡니다.",
      decision:
          "공동창업자 이탈 시 2주 내 인수인계를 완료하고(인수인계 문서/레포 정리/계정 목록 포함), 권한은 이탈일 즉시 차단한다. 지분/정산은 베스팅 기준을 적용하고 Bad Leaver는 액면가 회수 원칙으로 7일 내 정리한다. 고객 데이터 접근은 즉시 차단하며 소스/디자인/도메인 등 자산은 회사 귀속으로 한다.",
    ),
  ];

  @override
  void initState() {
    super.initState();
    // 각 Topic에 대한 GlobalKey 초기화
    for (var topic in _topics) {
      _topicKeys[topic.id] = GlobalKey();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleRegister(String location) {
    setState(() => _isModalOpen = false);
    // EmailSignupModal 열기
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const EmailSignupModal(),
    );
  }

  void _scrollToTopic(int id) {
    final key = _topicKeys[id];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.1, // 상단에서 10% 위치에 정렬
      );
    } else {
      // Fallback: Snackbar (key가 아직 준비되지 않은 경우)
      Get.snackbar(
        "Navigation",
        "Topic 0$id로 이동합니다.",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery를 사용하여 정확한 화면 크기 가져오기
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;

    // 반응형 브레이크포인트
    final isMobile = screenWidth < 640;
    final isTablet = screenWidth >= 640 && screenWidth < 1024;
    final isDesktop = screenWidth >= 1024;
    final isSmallMobile = screenWidth < 400;

    return Scaffold(
      backgroundColor: _AppColors.bgToss, // TDS Background
      body: Stack(
        children: [
          // --- Layer 1: Main Scrollable Content ---
          Column(
            children: [
              // 1-1. Sticky Header
              _buildStickyHeader(
                isDesktop: isDesktop,
                isMobile: isMobile,
                isSmallMobile: isSmallMobile,
                screenWidth: screenWidth,
              ),

              // 1-2. Scroll Body
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: _isModalOpen
                      ? const NeverScrollableScrollPhysics()
                      : const BouncingScrollPhysics(),
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 60),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: isDesktop
                              ? 768
                              : (isTablet ? 700 : screenWidth),
                        ), // max-w-3xl on desktop, full width on mobile
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isSmallMobile
                                ? 16
                                : isMobile
                                ? 20
                                : isTablet
                                ? 24
                                : 32,
                            vertical: isDesktop ? 40 : (isMobile ? 16 : 24),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // A. Context
                              _RevealAnimation(
                                delay: 100,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    _buildSectionLabel(
                                      "A. 예시 팀 컨텍스트",
                                      isMobile: isMobile,
                                    ),
                                    _buildContextCard(
                                      isDesktop: isDesktop,
                                      isMobile: isMobile,
                                      isSmallMobile: isSmallMobile,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 32),

                              // B. Summary
                              _RevealAnimation(
                                delay: 300,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    _buildSectionLabel(
                                      "B. 합의 현황 요약",
                                      isMobile: isMobile,
                                    ),
                                    _buildSummaryCard(
                                      isDesktop: isDesktop,
                                      isMobile: isMobile,
                                      isSmallMobile: isSmallMobile,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 32),

                              // C. Topics
                              _RevealAnimation(
                                delay: 500,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    _buildSectionLabel(
                                      "C. Topic 01~03 (합의 결과)",
                                      isMobile: isMobile,
                                    ),
                                    _buildTableOfContents(
                                      isDesktop: isDesktop,
                                      isMobile: isMobile,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 32),
                              ..._topics.asMap().entries.map(
                                (entry) => _RevealAnimation(
                                  delay: 700 + (entry.key * 200),
                                  child: _buildTopicCard(
                                    entry.value,
                                    isDesktop: isDesktop,
                                    isMobile: isMobile,
                                    isSmallMobile: isSmallMobile,
                                    key: _topicKeys[entry.value.id],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 32),

                              // D. Footer Area
                              _RevealAnimation(
                                delay: 1300,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    _buildSectionLabel(
                                      "D. 면책 + 사전신청 CTA",
                                      isMobile: isMobile,
                                    ),
                                    _buildDisclaimer(
                                      isDesktop: isDesktop,
                                      isMobile: isMobile,
                                    ),
                                    _buildFooterSection(
                                      isMobile: isMobile,
                                      isSmallMobile: isSmallMobile,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // --- Layer 2: Watermark (Ignore Pointer) ---
          // 임시로 완전히 비활성화
          // Positioned.fill(
          //   child: IgnorePointer(
          //     child: _buildWatermark(),
          //   ),
          // ),

          // --- Layer 3: Sticky Bottom CTA (Mobile & Tablet) ---
          // Removed as per request to use inline footer style on all screens

          // --- Layer 4: Custom Modal Overlay ---
          if (_isModalOpen)
            Positioned.fill(
              child: Stack(
                children: [
                  // Backdrop
                  GestureDetector(
                    onTap: () => setState(() => _isModalOpen = false),
                    child: Container(
                      // [FIX] withOpacity -> withValues
                      color: Colors.black.withValues(alpha: 0.6),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                        child: Container(color: Colors.transparent),
                      ),
                    ),
                  ),
                  // Modal Content
                  Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: isSmallMobile ? 16 : 20,
                      ),
                      constraints: BoxConstraints(
                        maxWidth: isSmallMobile
                            ? double.infinity
                            : isMobile
                            ? 380
                            : 400,
                      ),
                      padding: EdgeInsets.all(
                        isSmallMobile
                            ? 20
                            : isMobile
                            ? 24
                            : 28,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          28,
                        ), // TDS: More rounded
                        boxShadow: [
                          // TDS: Soft shadow
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 32,
                            spreadRadius: 0,
                            offset: const Offset(0, 8),
                          ),
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 16,
                            spreadRadius: 0,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () => setState(() => _isModalOpen = false),
                              child: const Icon(
                                Icons.close,
                                color: _AppColors.gray400,
                              ),
                            ),
                          ),
                          Container(
                            width: isSmallMobile ? 44 : 48,
                            height: isSmallMobile ? 44 : 48,
                            decoration: const BoxDecoration(
                              color: _AppColors.blue100,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.lock,
                              color: _AppColors.blue600,
                              size: isSmallMobile ? 20 : 24,
                            ),
                          ),
                          SizedBox(height: isSmallMobile ? 12 : 16),
                          Text(
                            "상세 분석 데이터가 궁금하신가요?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: isSmallMobile
                                  ? 18
                                  : isMobile
                                  ? 20
                                  : 22,
                              fontWeight: FontWeight.bold,
                              color: _AppColors.textPrimary,
                              height: 1.4,
                            ),
                          ),
                          SizedBox(height: isSmallMobile ? 12 : 16),
                          Container(
                            padding: EdgeInsets.all(
                              isSmallMobile ? 16 : 20,
                            ), // TDS: More padding
                            decoration: BoxDecoration(
                              color: _AppColors.gray50,
                              borderRadius: BorderRadius.circular(
                                16,
                              ), // TDS: More rounded
                            ),
                            child: Column(
                              children: [
                                _buildCheckItem("오픈 시 내 팀 답변 기반 갭 체크"),
                                _buildCheckItem("10문항 확정 → 결정 로그 v1.0 생성"),
                                _buildCheckItem("링크 정본 + PIN 보호 + PDF 발급"),
                              ],
                            ),
                          ),
                          SizedBox(height: isSmallMobile ? 12 : 16),
                          Text(
                            "현재는 사전신청 단계이며, 기능은 오픈 후 제공됩니다.",
                            style: TextStyle(
                              fontSize: isSmallMobile ? 12 : 13,
                              color: _AppColors.textSub,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: isSmallMobile ? 20 : 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => _handleRegister('modal'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _AppColors.blue600,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  vertical: isSmallMobile ? 16 : 18,
                                ), // TDS: More padding
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    16,
                                  ), // TDS: More rounded
                                ),
                                elevation: 0,
                                shadowColor: Colors.transparent,
                              ),
                              child: Text(
                                _ctaLabel,
                                style: TextStyle(
                                  fontSize: isSmallMobile ? 14 : 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
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

  // --- Sub-Widgets ---

  Widget _buildStickyHeader({
    required bool isDesktop,
    required bool isMobile,
    required bool isSmallMobile,
    required double screenWidth,
  }) {
    return Container(
      padding: EdgeInsets.zero,
      decoration: const BoxDecoration(
        color: _AppColors.slate900,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: _AppColors.blue600,
            padding: EdgeInsets.symmetric(
              vertical: isSmallMobile ? 6 : 8,
              horizontal: isSmallMobile ? 12 : 16,
            ),
            child: Text(
              "현재는 사전신청 단계입니다. $_ctaSubLabel. (다운로드/복사 제한)",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: isSmallMobile ? 11 : 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            constraints: BoxConstraints(
              maxWidth: isDesktop ? 768 : screenWidth,
            ),
            margin: EdgeInsets.symmetric(
              horizontal: isSmallMobile
                  ? 12
                  : isMobile
                  ? 16
                  : isDesktop
                  ? 32
                  : 24,
              vertical: isSmallMobile ? 12 : 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.description,
                        color: const Color(0xFF60A5FA),
                        size: isSmallMobile ? 20 : 24,
                      ), // blue-400
                      SizedBox(width: isSmallMobile ? 6 : 8),
                      Flexible(
                        child: RichText(
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: isSmallMobile
                                  ? 14
                                  : isMobile
                                  ? 16
                                  : isDesktop
                                  ? 18
                                  : 17,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              const TextSpan(text: "CoSync "),
                              if (!isMobile)
                                TextSpan(
                                  text: "Sample Report",
                                  style: TextStyle(
                                    fontSize: isSmallMobile
                                        ? 12
                                        : isMobile
                                        ? 13
                                        : 14,
                                    color: _AppColors.gray400,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: _AppColors.gray600),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    "Read Only",
                    style: TextStyle(color: _AppColors.gray400, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text, {required bool isMobile}) {
    return Padding(
      padding: EdgeInsets.only(
        left: 4,
        bottom: isMobile ? 10 : 12,
      ), // TDS: More spacing
      child: Text(
        text,
        style: TextStyle(
          fontSize: isMobile ? 11 : 12,
          color: _AppColors.textSub, // TDS: Use textSub color
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _buildContextCard({
    required bool isDesktop,
    required bool isMobile,
    required bool isSmallMobile,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 32 : 40,
        horizontal: isMobile ? 20 : 32,
      ),
      decoration: _cardDecoration(), // Consistent card style
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Label
          const Text(
            "AGREEMENT CONTEXT",
            style: TextStyle(
              color: _AppColors.textSub,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: isMobile ? 12 : 16),
          // 2. Title
          Text(
            "공동창업자 합의안 (v1.0)",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isSmallMobile ? 20 : (isMobile ? 22 : 26),
              fontWeight: FontWeight.bold,
              color: _AppColors.textPrimary,
              height: 1.3,
            ),
          ),
          SizedBox(height: isMobile ? 20 : 24),
          // 3. Tags
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _tagChip("2인 팀"),
              _tagChip(_stageLabel),
              _tagChip("아직 투자 전"),
              _tagChip("풀타임 전환 중"),
            ],
          ),
          SizedBox(height: isMobile ? 24 : 32),
          // 4. Divider with style
          Container(
            height: 1,
            width: double.infinity,
            color: _AppColors.gray200,
          ),
          SizedBox(height: isMobile ? 24 : 32),
          // 5. Members
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _memberProfileCenter("CEO", "김철수"),
              Container(
                height: 24,
                width: 1,
                color: _AppColors.gray200,
                margin: const EdgeInsets.symmetric(horizontal: 24),
              ),
              _memberProfileCenter("CTO", "이영희"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _memberProfileCenter(String role, String name) {
    return Column(
      children: [
        Text(
          role,
          style: const TextStyle(
            fontSize: 11,
            color: _AppColors.blue600, // Make role pop with color
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _tagChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ), // TDS: More padding
      decoration: BoxDecoration(
        color: _AppColors.gray50, // TDS: Light background
        borderRadius: BorderRadius.circular(8), // TDS: More rounded
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: _AppColors.textPrimary, // TDS: Dark text on light bg
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required bool isDesktop,
    required bool isMobile,
    required bool isSmallMobile,
  }) {
    return Container(
      padding: EdgeInsets.all(
        isSmallMobile
            ? 16
            : isMobile
            ? 20
            : isDesktop
            ? 32
            : 24,
      ), // Responsive Padding
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "합의 현황 요약",
            style: TextStyle(
              fontSize: isSmallMobile
                  ? 16
                  : isMobile
                  ? 18
                  : isDesktop
                  ? 20
                  : 19,
              fontWeight: FontWeight.bold,
              color: _AppColors.textPrimary,
            ),
          ),
          SizedBox(height: isSmallMobile ? 10 : 12),
          Text(
            "예시값 기반으로 3개 안건을 모두 합의 완료한 결정 로그(v1.0) 형태의 샘플입니다.",
            style: TextStyle(
              fontSize: isSmallMobile
                  ? 12
                  : isMobile
                  ? 13
                  : 14,
              color: _AppColors.textSub, // TDS: Use textSub
              height: 1.6, // TDS: Generous line height
            ),
          ),
          SizedBox(height: isSmallMobile ? 16 : 20),
          // Stack on mobile if needed, but grid 3 items usually fit.
          // Requirement ensures grid-cols-1 on mobile for "Section 2" but for summary boxes (3 items),
          // usually they are side-by-side or wrapped. Let's use Column on very small screens.
          // User said "All grid systems should be grid-cols-1 on mobile".
          (isMobile || isSmallMobile)
              ? Column(
                  children: [
                    _summaryBox(
                      "3",
                      "주요 안건",
                      Icons.topic_rounded,
                      _AppColors.blue50,
                      _AppColors.blue600,
                      width: double.infinity,
                      isSmallMobile: isSmallMobile,
                    ),
                    SizedBox(height: isSmallMobile ? 10 : 12),
                    _summaryBox(
                      "100%",
                      "합의 완료",
                      Icons.check_circle_rounded,
                      _AppColors.green50,
                      _AppColors.green600,
                      width: double.infinity,
                      isSmallMobile: isSmallMobile,
                    ),
                    SizedBox(height: isSmallMobile ? 10 : 12),
                    _summaryBox(
                      "Locked",
                      "누락된 포인트",
                      Icons.lock_rounded,
                      _AppColors.orange50,
                      _AppColors.orange500,
                      width: double.infinity,
                      isSmallMobile: isSmallMobile,
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: _summaryBox(
                        "3",
                        "주요 안건",
                        Icons.topic_rounded,
                        _AppColors.blue50,
                        _AppColors.blue600,
                        isSmallMobile: false,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _summaryBox(
                        "100%",
                        "합의 완료",
                        Icons.check_circle_rounded,
                        _AppColors.green50,
                        _AppColors.green600,
                        isSmallMobile: false,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _summaryBox(
                        "Locked",
                        "누락된 포인트",
                        Icons.lock_rounded,
                        _AppColors.orange50,
                        _AppColors.orange500,
                        isSmallMobile: false,
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _summaryBox(
    String val,
    String label,
    IconData icon,
    Color bg,
    Color text, {
    String? sub,
    double? width,
    required bool isSmallMobile,
  }) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(
        vertical: isSmallMobile ? 16 : 20,
        horizontal: isSmallMobile ? 12 : 16,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(isSmallMobile ? 16 : 20),
        border: Border.all(
          color: text.withValues(alpha: 0.1),
          width: 1.5,
        ), // Colored Border
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(isSmallMobile ? 6 : 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.6),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: text,
              size: isSmallMobile ? 20 : 24,
            ), // Added Icon
          ),
          SizedBox(height: isSmallMobile ? 8 : 12),
          Text(
            val,
            style: TextStyle(
              fontSize: isSmallMobile ? 22 : 28,
              fontWeight: FontWeight.w800,
              color: text,
              height: 1.2,
            ),
          ),
          SizedBox(height: isSmallMobile ? 3 : 4),
          Text(
            label,
            style: TextStyle(
              fontSize: isSmallMobile ? 11 : 13,
              color: text.withValues(alpha: 0.8),
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          if (sub != null) ...[
            const SizedBox(height: 4),
            Text(
              sub,
              style: const TextStyle(fontSize: 10, color: _AppColors.textSub),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTableOfContents({
    required bool isDesktop,
    required bool isMobile,
  }) {
    return Container(
      padding: EdgeInsets.all(
        isMobile
            ? 20
            : isDesktop
            ? 32
            : 24,
      ), // Responsive Padding
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "목차",
            style: TextStyle(
              fontSize: isMobile
                  ? 16
                  : isDesktop
                  ? 20
                  : 18,
              fontWeight: FontWeight.bold,
              color: _AppColors.textPrimary,
            ),
          ),
          SizedBox(height: isMobile ? 12 : 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _topics
                .asMap()
                .entries
                .map(
                  (e) => InkWell(
                    onTap: () => _scrollToTopic(e.value.id),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 14 : 16,
                        vertical: isMobile ? 8 : 10,
                      ), // TDS: More padding
                      decoration: BoxDecoration(
                        // TDS: Light background + dark text (no border)
                        color: _AppColors.gray50,
                        borderRadius: BorderRadius.circular(
                          12,
                        ), // TDS: More rounded
                      ),
                      child: Text(
                        "Topic 0${e.key + 1}. ${e.value.title.split('(')[0]}", // Shorten title for TOC
                        style: TextStyle(
                          fontSize: isMobile ? 12 : 13,
                          color: _AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicCard(
    _Topic topic, {
    required bool isDesktop,
    required bool isMobile,
    required bool isSmallMobile,
    GlobalKey? key,
  }) {
    // Determine Color based on ID (as per requirement: 1=Blue(Decision), 2=Green(Equity), 3=Orange(R&R))
    // Current IDs: 1: Decision, 2: Finance, 3: Exit.
    // Requirement Mapping:
    // - Decision (Blue)
    // - Equity/Vesting (Green)
    // - R&R (Orange)
    // We will align closely.

    Color sectionColor = _AppColors.blue600;
    Color sectionBg = _AppColors.blue50;
    IconData sectionIcon = Icons.gavel_rounded;

    if (topic.id == 2) {
      // Finance/Vesting/Equity -> Green
      sectionColor = _AppColors.green600;
      sectionBg = _AppColors.green50;
      sectionIcon = Icons.pie_chart_rounded;
    } else if (topic.id == 3) {
      // Exit/R&R -> Orange
      sectionColor = _AppColors.orange500;
      sectionBg = _AppColors.orange50;
      sectionIcon = Icons.diversity_3_rounded;
    }

    return RepaintBoundary(
      key: key,
      child: Container(
        margin: const EdgeInsets.only(bottom: 32),
        decoration: _cardDecoration(),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallMobile
                    ? 16
                    : isMobile
                    ? 20
                    : isDesktop
                    ? 32
                    : 24,
                vertical: isSmallMobile ? 16 : 20,
              ),
              color: _AppColors.gray50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        // Section Icon System
                        Container(
                          padding: EdgeInsets.all(
                            isSmallMobile ? 8 : 12,
                          ), // Larger padding for icon
                          decoration: BoxDecoration(
                            color: sectionBg,
                            borderRadius: BorderRadius.circular(
                              isSmallMobile ? 12 : 14,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: sectionColor.withValues(alpha: 0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ], // Glow effect
                          ),
                          child: Icon(
                            sectionIcon,
                            color: sectionColor,
                            size: isSmallMobile ? 20 : 28,
                          ), // Larger Icon
                        ),
                        SizedBox(width: isSmallMobile ? 8 : 12),
                        Expanded(
                          child: Text(
                            "Topic 0${topic.id}. ${topic.title}",
                            style: TextStyle(
                              fontSize: isSmallMobile
                                  ? 16
                                  : isMobile
                                  ? 19
                                  : isDesktop
                                  ? 22
                                  : 21,
                              fontWeight: FontWeight.bold,
                              color: _AppColors.textPrimary,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isDesktop)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ), // TDS: More padding
                      margin: const EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                        // TDS: Light background + dark text (no border)
                        color: _AppColors.green50,
                        borderRadius: BorderRadius.circular(
                          8,
                        ), // TDS: More rounded
                      ),
                      child: const Text(
                        "합의 완료",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _AppColors.green600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const Divider(height: 1, color: _AppColors.gray200),
            Padding(
              padding: EdgeInsets.all(
                isSmallMobile
                    ? 16
                    : isMobile
                    ? 20
                    : isDesktop
                    ? 32
                    : 24,
              ), // Responsive Padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(
                      isSmallMobile ? 16 : 20,
                    ), // TDS: More padding
                    decoration: BoxDecoration(
                      // TDS: Remove border, use soft shadow
                      color: _AppColors.gray50,
                      borderRadius: BorderRadius.circular(
                        isSmallMobile ? 12 : 16,
                      ), // TDS: More rounded
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Q.",
                          style: TextStyle(
                            fontSize: isSmallMobile ? 11 : 12,
                            color: _AppColors.textSub,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: isSmallMobile ? 6 : 8),
                        Text(
                          topic.questionTitle,
                          style: TextStyle(
                            fontSize: isSmallMobile
                                ? 14
                                : isMobile
                                ? 15
                                : 16,
                            fontWeight: FontWeight.w600,
                            height: 1.6, // TDS: Generous line height
                            color: _AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: isSmallMobile ? 10 : 12),
                        Text(
                          topic.questionDesc,
                          style: TextStyle(
                            fontSize: isSmallMobile
                                ? 12
                                : isMobile
                                ? 13
                                : 14,
                            color: _AppColors.textSub,
                            height: 1.6, // TDS: Generous line height
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: isSmallMobile ? 12 : 16),

                  // Opinions
                  isMobile
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _opinionBox(
                              "A 의견 (CEO)",
                              topic.opinionA,
                              _AppColors.blue50,
                              _AppColors.blue600,
                              isSmallMobile: isSmallMobile,
                              expand: false,
                            ),
                            SizedBox(height: isSmallMobile ? 12 : 16),
                            _opinionBox(
                              "B 의견 (CTO)",
                              topic.opinionB,
                              _AppColors.purple50,
                              _AppColors.purple600,
                              isSmallMobile: isSmallMobile,
                              expand: false,
                            ),
                          ],
                        )
                      : IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: _opinionBox(
                                  "A 의견 (CEO)",
                                  topic.opinionA,
                                  _AppColors.blue50,
                                  _AppColors.blue600,
                                  isSmallMobile: false,
                                  expand: true,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _opinionBox(
                                  "B 의견 (CTO)",
                                  topic.opinionB,
                                  _AppColors.purple50,
                                  _AppColors.purple600,
                                  isSmallMobile: false,
                                  expand: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                  SizedBox(height: isSmallMobile ? 12 : 16),

                  // Reference
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(
                      isSmallMobile ? 16 : 20,
                    ), // TDS: More padding
                    decoration: BoxDecoration(
                      color: _AppColors.slate50,
                      borderRadius: BorderRadius.circular(
                        isSmallMobile ? 12 : 16,
                      ), // TDS: More rounded
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: isSmallMobile ? 18 : 22,
                          color: _AppColors.slate400,
                        ),
                        SizedBox(width: isSmallMobile ? 12 : 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "MARKET STANDARD",
                                style: TextStyle(
                                  fontSize: isSmallMobile ? 10 : 11,
                                  fontWeight: FontWeight.bold,
                                  color: _AppColors.slate500,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              SizedBox(height: isSmallMobile ? 6 : 8),
                              Text(
                                topic.reference,
                                style: TextStyle(
                                  fontSize: isSmallMobile
                                      ? 12
                                      : isMobile
                                      ? 13
                                      : 14,
                                  color: _AppColors.slate700,
                                  height: 1.6, // TDS: Generous line height
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: isSmallMobile ? 12 : 16),

                  // Blurred Section
                  GestureDetector(
                    onTap: () => setState(() => _isModalOpen = true),
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: _AppColors.gray100),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Stack(
                        children: [
                          RepaintBoundary(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: ImageFiltered(
                                imageFilter: ImageFilter.blur(
                                  sigmaX: 6,
                                  sigmaY: 6,
                                ),
                                child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: _AppColors.gray50,
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "의사결정 권한 분배: 기술/보안 관련은 CTO 동의 필수, 나머지는 CEO 최종 확정. 비용 조정 트리거: 잔고 3,000만원 이하 시 마케팅 50% 축소 후 외주 신규 발주 중단. 이탈 시 인수인계: 2주 내 완료, 권한 즉시 차단, 지분/정산은 베스팅 기준 적용. 추가 합의 사항: 서버/보안 비용은 보호하며, 런웨이 6개월 회복 시 단계적으로 복구한다.",
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      height: 1.6,
                                      color: _AppColors.gray900,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Overlay Button
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  "누락된 합의 포인트",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _AppColors.gray600,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.1,
                                        ),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.lock,
                                        size: 14,
                                        color: _AppColors.gray600,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        "분석 보기",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: _AppColors.gray700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Decision Log
                  Container(
                    padding: EdgeInsets.all(
                      isSmallMobile
                          ? 16
                          : isMobile
                          ? 20
                          : 24,
                    ), // TDS: More padding
                    decoration: BoxDecoration(
                      color: _AppColors.blue50,
                      // TDS: Remove border, use soft shadow
                      borderRadius: BorderRadius.circular(
                        isSmallMobile ? 12 : 16,
                      ), // TDS: More rounded
                      boxShadow: [
                        BoxShadow(
                          color: _AppColors.blue100.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: isSmallMobile ? 6 : 8,
                              height: isSmallMobile ? 6 : 8,
                              decoration: const BoxDecoration(
                                color: _AppColors.blue600,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: isSmallMobile ? 8 : 12),
                            Text(
                              "Final Decision Log v1.0",
                              style: TextStyle(
                                fontSize: isSmallMobile ? 10 : 12,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2563EB), // blue700
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: isSmallMobile ? 10 : 12),
                        Text(
                          topic.decision,
                          style: TextStyle(
                            fontSize: isSmallMobile
                                ? 13
                                : isMobile
                                ? 14
                                : 15,
                            height: 1.7, // TDS: Generous line height
                            fontWeight: FontWeight.w500,
                            color: _AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _opinionBox(
    String label,
    String content,
    Color bg,
    Color accent, {
    required bool isSmallMobile,
    bool expand = false,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // 1. Background Layer (Stretches to fill Stack)
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(isSmallMobile ? 16 : 20),
              border: Border.all(
                color: accent.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
          ),
        ),
        // 2. Content Layer (Determines Size)
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            isSmallMobile ? 16 : 20,
            isSmallMobile ? 24 : 28,
            isSmallMobile ? 16 : 20,
            isSmallMobile ? 16 : 20,
          ),
          child: Text(
            '"$content"',
            style: TextStyle(
              fontSize: isSmallMobile ? 13 : 15,
              height: 1.6,
              color: _AppColors.textPrimary.withValues(alpha: 0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // 3. Badge Layer
        Positioned(
          top: isSmallMobile ? -10 : -12,
          left: isSmallMobile ? 16 : 20,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallMobile ? 8 : 10,
              vertical: isSmallMobile ? 5 : 6,
            ),
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(isSmallMobile ? 6 : 8),
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: 0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: isSmallMobile ? 11 : 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12), // TDS: More spacing
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 18, color: _AppColors.blue600),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: _AppColors.textPrimary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimer({required bool isDesktop, required bool isMobile}) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 32 : 40,
        horizontal: isMobile ? 12 : 16,
      ), // TDS: More padding
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(
            "본 문서는 CoSync의 샘플 리포트이며 법적 효력이 없는 예시 자료입니다.",
            style: TextStyle(
              fontSize: isMobile ? 11 : 12,
              color: _AppColors.textSub,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isMobile ? 6 : 8),
          Text(
            "실제 법적 분쟁 시에는 변호사의 자문을 구하시길 바랍니다.",
            style: TextStyle(
              fontSize: isMobile ? 11 : 12,
              color: _AppColors.textSub,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFooterSection({
    required bool isMobile,
    required bool isSmallMobile,
  }) {
    // Determine the width constraint based on other cards
    // In strict sense, it's already in a constrained column, so just using decoration is enough.

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 32 : 48,
        horizontal: isMobile ? 24 : 32,
      ),
      decoration:
          _cardDecoration(), // Match the design of other cards (white, rounded, shadow)
      child: Column(
        children: [
          // Visual Icon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _AppColors.textPrimary.withValues(alpha: 0.1),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
              border: Border.all(color: _AppColors.gray200, width: 1),
            ),
            child: const Icon(
              Icons.mark_email_unread_rounded,
              color: _AppColors.textPrimary,
              size: 30,
            ),
          ),
          SizedBox(height: isMobile ? 24 : 32),
          Text(
            "내 팀 답변으로 결정 로그(v1.0)를\n받아보고 싶으신가요?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isSmallMobile ? 20 : (isMobile ? 22 : 24),
              fontWeight: FontWeight.bold,
              color: _AppColors.textPrimary,
              height: 1.3,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: isMobile ? 12 : 16),
          Container(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Text(
              "오픈 시 내 팀 답변 기반으로 추가 논의 포인트(갭)를 잡아드리고,\n결정 로그 정본 링크로 최신 버전을 관리할 수 있습니다.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isSmallMobile ? 13 : (isMobile ? 14 : 15),
                color: _AppColors.textSub,
                height: 1.6,
              ),
            ),
          ),
          SizedBox(height: isMobile ? 32 : 40),
          _Bounceable(
            child: ElevatedButton(
              onPressed: () => _handleRegister('footer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _AppColors.textPrimary, // Dark Navy
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 32 : 48,
                  vertical: isMobile ? 18 : 22,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
                shadowColor: Colors.black.withValues(alpha: 0.3),
              ),
              child: Text(
                _ctaLabel,
                style: TextStyle(
                  fontSize: isMobile ? 16 : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(28), // TDS: rounded-3xl (24-32px)
      // TDS: Remove border, use soft shadow instead
      boxShadow: [
        // TDS: shadow-soft - wide spread, low opacity
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 20,
          spreadRadius: 0,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.02),
          blurRadius: 6,
          spreadRadius: 0,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
}

class _Bounceable extends StatefulWidget {
  final Widget child;

  const _Bounceable({required this.child});

  @override
  State<_Bounceable> createState() => _BounceableState();
}

class _BounceableState extends State<_Bounceable>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final double _scaleFactor = 0.96;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(PointerDownEvent event) {
    _controller.forward();
  }

  void _onTapUp(PointerUpEvent event) {
    _controller.reverse();
  }

  void _onTapCancel(PointerCancelEvent event) {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _onTapDown,
      onPointerUp: _onTapUp,
      onPointerCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 - (_controller.value * (1.0 - _scaleFactor)),
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}

// Fade In Up Animation Wrapper
class _RevealAnimation extends StatefulWidget {
  final Widget child;
  final int delay;

  const _RevealAnimation({required this.child, this.delay = 0});

  @override
  State<_RevealAnimation> createState() => _RevealAnimationState();
}

class _RevealAnimationState extends State<_RevealAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Simulate "Intersection Observer" by triggering after build/delay
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(position: _slideAnimation, child: widget.child),
    );
  }
}

class _BouncingButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _BouncingButton({required this.child, required this.onTap});

  @override
  State<_BouncingButton> createState() => _BouncingButtonState();
}

class _BouncingButtonState extends State<_BouncingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.04, // Scale down by 4%
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(scale: 1.0 - _controller.value, child: child);
        },
        child: widget.child,
      ),
    );
  }
}