import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sculpture_shop/core/api/api_response.dart';
import 'package:sculpture_shop/features/admin_panel/posts/data/entity/post_response.dart';
import 'package:sculpture_shop/features/admin_panel/posts/domain/repository/post_repository.dart';

class PostsManageController extends GetxController {
  final PostManageRepository repo;
  PostsManageController({required this.repo});

  final posts = <PostManageResponse>[].obs;
  final categories = <PostCategoryResponse>[].obs;
  final searchController = TextEditingController();
  final searchQuery = ''.obs;
  final currentPage = 1.obs;
  final lastPage = 1.obs;
  final isLoading = true.obs;
  final isLoadingCategories = true.obs;
  final errorMessage = RxnString();
  final categoriesError = RxnString();
  int _fetchVersion = 0;

  @override
  void onInit() {
    super.onInit();
    fetchLatestPosts();
    fetchCategories();
  }

  Future<void> fetchLatestPosts() async {
    final version = ++_fetchVersion;
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final result = await repo.getPosts(
        currentPage.value,
        search: searchQuery.value.trim().isEmpty
            ? null
            : searchQuery.value.trim(),
      );
      if (isClosed || version != _fetchVersion) return;
      posts.assignAll(result.rows.map(PostManageResponse.fromJson));
      currentPage.value = result.currentPage;
      lastPage.value = result.lastPage;
    } catch (error) {
      if (isClosed || version != _fetchVersion) return;
      errorMessage.value = ApiResponse.userFacingError(error);
    } finally {
      if (!isClosed && version == _fetchVersion) isLoading.value = false;
    }
  }

  Future<void> fetchCategories() async {
    isLoadingCategories.value = true;
    categoriesError.value = null;
    try {
      final result = await repo.getCategories();
      if (isClosed) return;
      categories.assignAll(result);
    } catch (error) {
      if (isClosed) return;
      categoriesError.value = ApiResponse.userFacingError(error);
    } finally {
      if (!isClosed) isLoadingCategories.value = false;
    }
  }

  Future<void> search(String value) async {
    searchQuery.value = value.trim();
    currentPage.value = 1;
    await fetchLatestPosts();
  }

  Future<void> clearSearch() async {
    searchController.clear();
    searchQuery.value = '';
    currentPage.value = 1;
    await fetchLatestPosts();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> goToPage(int page) async {
    if (page < 1 || page > lastPage.value || isLoading.value) return;
    currentPage.value = page;
    await fetchLatestPosts();
  }

  Future<void> createPost(Map<String, dynamic> post) async {
    await repo.createPost(post);
    currentPage.value = 1;
    await fetchLatestPosts();
  }

  Future<void> updatePost(Map<String, dynamic> post) async {
    await repo.updatePost(post);
    await fetchLatestPosts();
  }

  Future<void> setPublished(PostManageResponse post, bool published) async {
    await repo.updatePost({
      'id': post.id,
      'published': published ? DateTime.now().toUtc().toIso8601String() : null,
    });
    if (!published && posts.length == 1 && currentPage.value > 1) {
      currentPage.value--;
    }
    await fetchLatestPosts();
  }

  Future<void> deletePost(int id) async {
    await repo.deletePost(id);
    if (posts.length == 1 && currentPage.value > 1) {
      currentPage.value--;
    }
    await fetchLatestPosts();
  }
}
