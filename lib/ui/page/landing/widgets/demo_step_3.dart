import 'package:flutter/material.dart';

class DemoStep3 extends StatelessWidget {
  const DemoStep3({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _optionCard(
          "Option A. 표준형 (Standard)",
          "1년 미만 퇴사 시 지분 전량 회수. 대신 급여 소급 지급 조항 추가.",
          false,
        ),
        const SizedBox(height: 12),
        _optionCard(
          "Option B. 마일스톤 연동형 (Hybrid)",
          "기본적으로 1년 클리프를 적용하되, MVP 런칭 마일스톤 달성 시 5% 지분 인정.",
          true,
        ),
      ],
    );
  }

  Widget _optionCard(String title, String desc, bool isRecommended) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isRecommended ? Colors.blue[50] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isRecommended ? Colors.blue : Colors.grey[200]!,
        ),
        boxShadow: isRecommended
            ? [
                BoxShadow(
                  color: Colors.blue.withValues(alpha: 0.1),
                  blurRadius: 8,
                ),
              ]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isRecommended)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(Icons.psychology, size: 14, color: Colors.blue[700]),
                  const SizedBox(width: 4),
                  Text(
                    "AI 추천",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                ],
              ),
            ),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: isRecommended ? Colors.blue[900] : Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            desc,
            style: TextStyle(
              fontSize: 12,
              color: isRecommended ? Colors.blue[800] : Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
