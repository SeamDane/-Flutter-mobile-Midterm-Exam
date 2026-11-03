import 'package:get/get.dart';

import '../../auth/controllers/auth_controller.dart';

class HomeController extends GetxController {
  final tabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    Get.find<AuthController>().loadUser();
  }

  void changeTab(int i) => tabIndex.value = i;
}
