import 'package:get/get.dart';

import '../../../data/repositories/employee_repository.dart';
import '../controllers/employee_form_controller.dart';

class EmployeeFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EmployeeFormController(Get.find<EmployeeRepository>()));
  }
}
