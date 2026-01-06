import 'package:flutter/material.dart';
import '../../widgets/responsive_layout.dart';

class SampleReportPage extends StatelessWidget {
  const SampleReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveLayout.isMobile(context);

    return Scaffold(
      backgroundColor: Colors.grey[100], // bg-gray-100
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 896), // max-w-4xl
              margin: isMobile
                  ? const EdgeInsets.only(bottom: 12)
                  : const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ), // shadow-xl
                ],
                borderRadius: BorderRadius.zero, // remove rounding on body
              ),
              clipBehavior: Clip.hardEdge, // overflow-hidden
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(context, isMobile),
                  _buildSummarySection(context, isMobile),
                  SizedBox(height: 30),
                  _buildDetailSection1(context, isMobile),
                  SizedBox(height: 50),
                  _buildDetailSection2(context, isMobile),
                  SizedBox(height: 50),
                  _buildDetailSection3(context, isMobile),
                  SizedBox(height: 50),
                  _buildDisclaimer(context, isMobile),
                  SizedBox(height: 50),
                  _buildFooter(context, isMobile),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile) {
    return Container(
      color: const Color(0xFF0F172A), // bg-slate-900
      padding: EdgeInsets.all(isMobile ? 24 : 32),
      child: Flex(
        direction: isMobile ? Axis.vertical : Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: isMobile
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "CoSync Agreement",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 20 : 24, // text-xl md:text-2xl
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0, // tracking-wider
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "공동창업자 합의 성향 분석 및 합의서",
                style: TextStyle(
                  color: Color(0xFF94A3B8), // text-slate-400
                  fontSize: 12, // text-xs md:text-sm
                ),
              ),
            ],
          ),
          if (isMobile)
            Container(
              margin: const EdgeInsets.only(top: 16, bottom: 8),
              height: 1,
              color: const Color(0xFF334155), // border-slate-700
            ),
          Column(
            crossAxisAlignment: isMobile
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
            children: [
              Text(
                "진단 일자",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12, // text-xs like
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Text(
                "2025. 10. 21",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16, // text-base md:text-lg
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection(BuildContext context, bool isMobile) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      padding: EdgeInsets.all(isMobile ? 20 : 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.pie_chart, color: Color(0xFF2563EB), size: 20),
              const SizedBox(width: 8),
              Text(
                "합의 현황 요약",
                style: TextStyle(
                  fontSize: isMobile ? 18 : 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(isMobile ? 20 : 24),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC), // bg-slate-50
              borderRadius: BorderRadius.circular(8),
            ),
            child: Flex(
              direction: isMobile ? Axis.vertical : Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: isMobile ? 0 : 1,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 16,
                        color: const Color(0xFF374151), // text-gray-700
                        height: 1.6,
                      ),
                      children: const [
                        TextSpan(
                          text: "User A(CEO)",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E40AF), // text-blue-800
                          ),
                        ),
                        TextSpan(text: "님과 "),
                        TextSpan(
                          text: "User B(CTO)",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E40AF),
                          ),
                        ),
                        TextSpan(text: "님의 답변을 분석한 결과, "),
                        TextSpan(
                          text: "3개 항목 중 1개",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2563EB), // text-blue-600
                          ),
                        ),
                        TextSpan(
                          text:
                              " 항목에서만 완전한 의견 일치를 보였습니다.\n특히 '지분 베스팅'과 'R&R' 항목에서는 서로의 기대치가 달라, 향후 ",
                        ),
                        TextSpan(
                          text: "잠재적 분쟁 리스크(Potential Risk)",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text:
                              "가 감지되었습니다. CoSync의 누적 데이터를 참고하여 간극을 좁히는 과정이 필요합니다.",
                        ),
                      ],
                    ),
                  ),
                ),
                if (isMobile) const SizedBox(height: 16),
                if (!isMobile) const SizedBox(width: 24),
                // Badges
                Builder(
                  builder: (context) {
                    final badges = [
                      _buildSummaryBadge(
                        "R&R",
                        "조율 필요",
                        Colors.yellow[800]!,
                        Colors.yellow[600]!,
                      ), // Approximate yellow styling
                      _buildSummaryBadge(
                        "베스팅",
                        "Risk 높음",
                        Colors.red[800]!,
                        Colors.red[600]!,
                      ),
                      _buildSummaryBadge(
                        "Bad Leaver",
                        "의견 일치",
                        Colors.green[800]!,
                        Colors.green[600]!,
                      ),
                    ];

                    if (isMobile) {
                      return SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 8,
                          runSpacing: 8,
                          children: badges,
                        ),
                      );
                    }

                    return Wrap(spacing: 8, runSpacing: 8, children: badges);
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSummaryBadge(
    String label,
    String status,
    Color textColor,
    Color statusColor,
  ) {
    return SizedBox(
      width: 93,
      height: 88,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey[100]!), // border-gray-100
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 1),
              blurRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
            const SizedBox(height: 6),
            Text(
              status,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection1(BuildContext context, bool isMobile) {
    return _buildDetailBase(
      context,
      isMobile,
      topic: "Topic 01",
      title: "역할 및 책임 (R&R)",
      badge: _buildStatusBadge(
        "Insight: 데이터 기반 리스크",
        const Color(0xFFFEF3C7),
        const Color(0xFF92400E),
      ), // yellow
      userAContent: "경영/기획 총괄. 개발 결정권은 위임하되, 경영권 확보 필요.",
      userBContent: "개발 전권. 기획 단계에서의 기술적 거부권(Veto) 희망.",
      userBHighlight: "기술적 거부권(Veto)",
      marketStandard:
          "시장 표준 R&R: 경영/자금은 CEO 전결(100%), 기술 스택은 CTO 전결(100%). 단, 제품 로드맵은 5:5 합의를 원칙으로 하되, 데드락(Deadlock) 발생 시 CEO가 캐스팅 보트(Casting Vote)를 행사하는 구조가 일반적입니다.",
      insight:
          "CoSync의 누적 체결 데이터 15,000건 분석 결과, 초기 스타트업의 82%는 C-Level 간 '전결권'을 명확히 분리하고 있습니다. 특히 B님이 희망하시는 <strong>'기술적 거부권(Veto)'</strong>을 설정한 팀은 그렇지 않은 팀 대비 의사결정 시간이 <strong>평균 3.4배</strong> 더 소요되는 것으로 나타나, 데이터상으로는 '협의' 조항으로의 완화가 권장됩니다.",
      agreement:
          "경영/자금은 CEO, 기술은 CTO 전결. 제품 로드맵은 상호 합의하되 데드락 발생 시 CEO가 최종 결정권(Casting Vote)을 행사합니다.",
    );
  }

  Widget _buildDetailSection2(BuildContext context, bool isMobile) {
    return _buildDetailBase(
      context,
      isMobile,
      topic: "Topic 02",
      title: "베스팅(Vesting) 기간",
      badge: _buildStatusBadge(
        "Insight: 투자 유치 적합성 우려",
        const Color(0xFFFEE2E2),
        const Color(0xFF991B1B),
      ), // red
      userAContent: "신뢰 기반, 기간 없이 즉시 100% 인정 희망.",
      userAHighlight: "즉시 100% 인정",
      userBContent: "이탈 대비 4년 베스팅 적용 필요.",
      userBHighlight: "4년 베스팅",
      marketStandard:
          "VC 투자 표준: 총 4년(48개월) 베스팅. 최초 1년 클리프(Cliff) 근무 시 지분의 25%를 일괄 인정하고, 이후 3년간 매월 1/48(약 2.08%)씩 분할 귀속시키는 조건이 가장 보편적입니다.",
      insight:
          "CoSync를 통해 후속 투자를 유치한 팀의 <strong>96%</strong>가 '베스팅(Vesting)' 조항을 보유하고 있었습니다. A님의 '베스팅 없음(즉시 100% 인정)' 의견은 전체 데이터의 <strong>하위 2%</strong>에 해당하며, 이는 투자 유치 실패율을 40% 이상 높이는 리스크 요인으로 집계됩니다. 데이터 기반의 안전한 의사결정이 필요합니다.",
      agreement:
          "양측 의견을 절충하여 '총 3년(36개월) 베스팅'으로 단축하되, 1년 Cliff(필수 근속) 조건은 유지하여 상호 신뢰와 안전장치를 확보합니다.",
    );
  }

  Widget _buildDetailSection3(BuildContext context, bool isMobile) {
    return _buildDetailBase(
      context,
      isMobile,
      topic: "Topic 03",
      title: "이탈 시 지분 처리 (Bad Leaver)",
      badge: _buildStatusBadge(
        "Insight: 높은 합의 일치도",
        const Color(0xFFDCFCE7),
        const Color(0xFF166534),
      ), // green
      userAContent: "징계 해고/배임 시 액면가로 전량 회수.",
      userBContent: "액면가 회수 조항 삽입.",
      marketStandard:
          "Bad Leaver(횡령, 배임 등) 확정 시, 보유 지분 100%를 '액면가'로 콜옵션(Call Option). 단순 변심 등(Good Leaver)의 경우, 근속 기간에 비례해 베스팅된 지분은 인정하되 잔여 지분만 무상 회수합니다.",
      insight:
          "CoSync 사용자 중 <strong>86%</strong>가 동의한 '표준 합의(Consensus)' 항목입니다. 배임, 횡령 등의 명백한 귀책사유에 대해서는 예외 없이 <strong>'액면가 회수'</strong>를 적용하는 것이 압도적인 데이터 표준이며, 두 분의 의견 또한 이 데이터 트렌드와 정확히 일치합니다.",
      agreement:
          "Bad Leaver 발생 시 지분 100%를 액면가로 회수하고, Good Leaver는 근속 기간에 따라 베스팅된 지분만 인정하는 표준안에 합의합니다.",
    );
  }

  Widget _buildDetailBase(
    BuildContext context,
    bool isMobile, {
    required String topic,
    required String title,
    required Widget badge,
    required String userAContent,
    String? userAHighlight,
    required String userBContent,
    String? userBHighlight,
    required String marketStandard,
    required String insight,
    required String agreement,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: isMobile ? 360 : 340),
      child: Container(
        padding: EdgeInsets.all(isMobile ? 20 : 32),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flex(
              direction: isMobile ? Axis.vertical : Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E8F0), // bg-slate-200
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        topic,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF334155), // text-slate-700
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: isMobile ? 16 : 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                  ],
                ),
                if (isMobile) const SizedBox(height: 8),
                badge,
              ],
            ),
            const SizedBox(height: 24),
            // User Inputs
            if (isMobile)
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: _buildUserInputBox(
                      "User A (CEO) 의견",
                      userAContent,
                      userAHighlight,
                      Colors.red,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: _buildUserInputBox(
                      "User B (CTO) 의견",
                      userBContent,
                      userBHighlight,
                      title == "역할 및 책임 (R&R)" ? Colors.red : Colors.blue,
                    ),
                  ),
                ],
              )
            else
              Row(
                children: [
                  Expanded(
                    child: _buildUserInputBox(
                      "User A (CEO) 의견",
                      userAContent,
                      userAHighlight,
                      Colors.red,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildUserInputBox(
                      "User B (CTO) 의견",
                      userBContent,
                      userBHighlight,
                      title == "역할 및 책임 (R&R)" ? Colors.red : Colors.blue,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            // Market Standard
            _buildInfoBox(
              title: "시장 표준 제안 (Reference)",
              icon: Icons.balance,
              content: marketStandard,
              bgColor: const Color(0xFFF8FAFC),
              borderColor: const Color(0xFF64748B),
              titleColor: const Color(0xFF475569),
            ),
            const SizedBox(height: 16),
            // Insight
            _buildInfoBox(
              title: "CoSync 룰북 데이터 분석",
              icon: Icons.storage,
              content: insight,
              bgColor: const Color(0xFFEFF6FF), // bg-blue-50
              borderColor: const Color(0xFF3B82F6), // border-blue-500
              titleColor: const Color(0xFF1E40AF),
              isHtmlLike: true, // simplified rich text handling
            ),
            const SizedBox(height: 16),
            // Agreement
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFF0FDF4),
                border: Border(
                  left: BorderSide(color: Color(0xFF16A34A), width: 4),
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(4),
                ), // slightly rounded
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 16,
                        color: Color(0xFF166534),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "최종 합의안 (Ver 1.0)",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF166534),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    agreement,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF374151),
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInputBox(
    String title,
    String content,
    String? highlight,
    Color highlightColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 14, color: Color(0xFF374151)),
              children: _buildRichTextWithTerms(
                content,
                baseStyle: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF374151),
                ),
                highlight: highlight,
                highlightColor: highlightColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox({
    required String title,
    required IconData icon,
    required String content,
    required Color bgColor,
    required Color borderColor,
    required Color titleColor,
    bool isHtmlLike = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(left: BorderSide(color: borderColor, width: 4)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 14,
                color: titleColor,
              ), // FontAwesome icons are usually small here
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF4B5563),
                height: 1.6,
              ), // text-gray-600
              children: _buildRichTextWithTerms(
                content,
                baseStyle: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF4B5563),
                  height: 1.6,
                ),
                parseStrong: isHtmlLike,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildDisclaimer(BuildContext context, bool isMobile) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 32,
        vertical: 16,
      ),
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB), // bg-gray-200
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "[면책 조항]",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Color(0xFF6B7280),
            ),
          ),
          Text(
            "본 문서는 데이터를 바탕으로 시장의 통상적인 사례와 트렌드를 제공하는 정보성 자료입니다. CoSync는 법무법인이 아니며, 본 리포트의 내용은 법률적 자문이나 유권해석을 구성하지 않습니다. 실제 주주간계약 체결 시에는 변호사 등 법률 전문가의 검토를 거치시기를 권고드립니다.",
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, bool isMobile) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        isMobile ? 24 : 32,
        24,
        isMobile ? 24 : 32,
        48,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Column(
        children: [
          Text(
            "분석된 리스크를 보완하는 '맞춤형 합의서'이 필요하신가요?",
            style: TextStyle(
              fontSize: isMobile ? 16 : 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F2937),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            "시장 표준 데이터를 반영하여 두 분의 의견 차이를 좁힌\n합의서(주주간계약서 초안)를 확인해보세요.",
            style: TextStyle(fontSize: 14, color: Color(0xFF4B5563)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: isMobile ? double.infinity : null,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E293B), // bg-slate-800
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9999), // rounded-full
                ),
                elevation: 4,
              ),
              child: const Text(
                "주주간계약서 초안 생성하기",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Copyright © 2024 CoSync. All rights reserved.",
            style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}

