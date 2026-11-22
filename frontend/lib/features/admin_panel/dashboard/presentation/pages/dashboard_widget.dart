import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sculpture_shop/features/admin_panel/dashboard/presentation/controllers/dashboard_controller.dart';

class DashboardWidget extends GetView<DashboardController> {
  const DashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final actions = const [
      _DashboardAction(
        icon: Icons.inventory_2_outlined,
        title: 'Products',
        description: 'Review and manage the sculpture collection.',
        index: 2,
      ),
      _DashboardAction(
        icon: Icons.people_outline_rounded,
        title: 'Users & roles',
        description: 'Review customer accounts and manage admin access.',
        index: 1,
      ),
      _DashboardAction(
        icon: Icons.article_outlined,
        title: 'Posts',
        description: 'Manage journal articles and stories.',
        index: 3,
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Dashboard', style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 6),
          Text(
            'Manage your storefront from one place.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colors.onSurface.withOpacity(0.68),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).cardColor,
                  colors.secondary.withOpacity(0.2),
                ],
              ),
              border: Border.all(color: colors.primary.withOpacity(0.14)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Choose a section below to keep your shop up to date.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colors.onSurface.withOpacity(0.72),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.auto_awesome_rounded,
                  size: 42,
                  color: colors.primary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Text('Quick access', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: actions.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 320,
              mainAxisExtent: 188,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
            ),
            itemBuilder: (context, index) => _ActionCard(
              action: actions[index],
              onTap: () => controller.selectMenu(actions[index].index),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardAction {
  final IconData icon;
  final String title;
  final String description;
  final int index;

  const _DashboardAction({
    required this.icon,
    required this.title,
    required this.description,
    required this.index,
  });
}

class _ActionCard extends StatelessWidget {
  final _DashboardAction action;
  final VoidCallback onTap;

  const _ActionCard({required this.action, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: colors.onSurface.withOpacity(0.08)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(action.icon, color: colors.primary, size: 26),
              const SizedBox(height: 10),
              Text(
                action.title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Expanded(
                child: Text(
                  action.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colors.onSurface.withOpacity(0.68),
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    'Open section',
                    style: TextStyle(
                      color: colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 16,
                    color: colors.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
