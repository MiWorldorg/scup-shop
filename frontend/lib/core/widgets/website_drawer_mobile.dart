import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sculpture_shop/core/constants/routes.dart';
import 'package:sculpture_shop/core/widgets/navbar_desktop.dart';

class MobileDrawer extends StatelessWidget {
  MobileDrawer({super.key});

  final NavbarList data = NavbarList();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Drawer(
      width: 300,
      backgroundColor: colors.background,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/SpcLogo.png',
                    height: 86,
                    semanticLabel: 'Scup-Shop',
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'SCULPTURE SHOP',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      letterSpacing: 2,
                      color: colors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Explore the collection',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: colors.onBackground.withOpacity(0.12)),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                itemCount: data.menuNav.length,
                separatorBuilder: (_, __) => const SizedBox(height: 4),
                itemBuilder: (context, index) {
                  final item = data.menuNav[index];
                  final selected = Get.currentRoute == item.routes;
                  return ListTile(
                    selected: selected,
                    selectedTileColor: colors.primary.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    leading: Icon(
                      item.icon,
                      color: selected ? colors.primary : colors.onBackground,
                    ),
                    title: Text(
                      item.title,
                      style: TextStyle(
                        color: selected ? colors.primary : colors.onBackground,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      if (Get.currentRoute != item.routes)
                        Get.toNamed(item.routes);
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  Get.toNamed(AppRoutes.adminLogin);
                },
                icon: const Icon(Icons.admin_panel_settings_outlined),
                label: const Text('Admin sign in'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
