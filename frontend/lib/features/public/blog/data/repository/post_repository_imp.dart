import 'package:sculpture_shop/features/public/blog/data/entity/post_response.dart';
import 'package:sculpture_shop/features/public/blog/domain/repository/post_repository.dart';

import '../service/post_service.dart';

class PostRepositoryImpl extends PostRepository {
  final service = PostService();

  @override
  Future<List<PostResponse>> getPosts(int page) async {
    return await service.call(page);
  }
}
