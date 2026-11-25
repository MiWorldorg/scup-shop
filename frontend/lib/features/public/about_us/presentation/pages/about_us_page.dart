import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sculpture_shop/core/variable/page_padding_var.dart';
import 'package:sculpture_shop/core/widgets/header.dart';
import 'package:sculpture_shop/core/widgets/website_drawer_mobile.dart';
import 'package:sculpture_shop/core/widgets/website_footer.dart';

class AboutUsPage extends StatelessWidget {
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
                    border: Border.all(color: colors.outline),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth >= 760;
                      final story = Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'OUR STORY',
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(
                                  color: colors.primary,
                                  letterSpacing: 2,
                                ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'A space for sculpture and craft',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Scup-Shop is a digital showcase for sculpture and decorative art. Explore forms, materials, and ideas through the collection and its journal, then get in touch to ask about a piece.',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: colors.onSurfaceVariant),
                          ),
                        ],
                      );
                      final artwork = Image.asset(
                        'assets/images/sculpture-object.png',
                        height: isWide ? 360 : 260,
                        fit: BoxFit.contain,
                        semanticLabel: 'Sculpture artwork from the Scup-Shop collection',
                      );

                      if (!isWide) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            story,
                            const SizedBox(height: 24),
                            artwork,
                          ],
                        );
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(child: story),
                          const SizedBox(width: 28),
                          Expanded(child: artwork),
                        ],
                      );
                    },
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
