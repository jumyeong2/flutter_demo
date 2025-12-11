import 'package:flutter/material.dart';
import 'package:flutter_demo/ui/widgets/responsive_layout.dart';

class ProcessSection extends StatelessWidget {
  const ProcessSection({super.key});

  @override
  Widget build(BuildContext context) {
    final steps = [
      {
        "icon": Icons.chat_bubble_outline,
        "title": "1. 진단 (Sync)",
        "desc": "단순한 설문이 아닙니다. 예민하지만 꼭 필요한 질문에 각자 답변합니다.",
      },
      {
        "icon": Icons.bar_chart,
        "title": "2. 리스크 시각화",
        "desc": "생각이 일치하는 부분과 조율이 필요한 부분을 데이터로 명확히 보여줍니다.",
      },
      {
        "icon": Icons.psychology,
        "title": "3. AI 중재안",
        "desc": "\"이런 방식은 어때요?\" 양쪽의 입장을 고려한 Option A, B, C를 제안합니다.",
      },
      {
        "icon": Icons.description_outlined,
        "title": "4. Rulebook",
        "desc": "합의된 내용을 바탕으로 법적 효력을 고려한 공동창업자 룰북을 생성합니다.",
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      color: Colors.white,
      child: Column(
        children: [
          const Text(
            "감정 싸움 없이 합의하는\n4단계 프로세스",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "코파운더 싱크는 '중간 다리' 역할을 통해 객관적인 합의를 이끌어냅니다.",
            style: TextStyle(fontSize: 16, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 32),
          LayoutBuilder(
            builder: (context, constraints) {
              bool isMobile = ResponsiveLayout.isMobile(context);
              double spacing = isMobile ? 8 : 24;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                alignment: WrapAlignment.center,
                children: steps.map((step) {
                  double width;
                  if (isMobile) {
                    width = (constraints.maxWidth - spacing) / 2;
                  } else if (ResponsiveLayout.isTablet(context)) {
                    width = (constraints.maxWidth - spacing) / 2;
                  } else {
                    width = (constraints.maxWidth - (spacing * 3)) / 4;
                  }
                  return Container(
                    width: width,
                    constraints: BoxConstraints(
                      minHeight: isMobile ? 240 : 300,
                    ),
                    padding: EdgeInsets.all(isMobile ? 16 : 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[100]!),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            step['icon'] as IconData,
                            color: Colors.blue[600],
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          step['title'] as String,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          step['desc'] as String,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF64748B),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
