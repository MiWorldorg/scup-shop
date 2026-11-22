import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sculpture_shop/features/public/about_us/presentation/bindings/about_us_binding.dart';

import 'package:sculpture_shop/features/public/about_us/presentation/pages/about_us_page.dart';
import 'package:sculpture_shop/features/admin_panel/dashboard/presentation/bindings/dashboard_bindings.dart';
import 'package:sculpture_shop/features/admin_panel/products/presentation/bindings/products_list_bindings.dart';
import 'package:sculpture_shop/features/admin_panel/dashboard/presentation/pages/dashboard_page.dart';
import 'package:sculpture_shop/features/admin_panel/products/presentation/pages/products_page.dart';
import 'package:sculpture_shop/features/admin_panel/users/presentation/pages/users_page.dart';
import 'package:sculpture_shop/features/public/blog/presentation/bindings/post_binding.dart';
import 'package:sculpture_shop/features/public/blog/presentation/pages/blog_page.dart';
import 'package:sculpture_shop/features/public/contact/presentation/binding/contact_us_binding.dart';
import 'package:sculpture_shop/features/public/contact/presentation/pages/contact_us_page.dart';
import 'package:sculpture_shop/features/public/gallery/presentation/bindings/gallery_binding.dart';
import 'package:sculpture_shop/features/public/gallery/presentation/pages/gallery_page.dart';
import 'package:sculpture_shop/features/public/landing_page/presentation/bindings/landing_binding.dart';
import 'package:sculpture_shop/features/public/landing_page/presentation/pages/landing_page.dart';
import 'package:sculpture_shop/features/public/shop/presentation/bindings/shop_binding.dart';
import 'package:sculpture_shop/features/public/shop/presentation/pages/shop_page.dart';
import 'package:sculpture_shop/features/authentication/presentation/middleware/admin_route_middleware.dart';
import 'package:sculpture_shop/features/authentication/presentation/pages/auth_page.dart';

class AppRoutes {
  //AdminSide
  static const String dashboard = '/dashboard';
  static const String adminLogin = '/admin/login';
  static const String users = '/users';
  static const String productList = '/products';

  //UserSide
  static const String landing = '/landing';
  static const String gallery = '/gallery';
  static const String blog = '/blog';
  static const String shop = '/shop';
  static const String profile = '/profile';
  static const String aboutUs = '/about-us';
  static const String contactUs = '/contact-us';

  static List<GetPage> get pages => [
    GetPage(
      name: AppRoutes.shop,
      page: () => ShopPage(),
      binding: ShopBinding(),
    ),
    GetPage(name: AppRoutes.profile, page: () => Container(), binding: null),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => DashboardPage(),
      binding: DashboardBinding(),
      middlewares: [AdminRouteMiddleware()],
    ),
    GetPage(name: AppRoutes.adminLogin, page: () => const AuthPage()),
    GetPage(
      name: AppRoutes.users,
      page: () => UsersWidget(),
      binding: null,
      middlewares: [AdminRouteMiddleware()],
    ),
    GetPage(
      name: AppRoutes.productList,
      page: () => ProductListWidget(),
      binding: ProductListBinding(),
      middlewares: [AdminRouteMiddleware()],
    ),
    GetPage(
      name: AppRoutes.landing,
      page: () => LandingPage(),
      binding: LandingBinding(),
    ),
    GetPage(
      name: AppRoutes.blog,
      page: () => BlogPage(),
      binding: PostBinding(),
    ),
    GetPage(
      name: AppRoutes.aboutUs,
      page: () => AboutUsPage(),
      binding: AboutUsBinding(),
    ),
    GetPage(
      name: AppRoutes.gallery,
      page: () => GalleryPage(),
      binding: GalleryBinding(),
    ),
    GetPage(
      name: AppRoutes.contactUs,
      page: () => ContactUsPage(),
      binding: ContactUsBinding(),
    ),
  ];
}
