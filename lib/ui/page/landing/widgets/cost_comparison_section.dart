import 'package:flutter/material.dart';
import 'package:flutter_demo/ui/widgets/responsive_layout.dart';

class CostComparisonSection extends StatelessWidget {
  const CostComparisonSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      color: Colors.white,
      child: Column(
        children: [
          // Header
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontSize: ResponsiveLayout.isMobile(context) ? 28 : 40,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0F172A),
                height: 1.3,
                fontFamily: 'Pretendard', // Assuming default font
              ),
              children: [
                const TextSpan(text: "계약서를 안 써서 아낀 "),
                TextSpan(
                  text: "500만 원",
                  style: TextStyle(color: Colors.blue[600]),
                ),
                const TextSpan(text: ",\n그 대가는 얼마일까요?"),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "많은 팀이 비용을 아끼려다, 더 큰 기회를 놓치고 있습니다.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ResponsiveLayout.isMobile(context) ? 16 : 18,
              color: const Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 60),

          // Cards Layout
          LayoutBuilder(
            builder: (context, constraints) {
              bool isDesktop = ResponsiveLayout.isDesktop(context);

              return IntrinsicHeight(
                child: Flex(
                  direction: isDesktop ? Axis.horizontal : Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Left Card: Perceived Cost (Lawyer)
                    Container(
                      width: isDesktop ? 500 : double.infinity,
                      // height: isDesktop ? 520 : null, // Removed fixed height to let IntrinsicHeight handle it
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.error_outline_rounded,
                                color: Colors.grey[500],
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "많은 팀이 착각하는 비용",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "\"변호사 비용, 부담스러운대...\"",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF334155),
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 40),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              vertical: 32,
                              horizontal: 24,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text("💰 "),
                                    Text(
                                      "주주간계약서 작성 평균 비용",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  "약 300 ~ 700만 원",
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          const SizedBox(height: 32),
                          Text(
                            "\"아직 초기라 계약서까지는...\", \"관계가 어색해질까 봐\"라는 이유로 작성을 미룹니다.",
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.6,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (!isDesktop)
                      const SizedBox(height: 24)
                    else
                      const SizedBox(width: 32),

                    // Right Card: Hidden Cost (Real)
                    Container(
                      width: isDesktop ? 600 : double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF1F2), // Light Red/Pink
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.add_alert_rounded,
                                color: Colors.red[400],
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "진짜 비용 (HIDDEN COST)",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "\"합의 지연으로 사라지는 시간\"",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF991B1B), // Dark Red
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 40),

                          // List Items
                          _buildHiddenCostItem(
                            icon: Icons.hourglass_empty_rounded,
                            title: "의사결정 지연: 평균 3~6개월",
                            desc: "핵심 합의 미정으로 인한 성장 정체",
                          ),
                          const SizedBox(height: 16),
                          _buildHiddenCostItem(
                            icon: Icons.cancel_outlined,
                            title: "투자 미팅 종료 (Deal Breaker)",
                            desc: "투자 검토 단계에서 합의 구조 불명확 시 탈락",
                          ),
                          const SizedBox(height: 16),
                          _buildHiddenCostItem(
                            icon: Icons.money_off_csred_rounded,
                            title: "재정비 비용: 수천만 ~ 수억 원",
                            desc: "공동창업자 이탈 및 법적 분쟁 발생 시",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHiddenCostItem({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            child: Icon(icon, color: Colors.red[400], size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[900],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.red[300],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