class TermTooltip extends StatelessWidget {
  final String term;
  final String meaning;
  final TextStyle? style;
  final String? display;

  const TermTooltip({
    super.key,
    required this.term,
    required this.meaning,
    this.style,
    this.display,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle =
        style ??
        const TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
          decorationStyle: TextDecorationStyle.solid,
        );
    return Tooltip(
      message: meaning,
      waitDuration: const Duration(milliseconds: 250),
      child: InkWell(
        onTap: () => showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(term),
            content: Text(meaning),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("닫기"),
              ),
            ],
          ),
        ),
        child: Text(
          display ?? term,
          style: textStyle.copyWith(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
            decorationStyle: TextDecorationStyle.solid,
          ),
        ),
      ),
    );
  }
}

const Map<String, String> _termMeanings = {
  "베스팅(Vesting)":
      "공동창업자의 지분을 한 번에 주지 않고, 일정 기간 일할 때마다 조금씩 내 지분이 확정되는 제도. 팀에 오래 남아 함께 하자는 안전장치.",
  "클리프(Cliff)":
      "베스팅을 시작할 때 '최초 확정' 구간. 예를 들어 1년 클리프면 1년을 채워야 첫 25% 지분이 한 번에 확정되고, 이후 매달/매분기 조금씩 추가 확정.",
  "데드락(Deadlock)": "의사결정이 완전히 막힌 상태. 서로 합의가 안 되어 회사가 멈춰버리는 상황.",
  "캐스팅 보트(Casting Vote)":
      "표가 동률일 때 최종 결정권. 예를 들어 CEO가 캐스팅 보트를 가지면 의견이 반반일 때 CEO가 최종 결정.",
  "최종 결정권(Casting Vote)":
      "표가 동률일 때 최종 결정권. 예를 들어 CEO가 캐스팅 보트를 가지면 의견이 반반일 때 CEO가 최종 결정.",
  "콜옵션(Call Option)":
      "특정 조건에서 회사가 지분을 정해진 가격(주로 액면가)으로 사올 수 있는 권리. 문제가 있는 퇴사자 지분을 회수할 때 쓰임.",
  "Bad Leaver": "배임·횡령 같은 중대한 잘못으로 퇴사한 사람. 보통 이 경우 지분을 싸게(액면가 등) 회수하는 조항을 둠.",
  "Good Leaver":
      "정상적 사유(개인 사정, 건강, 성과 문제 아님 등)로 퇴사한 사람. 이미 근속하며 확정된 지분은 인정하되, 남은 미확정 지분만 회수하는 식으로 보호.",
};

