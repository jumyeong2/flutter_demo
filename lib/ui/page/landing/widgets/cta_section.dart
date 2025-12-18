import 'package:flutter/material.dart';
import 'package:flutter_demo/ui/widgets/responsive_layout.dart';
import 'package:get/get.dart';
import '../landing_controller.dart';

class CtaSection extends StatelessWidget {
  const CtaSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LandingController>();
    return Container(
      color: const Color(0xFF0F172A),
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      width: double.infinity,
      child: Column(
        children: [
          Text(
            "건강한 팀만이\n유니콘이 될 수 있습니다.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ResponsiveLayout.isMobile(context) ? 28 : 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "지금의 껄끄러움이 나중의 소송을 막습니다.\n가장 합리적인 비용으로 팀의 안전장치를 마련하세요.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ResponsiveLayout.isMobile(context) ? 14 : 18,
              color: Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: controller.startTrial,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("공동창업 합의서 (Draft) 만들기"),
          ),
        ],
      ),
    );
  }
}
