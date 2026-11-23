import 'package:get/get.dart';
import 'package:sculpture_shop/features/public/contact/data/service/contact_service.dart';
import 'package:sculpture_shop/features/public/contact/presentation/controllers/contact_us_controller.dart';

class ContactUsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContactUsController>(
      () => ContactUsController(service: Get.find<ContactService>()),
    );
  }
}
