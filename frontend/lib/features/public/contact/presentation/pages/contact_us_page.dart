import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:sculpture_shop/core/variable/page_padding_var.dart';
import 'package:sculpture_shop/core/widgets/header.dart';
import 'package:sculpture_shop/core/widgets/website_drawer_mobile.dart';
import 'package:sculpture_shop/core/widgets/website_footer.dart';
import 'package:sculpture_shop/features/public/contact/presentation/controllers/contact_us_controller.dart';

class ContactUsPage extends GetView<ContactUsController> {
  ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      drawer: MobileDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: getResponsivePadding(context, width),
          child: SafeArea(
            child: Column(
              children: [
                Header(selectedIndex: 4.obs),
                const SizedBox(height: 32),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(width < 500 ? 20 : 36),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: colors.outline),
                      ),
                      child: Form(
                        key: controller.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'LET’S TALK',
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(
                                    color: colors.primary,
                                    letterSpacing: 2,
                                  ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Start a conversation',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Ask us about a sculpture, the collection, or anything else. Send a note and our team will follow up.',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: colors.onSurfaceVariant),
                            ),
                            const SizedBox(height: 28),
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final sideBySide = constraints.maxWidth >= 520;
                                final firstName = _input(
                                  controller: controller.name,
                                  label: 'First name',
                                  icon: Ionicons.person_outline,
                                  validator: controller.validateRequired,
                                  textInputAction: TextInputAction.next,
                                );
                                final lastName = _input(
                                  controller: controller.lastName,
                                  label: 'Last name',
                                  icon: Ionicons.person_outline,
                                  validator: controller.validateRequired,
                                  textInputAction: TextInputAction.next,
                                );

                                if (!sideBySide) {
                                  return Column(
                                    children: [
                                      firstName,
                                      const SizedBox(height: 14),
                                      lastName,
                                    ],
                                  );
                                }

                                return Row(
                                  children: [
                                    Expanded(child: firstName),
                                    const SizedBox(width: 14),
                                    Expanded(child: lastName),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 14),
                            _input(
                              controller: controller.email,
                              label: 'Email address',
                              icon: Ionicons.mail_outline,
                              validator: controller.validateEmail,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 14),
                            _input(
                              controller: controller.message,
                              label: 'Your message',
                              icon: Ionicons.chatbubble_ellipses_outline,
                              validator: controller.validateRequired,
                              maxLines: 6,
                              textInputAction: TextInputAction.newline,
                            ),
                            const SizedBox(height: 20),
                            Obx(() {
                              if (controller.successMessage.isNotEmpty) {
                                return _statusMessage(
                                  context,
                                  controller.successMessage.value,
                                  colors.tertiary,
                                  Icons.check_circle_outline_rounded,
                                );
                              }
                              if (controller.errorMessage.isNotEmpty) {
                                return _statusMessage(
                                  context,
                                  controller.errorMessage.value,
                                  colors.error,
                                  Icons.error_outline_rounded,
                                );
                              }
                              return const SizedBox.shrink();
                            }),
                            const SizedBox(height: 12),
                            Obx(
                              () => SizedBox(
                                width: double.infinity,
                                child: FilledButton.icon(
                                  onPressed: controller.isSubmitting.value
                                      ? null
                                      : controller.submit,
                                  icon: controller.isSubmitting.value
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Icon(Icons.send_rounded),
                                  label: Text(
                                    controller.isSubmitting.value
                                        ? 'Sending…'
                                        : 'Send message',
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Your details are used only to respond to your message.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: colors.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Footer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _input({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    int maxLines = 1,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        labelText: label,
        alignLabelWithHint: maxLines > 1,
        prefixIcon: maxLines == 1 ? Icon(icon) : null,
      ),
    );
  }

  Widget _statusMessage(
    BuildContext context,
    String message,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.45)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
