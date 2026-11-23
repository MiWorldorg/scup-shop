import 'package:get/get.dart';
import 'package:sculpture_shop/features/admin_panel/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:sculpture_shop/features/admin_panel/posts/domain/repository/post_repository.dart';
import 'package:sculpture_shop/features/admin_panel/posts/presentation/controllers/posts_manage_controller.dart';
import 'package:sculpture_shop/features/admin_panel/products/domain/repository/products_list_repository.dart';
import 'package:sculpture_shop/features/admin_panel/products/presentation/controllers/products_list_controller.dart';
import 'package:sculpture_shop/features/admin_panel/users/domain/repository/users_manage_repository.dart';
import 'package:sculpture_shop/features/admin_panel/users/presentation/controllers/users_manage_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<UsersManageController>(
      () => UsersManageController(repo: Get.find<UsersManageRepository>()),
    );
    Get.lazyPut<ProductListController>(
      () => ProductListController(repo: Get.find<ProductListRepository>()),
    );
    Get.lazyPut<PostsManageController>(
      () => PostsManageController(repo: Get.find<PostManageRepository>()),
    );
  }
}
