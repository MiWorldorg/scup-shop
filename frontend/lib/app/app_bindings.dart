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

/// Composition root for shared application dependencies.
class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<ApiClient>(ApiClient(), permanent: true);

    Get.lazyPut<AuthService>(
      () => AuthService(client: Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(service: Get.find<AuthService>()),
      fenix: true,
    );
    Get.put<AuthController>(
      AuthController(repository: Get.find<AuthRepository>()),
      permanent: true,
    );

    Get.lazyPut<ShopService>(
      () => ShopService(client: Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<ShopRepository>(
      () => ShopRepositoryImpl(service: Get.find<ShopService>()),
      fenix: true,
    );

    Get.lazyPut<PostService>(
      () => PostService(client: Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<PostRepository>(
      () => PostRepositoryImpl(service: Get.find<PostService>()),
      fenix: true,
    );

    Get.lazyPut<ProductListService>(
      () => ProductListService(client: Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<ProductListRepository>(
      () => ProductListRepositoryImpl(service: Get.find<ProductListService>()),
      fenix: true,
    );

    Get.lazyPut<PostManageService>(
      () => PostManageService(client: Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<PostManageRepository>(
      () => PostManageRepositoryImpl(service: Get.find<PostManageService>()),
      fenix: true,
    );

    Get.lazyPut<UsersManageService>(
      () => UsersManageService(client: Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<UsersManageRepository>(
      () => UsersManageRepositoryImpl(service: Get.find<UsersManageService>()),
      fenix: true,
    );
  }
}
