import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:sculpture_shop/core/api/api_session.dart';
import 'package:sculpture_shop/core/constants/routes.dart';
import 'package:sculpture_shop/core/theme/theme_light.dart';
import 'package:sculpture_shop/features/authentication/presentation/controllers/auth_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiSession.initialize();
  final authController = AuthController();
  Get.put<AuthController>(authController, permanent: true);
  await authController.restoreSession();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: GetMaterialApp(
        builder: (context, child) => ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: [
            const Breakpoint(start: 0, end: 450, name: MOBILE),
            const Breakpoint(start: 451, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
        ),
        debugShowCheckedModeBanner: false,
        theme: AppThemes.lightTheme,
        getPages: AppRoutes.pages,
        initialRoute: AppRoutes.landing,
      ),
    );
  }
}
