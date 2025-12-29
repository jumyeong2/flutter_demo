import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_demo/ui/widgets/responsive_layout.dart';
import '../x_landing_controller.dart';

class LandingNavbar extends StatelessWidget {
  const LandingNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LandingController>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo and Title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.blueGrey[900],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.psychology,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                "CoSync",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          // Navigation Links (Desktop only, Tablet uses menu)
          if (ResponsiveLayout.isDesktop(context))
            Row(
              children: [
                _navLink("프로세스"),
                _navLink("리스크 진단"),
                _navLink("공동창업 합의서란?"),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: controller.startTrial,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F172A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "팀 Rulebook 만들기",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 40),
              ],
            )
          // Menu Button (Mobile)
          else
            Obx(
              () => IconButton(
                icon: Icon(
                  controller.isMenuOpen.value ? Icons.close : Icons.menu,
                ),
                onPressed: controller.toggleMenu,
              ),
            ),
        ],
      ),
    );
  }

  Widget _navLink(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.grey[600],
        ),
      ),
    );
  }
}
