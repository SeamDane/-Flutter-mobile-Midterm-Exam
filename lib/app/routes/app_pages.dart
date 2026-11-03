import 'package:get/get.dart';

import '../../modules/auth/bindings/login_binding.dart';
import '../../modules/auth/views/login_view.dart';
import '../../modules/employees/bindings/employee_form_binding.dart';
import '../../modules/employees/views/employee_form_view.dart';
import '../../modules/home/bindings/home_binding.dart';
import '../../modules/home/views/home_view.dart';

abstract class Routes {
  static const login = '/login';
  static const home = '/home';
  static const employeeForm = '/employee-form';
}

class AppPages {
  static final pages = <GetPage>[
    GetPage(name: Routes.login, page: () => const LoginView(), binding: LoginBinding()),
    GetPage(name: Routes.home, page: () => const HomeView(), binding: HomeBinding()),
    GetPage(
      name: Routes.employeeForm,
      page: () => const EmployeeFormView(),
      binding: EmployeeFormBinding(),
    ),
  ];
}
