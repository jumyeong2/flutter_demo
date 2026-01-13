import 'dart:ui'; // For ImageFilter
import 'dart:math' as math; // For rotate
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// --- 0. Tailwind Color Palette Mapping ---
class _AppColors {
  static const blue600 = Color(0xFF2563EB);
  static const blue700 = Color(0xFF1D4ED8);
  static const blue50 = Color(0xFFEFF6FF);
  static const blue100 = Color(0xFFDBEAFE);
  static const slate900 = Color(0xFF0F172A);
  static const slate50 = Color(0xFFF8FAFC);
  static const slate400 = Color(0xFF94A3B8);
  static const slate500 = Color(0xFF64748B);
  static const slate700 = Color(0xFF334155);
  static const gray50 = Color(0xFFF9FAFB);
  static const gray100 = Color(0xFFF3F4F6);
  static const gray200 = Color(0xFFE5E7EB);
  static const gray300 = Color(0xFFD1D5DB);
  static const gray400 = Color(0xFF9CA3AF);
  static const gray500 = Color(0xFF6B7280);
  static const gray600 = Color(0xFF4B5563);
  // [FIX] gray700 추가됨 (오류 해결)
  static const gray700 = Color(0xFF374151); 
  static const gray800 = Color(0xFF1F2937);
  static const gray900 = Color(0xFF111827);
  static const green50 = Color(0xFFF0FDF4);
  static const green100 = Color(0xFFDCFCE7);
  static const green600 = Color(0xFF16A34A);
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

class _SampleReportPageState extends State<SampleReportPage> {
  // State
  bool _isModalOpen = false;
  final ScrollController _scrollController = ScrollController();
  final String _sessionId = "XJ92KDL"; // Demo ID (Random gen in real app)
  final String _issuedAt = "2024.05.20";

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
      reference: "초기 팀은 교착(Deadlock) 방지가 최우선입니다. 최종 확정자(캐스팅보트)를 두되, 기술/보안 같은 예외 영역을 함께 정의하는 방식이 흔합니다.",
      decision: "의견 불일치 시 48시간 내 논의 후 CEO(PM)가 최종 확정한다. 전환율(+10%) 또는 2주 잔존율(+5%) 중 1개 이상 개선이 예상되면 실행하며, 교착 시 외부 멘토 1회 자문 후 재결정한다.",
    ),
    _Topic(
      id: 2,
      title: "자금 조정 룰 (트리거/우선순위/기한)",
      questionTitle: "어떤 신호(잔고/런웨이)에서 무엇을 어떤 순서로 얼마까지 줄이고, 누가 언제 확정하나요?",
      questionDesc: "트리거와 조정 순서가 없으면 비용/급여에서 갈등이 납니다.",
      opinionA: "런웨이 기준을 먼저 두고, 마케팅부터 줄이는 게 빠릅니다.",
      opinionB: "외주/고정비가 크면 마케팅보다 외주부터 끊어야 합니다. 보호 항목도 필요합니다.",
      reference: "비용 조정은 ‘트리거(수치) → 우선순위(순서) → 보호 항목’이 세트로 있어야 팀 갈등이 줄어듭니다.",
      decision: "잔고 3,000만원 이하 또는 런웨이 3개월 이하 시 비용 조정을 발동한다. 1순위는 마케팅 50% 축소, 2순위는 외주 신규 발주 중단(유지 상한 월 200만원)으로 조정한다. 최종 확정은 CEO(재무 산출)+CTO(외주 범위)가 72시간 내 진행한다. 서버/보안 비용은 보호하며, 런웨이 6개월 회복 시 단계적으로 복구한다.",
    ),
    _Topic(
      id: 3,
      title: "이탈 정리 원칙 (인수인계/권한/정산)",
      questionTitle: "공동창업자 1명 이탈 시, 인수인계/권한/지분/채무/데이터를 언제까지 어떤 원칙으로 정리하나요?",
      questionDesc: "이 질문은 감정이 아니라 체크리스트입니다. 핵심 영역을 빠짐없이 확정합니다.",
      opinionA: "이탈 후에도 업무 공백이 생기지 않도록 인수인계를 최우선으로 해야 합니다.",
      opinionB: "권한/데이터 차단이 즉시 되지 않으면 리스크가 큽니다. 정산 기한도 짧게 잡아야 합니다.",
      reference: "실무에선 ‘인수인계(기간/산출물) + 권한 차단(즉시) + 정산 기한(짧게)’을 최소 세트로 둡니다.",
      decision: "공동창업자 이탈 시 2주 내 인수인계를 완료하고(인수인계 문서/레포 정리/계정 목록 포함), 권한은 이탈일 즉시 차단한다. 지분/정산은 베스팅 기준을 적용하고 Bad Leaver는 액면가 회수 원칙으로 7일 내 정리한다. 고객 데이터 접근은 즉시 차단하며 소스/디자인/도메인 등 자산은 회사 귀속으로 한다.",
    ),
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleRegister(String location) {
    setState(() => _isModalOpen = false);
    // GetX Snackbar for Toast
    Get.snackbar(
      "알림",
      "사전신청이 완료되었습니다! (Demo)",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      icon: const Icon(Icons.check_circle, color: Colors.green),
    );
  }

