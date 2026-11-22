import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:sculpture_shop/core/variable/page_padding_var.dart';
import 'package:sculpture_shop/core/widgets/website_navbar_mobile.dart';
import 'package:sculpture_shop/features/admin_panel/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:sculpture_shop/features/admin_panel/posts/presentation/pages/posts_manage_page.dart';
import 'package:sculpture_shop/features/admin_panel/products/presentation/pages/products_page.dart';
import 'package:sculpture_shop/features/admin_panel/dashboard/presentation/pages/dashboard_widget.dart';
import 'package:sculpture_shop/features/admin_panel/users/presentation/pages/users_page.dart';
import 'package:sculpture_shop/core/widgets/admin_panel/sidebar_widget.dart';

import '../../../../../core/widgets/admin_panel/mobile_sidebar_widget.dart';

class DashboardPage extends GetView<DashboardController> {
  final double screenWidth = Get.width;
  DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
          drawer: ResponsiveBreakpoints.of(context).isMobile
              ? const MobileSideBar()
              : null,
          body: SafeArea(
            child: Padding(
                padding: getResponsivePadding(context, screenWidth),
                child: ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET)
                    ? Row(
                        children: [
                          const Expanded(
                              flex: 3,
                              child: SizedBox(
                                child: SideBar(),
                              )),
                          Expanded(
                              flex: 9,
                              child: Obx(() {
                                switch (controller.selectedIndex.value) {
                                  case 0:
                                    return const DashboardWidget(); // Dashboard content
                                  case 1:
                                    return UsersWidget(); // Users content
                                  case 2:
                                    return ProductListWidget();
                                  case 3:
                                    return PostManagePage();

                                  /// Products content
                                  // Add cases for other menu items if needed
                                  default:
                                    return Container(); // Default content
                                }
                              })),
                        ],
                      )
                    : Column(
                        children: [
                          const HeaderNavbarMobile(),
                          Expanded(child: Obx(() {
                            switch (controller.selectedIndex.value) {
                              case 0:
                                return const DashboardWidget(); // Dashboard content
                              case 1:
                                return UsersWidget(); // Users content
                              case 2:
                                return ProductListWidget();
                              case 3:
                                return PostManagePage(); // Products content
                              // Add cases for other menu items if needed
                              default:
                                return Container(); // Default content
                            }
                          })),
                        ],
                      )),
          )),
    );
  }
}
