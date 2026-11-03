import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_pages.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../employees/views/employees_view.dart';
import '../../products/views/products_view.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    const titles = ['Products', 'Employees'];

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 68,
        title: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  auth.user.value == null ? 'Welcome' : 'Hi, ${auth.user.value!.firstName} 👋',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                Text(titles[controller.tabIndex.value],
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 24)),
              ],
            )),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout_rounded),
            onPressed: auth.confirmLogout,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Obx(() => IndexedStack(
            index: controller.tabIndex.value,
            children: const [ProductsView(), EmployeesView()],
          )),
      floatingActionButton: Obx(() => controller.tabIndex.value == 1
          ? FloatingActionButton.extended(
              onPressed: () => Get.toNamed(Routes.employeeForm),
              icon: const Icon(Icons.person_add_alt_1),
              label: const Text('Add employee'),
            )
          : const SizedBox.shrink()),
      bottomNavigationBar: Obx(() => NavigationBar(
            selectedIndex: controller.tabIndex.value,
            onDestinationSelected: controller.changeTab,
            destinations: const [
              NavigationDestination(
                  icon: Icon(Icons.inventory_2_outlined),
                  selectedIcon: Icon(Icons.inventory_2),
                  label: 'Products'),
              NavigationDestination(
                  icon: Icon(Icons.groups_outlined),
                  selectedIcon: Icon(Icons.groups),
                  label: 'Employees'),
            ],
          )),
    );
  }
}
