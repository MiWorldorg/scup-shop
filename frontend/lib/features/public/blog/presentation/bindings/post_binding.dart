import 'package:get/get.dart';
import 'package:sculpture_shop/features/public/blog/domain/repository/post_repository.dart';
import 'package:sculpture_shop/features/public/blog/presentation/controllers/post_controller.dart';

class PostBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostController>(
      () => PostController(repo: Get.find<PostRepository>()),
    );
  }
}
