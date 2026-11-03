import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/utils/app_snack.dart';
import '../../../data/models/employee.dart';
import '../../../data/repositories/employee_repository.dart';

class EmployeesController extends GetxController {
  EmployeesController(this._repo);
  final EmployeeRepository _repo;

  static const _pageSize = 20;

  final employees = <Employee>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final error = RxnString();
  final query = ''.obs;
  final scroll = ScrollController();

  int _total = 0;
  bool get hasMore => employees.length < _total;

  /// Client-side search over the loaded employees.
  List<Employee> get filtered {
    final q = query.value.trim().toLowerCase();
    if (q.isEmpty) return employees;
    return employees
        .where((e) =>
            e.fullName.toLowerCase().contains(q) ||
            e.email.toLowerCase().contains(q) ||
            e.department.toLowerCase().contains(q) ||
            e.jobTitle.toLowerCase().contains(q))
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    scroll.addListener(_onScroll);
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    error.value = null;
    try {
      final page = await _repo.getEmployees(limit: _pageSize, skip: 0);
      // Keep locally-created records (simulated backend) on refresh.
      final local = employees.where((e) => e.isLocal).toList();
      employees.assignAll([...local, ...page.items]);
      _total = page.total + local.length;
    } on ApiException catch (e) {
      error.value = e.message;
      if (employees.isNotEmpty) AppSnack.error(e.message);
    } catch (_) {
      error.value = 'Unable to load employees.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (isLoading.value || isLoadingMore.value || !hasMore) return;
    isLoadingMore.value = true;
    try {
      final remote = employees.where((e) => !e.isLocal).length;
      final page = await _repo.getEmployees(limit: _pageSize, skip: remote);
      employees.addAll(page.items);
    } on ApiException catch (e) {
      AppSnack.error(e.message);
    } finally {
      isLoadingMore.value = false;
    }
  }

  /// Called by the form after a successful add / update.
  void onSaved(Employee saved, {required bool isEdit}) {
    if (isEdit) {
      final i = employees.indexWhere((e) => e.id == saved.id);
      if (i != -1) employees[i] = saved;
    } else {
      employees.insert(0, saved);
      _total++;
    }
  }

  Future<void> confirmDelete(Employee employee) async {
    final ok = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: Icon(Icons.warning_amber_rounded, color: Colors.red.shade400, size: 40),
        title: const Text('Delete employee?'),
        content: Text('${employee.fullName} will be permanently removed. '
            'This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(
                minimumSize: const Size(100, 44), backgroundColor: Colors.red.shade600),
            onPressed: () => Get.back(result: true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok != true) return;

    Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
    try {
      await _repo.deleteEmployee(employee);
      employees.removeWhere((e) => e.id == employee.id);
      _total = (_total - 1).clamp(0, 1 << 31);
      Get.back(); // close loader
      AppSnack.success('${employee.fullName} deleted');
    } on ApiException catch (e) {
      Get.back();
      AppSnack.error(e.message);
    } catch (_) {
      Get.back();
      AppSnack.error('Could not delete employee.');
    }
  }

  void _onScroll() {
    if (scroll.hasClients && scroll.position.pixels >= scroll.position.maxScrollExtent - 240) {
      loadMore();
    }
  }

  @override
  void onClose() {
    scroll.dispose();
    super.onClose();
  }
}
