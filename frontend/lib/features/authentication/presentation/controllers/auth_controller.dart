import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sculpture_shop/core/api/api_response.dart';
import 'package:sculpture_shop/core/api/api_session.dart';
import 'package:sculpture_shop/features/authentication/data/service/auth_service.dart';

class AuthController extends GetxController {
  final AuthService service;
  AuthController({AuthService? service}) : service = service ?? AuthService();

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;
  final errorMessage = RxnString();
  final currentRole = ''.obs;
  final currentUsername = ''.obs;

  bool get isAdmin =>
      ApiSession.isAuthenticated && currentRole.value == 'admin';

  Future<bool> login() async {
    if (isLoading.value) return false;
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final response = await service.login(
        emailController.text.trim(),
        passwordController.text,
      );
      final role = response['role']?.toString() ?? '';
      if (role != 'admin') {
        final token = response['token']?.toString();
        if (token != null && token.isNotEmpty) {
          try {
            await service.logout(token);
          } catch (_) {
            // Keep the administrator sign-in error clear if revocation fails.
          }
        }
        throw const ApiException(
          'This account does not have administrator access.',
        );
      }

      final token = response['token']?.toString() ?? '';
      if (token.isEmpty) {
        throw const ApiException('The server did not return an access token.');
      }

      ApiSession.setAccessToken(token);
      currentRole.value = role;
      currentUsername.value = response['username']?.toString() ?? '';
      return true;
    } catch (error) {
      errorMessage.value = ApiResponse.userFacingError(error);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    final token = ApiSession.accessToken;
    try {
      if (token != null) await service.logout(token);
    } catch (_) {
      // Local access still ends even if the network is unavailable.
    } finally {
      ApiSession.clear();
      currentRole.value = '';
      currentUsername.value = '';
      passwordController.clear();
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
