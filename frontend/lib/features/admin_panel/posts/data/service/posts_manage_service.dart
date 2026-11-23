import 'package:get/get.dart';
import 'package:sculpture_shop/core/api/api_response.dart';
import 'package:sculpture_shop/core/api/api_session.dart';
import 'package:sculpture_shop/core/api/endpoints.dart';
import 'package:sculpture_shop/core/api/url.dart';
import 'package:sculpture_shop/features/admin_panel/posts/data/entity/post_response.dart';

class PostManageService extends GetConnect {
  Future<ApiPaginatedResult> call(int page) async {
    final url = Uri.parse(
      '${BaseUrl.apiUrlV1}${EndPoints.apPost}',
    ).replace(queryParameters: {'page': page.toString()});
    final response = await get(url.toString(), headers: ApiSession.headers);
    return ApiResponse.paginated(response);
  }

  Future<List<PostCategoryResponse>> getCategories() async {
    final response = await get(
      '${BaseUrl.apiUrlV1}${EndPoints.apPostCategories}',
      headers: ApiSession.headers,
    );
    return ApiResponse.list(
      response,
    ).map(PostCategoryResponse.fromJson).toList(growable: false);
  }

  Future<void> createPost(Map<String, dynamic> post) async {
    final response = await postRequest(
      '${BaseUrl.apiUrlV1}${EndPoints.apPostCreate}',
      post,
      headers: ApiSession.headers,
    );
    ApiResponse.object(response);
  }

  Future<void> updatePost(Map<String, dynamic> post) async {
    final response = await put(
      '${BaseUrl.apiUrlV1}${EndPoints.apPostUpdate}',
      headers: ApiSession.headers,
      body: post,
    );
    ApiResponse.object(response);
  }

  Future<void> deletePost(int id) async {
    final url = Uri.parse(
      '${BaseUrl.apiUrlV1}${EndPoints.apPostDelete}',
    ).replace(queryParameters: {'id': id.toString()});
    final response = await delete(url.toString(), headers: ApiSession.headers);
    ApiResponse.ensureSuccess(response);
  }
}
