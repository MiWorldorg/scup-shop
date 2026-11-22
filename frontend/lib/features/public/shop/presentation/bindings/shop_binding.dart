import 'package:get/get.dart';
import 'package:sculpture_shop/features/public/shop/data/repository/shop_repository_imp.dart';

import '../controllers/shop_controller.dart';

class ShopBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShopController>(
        () => ShopController(repo: ShopRepositoryImpl()));
  }
}
