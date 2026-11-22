import 'package:get/get.dart';
import 'package:sculpture_shop/features/public/gallery/presentation/controllers/gallery_controller.dart';

class GalleryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GalleryController>(() => GalleryController());
  }
}
