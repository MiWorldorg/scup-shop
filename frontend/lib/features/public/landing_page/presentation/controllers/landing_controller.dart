import 'package:get/get.dart';
import 'package:sculpture_shop/features/public/blog/presentation/controllers/post_controller.dart';
import 'package:sculpture_shop/features/public/shop/presentation/controllers/shop_controller.dart';

/// Coordinates the data controllers rendered together on the landing page.
class LandingController extends GetxController {
  final ShopController shopController;
  final PostController postController;

  LandingController({
    required this.shopController,
    required this.postController,
  });
}
