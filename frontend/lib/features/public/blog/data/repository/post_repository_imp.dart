import 'package:sculpture_shop/core/api/api_response.dart';
import 'package:sculpture_shop/features/public/blog/data/service/post_service.dart';
import 'package:sculpture_shop/features/public/blog/domain/repository/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final PostService service;

  PostRepositoryImpl({required this.service});

  @override
  Future<ApiPaginatedResult> getPosts(int page) => service.call(page);
}
