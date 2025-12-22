import 'package:get/get.dart';
import '../signup/signup_page.dart';

class OnboardingController extends GetxController {
  void goBack() {
    Get.back();
  }

  void startExperience() {
    Get.to(() => const SignupPage());
  }
}
