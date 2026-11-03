import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_pages.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/utils/app_snack.dart';
import '../../../data/repositories/auth_repository.dart';

class LoginController extends GetxController {
  LoginController(this._repo);
  final AuthRepository _repo;

  final formKey = GlobalKey<FormState>();
  // Demo credentials for dummyjson.com – clear these for production.
  final usernameCtrl = TextEditingController(text: 'emilys');
  final passwordCtrl = TextEditingController(text: 'emilyspass');

  final isLoading = false.obs;
  final obscure = true.obs;

  Future<void> login() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      await _repo.login(usernameCtrl.text.trim(), passwordCtrl.text);
      await Get.offAllNamed(Routes.home);
    } on ApiException catch (e) {
      AppSnack.error(e.message);
    } catch (_) {
      AppSnack.error('Unexpected error. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    usernameCtrl.dispose();
    passwordCtrl.dispose();
    super.onClose();
  }
}
