import 'package:get/get.dart';
import 'package:sculpture_shop/core/api/api_response.dart';
import 'package:sculpture_shop/core/api/endpoints.dart';
import 'package:sculpture_shop/core/api/url.dart';
import 'package:sculpture_shop/features/public/shop/data/entity/product_response.dart';

class ShopService extends GetConnect {
  Future<List<ProductResponse>> call(int page) async {
    try {
      final url = Uri.parse(
        '${BaseUrl.apiUrlV1}${EndPoints.products}',
      ).replace(queryParameters: {'page': page.toString()});
      final response = await get(url.toString());
      return ApiResponse.list(
        response,
      ).map(ProductResponse.fromJson).toList(growable: false);
    } catch (error) {
      rethrow;
    }
  }
}
