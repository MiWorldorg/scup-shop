import 'package:sculpture_shop/core/api/api_client.dart';
import 'package:sculpture_shop/core/api/api_response.dart';
import 'package:sculpture_shop/core/api/endpoints.dart';

class ShopService {
  final ApiClient client;
  ShopService({required this.client});

  Future<ApiPaginatedResult> call(int page) async {
    final response = await client.getJson(
      EndPoints.products,
      query: {'page': page.toString()},
    );
    return ApiResponse.paginated(response);
  }
}
