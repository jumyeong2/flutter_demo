import 'package:flutter/material.dart';
import 'package:flutter_demo/ui/widgets/responsive_layout.dart';

class RulebookSection extends StatelessWidget {
  const RulebookSection({super.key});

  @override
  Widget build(BuildContext context) {
    // This uses the Super Compact layout I just implemented
    // This uses the Super Compact layout I just implemented
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Center(
        child: Wrap(
          spacing: 60,
          runSpacing: 40,
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            // Text Content
            SizedBox(
              width: 540,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "FINAL OUTPUT",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "말뿐인 약속은 잊혀집니다.\n'공동창업자 Rulebook'으로 기록하세요.",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "동업계약서 쓰기엔 너무 딱딱하고, 말로만 하기엔 불안하신가요? CoSync는 합의된 내용을 바탕으로 우리 팀만의 헌법, [Rulebook.pdf]를 생성해 드립니다.",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF475569),
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _checkItem("Mission & Vision (우리가 모인 이유)"),
                  _checkItem("R&R (명확한 역할과 책임)"),
                  _checkItem("Compensation (지분 및 급여)"),
                  _checkItem("Decision Making (의사결정 구조)"),
                  _checkItem("Exit Plan (아름다운 이별의 조건)"),
                ],
              ),
            ),
            // Document Preview
            Transform.rotate(
              angle: -0.05,
              child: Container(
                width: ResponsiveLayout.isMobile(context)
                    ? double.infinity
                    : 460,
                constraints: const BoxConstraints(minHeight: 500),
                padding: const EdgeInsets.all(32),
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
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Co-founder Rulebook",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Serif',
                              ),
                            ),
                            Text(
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
                          size: 32,
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _docSection(
                          "Chapter 3. Equity & Vesting",
                          "제3조 (지분 및 베스팅)",
                          "공동창업자 김민준, 이강인은 총 4년의 베스팅 기간을 설정하며...",
                        ),
                        const SizedBox(height: 16),
                        _docSection(
                          "Chapter 5. Exit Plan",
                          "제5조 (이탈 조건)",
                          "자발적 퇴사의 경우 보유 지분의 50%를 액면가로 회사에 반환하며...",
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

  Widget _checkItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.blue, size: 20),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF334155),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _docSection(String subtitle, String title, String content) {
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
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
