import 'package:get/get.dart';

import '../../../data/repositories/employee_repository.dart';
import '../../../data/repositories/product_repository.dart';
import '../../employees/controllers/employees_controller.dart';
import '../../products/controllers/products_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => ProductsController(Get.find<ProductRepository>()));
    Get.lazyPut(() => EmployeesController(Get.find<EmployeeRepository>()));
  }
}
