import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_demo/ui/page/landing/landing_controller.dart';
import 'package:flutter_demo/ui/page/landing/widget/app_bar_widget.dart';
import 'package:flutter_demo/ui/page/landing/widget/description_section1.dart';
import 'package:flutter_demo/ui/page/landing/widget/description_section2.dart';
import 'package:flutter_demo/ui/page/landing/widget/description_section3.dart';
import 'package:flutter_demo/ui/page/landing/widget/description_section4.dart';
import 'package:flutter_demo/ui/page/landing/widget/description_section5.dart';
import 'package:flutter_demo/ui/page/landing/widget/description_section6.dart';
import 'package:flutter_demo/ui/page/landing/widget/description_section7.dart';
import 'package:flutter_demo/ui/page/landing/widget/description_section8.dart';
import 'package:flutter_demo/ui/page/landing/widget/footer_section.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LandingController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget(),
      body: ListView(
        controller: controller.scrollController,
        children: [
          const Description1(),
          const Description2(),
          const Description3(),
          Description4(key: controller.riskKey),
          Description5(key: controller.processKey),
          const Description6(),
          const Description7(),
          Description8(key: controller.rulebookKey),
          const FooterSection(),
        ],
      ),
    );
  }
}
