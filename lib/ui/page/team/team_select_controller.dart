import 'package:get/get.dart';
import '../../../router/routes.dart';

/// TeamSelectController: 팀 선택 페이지 컨트롤러
class TeamSelectController extends GetxController {
  /// 팀 생성 페이지로 이동
  void goToCreate() {
    Get.toNamed(Routes.teamCreate);
  }

  /// 팀 가입 페이지로 이동
  void goToJoin() {
    Get.toNamed(Routes.teamJoin);
  }
}
