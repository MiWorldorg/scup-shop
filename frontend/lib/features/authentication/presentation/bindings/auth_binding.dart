import 'package:get/get.dart';
import 'package:sculpture_shop/features/authentication/presentation/controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
  }
}
