import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sculpture_shop/core/api/api_response.dart';
import 'package:sculpture_shop/features/public/contact/data/service/contact_service.dart';

class ContactUsController extends GetxController {
  final ContactService service;

  ContactUsController({required this.service});

  final formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final message = TextEditingController();

  final isSubmitting = false.obs;
  final successMessage = ''.obs;
  final errorMessage = ''.obs;

  String? validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required.';
    }
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

  Future<void> submit() async {
    if (isSubmitting.value || !validateForm()) return;

    isSubmitting.value = true;
    successMessage.value = '';
    errorMessage.value = '';

    try {
      await service.sendMessage(
        firstName: name.text.trim(),
        lastName: lastName.text.trim(),
        email: email.text.trim(),
        message: message.text.trim(),
      );
      name.clear();
      lastName.clear();
      email.clear();
      message.clear();
      successMessage.value =
          'Your message was accepted. We will get back to you soon.';
    } catch (error) {
      errorMessage.value = ApiResponse.userFacingError(error);
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    name.dispose();
    lastName.dispose();
    email.dispose();
    message.dispose();
    super.onClose();
  }
}
