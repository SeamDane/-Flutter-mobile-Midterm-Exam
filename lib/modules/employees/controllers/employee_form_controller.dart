import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/utils/app_snack.dart';
import '../../../data/models/employee.dart';
import '../../../data/repositories/employee_repository.dart';
import 'employees_controller.dart';

/// Handles both "Add" (no argument) and "Edit" (Employee passed as argument).
class EmployeeFormController extends GetxController {
  EmployeeFormController(this._repo);
  final EmployeeRepository _repo;

  final Employee? editing = Get.arguments as Employee?;
  bool get isEdit => editing != null;

  final formKey = GlobalKey<FormState>();
  late final firstNameCtrl = TextEditingController(text: editing?.firstName);
  late final lastNameCtrl = TextEditingController(text: editing?.lastName);
  late final emailCtrl = TextEditingController(text: editing?.email);
  late final phoneCtrl = TextEditingController(text: editing?.phone);
  late final ageCtrl = TextEditingController(text: editing?.age.toString());
  late final jobTitleCtrl = TextEditingController(text: editing?.jobTitle);
  late final departmentCtrl = TextEditingController(text: editing?.department);

  final isSaving = false.obs;

  Future<void> save() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!formKey.currentState!.validate()) return;

    final employee = Employee(
      id: editing?.id,
      firstName: firstNameCtrl.text.trim(),
      lastName: lastNameCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      phone: phoneCtrl.text.trim(),
      age: int.parse(ageCtrl.text.trim()),
      jobTitle: jobTitleCtrl.text.trim(),
      department: departmentCtrl.text.trim(),
      isLocal: editing?.isLocal ?? false,
    );

    isSaving.value = true;
    try {
      final saved = isEdit
          ? await _repo.updateEmployee(employee)
          : await _repo.addEmployee(employee);
      Get.find<EmployeesController>().onSaved(saved, isEdit: isEdit);
      Get.back();
      AppSnack.success(isEdit ? 'Employee updated' : 'Employee added');
    } on ApiException catch (e) {
      AppSnack.error(e.message);
    } catch (_) {
      AppSnack.error('Could not save employee.');
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    for (final c in [
      firstNameCtrl, lastNameCtrl, emailCtrl, phoneCtrl, ageCtrl, jobTitleCtrl, departmentCtrl
    ]) {
      c.dispose();
    }
    super.onClose();
  }
}
