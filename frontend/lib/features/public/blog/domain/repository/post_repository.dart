import 'package:sculpture_shop/features/public/blog/data/entity/post_response.dart';

abstract class PostRepository {
  Future<List<PostResponse>> getPosts(int page);
}