  void _scrollToTopic(int id) {
    Get.snackbar("Navigation", "Topic 0$id로 이동합니다.",
        snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 640;

        return Scaffold(
          backgroundColor: _AppColors.gray100,
          body: Stack(
            children: [
              // --- Layer 1: Main Scrollable Content ---
              Column(
                children: [
                  // 1-1. Sticky Header
                  _buildStickyHeader(),

                  // 1-2. Scroll Body
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      physics: _isModalOpen
                          ? const NeverScrollableScrollPhysics()
                          : const ClampingScrollPhysics(),
                      child: Container(
                        padding: EdgeInsets.only(
                          bottom: isDesktop ? 60 : 120, // Space for footer/sticky
                        ),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 768), // max-w-3xl
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // A. Context
                                  _buildSectionLabel("A. 예시 팀 컨텍스트"),
                                  _buildContextCard(),
                                  const SizedBox(height: 24),

                                  // B. Summary
                                  _buildSectionLabel("B. 합의 현황 요약"),
                                  _buildSummaryCard(),
                                  const SizedBox(height: 24),

                                  // C. Topics
                                  _buildSectionLabel("C. Topic 01~03 (합의 결과)"),
                                  _buildTableOfContents(),
                                  const SizedBox(height: 24),
                                  ..._topics.map((t) => _buildTopicCard(t)),
                                  
                                  const SizedBox(height: 24),
                                  
                                  // D. Footer Area
                                  _buildSectionLabel("D. 면책 + 사전신청 CTA"),
                                  _buildDisclaimer(),
                                  if (isDesktop) _buildDesktopFooter(),
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
              IgnorePointer(
                child: _buildWatermark(),
              ),

              // --- Layer 3: Sticky Bottom CTA (Mobile Only) ---
              if (!isDesktop && !_isModalOpen)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: const Border(top: BorderSide(color: _AppColors.gray200)),
                      boxShadow: [
                        BoxShadow(
                          // [FIX] withOpacity -> withValues
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () => _handleRegister('sticky'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _AppColors.gray900,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(_ctaLabel, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: _AppColors.gray800,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              _ctaSubLabel,
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal, color: _AppColors.gray400),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),

              // --- Layer 4: Custom Modal Overlay ---
              if (_isModalOpen)
                Stack(
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
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        constraints: const BoxConstraints(maxWidth: 400),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              // [FIX] withOpacity -> withValues
                              color: Colors.black.withValues(alpha: 0.25),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () => setState(() => _isModalOpen = false),
                                child: const Icon(Icons.close, color: _AppColors.gray400),
                              ),
                            ),
                            Container(
                              width: 48, height: 48,
                              decoration: const BoxDecoration(
                                color: _AppColors.blue100,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.lock, color: _AppColors.blue600),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "상세 분석 데이터가 궁금하신가요?",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _AppColors.gray900),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: _AppColors.gray50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  _buildCheckItem("오픈 시 내 팀 답변 기반 갭 체크"),
                                  _buildCheckItem("10문항 확정 → 결정 로그 v1.0 생성"),
                                  _buildCheckItem("링크 정본 + PIN 보호 + PDF 발급"),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "현재는 사전신청 단계이며, 기능은 오픈 후 제공됩니다.",
                              style: TextStyle(fontSize: 12, color: _AppColors.gray500),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => _handleRegister('modal'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _AppColors.blue600,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  elevation: 4,
                                  shadowColor: _AppColors.blue100,
                                ),
                                child: const Text(_ctaLabel, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  // --- Sub-Widgets ---

  Widget _buildStickyHeader() {
    return Container(
      decoration: const BoxDecoration(
        color: _AppColors.slate900,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: _AppColors.blue600,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: const Text(
              "현재는 사전신청 단계입니다. $_ctaSubLabel. (다운로드/복사 제한)",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            constraints: const BoxConstraints(maxWidth: 768),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.description, color: Color(0xFF60A5FA), size: 24), // blue-400
                    const SizedBox(width: 8),
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(fontFamily: 'Pretendard', fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(text: "CoSync "),
                          TextSpan(text: "Sample Report", style: TextStyle(fontSize: 14, color: _AppColors.gray400, fontWeight: FontWeight.normal)),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: _AppColors.gray600),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text("Read Only", style: TextStyle(color: _AppColors.gray400, fontSize: 11)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(text, style: const TextStyle(fontSize: 12, color: _AppColors.gray500, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildContextCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("AGREEMENT CONTEXT", style: TextStyle(color: _AppColors.gray500, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
          const SizedBox(height: 16),
          LayoutBuilder(builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 500;
            return Flex(
              direction: isMobile ? Axis.vertical : Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("공동창업자 합의안 (v1.0)", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _AppColors.gray900)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _tagChip("2인 팀"),
                        _tagChip(_stageLabel),
                        _tagChip("아직 투자 전"),
                        _tagChip("풀타임 전환 중"),
                      ],
                    )
                  ],
                ),
                if (isMobile) const SizedBox(height: 16) else const SizedBox(width: 16),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: isMobile ? const BorderSide(color: _AppColors.gray100) : BorderSide.none,
                      left: isMobile ? BorderSide.none : const BorderSide(color: _AppColors.gray100),
                    ),
                  ),
                  padding: EdgeInsets.only(
                    top: isMobile ? 16 : 0,
                    left: isMobile ? 0 : 24,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _memberProfile("CEO", "김철수"),
                      const SizedBox(width: 16),
                      _memberProfile("CTO", "이영희"),
                    ],
                  ),
                )
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _memberProfile(String role, String name) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(role, style: const TextStyle(fontSize: 11, color: _AppColors.gray400)),
        Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _AppColors.gray800)),
      ],
    );
  }

  Widget _tagChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: _AppColors.gray100, borderRadius: BorderRadius.circular(6)),
      child: Text(text, style: const TextStyle(fontSize: 12, color: _AppColors.gray600)),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("합의 현황 요약", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _AppColors.gray900)),
          const SizedBox(height: 8),
          const Text("예시값 기반으로 3개 안건을 모두 합의 완료한 결정 로그(v1.0) 형태의 샘플입니다.", style: TextStyle(fontSize: 14, color: _AppColors.gray600)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _summaryBox("3", "주요 안건", _AppColors.blue50, _AppColors.blue600)),
              const SizedBox(width: 12),
              Expanded(child: _summaryBox("100%", "합의 완료", _AppColors.green50, _AppColors.green600)),
              const SizedBox(width: 12),
              Expanded(child: _summaryBox("Locked", "룰북 분석", _AppColors.gray50, _AppColors.gray600, sub: "샘플 잠금")),
            ],
          )
        ],
      ),
    );
  }

  Widget _summaryBox(String val, String label, Color bg, Color text, {String? sub}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Text(val, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: text)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: _AppColors.gray500)),
          if (sub != null) ...[
            const SizedBox(height: 4),
            Text(sub, style: const TextStyle(fontSize: 10, color: _AppColors.gray400)),
          ]
        ],
      ),
    );
  }

  Widget _buildTableOfContents() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("목차", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _AppColors.gray900)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _topics
                .asMap()
                .entries
                .map((e) => InkWell(
                      onTap: () => _scrollToTopic(e.value.id),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: _AppColors.gray200),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        // [FIX] gray700 사용 오류 해결
                        child: Text("Topic 0${e.key + 1}. ${e.value.title}", style: const TextStyle(fontSize: 13, color: _AppColors.gray700)),
                      ),
                    ))
                .toList(),
          )
        ],
      ),
    );
  }

  Widget _buildTopicCard(_Topic topic) {
    return RepaintBoundary(
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: _cardDecoration(),
        clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            color: _AppColors.gray50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text("Topic 0${topic.id}. ${topic.title}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _AppColors.gray800)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: _AppColors.green100, border: Border.all(color: _AppColors.green50), borderRadius: BorderRadius.circular(4)),
                  child: const Text("합의 완료", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _AppColors.green600)),
                )
              ],
            ),
          ),
          const Divider(height: 1, color: _AppColors.gray200),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Question
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(border: Border.all(color: _AppColors.gray200), borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Q.", style: TextStyle(fontSize: 12, color: _AppColors.gray500, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(topic.questionTitle, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, height: 1.5, color: _AppColors.gray900)),
                      const SizedBox(height: 8),
                      Text(topic.questionDesc, style: const TextStyle(fontSize: 13, color: _AppColors.gray600, height: 1.4)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Opinions
                LayoutBuilder(builder: (context, c) {
                  final isSmall = c.maxWidth < 500;
                  return Flex(
                    direction: isSmall ? Axis.vertical : Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: isSmall ? 0 : 1, child: _opinionBox("A 의견 (CEO)", topic.opinionA)),
                      SizedBox(width: isSmall ? 0 : 16, height: isSmall ? 16 : 0),
                      Expanded(flex: isSmall ? 0 : 1, child: _opinionBox("B 의견 (CTO)", topic.opinionB)),
                    ],
                  );
                }),
                const SizedBox(height: 16),

                // Reference
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: _AppColors.slate50, borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline, size: 20, color: _AppColors.slate400),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("MARKET STANDARD", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _AppColors.slate500)),
                            const SizedBox(height: 4),
                            // [FIX] gray700 사용 오류 해결
                            Text(topic.reference, style: const TextStyle(fontSize: 13, color: _AppColors.slate700, height: 1.4)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Blurred Section (Interactive) - 성능 최적화: RepaintBoundary로 감싸기
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
                        // Blurred Content - 실제 텍스트를 블러 처리
                        RepaintBoundary(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: ImageFiltered(
                              imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
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
                              const Text("누락된 합의 포인트", style: TextStyle(fontWeight: FontWeight.bold, color: _AppColors.gray600, fontSize: 13)),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 2))
                                  ],
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.lock, size: 14, color: _AppColors.gray600),
                                    SizedBox(width: 6),
                                    Text("분석 보기", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _AppColors.gray700)),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Decision Log
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _AppColors.blue50,
                    border: Border.all(color: _AppColors.blue100),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(width: 8, height: 8, decoration: const BoxDecoration(color: _AppColors.blue600, shape: BoxShape.circle)),
                          const SizedBox(width: 8),
                          const Text("Final Decision Log v1.0", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _AppColors.blue700, letterSpacing: 0.5)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(topic.decision, style: const TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w500, color: _AppColors.gray900)),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
      ),
    );
  }

  Widget _opinionBox(String label, String content) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: _AppColors.gray200),
            borderRadius: BorderRadius.circular(8),
          ),
          // [FIX] gray700 사용 오류 해결
          child: Text('"$content"', style: const TextStyle(fontSize: 13, height: 1.5, color: _AppColors.gray700)),
        ),
        Positioned(
          top: -10,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            color: Colors.white,
            child: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _AppColors.gray500)),
          ),
        )
      ],
    );
  }

  Widget _buildCheckItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 16, color: _AppColors.blue600),
          const SizedBox(width: 8),
          // [FIX] gray700 사용 오류 해결
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13, color: _AppColors.gray700))),
        ],
      ),
    );
  }

  Widget _buildDisclaimer() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      alignment: Alignment.center,
      child: const Column(
        children: [
          Text("본 문서는 CoSync의 샘플 리포트이며 법적 효력이 없는 예시 자료입니다.", style: TextStyle(fontSize: 11, color: _AppColors.gray400)),
          SizedBox(height: 4),
          Text("실제 법적 분쟁 시에는 변호사의 자문을 구하시길 바랍니다.", style: TextStyle(fontSize: 11, color: _AppColors.gray400)),
        ],
      ),
    );
  }

  Widget _buildDesktopFooter() {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.symmetric(vertical: 48),
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: _AppColors.gray200))),
      child: Column(
        children: [
          const Text("내 팀 답변으로 결정 로그(v1.0)를\n받아보고 싶으신가요?",
              textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _AppColors.gray900, height: 1.3)),
          const SizedBox(height: 16),
          const SizedBox(
            width: 400,
            child: Text(
              "오픈 시 내 팀 답변 기반으로 추가 논의 포인트(갭)를 잡아드리고, 결정 로그 정본 링크로 최신 버전을 관리할 수 있습니다. 오픈 알림을 먼저 받아보세요.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: _AppColors.gray500, height: 1.5),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => _handleRegister('footer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _AppColors.gray900,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(_ctaLabel, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _buildWatermark() {
    // 성능 최적화: RepaintBoundary로 감싸고 위젯 수 감소
    return RepaintBoundary(
      child: IgnorePointer(
        child: CustomPaint(
          painter: _WatermarkPainter(
            text: "SAMPLE · CoSync · 예시 문서(무료 미리보기) · $_issuedAt · SID:$_sessionId",
          ),
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: _AppColors.gray200),
      boxShadow: [
        // [FIX] withOpacity -> withValues
        BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 2, offset: const Offset(0, 1)),
      ],
    );
  }
}

// CustomPainter for Watermark (성능 최적화)
class _WatermarkPainter extends CustomPainter {
  final String text;

  _WatermarkPainter({required this.text});

  @override
  void paint(Canvas canvas, Size size) {
    final textStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.black.withValues(alpha: 0.03),
    );

    final textSpan = TextSpan(text: text, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    // 화면을 덮을 만큼만 그리기 (성능 최적화)
    final angle = -math.pi / 12; // -15 degrees
    final spacing = 200.0;
    final horizontalSpacing = 300.0;

    for (double y = -100; y < size.height + 200; y += spacing) {
      for (double x = -100; x < size.width + 200; x += horizontalSpacing) {
        canvas.save();
        canvas.translate(x, y);
        canvas.rotate(angle);
        textPainter.paint(canvas, Offset.zero);
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(_WatermarkPainter oldDelegate) => false; // 정적이므로 재그리기 불필요
}