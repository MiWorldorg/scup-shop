import 'package:get/get.dart';
import 'package:sculpture_shop/features/admin_panel/products/domain/repository/products_list_repository.dart';
import 'package:sculpture_shop/features/admin_panel/products/presentation/controllers/products_list_controller.dart';

class ProductListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductListController>(
      () => ProductListController(repo: Get.find<ProductListRepository>()),
    );
  }
}
