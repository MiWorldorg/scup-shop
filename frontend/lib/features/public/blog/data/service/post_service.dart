import 'package:sculpture_shop/core/api/api_client.dart';
import 'package:sculpture_shop/core/api/api_response.dart';
import 'package:sculpture_shop/core/api/endpoints.dart';

class PostService {
  final ApiClient client;

  PostService({required this.client});

  Future<ApiPaginatedResult> call(int page) async {
    final response = await client.getJson(
      EndPoints.posts,
      query: {'page': page.toString()},
    );
    return ApiResponse.paginated(response);
  }
}
