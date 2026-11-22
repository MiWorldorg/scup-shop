import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sculpture_shop/core/constants/routes.dart';
import 'package:sculpture_shop/features/authentication/presentation/controllers/auth_controller.dart';

class AdminRouteMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (Get.find<AuthController>().isAdmin) return null;
    return const RouteSettings(name: AppRoutes.adminLogin);
  }
}
