import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class AppSnack {
  static void success(String message) => _show(message, Colors.green.shade600, Icons.check_circle);
  static void error(String message) => _show(message, Colors.red.shade600, Icons.error);

  static void _show(String message, Color color, IconData icon) {
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
    Get.snackbar(
      '',
      message,
      titleText: const SizedBox.shrink(),
      icon: Icon(icon, color: Colors.white),
      backgroundColor: color,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
    );
  }
}
