import 'package:flutter/material.dart';
import 'package:flutter_demo/ui/widgets/responsive_layout.dart';

class RulebookSection extends StatelessWidget {
  const RulebookSection({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    // This uses the Super Compact layout I just implemented
    return Container(
      color: Colors.grey[50],
      // Increased top padding to prevent content from being cut off by the navbar
      padding: EdgeInsets.fromLTRB(
        24,
        isMobile ? 100 : 80,
        24,
        isMobile ? 32 : 80,
      ),
      child: Center(
        child: Wrap(
          spacing: 60,
          // Reduced runSpacing to minimize gap between text and card on mobile
          runSpacing: isMobile ? 16 : 40,
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            // Text Content
            SizedBox(
              width: isMobile ? double.infinity : 540,
              child: Column(
                // Ensure text block is vertically centered if it has extra space
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "FINAL OUTPUT",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      fontSize: isMobile ? 12 : 14,
                    ),
                  ),
                  SizedBox(height: isMobile ? 12 : 16),
                  Text(
                    "말뿐인 약속은 잊혀집니다.\n'공동창업자 Rulebook'으로 기록하세요.",
                    style: TextStyle(
                      fontSize: isMobile ? 28 : 36,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: isMobile ? 16 : 24),
                  Text(
                    "동업계약서 쓰기엔 너무 딱딱하고, 말로만 하기엔 불안하신가요? CoSync는 합의된 내용을 바탕으로 우리 팀만의 헌법, [Rulebook.pdf]를 생성해 드립니다.",
                    style: TextStyle(
                      fontSize: isMobile ? 15 : 18,
                      color: const Color(0xFF475569),
                      height: 1.6,
                    ),
                  ),
                  SizedBox(height: isMobile ? 24 : 32),
                  _checkItem("Mission & Vision (우리가 모인 이유)", isMobile),
                  _checkItem("R&R (명확한 역할과 책임)", isMobile),
                  _checkItem("Compensation (지분 및 급여)", isMobile),
                  _checkItem("Decision Making (의사결정 구조)", isMobile),
                  _checkItem("Exit Plan (아름다운 이별의 조건)", isMobile),
                ],
              ),
            ),
            // Document Preview
            Transform.rotate(
              angle: -0.05,
              child: Container(
                width: isMobile ? double.infinity : 460,
                constraints: BoxConstraints(minHeight: isMobile ? 400 : 500),
                padding: EdgeInsets.all(isMobile ? 24 : 32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Co-founder Rulebook",
                              style: TextStyle(
                                fontSize: isMobile ? 18 : 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Serif',
                              ),
                            ),
                            const Text(
                              "Ver 1.0 | 2025.05.20",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.description,
                          color: Colors.grey[300],
                          size: isMobile ? 24 : 32,
                        ),
                      ],
                    ),
                    Divider(height: isMobile ? 16 : 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _docSection(
                          "Chapter 3. Equity & Vesting",
                          "제3조 (지분 및 베스팅)",
                          "공동창업자 김민준, 이강인은 총 4년의 베스팅 기간을 설정하며...",
                          isMobile,
                        ),
                        SizedBox(height: isMobile ? 12 : 16),
                        _docSection(
                          "Chapter 5. Exit Plan",
                          "제5조 (이탈 조건)",
                          "자발적 퇴사의 경우 보유 지분의 50%를 액면가로 회사에 반환하며...",
                          isMobile,
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
    );
  }

  Widget _checkItem(String text, bool isMobile) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.blue,
            size: isMobile ? 18 : 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: isMobile ? 14 : 16,
                color: const Color(0xFF334155),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _docSection(
    String subtitle,
    String title,
    String content,
    bool isMobile,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: isMobile ? 16 : 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(isMobile ? 12 : 16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Text(
            content,
            style: TextStyle(
              fontSize: isMobile ? 13 : 14,
              color: const Color(0xFF64748B),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
