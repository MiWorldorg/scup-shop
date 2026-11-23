import 'package:sculpture_shop/core/api/api_response.dart';

abstract class PostRepository {
  Future<ApiPaginatedResult> getPosts(int page);
}
