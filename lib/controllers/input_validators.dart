import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passifyapp/register.dart';

class InputValidator {
  static bool validateField(String title, String value) {
    if (value.trim().isNotEmpty) {
      return true;
    }
    Get.snackbar(
      "Error",
      "$title is empty",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      borderRadius: 10,
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
    );
    return false;
  }
}
