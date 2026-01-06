import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_demo/ui/widgets/responsive_layout.dart';
import '../../../sample/sample_report.dart';
import '../x_landing_controller.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Note: In strict architecture, we might pass controller as an argument,
    // but Get.find is acceptable for coupled widgets in the same module.
    // However, since this is a clean extraction, let's find it.
    final controller = Get.find<LandingController>();

    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height - 80,
      ),
      color: Colors.white,
      child: Stack(
        children: [
          // Background Decoration
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                color: Colors.blue[100]!.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: 600,
              height: 600,
              decoration: BoxDecoration(
                color: Colors.indigo[100]!.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Content
          Center(
            child: Padding(
              // Increased top padding to clear fixed Navbar (approx 80px) + spacing
              // Reduced bottom padding to balance centering relative to visible area
              padding: const EdgeInsets.fromLTRB(24, 120, 24, 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.yellow[200]!),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.bolt, color: Colors.amber, size: 16),
                        const SizedBox(width: 8),
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              color: Color(0xFF334155),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(text: "지금 "),
                              TextSpan(
                                text: "12팀",
                                style: TextStyle(color: Colors.blue),
                              ),
                              TextSpan(text: "이 실시간으로 합의 중입니다"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80),
                  Text(
                    "팀이 터지기 전에 막아주는\n공동창업 리스크 관리 솔루션’ ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: ResponsiveLayout.isMobile(context) ? 28 : 40,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    "'CoSync Rulebook'",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: ResponsiveLayout.isMobile(context) ? 28 : 40,
                      fontWeight: FontWeight.w800,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    "\"우리는 서로 믿으니까 계약서는 나중에?\"",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: ResponsiveLayout.isMobile(context) ? 16 : 20,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "아니요, 믿을수록 처음부터 투명해야 합니다.\n감정 소모 없이, 데이터로 합의하세요.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: ResponsiveLayout.isMobile(context) ? 14 : 16,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 60),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: [
                      Container(
                        width: 280,
                        height: 60,
                        child: ElevatedButton.icon(
                          onPressed: controller.startTrial,
                          icon: const Icon(Icons.chevron_right),
                          label: const Text("질문 3개 체험하기 (무료)"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0F172A),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 20,
                            ),
                            textStyle: TextStyle(
                              fontSize: ResponsiveLayout.isMobile(context)
                                  ? 16
                                  : 18,
                              fontWeight: FontWeight.bold,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 280,
                        height: 60,
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              Get.to(() => const SampleReportPage()),
                          icon: const Icon(
                            Icons.description,
                            color: Colors.grey,
                          ),
                          label: const Text(
                            "샘플 리포트 보기",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF334155),
                            side: BorderSide(color: Colors.grey[400]!),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 20,
                            ),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