const Map<String, String> _termDisplay = {
  "베스팅(Vesting)": "베스팅(Vesting)",
  "베스팅": "베스팅(Vesting)",
  "클리프(Cliff)": "클리프(Cliff)",
  "Cliff": "클리프(Cliff)",
  "데드락(Deadlock)": "데드락(Deadlock)",
  "캐스팅 보트(Casting Vote)": "최종 결정권(Casting Vote)",
  "최종 결정권(Casting Vote)": "최종 결정권(Casting Vote)",
  "Casting Vote": "최종 결정권(Casting Vote)",
  "콜옵션(Call Option)": "콜옵션(Call Option)",
  "Call Option": "콜옵션(Call Option)",
  "Bad Leaver": "배드 리버(Bad Leaver)",
  "Good Leaver": "굿 리버(Good Leaver)",
};

List<InlineSpan> _buildRichTextWithTerms(
  String text, {
  TextStyle? baseStyle,
  bool parseStrong = false,
  String? highlight,
  Color? highlightColor,
}) {
  final style = baseStyle ?? const TextStyle(color: Colors.black);
  final List<InlineSpan> spans = [];

  // handle <strong> ... </strong>
  if (parseStrong) {
    final exp = RegExp(r"<strong>(.*?)<\/strong>");
    int lastIndex = 0;
    for (final m in exp.allMatches(text)) {
      if (m.start > lastIndex) {
        spans.addAll(
          _buildTermSpans(text.substring(lastIndex, m.start), style),
        );
      }
      spans.addAll(
        _buildTermSpans(
          m.group(1) ?? "",
          style.copyWith(fontWeight: FontWeight.bold),
        ),
      );
      lastIndex = m.end;
    }
    if (lastIndex < text.length) {
      spans.addAll(_buildTermSpans(text.substring(lastIndex), style));
    }
  } else {
    spans.addAll(
      _buildTermSpans(
        text,
        style,
        highlight: highlight,
        highlightColor: highlightColor,
      ),
    );
  }

  return spans;
}

