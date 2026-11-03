import 'package:get/get.dart';

import '../../core/network/api_client.dart';
import '../../core/storage/token_storage.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/employee_repository.dart';
import '../../data/repositories/product_repository.dart';
import '../../modules/auth/controllers/auth_controller.dart';

/// Registers app-wide singletons: storage, HTTP client, repositories.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<TokenStorage>(TokenStorage(), permanent: true);
    Get.put<ApiClient>(ApiClient(Get.find()), permanent: true);

    Get.put<AuthRepository>(AuthRepositoryImpl(Get.find(), Get.find()), permanent: true);
    Get.put<ProductRepository>(ProductRepositoryImpl(Get.find()), permanent: true);
    Get.put<EmployeeRepository>(EmployeeRepositoryImpl(Get.find()), permanent: true);

    Get.put<AuthController>(AuthController(Get.find()), permanent: true);
  }
}
