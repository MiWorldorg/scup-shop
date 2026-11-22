import 'package:get/get.dart';
import 'package:sculpture_shop/core/api/api_response.dart';
import 'package:sculpture_shop/core/api/api_session.dart';
import 'package:sculpture_shop/core/api/endpoints.dart';
import 'package:sculpture_shop/core/api/url.dart';
import 'package:sculpture_shop/features/admin_panel/products/data/entity/products_list_response.dart';

class ProductListService extends GetConnect {
  Future<List<ProductListResponse>> call(int page) async {
    try {
      final url = Uri.parse(
        '${BaseUrl.apiUrlV1}${EndPoints.productsList}',
      ).replace(queryParameters: {'page': page.toString()});
      final response = await get(url.toString(), headers: ApiSession.headers);
      return ApiResponse.list(
        response,
      ).map(ProductListResponse.fromJson).toList(growable: false);
    } catch (error) {
      rethrow;
    }
  }

  Future<List<ProductCategoryResponse>> getCategories() async {
    final response = await get(
      '${BaseUrl.apiUrlV1}${EndPoints.productCategories}',
      headers: ApiSession.headers,
    );
    return ApiResponse.list(
      response,
    ).map(ProductCategoryResponse.fromJson).toList(growable: false);
  }

  Future<void> createProduct(Map<String, dynamic> product) async {
    final response = await post(
      '${BaseUrl.apiUrlV1}${EndPoints.productCreate}',
      product,
      headers: ApiSession.headers,
    );
    ApiResponse.object(response);
  }

  Future<void> updateProduct(int id, Map<String, dynamic> product) async {
    final response = await put(
      '${BaseUrl.apiUrlV1}${EndPoints.productUpdate}',
      {'id': id, ...product},
      headers: ApiSession.headers,
    );
    ApiResponse.object(response);
  }

  Future<void> deleteProduct(int id) async {
    final url = Uri.parse(
      '${BaseUrl.apiUrlV1}${EndPoints.productDelete}',
    ).replace(queryParameters: {'id': id.toString()});
    final response = await delete(url.toString(), headers: ApiSession.headers);
    ApiResponse.ensureSuccess(response);
  }
}
