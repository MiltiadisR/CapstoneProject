import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  // Text Controllers to get data from Textfields
  final email = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();
  final phoneNo = TextEditingController();
  final address = TextEditingController();

  // Call this function from Design & it will do th rest
  void registerUser(String email, String password) {}
}
