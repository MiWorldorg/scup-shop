import 'package:get/get.dart';
import 'package:sculpture_shop/core/api/api_response.dart';
import 'package:sculpture_shop/core/api/endpoints.dart';
import 'package:sculpture_shop/core/api/url.dart';

class ShopService extends GetConnect {
  Future<ApiPaginatedResult> call(int page) async {
    final url = Uri.parse(
      '${BaseUrl.apiUrlV1}${EndPoints.products}',
    ).replace(queryParameters: {'page': page.toString()});
    final response = await get(url.toString());
    return ApiResponse.paginated(response);
  }
}