List<InlineSpan> _buildTermSpans(
  String text,
  TextStyle style, {
  String? highlight,
  Color? highlightColor,
}) {
  final List<InlineSpan> result = [];
  final termsPattern =
      r"(베스팅\(Vesting\)|베스팅|클리프\(Cliff\)|Cliff|데드락\(Deadlock\)|캐스팅 보트\(Casting Vote\)|최종 결정권\(Casting Vote\)|Casting Vote|콜옵션\(Call Option\)|Call Option|Bad Leaver|Good Leaver)";
  final reg = RegExp(termsPattern);

  int last = 0;
  for (final m in reg.allMatches(text)) {
    if (m.start > last) {
      result.add(
        _maybeHighlightSpan(
          text.substring(last, m.start),
          style,
          highlight: highlight,
          highlightColor: highlightColor,
        ),
      );
    }
    final term = m.group(0)!;
    final meaning = _termMeanings[term];
    if (meaning != null) {
      result.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.baseline,
          baseline: TextBaseline.alphabetic,
          child: TermTooltip(
            term: term,
            meaning: meaning,
            display: _termDisplay[term] ?? term,
            style: style.copyWith(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              decorationStyle: TextDecorationStyle.solid,
            ),
          ),
        ),
      );
    } else {
      result.add(TextSpan(text: term, style: style));
    }
    last = m.end;
  }
  if (last < text.length) {
    result.add(
      _maybeHighlightSpan(
        text.substring(last),
        style,
        highlight: highlight,
        highlightColor: highlightColor,
      ),
    );
  }
  return result;
}

InlineSpan _maybeHighlightSpan(
  String text,
  TextStyle style, {
  String? highlight,
  Color? highlightColor,
}) {
  if (highlight != null && text.contains(highlight)) {
    final parts = text.split(highlight);
    final spans = <InlineSpan>[];
    for (int i = 0; i < parts.length; i++) {
      spans.add(TextSpan(text: parts[i], style: style));
      if (i != parts.length - 1) {
        spans.add(
          TextSpan(
            text: highlight,
            style: style.copyWith(
              fontWeight: FontWeight.bold,
              color: highlightColor ?? style.color,
            ),
          ),
        );
      }
    }
    return TextSpan(children: spans);
  }
  return TextSpan(text: text, style: style);
}
