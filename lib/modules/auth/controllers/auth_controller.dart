import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_pages.dart';
import '../../../data/models/auth_user.dart';
import '../../../data/repositories/auth_repository.dart';

/// App-wide session state (current user, logout).
class AuthController extends GetxController {
  AuthController(this._repo);
  final AuthRepository _repo;

  final user = Rxn<AuthUser>();

  Future<void> loadUser() async {
    try {
      user.value = await _repo.getCurrentUser();
    } catch (_) {
      // Non-critical: the 401 interceptor already handles expired sessions.
    }
  }

  Future<void> confirmLogout() async {
    final ok = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Sign out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size(100, 44)),
            onPressed: () => Get.back(result: true),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
    if (ok == true) await logout();
  }

  Future<void> logout() async {
    await _repo.logout();
    user.value = null;
    await Get.offAllNamed(Routes.login);
  }
}
