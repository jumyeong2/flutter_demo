import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_demo/ui/widgets/responsive_layout.dart';
import '../x_landing_controller.dart';
import 'demo_step_1.dart';
import 'demo_step_2.dart';
import 'demo_step_3.dart';

class DemoSection extends StatelessWidget {
  const DemoSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Get controller
    final controller = Get.find<LandingController>();

    // Define steps here
    final List<Map<String, dynamic>> demoSteps = [
      {
        "title": "1단계: 심층 진단 (Deep Dive)",
        "desc": "가장 민감한 '이탈 조건'에 대해 각자의 솔직한 생각을 입력합니다.",
        "content": const DemoStep1(),
      },
      {
        "title": "2단계: 리스크 시각화 (Risk Radar)",
        "desc": "답변 데이터를 분석하여 조율이 필요한 부분을 시각화합니다.",
        "content": const DemoStep2(),
      },
      {
        "title": "3단계: AI 중재안 (Solution)",
        "desc": "업계 표준 데이터와 양측의 입장을 고려한 구체적인 절충안을 제시합니다.",
        "content": const DemoStep3(),
      },
    ];

    bool isMobile = ResponsiveLayout.isMobile(context);
    return Container(
      color: Colors.grey[50],
      padding: EdgeInsets.symmetric(
        vertical: 24, // Reduced from 48
        horizontal: isMobile ? 16 : 24,
      ),
      child: Column(
        children: [
          const Text(
            "어떻게 합의하는지 미리 보세요",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 8), // Reduced from 16
          const Text(
            "30분이면 갈등을 예방하는 과정을 체험할 수 있습니다.",
            style: TextStyle(fontSize: 16, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 16), // Reduced from 24
          Container(
            // constraints: const BoxConstraints(maxWidth: 1024),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
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
                // Header
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 16 : 24,
                    vertical: 12, // Reduced from 16
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[100]!),
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          _circle(Colors.grey[300]!),
                          const SizedBox(width: 8),
                          _circle(Colors.grey[300]!),
                          const SizedBox(width: 8),
                          _circle(Colors.grey[300]!),
                        ],
                      ),
                      const Spacer(),
                      const Text(
                        "Team_Rulebook_Generator",
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                // Body
                Padding(
                  padding: EdgeInsets.all(
                    isMobile ? 12 : 24,
                  ), // Reduced from 16/40
                  child: Column(
                    children: [
                      // Steps
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _demoStepButton(0, "진단", controller),
                            _demoStepButton(1, "시각화", controller),
                            _demoStepButton(2, "AI중재", controller),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16), // Reduced from 32
                      // Content
                      Obx(
                        () => Container(
                          padding: const EdgeInsets.all(
                            16,
                          ), // Reduced/Fixed at 16
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[100]!),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                demoSteps[controller.demoStep.value]['title'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                demoSteps[controller.demoStep.value]['desc'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                              const SizedBox(height: 12), // Reduced from 24
                              demoSteps[controller.demoStep.value]['content']
                                  as Widget,
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8), // Reduced from 24
                      TextButton.icon(
                        onPressed: () {
                          controller.setDemoStep(
                            (controller.demoStep.value + 1) % 3,
                          );
                        },
                        icon: const Icon(Icons.chevron_right, size: 16),
                        label: const Text("다음 단계 미리보기"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _circle(Color color) => Container(
    width: 12,
    height: 12,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );

  Widget _demoStepButton(
    int index,
    String label,
    LandingController controller,
  ) {
    // Note: We access controller.demoStep inside Obx in the parent,
    // but here we are passing arguments. For reactivity on 'isActive', this widget
    // might need to wrap its content in Obx or be stateless and rebuilt.
    // In the extracted code, the parent calls this inside Obx()!
    // So when demoStep changes, parent rebuilds and calls this again with new state?
    // Wait, the parent has `Obx(() => Row( ... _demoStepButton ... ))`.
    // Inside `_demoStepButton`, we check `controller.demoStep.value == index`.
    // This access is synchronous. Since parent is Obx, it tracks observables accessed during build.
    // If `_demoStepButton` accesses it immediately, it's tracked.
    bool isActive = controller.demoStep.value == index;
    return GestureDetector(
      onTap: () => controller.setDemoStep(index),
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isActive ? Colors.blue[600] : Colors.grey[100],
              shape: BoxShape.circle,
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: Colors.blue.withValues(alpha: 0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ]
                  : [],
            ),
            child: Center(
              child: Text(
                "${index + 1}",
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.grey[500],
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isActive ? Colors.blue[600] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
