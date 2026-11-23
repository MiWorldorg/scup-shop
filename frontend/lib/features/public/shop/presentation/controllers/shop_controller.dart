import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sculpture_shop/core/api/api_response.dart';
import 'package:sculpture_shop/features/public/shop/data/entity/product_response.dart';
import 'package:sculpture_shop/features/public/shop/data/entity/shop_category_response.dart';
import 'package:sculpture_shop/features/public/shop/domain/repository/shop_repository.dart';

class ShopController extends GetxController {
  final ShopRepository repo;

  ShopController({required this.repo});

  final products = <ProductResponse>[].obs;
  final categories = <ShopCategoryResponse>[].obs;
  final searchController = TextEditingController();
  final searchQuery = ''.obs;
  final selectedCategoryId = RxnInt();
  final categoriesLoading = false.obs;
  final categoriesError = RxnString();
  final currentPage = 1.obs;
  final lastPage = 1.obs;
  final isLoading = true.obs;
  final errorMessage = RxnString();
  int _fetchVersion = 0;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchLatestProduct();
  }

  Future<void> fetchCategories() async {
    categoriesLoading.value = true;
    categoriesError.value = null;

    try {
      final result = await repo.getCategories();
      if (isClosed) return;
      categories.assignAll(result);
    } catch (error) {
      if (isClosed) return;
      categoriesError.value = ApiResponse.userFacingError(error);
    } finally {
      if (!isClosed) categoriesLoading.value = false;
    }
  }

  Future<void> fetchLatestProduct() async {
    final version = ++_fetchVersion;
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final result = await repo.getProducts(
        currentPage.value,
        categoryId: selectedCategoryId.value,
        search: searchQuery.value.trim().isEmpty
            ? null
            : searchQuery.value.trim(),
      );
      if (isClosed || version != _fetchVersion) return;

      products.assignAll(result.rows.map(ProductResponse.fromJson));
      currentPage.value = result.currentPage;
      lastPage.value = result.lastPage;
    } catch (error) {
      if (isClosed || version != _fetchVersion) return;
      errorMessage.value = ApiResponse.userFacingError(error);
    } finally {
      if (!isClosed && version == _fetchVersion) {
        isLoading.value = false;
      }
    }
  }

  Future<void> search(String value) async {
    searchQuery.value = value.trim();
    currentPage.value = 1;
    await fetchLatestProduct();
  }

  Future<void> selectCategory(int? categoryId) async {
    if (selectedCategoryId.value == categoryId) return;
    selectedCategoryId.value = categoryId;
    currentPage.value = 1;
    await fetchLatestProduct();
  }

  Future<void> clearFilters() async {
    searchController.clear();
    searchQuery.value = '';
    selectedCategoryId.value = null;
    currentPage.value = 1;
    await fetchLatestProduct();
  }

  Future<void> goToPage(int page) async {
    if (page < 1 || page > lastPage.value || isLoading.value) return;
    currentPage.value = page;
    await fetchLatestProduct();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
