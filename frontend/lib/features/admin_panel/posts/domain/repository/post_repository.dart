import 'package:sculpture_shop/features/admin_panel/posts/data/entity/post_response.dart';

abstract class PostManageRepository {
  Future<List<PostManageResponse>> getPosts(int page);
  Future<void> updatePost(PostManageResponse post);
}
