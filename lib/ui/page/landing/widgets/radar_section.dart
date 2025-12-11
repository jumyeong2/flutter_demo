import 'package:flutter/material.dart';
import 'package:flutter_demo/ui/widgets/responsive_layout.dart';

class RadarSection extends StatelessWidget {
  const RadarSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 32 : 80,
        horizontal: 24,
      ),
      child: Center(
        child: Wrap(
          spacing: 60,
          runSpacing: isMobile ? 32 : 40,
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            // Radar Card
            Container(
              width: isMobile ? double.infinity : 460,
              padding: EdgeInsets.all(isMobile ? 24 : 40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 30,
                  ),
                ],
                border: Border.all(color: Colors.grey[100]!),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.show_chart,
                    size: isMobile ? 60 : 80,
                    color: Colors.blue,
                  ),
                  SizedBox(height: isMobile ? 24 : 32),
                  _riskItem("💰 보상/지분 합의", "안정적 (95점)", Colors.green, isMobile),
                  SizedBox(height: isMobile ? 12 : 16),
                  _riskItem(
                    "🚪 Exit / 이탈 조건",
                    "위험 (32점)",
                    Colors.red,
                    isMobile,
                  ),
                  SizedBox(height: isMobile ? 12 : 16),
                  _riskItem("🎯 비전 일치도", "보통 (70점)", Colors.orange, isMobile),
                ],
              ),
            ),
            // Text Content
            SizedBox(
              width: isMobile ? double.infinity : 540,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "RISK RADAR",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      fontSize: isMobile ? 12 : 14,
                    ),
                  ),
                  SizedBox(height: isMobile ? 12 : 16),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: isMobile ? 28 : 36,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0F172A),
                        height: 1.2,
                      ),
                      children: [
                        const TextSpan(text: "팀의 안정성을 점수로 관리하세요.\n"),
                        TextSpan(
                          text: "Team Stability Score",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: isMobile ? 20 : 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: isMobile ? 16 : 24),
                  Text(
                    "'그냥 느낌이 좀 쎄한데?'라는 감을 데이터로 확인시켜 드립니다.\n자금, 비전, 역할, 이탈 조건 등 5가지 핵심 영역을 시각화하여 어디서 갈등이 터질지 미리 예측하고 방어합니다.",
                    style: TextStyle(
                      fontSize: isMobile ? 15 : 18,
                      color: const Color(0xFF475569),
                      height: 1.6,
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

  Widget _riskItem(String label, String score, Color color, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: isMobile ? 12 : 16,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isMobile ? 14 : 16,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF334155),
            ),
          ),
          Text(
            score,
            style: TextStyle(
              fontSize: isMobile ? 14 : 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
