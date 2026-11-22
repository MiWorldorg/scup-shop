import 'package:get/get.dart';
import 'package:sculpture_shop/core/api/api_response.dart';
import 'package:sculpture_shop/features/public/shop/data/entity/product_response.dart';
import 'package:sculpture_shop/features/public/shop/domain/repository/shop_repository.dart';

class ShopController extends GetxController {
  late ShopRepository repo;
  ShopController({required this.repo});
  var products = <ProductResponse>[].obs;
  var currentPage = 1.obs;
  final isLoading = true.obs;
  final errorMessage = RxnString();
  int _fetchVersion = 0;

  @override
  void onInit() {
    super.onInit();
    fetchLatestProduct();
  }

  Future<void> fetchLatestProduct() async {
    final version = ++_fetchVersion;
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final result = await repo.getProducts(currentPage.value);
      if (isClosed || version != _fetchVersion) return;
      products.assignAll(result);
    } catch (error) {
      if (isClosed || version != _fetchVersion) return;
      errorMessage.value = ApiResponse.userFacingError(error);
    } finally {
      if (!isClosed && version == _fetchVersion) isLoading.value = false;
    }
  }
}
