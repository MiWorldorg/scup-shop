import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sculpture_shop/core/variable/page_padding_var.dart';
import 'package:sculpture_shop/core/widgets/header.dart';
import 'package:sculpture_shop/core/widgets/sections_header.dart';
import 'package:sculpture_shop/core/widgets/website_drawer_mobile.dart';
import 'package:sculpture_shop/core/widgets/website_footer.dart';
import 'package:sculpture_shop/features/public/gallery/presentation/controllers/gallery_controller.dart';

class GalleryPage extends GetView<GalleryController> {
  GalleryPage({super.key});

  static const _images = [
    'assets/images/gallery/gallery-1.png',
    'assets/images/gallery/gallery-2.png',
    'assets/images/gallery/gallery-3.png',
    'assets/images/gallery/gallery-4.png',
    'assets/images/gallery/gallery-5.png',
    'assets/images/gallery/gallery-6.png',
    'assets/images/gallery/gallery-7.png',
    'assets/images/gallery/gallery-8.png',
    'assets/images/gallery/gallery-9.png',
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final compact = width < 600;
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
                Header(selectedIndex: 5.obs),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 26,
                  ),
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
                        'IN THE STUDIO',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: colors.primary,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'A closer look at the collection',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 18),
                      CarouselSlider.builder(
                        itemCount: _images.length,
                        itemBuilder: (context, index, realIndex) =>
                            _galleryImage(context, _images[index], index),
                        options: CarouselOptions(
                          height: compact ? 250 : 420,
                          viewportFraction: compact ? 0.88 : 0.72,
                          enlargeCenterPage: true,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 5),
                          pauseAutoPlayOnTouch: true,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const SectionsHeader(title: 'Gallery'),
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _images.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 340,
                    mainAxisExtent: 250,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemBuilder: (context, index) => _galleryImage(
                    context,
                    _images[index],
                    index,
                    openOnTap: true,
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

  Widget _galleryImage(
    BuildContext context,
    String path,
    int index, {
    bool openOnTap = false,
  }) {
    final image = ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Image.asset(
        path,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        semanticLabel: 'Sculpture gallery image ${index + 1}',
      ),
    );
    if (!openOnTap) return image;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => showDialog<void>(
          context: context,
          builder: (context) => Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(20),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                InteractiveViewer(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.asset(path, fit: BoxFit.contain),
                  ),
                ),
                IconButton.filledTonal(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  tooltip: 'Close image',
                ),
              ],
            ),
          ),
        ),
        child: image,
      ),
    );
  }
}
