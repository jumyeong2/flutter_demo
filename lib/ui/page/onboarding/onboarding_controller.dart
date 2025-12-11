import 'package:get/get.dart';
import '../agreement/agreement_adjust_intro.dart';

class OnboardingController extends GetxController {
  void goBack() {
    Get.back();
  }

  void startExperience() {
    Get.to(() => const AgreementAdjustIntroPage());
  }
}
