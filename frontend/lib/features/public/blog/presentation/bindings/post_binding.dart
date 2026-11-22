import 'package:get/get.dart';
import 'package:sculpture_shop/features/public/blog/presentation/controllers/post_controller.dart';

import '../../data/repository/post_repository_imp.dart';

class PostBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostController>(
        () => PostController(repo: PostRepositoryImpl()));
  }
}
