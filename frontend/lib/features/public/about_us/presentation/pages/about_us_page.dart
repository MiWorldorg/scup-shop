import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sculpture_shop/core/variable/page_padding_var.dart';
import 'package:sculpture_shop/core/widgets/header.dart';
import 'package:sculpture_shop/core/widgets/website_drawer_mobile.dart';
import 'package:sculpture_shop/core/widgets/website_footer.dart';
import 'package:sculpture_shop/features/public/about_us/presentation/controllers/about_us_controller.dart';

class AboutUsPage extends GetView<AboutUsController> {
  AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      drawer: MobileDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: getResponsivePadding(context, width),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Header(selectedIndex: 3.obs),
                const SizedBox(height: 28),
                Container(
                  padding: EdgeInsets.all(width < 500 ? 20 : 38),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: colors.onBackground.withOpacity(0.07),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'OUR STORY',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: colors.primary,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'A space for sculpture and craft',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'This website was designed and developed by Mahdi Izadi and Amin Mashhadi Farahani as the final project for a web design course. It presents a sculpture storefront with a distinctive visual style.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colors.onBackground.withOpacity(0.76),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 34,
                        runSpacing: 24,
                        children: [
                          Image.asset(
                            'assets/images/Shamsipour-fa-logo.svg.png',
                            height: width < 500 ? 100 : 150,
                            fit: BoxFit.contain,
                          ),
                          Image.asset(
                            'assets/images/TVU_logo.png',
                            height: width < 500 ? 100 : 150,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Footer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
