import 'package:sculpture_shop/core/api/api_client.dart';
import 'package:sculpture_shop/core/api/api_response.dart';
import 'package:sculpture_shop/core/api/endpoints.dart';
import 'package:sculpture_shop/features/admin_panel/posts/data/entity/post_response.dart';

class PostManageService {
  final ApiClient client;
  PostManageService({required this.client});

  Future<ApiPaginatedResult> call(int page, {String? search}) async {
    final query = <String, String>{'page': page.toString()};
    if (search != null && search.trim().isNotEmpty) query['search'] = search.trim();
    final response = await client.getJson(
      EndPoints.apPost,
      query: query,
      authenticated: true,
    );
    return ApiResponse.paginated(response);
  }

  Future<List<PostCategoryResponse>> getCategories() async {
    final response = await client.getJson(
      EndPoints.apPostCategories,
      authenticated: true,
    );
    return ApiResponse.list(response)
        .map(PostCategoryResponse.fromJson)
        .toList(growable: false);
  }

  Future<void> createPost(Map<String, dynamic> payload) async {
    final response = await client.postJson(
      EndPoints.apPostCreate,
      payload,
      authenticated: true,
    );
    ApiResponse.object(response);
  }

  Future<void> updatePost(Map<String, dynamic> payload) async {
    final response = await client.putJson(
      EndPoints.apPostUpdate,
      payload,
      authenticated: true,
    );
    ApiResponse.object(response);
  }

  Future<void> deletePost(int id) async {
    final response = await client.deleteJson(
      EndPoints.apPostDelete,
      query: {'id': id.toString()},
      authenticated: true,
    );
    ApiResponse.ensureSuccess(response);
  }
}
