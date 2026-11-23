import 'package:get/get.dart';
import 'package:sculpture_shop/core/api/api_response.dart';
import 'package:sculpture_shop/features/public/shop/data/entity/product_response.dart';
import 'package:sculpture_shop/features/public/shop/domain/repository/shop_repository.dart';

class ShopController extends GetxController {
  final ShopRepository repo;
  ShopController({required this.repo});

  final products = <ProductResponse>[].obs;
  final currentPage = 1.obs;
  final lastPage = 1.obs;
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
      products.assignAll(result.rows.map(ProductResponse.fromJson));
      currentPage.value = result.currentPage;
      lastPage.value = result.lastPage;
    } catch (error) {
      if (isClosed || version != _fetchVersion) return;
      errorMessage.value = ApiResponse.userFacingError(error);
    } finally {
      if (!isClosed && version == _fetchVersion) isLoading.value = false;
    }
  }

  Future<void> goToPage(int page) async {
    if (page < 1 || page > lastPage.value || isLoading.value) return;
    currentPage.value = page;
    await fetchLatestProduct();
  }
}
