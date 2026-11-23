import 'package:get/get.dart';
import 'package:sculpture_shop/features/admin_panel/posts/domain/repository/post_repository.dart';
import 'package:sculpture_shop/features/admin_panel/posts/presentation/controllers/posts_manage_controller.dart';

class PostsManageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostsManageController>(
      () => PostsManageController(repo: Get.find<PostManageRepository>()),
    );
  }
}
