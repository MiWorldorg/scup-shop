import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sculpture_shop/core/constants/routes.dart';
import 'package:sculpture_shop/core/widgets/admin_panel/sidebar_widget.dart';
import 'package:sculpture_shop/features/admin_panel/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:sculpture_shop/features/authentication/presentation/controllers/auth_controller.dart';

class MobileSideBar extends GetView<DashboardController> {
  const MobileSideBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final data = SideMenuData().menu;
    return Drawer(
      width: 300,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(22),
              child: Row(
                children: [
                  Icon(
                    Icons.dashboard_customize_outlined,
                    color: colors.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Admin panel',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'Sculpture Shop',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: colors.onSurface.withOpacity(0.12)),
            Expanded(
              child: Obx(
                () => ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  itemCount: data.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 4),
                  itemBuilder: (context, index) {
                    final item = data[index];
                    final selected = controller.selectedIndex.value == index;
                    return ListTile(
                      selected: selected,
                      selectedTileColor: colors.primary.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      leading: Icon(
                        item.icon,
                        color: selected ? colors.primary : colors.onSurface,
                      ),
                      title: Text(
                        item.title,
                        style: TextStyle(
                          color: selected ? colors.primary : colors.onSurface,
                          fontWeight: selected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        controller.selectMenu(index);
                      },
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Get.toNamed(AppRoutes.landing);
                    },
                    icon: const Icon(Icons.storefront_outlined),
                    label: const Text('View storefront'),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await Get.find<AuthController>().logout();
                      Get.offAllNamed(AppRoutes.adminLogin);
                    },
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text('Sign out'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
