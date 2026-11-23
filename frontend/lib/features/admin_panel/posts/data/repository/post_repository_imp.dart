import 'package:sculpture_shop/core/api/api_response.dart';
import 'package:sculpture_shop/features/admin_panel/posts/data/entity/post_response.dart';
import 'package:sculpture_shop/features/admin_panel/posts/data/service/posts_manage_service.dart';
import 'package:sculpture_shop/features/admin_panel/posts/domain/repository/post_repository.dart';

class PostManageRepositoryImpl implements PostManageRepository {
  final PostManageService service;
  PostManageRepositoryImpl({required this.service});

  @override
  Future<ApiPaginatedResult> getPosts(int page) => service.call(page);

  @override
  Future<List<PostCategoryResponse>> getCategories() => service.getCategories();

  @override
  Future<void> createPost(Map<String, dynamic> post) => service.createPost(post);

  @override
  Future<void> updatePost(Map<String, dynamic> post) => service.updatePost(post);

  @override
  Future<void> deletePost(int id) => service.deletePost(id);
}
