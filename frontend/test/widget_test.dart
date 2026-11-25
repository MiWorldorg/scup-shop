import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:sculpture_shop/core/api/api_response.dart';
import 'package:sculpture_shop/features/public/blog/domain/repository/post_repository.dart';
import 'package:sculpture_shop/features/public/shop/data/entity/shop_category_response.dart';
import 'package:sculpture_shop/features/public/shop/domain/repository/shop_repository.dart';
import 'package:sculpture_shop/main.dart';

class _FakeShopRepository implements ShopRepository {
  @override
  Future<ApiPaginatedResult> getProducts(
    int page, {
    int? categoryId,
    String? search,
  }) async => const ApiPaginatedResult(
    rows: [],
    currentPage: 1,
    lastPage: 1,
    total: 0,
  );

  @override
  Future<List<ShopCategoryResponse>> getCategories() async => const [];
}

class _FakePostRepository implements PostRepository {
  @override
  Future<ApiPaginatedResult> getPosts(int page) async =>
      const ApiPaginatedResult(
        rows: [],
        currentPage: 1,
        lastPage: 1,
        total: 0,
      );
}

void main() {
  setUp(() async {
    await Get.reset();
    Get.testMode = true;
    Get.put<ShopRepository>(_FakeShopRepository());
    Get.put<PostRepository>(_FakePostRepository());
  });

  tearDown(() async {
    await Get.reset();
    Get.testMode = false;
  });

  testWidgets('application opens the public landing route with injected data',
      (WidgetTester tester) async {
    await tester.view.setPhysicalSize(const Size(1280, 900));
    await tester.view.setDevicePixelRatio(1);

    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.byType(GetMaterialApp), findsOneWidget);
    expect(find.text('SCULPTURE SHOP'), findsWidgets);
    expect(find.text('A closer look at quality'), findsOneWidget);

    await tester.view.resetPhysicalSize();
    await tester.view.resetDevicePixelRatio();
  });
}
