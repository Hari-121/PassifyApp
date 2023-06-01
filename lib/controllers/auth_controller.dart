import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:passifyapp/login.dart';
import 'package:flutter/services.dart';
import 'package:passifyapp/home.dart';
import 'package:passifyapp/register.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<User?> _user;
  bool isLoging = false;
  User? get user => _user.value;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(auth.authStateChanges());
    ever(_user, loginRedirect);
  }

  loginRedirect(User? user) {
    Timer(Duration(seconds: isLoging ? 0 : 2), () {
      if (user == null) {
        isLoging = false;
        // update();
        Get.offAll(() => const Login());
      } else {
        isLoging = true;
        //update();
        Get.offAll(() => const Dashboard());
      }
    });
  }

  void registerUser(email, password) async {
    isLoging = false;
    try {
      //update();
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      getSuccessSnackBar("Successfully registred using ${_user.value!.email}");
    } on FirebaseAuthException catch (e) {
      //define error
      getErrorSnackBar("Account Creation Failed", e);
    }
  }

  void login(email, password) async {
    try {
      isLoging = true;
      //update();
      await auth.signInWithEmailAndPassword(email: email, password: password);
      getSuccessSnackBar("Successfully logged in using ${_user.value!.email}");
    } on FirebaseAuthException catch (e) {
      //define error
      getErrorSnackBar("Login Failed", e);
    }
  }

  getErrorSnackBar(String message, _) {
    Get.snackbar(
      "Error",
      "$message\n${_.message}",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color.fromARGB(255, 236, 38, 38),
      colorText: Colors.white,
      borderRadius: 10,
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
    );
  }

  getSuccessSnackBar(String message) {
    Get.snackbar(
      "Success",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      borderRadius: 10,
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
    );
  }

  void signOut() async {
    await auth.signOut();
  }
}
