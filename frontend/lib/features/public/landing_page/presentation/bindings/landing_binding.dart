import 'package:get/get.dart';
import 'package:sculpture_shop/features/public/blog/domain/repository/post_repository.dart';
import 'package:sculpture_shop/features/public/blog/presentation/controllers/post_controller.dart';
import 'package:sculpture_shop/features/public/landing_page/presentation/controllers/landing_controller.dart';
import 'package:sculpture_shop/features/public/shop/domain/repository/shop_repository.dart';
import 'package:sculpture_shop/features/public/shop/presentation/controllers/shop_controller.dart';

class LandingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShopController>(
      () => ShopController(repo: Get.find<ShopRepository>()),
    );
    Get.lazyPut<PostController>(
      () => PostController(repo: Get.find<PostRepository>()),
    );
    Get.lazyPut<LandingController>(
      () => LandingController(
        shopController: Get.find<ShopController>(),
        postController: Get.find<PostController>(),
      ),
    );
  }
}
