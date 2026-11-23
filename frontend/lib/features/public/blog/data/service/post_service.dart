import 'package:sculpture_shop/core/api/api_client.dart';
import 'package:sculpture_shop/core/api/api_response.dart';
import 'package:sculpture_shop/core/api/endpoints.dart';
import 'package:sculpture_shop/features/public/blog/data/entity/post_response.dart';

class PostService {
  final ApiClient client;
  PostService({required this.client});

  Future<List<PostResponse>> call(int page) async {
    final response = await client.getJson(
      EndPoints.posts,
      query: {'page': page.toString()},
    );
    return ApiResponse.list(response)
        .map(PostResponse.fromJson)
        .toList(growable: false);
  }
}
