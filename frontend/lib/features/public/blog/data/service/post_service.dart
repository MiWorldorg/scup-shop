import 'package:get/get.dart';
import 'package:sculpture_shop/core/api/api_response.dart';
import 'package:sculpture_shop/core/api/endpoints.dart';
import 'package:sculpture_shop/core/api/url.dart';
import 'package:sculpture_shop/features/public/blog/data/entity/post_response.dart';

class PostService extends GetConnect {
  Future<List<PostResponse>> call(int page) async {
    try {
      final url = Uri.parse(
        '${BaseUrl.apiUrlV1}${EndPoints.posts}',
      ).replace(queryParameters: {'page': page.toString()});
      final response = await get(url.toString());
      return ApiResponse.list(
        response,
      ).map(PostResponse.fromJson).toList(growable: false);
    } catch (error) {
      rethrow;
    }
  }
}
