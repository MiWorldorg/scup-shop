import 'package:get/get.dart';
import 'package:sculpture_shop/features/admin_panel/products/data/repository/products_list_repository_imp.dart';
import 'package:sculpture_shop/features/admin_panel/products/presentation/controllers/products_list_controller.dart';

class ProductListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductListController>(
        () => ProductListController(repo: ProductListRepositoryImpl()));
  }
}
