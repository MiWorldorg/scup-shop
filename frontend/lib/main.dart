import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:sculpture_shop/app/app_bindings.dart';
import 'package:sculpture_shop/core/api/api_session.dart';
import 'package:sculpture_shop/core/constants/routes.dart';
import 'package:sculpture_shop/core/theme/design_tokens.dart';
import 'package:sculpture_shop/core/theme/theme_light.dart';
import 'package:sculpture_shop/features/authentication/presentation/controllers/auth_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiSession.initialize();
  AppBindings().dependencies();
  await Get.find<AuthController>().restoreSession();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: GetMaterialApp(
        initialBinding: AppBindings(),
        builder: (context, child) => ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: [
            const Breakpoint(
              start: 0,
              end: AppBreakpoints.mobile,
              name: MOBILE,
            ),
            const Breakpoint(
              start: AppBreakpoints.mobile + 1,
              end: AppBreakpoints.tablet,
              name: TABLET,
            ),
            const Breakpoint(
              start: AppBreakpoints.tablet + 1,
              end: 1920,
              name: DESKTOP,
            ),
            const Breakpoint(
              start: 1921,
              end: double.infinity,
              name: '4K',
            ),
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
