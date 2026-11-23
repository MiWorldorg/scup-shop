import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:sculpture_shop/core/api/api_response.dart';
import 'package:sculpture_shop/features/public/shop/data/entity/shop_category_response.dart';
import 'package:sculpture_shop/features/public/shop/domain/repository/shop_repository.dart';
import 'package:sculpture_shop/features/public/shop/presentation/controllers/shop_controller.dart';

class _ControlledShopRepository implements ShopRepository {
  final Completer<ApiPaginatedResult> firstRequest = Completer();
  final requests = <({int page, int? categoryId, String? search})>[];
  int callCount = 0;
  bool holdFirstRequest = false;

  ApiPaginatedResult _page(int id, int page) => ApiPaginatedResult(
    rows: [
      {
        'id': id,
        'name': 'Sculpture $id',
        'desc': 'Test sculpture',
        'sku': 'SC-TEST-$id',
        'image': 'assets/images/products/marble-think.png',
        'category_id': 1,
        'category': {'id': 1, 'name': 'Sculptures'},
        'inventory_id': id,
        'inventory': {'id': id, 'quantity': 2},
        'price': 1250,
      },
    ],
    currentPage: page,
    lastPage: 2,
    total: 2,
  );

  @override
  Future<ApiPaginatedResult> getProducts(
    int page, {
    int? categoryId,
    String? search,
  }) {
    requests.add((page: page, categoryId: categoryId, search: search));
    callCount++;
    if (callCount == 1 && holdFirstRequest) return firstRequest.future;
    return Future.value(_page(2, page));
  }

  @override
  Future<List<ShopCategoryResponse>> getCategories() async => const [];
}

void main() {
  late _ControlledShopRepository repository;
  late ShopController controller;

  setUp(() {
    repository = _ControlledShopRepository();
    controller = ShopController(repo: repository);
  });

  tearDown(() {
    controller.searchController.dispose();
  });

  test('ignores an older response when a newer request completes first', () async {
    repository.holdFirstRequest = true;
    final olderRequest = controller.fetchLatestProduct();
    final newerRequest = controller.fetchLatestProduct();

    await newerRequest;
    repository.firstRequest.complete(repository._page(1, 1));
    await olderRequest;

    expect(controller.products, hasLength(1));
    expect(controller.products.single.productId, 2);
    expect(controller.isLoading.value, isFalse);
  });

  test('search resets pagination and forwards the search term', () async {
    await controller.fetchLatestProduct();
    controller.currentPage.value = 2;

    await controller.search('Greek');

    expect(repository.requests.last.page, 1);
    expect(repository.requests.last.search, 'Greek');
    expect(controller.currentPage.value, 1);
  });

  test('category selection resets pagination and forwards the category id',
      () async {
    await controller.fetchLatestProduct();
    controller.currentPage.value = 2;

    await controller.selectCategory(7);

    expect(repository.requests.last.page, 1);
    expect(repository.requests.last.categoryId, 7);
    expect(controller.selectedCategoryId.value, 7);
  });
}
