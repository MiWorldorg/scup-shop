import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:sculpture_shop/core/constants/routes.dart';
import 'package:sculpture_shop/features/admin_panel/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:sculpture_shop/features/authentication/presentation/controllers/auth_controller.dart';

class SideBar extends GetView<DashboardController> {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    final data = SideMenuData().menu;
    final colors = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Theme.of(context).cardColor,
        border: Border.all(color: colors.onSurface.withOpacity(0.07)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: colors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  Icons.dashboard_customize_outlined,
                  color: colors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Admin panel',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      'Sculpture Shop',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.onSurface.withOpacity(0.58),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 26),
          Text(
            'WORKSPACE',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colors.onSurface.withOpacity(0.5),
              letterSpacing: 1.4,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Obx(
              () => ListView.separated(
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
                    onTap: () => controller.selectMenu(index),
                  );
                },
              ),
            ),
          ),
          OutlinedButton.icon(
            onPressed: () => Get.toNamed(AppRoutes.landing),
            icon: const Icon(Icons.open_in_new_rounded, size: 17),
            label: const Text('View storefront'),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () async {
              await Get.find<AuthController>().logout();
              Get.offAllNamed(AppRoutes.adminLogin);
            },
            icon: const Icon(Icons.logout_rounded, size: 17),
            label: const Text('Sign out'),
          ),
        ],
      ),
    );
  }
}

class MenuModel {
  final IconData icon;
  final String title;
  final String routes;
  final int selectedIndex;

  const MenuModel({
    required this.selectedIndex,
    required this.icon,
    required this.title,
    required this.routes,
  });
}

class SideMenuData {
  final menu = const [
    MenuModel(
      icon: Ionicons.home_outline,
      title: 'Dashboard',
      routes: AppRoutes.dashboard,
      selectedIndex: 0,
    ),
    MenuModel(
      icon: Ionicons.people_outline,
      title: 'Users & roles',
      routes: AppRoutes.users,
      selectedIndex: 1,
    ),
    MenuModel(
      icon: Ionicons.bag_handle_outline,
      title: 'Products',
      routes: AppRoutes.productList,
      selectedIndex: 2,
    ),
    MenuModel(
      icon: Ionicons.book_outline,
      title: 'Posts',
      routes: '',
      selectedIndex: 3,
    ),
  ];
}
