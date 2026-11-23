import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sculpture_shop/core/variable/page_padding_var.dart';
import 'package:sculpture_shop/core/widgets/admin_panel/mobile_sidebar_widget.dart';
import 'package:sculpture_shop/core/widgets/admin_panel/sidebar_widget.dart';
import 'package:sculpture_shop/core/widgets/website_navbar_mobile.dart';
import 'package:sculpture_shop/features/admin_panel/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:sculpture_shop/features/admin_panel/dashboard/presentation/pages/dashboard_widget.dart';
import 'package:sculpture_shop/features/admin_panel/posts/presentation/pages/posts_manage_page.dart';
import 'package:sculpture_shop/features/admin_panel/products/presentation/pages/products_page.dart';
import 'package:sculpture_shop/features/admin_panel/users/presentation/pages/users_page.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= 800;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        drawer: isDesktop ? null : const MobileSideBar(),
        body: SafeArea(
          child: Padding(
            padding: getResponsivePadding(context, width),
            child: isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        width: width < 1100 ? 220 : 260,
                        child: const SideBar(),
                      ),
                      const SizedBox(width: 20),
                      Expanded(child: _selectedSection()),
                    ],
                  )
                : Column(
                    children: [
                      const HeaderNavbarMobile(),
                      const SizedBox(height: 12),
                      Expanded(child: _selectedSection()),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _selectedSection() {
    return Obx(() {
      switch (controller.selectedIndex.value) {
        case 0:
          return const DashboardWidget();
        case 1:
          return UsersWidget();
        case 2:
          return ProductListWidget();
        case 3:
          return PostManagePage();
        default:
          return const Center(child: Text('Choose a workspace section.'));
      }
    });
  }
}
