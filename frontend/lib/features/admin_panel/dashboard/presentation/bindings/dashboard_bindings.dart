import 'package:get/get.dart';
import 'package:sculpture_shop/features/admin_panel/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:sculpture_shop/features/admin_panel/posts/presentation/bindings/posts_manage_binding.dart';
import 'package:sculpture_shop/features/admin_panel/products/presentation/bindings/products_list_bindings.dart';
import 'package:sculpture_shop/features/admin_panel/users/presentation/bindings/users_manage_binding.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    UsersManageBinding().dependencies();
    ProductListBinding().dependencies();
    PostsManageBinding().dependencies();
  }
}
