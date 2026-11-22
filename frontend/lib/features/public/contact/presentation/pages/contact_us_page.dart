import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:sculpture_shop/core/variable/page_padding_var.dart';
import 'package:sculpture_shop/core/widgets/header.dart';
import 'package:sculpture_shop/core/widgets/website_drawer_mobile.dart';
import 'package:sculpture_shop/core/widgets/website_footer.dart';
import 'package:sculpture_shop/features/public/contact/presentation/controller/contact_us_controller.dart';

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
                const SizedBox(height: 28),
                Container(
                  width: 760,
                  padding: EdgeInsets.all(width < 500 ? 18 : 32),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: colors.onBackground.withOpacity(0.07),
                    ),
                  ),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'LET’S TALK',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: colors.primary,
                                letterSpacing: 2,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Send us a message',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Have a question about a piece or your order? We’d be glad to help.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: colors.onBackground.withOpacity(0.72),
                              ),
                        ),
                        const SizedBox(height: 26),
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
                          label: 'How can we help?',
                          icon: Ionicons.chatbubble_ellipses_outline,
                          validator: controller.validateRequired,
                          maxLines: 5,
                          textInputAction: TextInputAction.newline,
                        ),
                        const SizedBox(height: 22),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () => _submit(context),
                            icon: const Icon(Icons.send_rounded),
                            label: const Text('Send message'),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Ionicons.call_outline,
                              size: 17,
                              color: colors.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Prefer to call? 021 - 88123456',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: colors.onBackground.withOpacity(
                                      0.72,
                                    ),
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
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

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (!controller.validateForm()) return;
    Get.dialog(
      AlertDialog(
        icon: const Icon(Icons.info_outline_rounded),
        title: const Text('Online sending is not available yet'),
        content: const Text(
          'Your message has not been sent. Please call 021 - 88123456 and we’ll be happy to help.',
        ),
        actions: [TextButton(onPressed: Get.back, child: const Text('Got it'))],
      ),
    );
  }
}
