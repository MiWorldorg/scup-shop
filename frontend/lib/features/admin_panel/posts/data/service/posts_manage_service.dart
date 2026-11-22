import 'package:get/get.dart';
import 'package:sculpture_shop/core/api/api_response.dart';
import 'package:sculpture_shop/core/api/api_session.dart';
import 'package:sculpture_shop/core/api/endpoints.dart';
import 'package:sculpture_shop/core/api/url.dart';
import 'package:sculpture_shop/features/admin_panel/posts/data/entity/post_response.dart';

class PostManageService extends GetConnect {
  Future<List<PostManageResponse>> call(int page) async {
    try {
      final url = Uri.parse(
        '${BaseUrl.apiUrlV1}${EndPoints.posts}',
      ).replace(queryParameters: {'page': page.toString()});
      final response = await get(url.toString(), headers: ApiSession.headers);
      return ApiResponse.list(
        response,
      ).map(PostManageResponse.fromJson).toList(growable: false);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updatePost(PostManageResponse updatedPost) async {
    try {
      final url = Uri.parse('${BaseUrl.apiUrlV1}${EndPoints.apPostUpdate}');
      final response = await put(
        url.toString(),
        headers: ApiSession.headers,
        body: updatedPost.toJson(),
      );
      ApiResponse.ensureSuccess(response);
    } catch (error) {
      rethrow;
    }
  }
}
