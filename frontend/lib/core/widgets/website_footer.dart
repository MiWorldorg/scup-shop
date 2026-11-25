import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sculpture_shop/core/constants/routes.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 36, bottom: 24),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Theme.of(context).cardColor,
              border: Border.all(color: colors.outline),
            ),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/SpcLogo.png',
                  height: 92,
                  semanticLabel: 'Scup-Shop',
                ),
                const SizedBox(height: 12),
                Text(
                  'Art in form',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: colors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Explore the collection and the stories behind each piece.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: () => Get.toNamed(AppRoutes.contactUs),
                  icon: const Icon(Icons.mail_outline_rounded),
                  label: const Text('Contact the studio'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'All rights reserved.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          TextButton(
            onPressed: () => Get.toNamed(AppRoutes.adminLogin),
            child: const Text('Admin sign in'),
          ),
        ],
      ),
    );
  }
}
