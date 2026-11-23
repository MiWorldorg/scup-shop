import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactUsController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final message = TextEditingController();

  String? validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) return 'This field is required.';
    return null;
  }

  String? validateEmail(String? value) {
    final required = validateRequired(value);
    if (required != null) return required;
    final emailValue = value!.trim();
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(emailValue)) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  bool validateForm() => formKey.currentState?.validate() ?? false;

  @override
  void onClose() {
    name.dispose();
    lastName.dispose();
    email.dispose();
    message.dispose();
    super.onClose();
  }
}
