import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sculpture_shop/core/constants/routes.dart';
import 'package:sculpture_shop/features/authentication/presentation/controllers/auth_controller.dart';

class AuthPage extends GetView<AuthController> {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            tooltip: 'Back to storefront',
                            onPressed: () => Get.offAllNamed(AppRoutes.landing),
                            icon: const Icon(Icons.arrow_back_rounded),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 56,
                          height: 56,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: colors.primary.withOpacity(0.14),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Icon(
                            Icons.admin_panel_settings_outlined,
                            color: colors.primary,
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Admin sign in',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sign in with an administrator account to manage the shop.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: colors.onSurface.withOpacity(0.68),
                              ),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: controller.emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.username],
                          decoration: const InputDecoration(
                            labelText: 'Email address',
                            prefixIcon: Icon(Icons.mail_outline_rounded),
                          ),
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                              ? 'Enter your email address.'
                              : null,
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: controller.passwordController,
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          autofillHints: const [AutofillHints.password],
                          onFieldSubmitted: (_) => _submit(),
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock_outline_rounded),
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Enter your password.'
                              : null,
                        ),
                        Obx(() {
                          final message = controller.errorMessage.value;
                          if (message == null) return const SizedBox.shrink();
                          return Padding(
                            padding: const EdgeInsets.only(top: 14),
                            child: Text(
                              message,
                              style: TextStyle(color: colors.error),
                            ),
                          );
                        }),
                        const SizedBox(height: 20),
                        Obx(
                          () => FilledButton.icon(
                            onPressed: controller.isLoading.value
                                ? null
                                : _submit,
                            icon: controller.isLoading.value
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.login_rounded),
                            label: Text(
                              controller.isLoading.value
                                  ? 'Signing in…'
                                  : 'Sign in',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!(controller.formKey.currentState?.validate() ?? false)) return;
    if (await controller.login()) Get.offAllNamed(AppRoutes.dashboard);
  }
}
