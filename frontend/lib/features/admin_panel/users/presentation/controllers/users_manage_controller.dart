import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sculpture_shop/core/api/api_response.dart';
import 'package:sculpture_shop/features/admin_panel/users/data/entity/users_list_response.dart';
import 'package:sculpture_shop/features/admin_panel/users/domain/repository/users_manage_repository.dart';

class UsersManageController extends GetxController {
  final UsersManageRepository repo;
  UsersManageController({required this.repo});

  var users = <UsersListResponse>[].obs;
  var currentPage = 1.obs;
  final lastPage = 1.obs;
  final totalUsers = 0.obs;
  final searchQuery = ''.obs;
  final searchController = TextEditingController();
  final roleFilter = 'all'.obs;
  final isLoading = true.obs;
  final errorMessage = RxnString();
  final updatingUserIds = <int>{}.obs;
  int _fetchVersion = 0;
  Worker? _searchWorker;
  Worker? _roleWorker;

  List<UsersListResponse> get visibleUsers => users.toList(growable: false);

  @override
  void onInit() {
    super.onInit();
    _searchWorker = debounce(
      searchQuery,
      (_) => _applyFilters(),
      time: const Duration(milliseconds: 350),
    );
    _roleWorker = ever(roleFilter, (_) => _applyFilters());
    fetchLatestUsers();
  }

  void _applyFilters() {
    currentPage.value = 1;
    fetchLatestUsers(page: 1);
  }

  Future<void> fetchLatestUsers({int? page}) async {
    final version = ++_fetchVersion;
    final requestedPage = page ?? currentPage.value;
    isLoading.value = true;
    errorMessage.value = null;
    try {
      var result = await repo.getUsersList(
        requestedPage,
        search: searchQuery.value,
        role: roleFilter.value,
      );
      if (result.currentPage > result.lastPage && result.lastPage >= 1) {
        result = await repo.getUsersList(
          result.lastPage,
          search: searchQuery.value,
          role: roleFilter.value,
        );
      }
      if (isClosed || version != _fetchVersion) return;
      users.assignAll(result.users);
      currentPage.value = result.currentPage;
      lastPage.value = result.lastPage;
      totalUsers.value = result.total;
    } catch (error) {
      if (isClosed || version != _fetchVersion) return;
      errorMessage.value = ApiResponse.userFacingError(error);
    } finally {
      if (!isClosed && version == _fetchVersion) isLoading.value = false;
    }
  }

  Future<void> goToPage(int page) async {
    if (page < 1 || page > lastPage.value || page == currentPage.value) return;
    await fetchLatestUsers(page: page);
  }

  Future<bool> updateRole(UsersListResponse user, String role) async {
    if (user.role == role || updatingUserIds.contains(user.id)) return false;
    updatingUserIds.add(user.id);
    try {
      await repo.updateRole(user.id, role);
      await fetchLatestUsers();
      Get.snackbar(
        'Role updated',
        role == 'admin'
            ? 'Administrator access has been granted.'
            : 'Administrator access has been removed.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    } catch (error) {
      Get.snackbar(
        'Role not updated',
        ApiResponse.userFacingError(error),
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      updatingUserIds.remove(user.id);
    }
  }

  @override
  void onClose() {
    _searchWorker?.dispose();
    _roleWorker?.dispose();
    searchController.dispose();
    super.onClose();
  }
}
