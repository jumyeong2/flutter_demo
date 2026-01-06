import 'package:flutter/material.dart';
import 'package:flutter_demo/ui/page/landing/widget/email_signup_modal.dart';
import 'package:flutter_demo/main.dart' as main_app;
import 'package:get/get.dart';
import '../landing_controller.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LandingController>();
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth <= 1024;
    final isMobileScreen = screenWidth <= 700;

    return AppBar(
      backgroundColor: Colors.white.withValues(alpha: 0.3),
      surfaceTintColor: Colors.transparent,
      toolbarHeight: 65,
      title: Row(
        children: [
          const SizedBox(width: 8),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: Image(image: AssetImage('assets/CoSync.webp')),
          ),
          const SizedBox(width: 8),
          Text(
            'CoSync',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          Spacer(),
          if (!isSmallScreen)
            Row(
              children: [
                InkWell(
                  onTap: () => controller.scrollToProcess(),
                  child: const Text(
                    "프로세스",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 30),
                InkWell(
                  onTap: () => controller.scrollToRisk(),
                  child: const Text(
                    "리스크 진단",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 30),
                InkWell(
                  onTap: () => controller.scrollToRulebook(),
                  child: const Text(
                    "Rulebook이란?",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 30),
              ],
            ),
          if (!isMobileScreen) const SizedBox(width: 30),
          if (!isMobileScreen)
            ElevatedButton(
              onPressed: () {
                main_app.MyApp.analytics.logEvent(name: 'lead_modal_open');
                showDialog(
                  context: context,
                  builder: (context) => const EmailSignupModal(),
                );
              },
              child: const Text(
                "팀 Rulebook 만들기",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0F172A),
                fixedSize: const Size(200, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          const SizedBox(width: 16),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(color: Colors.grey[300], height: 1.0),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(66);
}
