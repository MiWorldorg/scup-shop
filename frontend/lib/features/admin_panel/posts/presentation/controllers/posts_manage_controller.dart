import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sculpture_shop/core/api/api_response.dart';
import 'package:sculpture_shop/features/admin_panel/posts/data/entity/post_response.dart';
import 'package:sculpture_shop/features/admin_panel/posts/domain/repository/post_repository.dart';

class PostsManageController extends GetxController {
  final TextEditingController slug = TextEditingController();
  final TextEditingController title = TextEditingController();
  final TextEditingController content = TextEditingController();
  late PostManageRepository repo;
  PostsManageController({required this.repo});

  var posts = <PostManageResponse>[].obs;
  var currentPage = 1.obs;
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
      posts.assignAll(result);
    } catch (error) {
      if (isClosed || version != _fetchVersion) return;
      errorMessage.value = ApiResponse.userFacingError(error);
    } finally {
      if (!isClosed && version == _fetchVersion) isLoading.value = false;
    }
  }

  @override
  void onClose() {
    slug.dispose();
    title.dispose();
    content.dispose();
    super.onClose();
  }
}
