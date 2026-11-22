import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import 'package:sculpture_shop/core/constants/routes.dart';

class HeaderNavbarDeskTop extends StatelessWidget {
  final RxInt selectedIndex;

  const HeaderNavbarDeskTop({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    final data = NavbarList();

    return Container(
      constraints: const BoxConstraints(minHeight: 88),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Image.asset('assets/images/SpcLogo.png', height: 62),
          const SizedBox(width: 20),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var index = 0; index < data.menuNav.length; index++)
                    _menuEntry(context, data.menuNav[index], index),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Tooltip(
            message: 'Open dashboard',
            child: OutlinedButton.icon(
              onPressed: () => Get.toNamed(AppRoutes.dashboard),
              icon: const Icon(Ionicons.person_outline, size: 18),
              label: const Text('Dashboard'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                minimumSize: const Size(48, 44),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuEntry(BuildContext context, NavMenuModel item, int index) {
    final isSelected =
        selectedIndex.value == index || Get.currentRoute == item.routes;
    final color = isSelected
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onBackground.withOpacity(0.78);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: TextButton(
        onPressed: () {
          if (Get.currentRoute != item.routes) Get.toNamed(item.routes);
        },
        style: TextButton.styleFrom(
          foregroundColor: color,
          backgroundColor: isSelected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
              : Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
        child: Text(item.title, maxLines: 1),
      ),
    );
  }
}

class NavMenuModel {
  final IconData icon;
  final String title;
  final String routes;

  const NavMenuModel({
    required this.icon,
    required this.title,
    required this.routes,
  });
}

class NavbarList {
  final menuNav = const [
    NavMenuModel(
      icon: Ionicons.home_outline,
      title: 'Home',
      routes: AppRoutes.landing,
    ),
    NavMenuModel(
      icon: Ionicons.bag_handle_outline,
      title: 'Shop',
      routes: AppRoutes.shop,
    ),
    NavMenuModel(
      icon: Ionicons.book_outline,
      title: 'Blog',
      routes: AppRoutes.blog,
    ),
    NavMenuModel(
      icon: Ionicons.information_circle_outline,
      title: 'About us',
      routes: AppRoutes.aboutUs,
    ),
    NavMenuModel(
      icon: Ionicons.help_circle_outline,
      title: 'Contact us',
      routes: AppRoutes.contactUs,
    ),
    NavMenuModel(
      icon: Ionicons.images_outline,
      title: 'Gallery',
      routes: AppRoutes.gallery,
    ),
  ];
}
