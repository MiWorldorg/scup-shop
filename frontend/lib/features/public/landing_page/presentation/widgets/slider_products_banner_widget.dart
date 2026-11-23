import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sculpture_shop/core/constants/routes.dart';

class SliderBanner extends StatelessWidget {
  const SliderBanner({super.key});

  static const _slides = [
    ('assets/images/sculpture-banner-1.png', 'Welcome to Sculpture Shop'),
    ('assets/images/sculpture-banner-2.png', 'Art made to be lived with'),
    ('assets/images/sculpture-banner-3.png', 'Find a piece that speaks to you'),
  ];

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 600;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return CarouselSlider.builder(
      itemCount: _slides.length,
      itemBuilder: (context, index, realIndex) {
        final (image, title) = _slides[index];
        return Padding(
          padding: EdgeInsets.all(compact ? 18 : 42),
          child: compact
              ? _mobileSlide(context, image, title)
              : _desktopSlide(context, image, title),
        );
      },
      options: CarouselOptions(
        height: compact ? 390 : 500,
        viewportFraction: 1,
        autoPlay: !reduceMotion,
        autoPlayInterval: const Duration(seconds: 6),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        pauseAutoPlayOnTouch: true,
      ),
    );
  }

  Widget _mobileSlide(BuildContext context, String image, String title) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SCULPTURE SHOP',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: colors.primary,
            letterSpacing: 2,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 27),
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: () => Get.toNamed(AppRoutes.shop),
          child: const Text('Explore the collection'),
        ),
        const SizedBox(height: 6),
        Expanded(child: _slideArt(context, image)),
      ],
    );
  }

  Widget _desktopSlide(BuildContext context, String image, String title) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'SCULPTURE SHOP',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colors.primary,
                    letterSpacing: 2.4,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.headlineMedium?.copyWith(fontSize: 42, height: 1.12),
                ),
                const SizedBox(height: 14),
                Text(
                  'Thoughtful objects, timeless forms, and details made to last.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.onBackground.withOpacity(0.75),
                  ),
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton.icon(
                    onPressed: () => Get.toNamed(AppRoutes.shop),
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: const Text('Explore the collection'),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(flex: 4, child: _slideArt(context, image)),
      ],
    );
  }

  Widget _slideArt(BuildContext context, String image) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          'assets/images/sculpture-banner-background.png',
          fit: BoxFit.contain,
          semanticLabel: 'Decorative sculpture illustration background',
        ),
        Image.asset(
          image,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Icon(
            Icons.image_not_supported_outlined,
            size: 48,
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.4),
          ),
        ),
      ],
    );
  }
}
