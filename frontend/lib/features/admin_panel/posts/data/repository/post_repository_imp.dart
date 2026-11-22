import 'package:sculpture_shop/features/admin_panel/posts/data/entity/post_response.dart';
import 'package:sculpture_shop/features/admin_panel/posts/data/service/posts_manage_service.dart';
import 'package:sculpture_shop/features/admin_panel/posts/domain/repository/post_repository.dart';

class PostManageRepositoryImpl extends PostManageRepository {
  final service = PostManageService();

  @override
  Future<List<PostManageResponse>> getPosts(int page) async {
    return await service.call(page);
  }

  @override
  Future<void> updatePost(PostManageResponse post) async {
    await service.updatePost(post);
  }
}
