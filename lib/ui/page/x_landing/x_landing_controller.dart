import 'package:get/get.dart';
import '../onboarding/onboarding_page.dart';

class LandingController extends GetxController {
  final RxInt demoStep = 0.obs;
  final RxBool isMenuOpen = false.obs;

  void setDemoStep(int step) {
    demoStep.value = step;
  }

  void toggleMenu() {
    isMenuOpen.value = !isMenuOpen.value;
  }

  void startTrial() {
    Get.to(() => const OnboardingPage());
  }
}
