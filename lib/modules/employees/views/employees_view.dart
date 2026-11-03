import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_pages.dart';
import '../../../core/widgets/state_views.dart';
import '../../../data/models/employee.dart';
import '../controllers/employees_controller.dart';

class EmployeesView extends GetView<EmployeesController> {
  const EmployeesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: TextField(
            onChanged: (v) => controller.query.value = v,
            decoration: const InputDecoration(
              hintText: 'Search by name, email, department…',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        Obx(() => controller.isLoading.value
            ? const LinearProgressIndicator(minHeight: 2)
            : const SizedBox(height: 2)),
        Expanded(
          child: Obx(() {
            final items = controller.filtered;
            if (controller.isLoading.value && controller.employees.isEmpty) {
              return const LoadingView();
            }
            if (controller.error.value != null && controller.employees.isEmpty) {
              return ErrorView(message: controller.error.value!, onRetry: controller.load);
            }
            if (items.isEmpty) {
              return const EmptyView(icon: Icons.groups_outlined, message: 'No employees found');
            }
            return RefreshIndicator(
              onRefresh: controller.load,
              child: ListView.separated(
                controller: controller.scroll,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                itemCount: items.length + (controller.isLoadingMore.value ? 1 : 0),
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  if (i >= items.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return _EmployeeCard(employee: items[i], controller: controller);
                },
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _EmployeeCard extends StatelessWidget {
  const _EmployeeCard({required this.employee, required this.controller});
  final Employee employee;
  final EmployeesController controller;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Get.toNamed(Routes.employeeForm, arguments: employee),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: scheme.primaryContainer,
                child: Text(employee.initials,
                    style: TextStyle(
                        color: scheme.onPrimaryContainer, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(employee.fullName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    const SizedBox(height: 2),
                    Text(
                      [employee.jobTitle, employee.department]
                          .where((s) => s.isNotEmpty)
                          .join(' • '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                    ),
                    const SizedBox(height: 2),
                    Text(employee.email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                onSelected: (v) {
                  if (v == 'edit') {
                    Get.toNamed(Routes.employeeForm, arguments: employee);
                  } else {
                    controller.confirmDelete(employee);
                  }
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: ListTile(
                      dense: true,
                      leading: Icon(Icons.edit_outlined),
                      title: Text('Edit'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: ListTile(
                      dense: true,
                      leading: Icon(Icons.delete_outline, color: Colors.red.shade600),
                      title: Text('Delete', style: TextStyle(color: Colors.red.shade600)),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
