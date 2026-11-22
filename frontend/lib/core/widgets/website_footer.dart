import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:sculpture_shop/core/constants/routes.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 24, top: 34),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Theme.of(context).cardColor,
              border: Border.all(color: colors.onBackground.withOpacity(0.07)),
            ),
            child: Column(
              children: [
                Image.asset('assets/images/SpcLogo.png', height: 112),
                const SizedBox(height: 10),
                Text(
                  'Sculpture store',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 22),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 28,
                  runSpacing: 14,
                  children: [
                    _contactItem(
                      context,
                      Ionicons.location_outline,
                      'Gheitariyeh, Tehran',
                    ),
                    _contactItem(
                      context,
                      Ionicons.call_outline,
                      '021 - 88123456',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'All rights reserved.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colors.onBackground.withOpacity(0.55),
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

  Widget _contactItem(BuildContext context, IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
