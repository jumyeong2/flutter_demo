import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'landing_controller.dart';
import 'widgets/landing_navbar.dart';
import 'widgets/hero_section.dart';
import 'widgets/process_section.dart';
import 'widgets/demo_section.dart';
import 'widgets/radar_section.dart';
import 'widgets/rulebook_section.dart';
import 'widgets/cta_section.dart';
import 'widgets/footer_section.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller 주입 (Dependency Injection)
    Get.put(LandingController());

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Main Scroll View
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const HeroSection(),
                  const SizedBox(height: 100),
                  const ProcessSection(),
                  const SizedBox(height: 100),
                  const DemoSection(),
                  const SizedBox(height: 50),
                  const RadarSection(),
                  const SizedBox(height: 100),
                  const RulebookSection(),
                  const SizedBox(height: 50),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [CtaSection(), FooterSection()],
                  ),
                ],
              ),
            ),
      
            // Navbar (Fixed on top)
            const Positioned(top: 0, left: 0, right: 0, child: LandingNavbar()),
          ],
        ),
      ),
    );
  }
}
