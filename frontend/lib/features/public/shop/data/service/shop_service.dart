import 'package:sculpture_shop/core/api/api_client.dart';
import 'package:sculpture_shop/core/api/api_response.dart';
import 'package:sculpture_shop/core/api/endpoints.dart';
import 'package:sculpture_shop/features/public/shop/data/entity/shop_category_response.dart';

class ShopService {
  final ApiClient client;

  ShopService({required this.client});

  Future<ApiPaginatedResult> call(
    int page, {
    int? categoryId,
    String? search,
  }) async {
    final query = <String, String>{'page': page.toString()};
    if (categoryId != null) query['category_id'] = categoryId.toString();
    if (search != null && search.trim().isNotEmpty) {
      query['search'] = search.trim();
    }

    final response = await client.getJson(EndPoints.products, query: query);
    return ApiResponse.paginated(response);
  }

  Future<List<ShopCategoryResponse>> getCategories() async {
    final response = await client.getJson(EndPoints.productCategoriesPublic);
    return ApiResponse.list(response)
        .map(ShopCategoryResponse.fromJson)
        .toList(growable: false);
  }
}
