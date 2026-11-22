import 'package:get/get.dart';
import 'package:sculpture_shop/features/public/landing_page/presentation/controllers/landing_controller.dart';

import '../../data/repository/shop_repository_imp.dart';

class LandingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LandingController>(
        () => LandingController(repo: LandingRepositoryImpl()));

  }
}
