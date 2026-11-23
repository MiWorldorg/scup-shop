import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sculpture_shop/core/api/api_response.dart';
import 'package:sculpture_shop/core/api/api_session.dart';
import 'package:sculpture_shop/features/authentication/domain/repository/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository repository;
  AuthController({required this.repository});

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;
  final errorMessage = RxnString();
  final currentRole = ''.obs;
  final currentUsername = ''.obs;

  bool get isAdmin =>
      ApiSession.isAuthenticated && currentRole.value == 'admin';

  Future<void> restoreSession() async {
    await ApiSession.initialize();
    if (!ApiSession.isAuthenticated) return;

    try {
      final user = await repository.currentUser();
      currentRole.value = user['role']?.toString() ?? '';
      currentUsername.value = user['username']?.toString() ?? '';
    } catch (error) {
      // Only discard a token when the server confirms it is invalid/revoked.
      if (error is ApiException &&
          (error.statusCode == 401 || error.statusCode == 403)) {
        await ApiSession.clear();
      }
      currentRole.value = '';
      currentUsername.value = '';
    }
  }

  Future<bool> login() async {
    if (isLoading.value) return false;
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final response = await repository.login(
        emailController.text.trim(),
        passwordController.text,
      );
      final role = response['role']?.toString() ?? '';
      final token = response['token']?.toString() ?? '';

      if (token.isEmpty) {
        throw const ApiException('The server did not return an access token.');
      }

      if (role != 'admin') {
        try {
          await repository.logout(token: token);
        } catch (_) {
          // Keep the administrator sign-in error clear if revocation fails.
        }
        throw const ApiException(
          'This account does not have administrator access.',
        );
      }

      await ApiSession.setAccessToken(token);
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
      if (token != null) await repository.logout();
    } catch (_) {
      // Local access still ends even if the network is unavailable.
    } finally {
      await ApiSession.clear();
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
