import 'package:flutter/material.dart';
import 'package:flutter_demo/ui/widgets/responsive_layout.dart';

class RadarSection extends StatelessWidget {
  const RadarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Center(
        child: Container(
          // constraints: const BoxConstraints(maxWidth: 1200),
          child: Wrap(
            spacing: 48,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              // Radar Card
              Container(
                width: ResponsiveLayout.isMobile(context)
                    ? double.infinity
                    : 400,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                    ),
                  ],
                  border: Border.all(color: Colors.grey[100]!),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.show_chart, size: 64, color: Colors.blue),
                    const SizedBox(height: 24),
                    _riskItem("💰 보상/지분 합의", "안정적 (95점)", Colors.green),
                    const SizedBox(height: 12),
                    _riskItem("🚪 Exit / 이탈 조건", "위험 (32점)", Colors.red),
                    const SizedBox(height: 12),
                    _riskItem("🎯 비전 일치도", "보통 (70점)", Colors.orange),
                  ],
                ),
              ),
              // Text Content
              SizedBox(
                width: 500,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "RISK RADAR",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                          height: 1.2,
                        ),
                        children: [
                          TextSpan(text: "팀의 안정성을 점수로 관리하세요.\n"),
                          TextSpan(
                            text: "Team Stability Score",
                            style: TextStyle(color: Colors.grey, fontSize: 24),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "'그냥 느낌이 좀 쎄한데?'라는 감을 데이터로 확인시켜 드립니다.\n자금, 비전, 역할, 이탈 조건 등 5가지 핵심 영역을 시각화하여 어디서 갈등이 터질지 미리 예측하고 방어합니다.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF475569),
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _riskItem(String label, String score, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(0xFF334155),
            ),
          ),
          Text(
            score,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}
