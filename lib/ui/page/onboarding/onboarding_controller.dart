import 'package:get/get.dart';
import '../login/login_page.dart';

class OnboardingController extends GetxController {
  void goBack() {
    Get.back();
  }

  void startExperience() {
    Get.to(() => const LoginPage());
  }
}
