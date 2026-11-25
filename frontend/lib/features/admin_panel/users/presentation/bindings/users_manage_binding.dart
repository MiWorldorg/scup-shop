import 'package:get/get.dart';
import 'package:sculpture_shop/features/admin_panel/users/domain/repository/users_manage_repository.dart';
import 'package:sculpture_shop/features/admin_panel/users/presentation/controllers/users_manage_controller.dart';

class UsersManageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UsersManageController>(
      () => UsersManageController(repo: Get.find<UsersManageRepository>()),
    );
  }
}
