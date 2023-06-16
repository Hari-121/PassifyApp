import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passifyapp/register.dart';

class InputValidator {
  static bool validateField(String title, String value) {
    if (value.trim().isNotEmpty) {
      if (title.toLowerCase() == 'email') {
        if (value.endsWith('sjcetpalai.ac.in')) {
          return true;
        } else {
          Get.snackbar(
            "Error",
            "Invalid email format. Use your SJCET official email!!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Color.fromARGB(255, 243, 53, 53),
            colorText: Colors.white,
            borderRadius: 10,
            margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
          );
          return false;
        }
      }
      return true;
    }
    Get.snackbar(
      "Error",
      "$title is empty",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color.fromARGB(255, 255, 0, 0),
      colorText: Colors.white,
      borderRadius: 10,
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
    );
    return false;
  }
}
