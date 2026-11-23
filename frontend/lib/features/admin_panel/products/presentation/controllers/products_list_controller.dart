import 'package:get/get.dart';
import 'package:sculpture_shop/core/api/api_response.dart';
import 'package:sculpture_shop/features/admin_panel/products/domain/repository/products_list_repository.dart';
import '../../data/entity/products_list_response.dart';

class ProductListController extends GetxController {
  final ProductListRepository repo;
  ProductListController({required this.repo});

  final products = <ProductListResponse>[].obs;
  final categories = <ProductCategoryResponse>[].obs;
  final currentPage = 1.obs;
  final lastPage = 1.obs;
  final isLoading = true.obs;
  final isLoadingCategories = true.obs;
  final categoriesError = RxnString();
  final errorMessage = RxnString();
  int _fetchVersion = 0;

  @override
  void onInit() {
    super.onInit();
    fetchLatestProduct();
    fetchCategories();
  }

  Future<void> fetchLatestProduct() async {
    final version = ++_fetchVersion;
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final result = await repo.getProductsList(currentPage.value);
      if (isClosed || version != _fetchVersion) return;
      products.assignAll(result.rows.map(ProductListResponse.fromJson));
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

  Future<void> fetchCategories() async {
    isLoadingCategories.value = true;
    categoriesError.value = null;
    try {
      final result = await repo.getCategories();
      if (isClosed) return;
      categories.assignAll(result);
    } catch (error) {
      if (isClosed) return;
      categoriesError.value = ApiResponse.userFacingError(error);
    } finally {
      if (!isClosed) isLoadingCategories.value = false;
    }
  }

  Future<void> createProduct(Map<String, dynamic> product) async {
    await repo.createProduct(product);
    currentPage.value = 1;
    await fetchLatestProduct();
  }

  Future<void> updateProduct(int id, Map<String, dynamic> product) async {
    await repo.updateProduct(id, product);
    await fetchLatestProduct();
  }

  Future<void> deleteProduct(int id) async {
    await repo.deleteProduct(id);
    if (products.length == 1 && currentPage.value > 1) currentPage.value--;
    await fetchLatestProduct();
  }
}
