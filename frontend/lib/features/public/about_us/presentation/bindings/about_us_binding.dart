import 'package:get/get.dart';
import 'package:sculpture_shop/features/public/about_us/presentation/controllers/about_us_controlelr.dart';

class AboutUsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AboutUsController>(() => AboutUsController());
  }
}
