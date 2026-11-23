import 'package:get/get.dart';
import 'package:sculpture_shop/features/public/shop/presentation/controllers/shop_controller.dart';
import 'package:sculpture_shop/features/public/shop/domain/repository/shop_repository.dart';

class ShopBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShopController>(
      () => ShopController(repo: Get.find<ShopRepository>()),
    );
  }
}
