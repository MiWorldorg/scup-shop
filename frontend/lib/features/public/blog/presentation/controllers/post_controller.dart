import 'package:get/get.dart';
import 'package:sculpture_shop/core/api/api_response.dart';
import 'package:sculpture_shop/features/public/blog/data/entity/post_response.dart';
import 'package:sculpture_shop/features/public/blog/domain/repository/post_repository.dart';

class PostController extends GetxController {
  final PostRepository repo;

  PostController({required this.repo});

  final posts = <PostResponse>[].obs;
  final currentPage = 1.obs;
  final lastPage = 1.obs;
  final totalPosts = 0.obs;
  final isLoading = true.obs;
  final errorMessage = RxnString();
  int _fetchVersion = 0;

  @override
  void onInit() {
    super.onInit();
    fetchLatestPosts();
  }

  Future<void> fetchLatestPosts() async {
    final version = ++_fetchVersion;
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final result = await repo.getPosts(currentPage.value);
      if (isClosed || version != _fetchVersion) return;

      posts.assignAll(result.rows.map(PostResponse.fromJson));
      currentPage.value = result.currentPage;
      lastPage.value = result.lastPage;
      totalPosts.value = result.total;
    } catch (error) {
      if (isClosed || version != _fetchVersion) return;
      errorMessage.value = ApiResponse.userFacingError(error);
    } finally {
      if (!isClosed && version == _fetchVersion) {
        isLoading.value = false;
      }
    }
  }

  Future<void> goToPage(int page) async {
    if (page < 1 || page > lastPage.value || isLoading.value) return;
    currentPage.value = page;
    await fetchLatestPosts();
  }
}
