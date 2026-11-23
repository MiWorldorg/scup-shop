import 'package:sculpture_shop/core/api/api_response.dart';
import 'package:sculpture_shop/features/admin_panel/posts/data/entity/post_response.dart';

abstract class PostManageRepository {
  Future<ApiPaginatedResult> getPosts(int page);
  Future<List<PostCategoryResponse>> getCategories();
  Future<void> createPost(Map<String, dynamic> post);
  Future<void> updatePost(Map<String, dynamic> post);
  Future<void> deletePost(int id);
}
