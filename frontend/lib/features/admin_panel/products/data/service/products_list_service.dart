import 'package:sculpture_shop/core/api/api_client.dart';
import 'package:sculpture_shop/core/api/api_response.dart';
import 'package:sculpture_shop/core/api/endpoints.dart';
import 'package:sculpture_shop/features/admin_panel/products/data/entity/products_list_response.dart';

class ProductListService {
  final ApiClient client;
  ProductListService({required this.client});

  Future<ApiPaginatedResult> call(int page) async {
    final response = await client.getJson(
      EndPoints.productsList,
      query: {'page': page.toString()},
      authenticated: true,
    );
    return ApiResponse.paginated(response);
  }

  Future<List<ProductCategoryResponse>> getCategories() async {
    final response = await client.getJson(
      EndPoints.productCategories,
      authenticated: true,
    );
    return ApiResponse.list(response)
        .map(ProductCategoryResponse.fromJson)
        .toList(growable: false);
  }

  Future<void> createProduct(Map<String, dynamic> product) async {
    final response = await client.postJson(
      EndPoints.productCreate,
      product,
      authenticated: true,
    );
    ApiResponse.object(response);
  }

  Future<void> updateProduct(int id, Map<String, dynamic> product) async {
    final response = await client.putJson(
      EndPoints.productUpdate,
      {'id': id, ...product},
      authenticated: true,
    );
    ApiResponse.object(response);
  }

  Future<void> deleteProduct(int id) async {
    final response = await client.deleteJson(
      EndPoints.productDelete,
      query: {'id': id.toString()},
      authenticated: true,
    );
    ApiResponse.ensureSuccess(response);
  }
}
