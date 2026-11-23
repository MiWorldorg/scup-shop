import 'package:get/get.dart';
import 'package:sculpture_shop/core/api/api_client.dart';
import 'package:sculpture_shop/features/admin_panel/posts/data/repository/post_repository_imp.dart';
import 'package:sculpture_shop/features/admin_panel/posts/data/service/posts_manage_service.dart';
import 'package:sculpture_shop/features/admin_panel/posts/domain/repository/post_repository.dart';
import 'package:sculpture_shop/features/admin_panel/products/data/repository/products_list_repository_imp.dart';
import 'package:sculpture_shop/features/admin_panel/products/data/service/products_list_service.dart';
import 'package:sculpture_shop/features/admin_panel/products/domain/repository/products_list_repository.dart';
import 'package:sculpture_shop/features/admin_panel/users/data/repository/users_manage_repository_impl.dart';
import 'package:sculpture_shop/features/admin_panel/users/data/service/service/users_manage_service.dart';
import 'package:sculpture_shop/features/admin_panel/users/domain/repository/users_manage_repository.dart';
import 'package:sculpture_shop/features/authentication/data/repository/auth_repository_impl.dart';
import 'package:sculpture_shop/features/authentication/data/service/auth_service.dart';
import 'package:sculpture_shop/features/authentication/domain/repository/auth_repository.dart';
import 'package:sculpture_shop/features/authentication/presentation/controllers/auth_controller.dart';
import 'package:sculpture_shop/features/public/blog/data/repository/post_repository_imp.dart';
import 'package:sculpture_shop/features/public/blog/data/service/post_service.dart';
import 'package:sculpture_shop/features/public/blog/domain/repository/post_repository.dart';
import 'package:sculpture_shop/features/public/shop/data/repository/shop_repository_imp.dart';
import 'package:sculpture_shop/features/public/shop/data/service/shop_service.dart';
import 'package:sculpture_shop/features/public/shop/domain/repository/shop_repository.dart';

/// Application composition root. Shared transports and repositories live here;
/// route bindings own short-lived presentation controllers.
class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<ApiClient>(ApiClient(), permanent: true);

    Get.lazyPut<AuthService>(() => AuthService(client: Get.find()));
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(service: Get.find()),
    );
    Get.put<AuthController>(
      AuthController(repository: Get.find()),
      permanent: true,
    );

    Get.lazyPut<ShopService>(() => ShopService(client: Get.find()));
    Get.lazyPut<ShopRepository>(
      () => ShopRepositoryImpl(service: Get.find()),
    );

    Get.lazyPut<PostService>(() => PostService(client: Get.find()));
    Get.lazyPut<PostRepository>(
      () => PostRepositoryImpl(service: Get.find()),
    );

    Get.lazyPut<ProductListService>(
      () => ProductListService(client: Get.find()),
    );
    Get.lazyPut<ProductListRepository>(
      () => ProductListRepositoryImpl(service: Get.find()),
    );

    Get.lazyPut<PostManageService>(
      () => PostManageService(client: Get.find()),
    );
    Get.lazyPut<PostManageRepository>(
      () => PostManageRepositoryImpl(service: Get.find()),
    );

    Get.lazyPut<UsersManageService>(
      () => UsersManageService(client: Get.find()),
    );
    Get.lazyPut<UsersManageRepository>(
      () => UsersManageRepositoryImpl(service: Get.find()),
    );
  }
}
