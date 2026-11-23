import 'package:get/get.dart';
import 'package:sculpture_shop/features/authentication/domain/repository/auth_repository.dart';
import 'package:sculpture_shop/features/authentication/presentation/controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AuthController>()) {
      Get.put(AuthController(repository: Get.find<AuthRepository>()), permanent: true);
    }
  }
}
