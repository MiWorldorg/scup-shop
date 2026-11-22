import 'package:get/get.dart';
import 'package:sculpture_shop/features/public/contact/presentation/controller/contact_us_controller.dart';

class ContactUsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContactUsController>(() => ContactUsController());
  }
}
