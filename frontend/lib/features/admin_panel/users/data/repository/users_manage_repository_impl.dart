import 'package:sculpture_shop/features/admin_panel/users/data/entity/users_list_response.dart';
import 'package:sculpture_shop/features/admin_panel/users/data/service/users_manage_service.dart';
import 'package:sculpture_shop/features/admin_panel/users/domain/repository/users_manage_repository.dart';

class UsersManageRepositoryImpl implements UsersManageRepository {
  final UsersManageService service;
  UsersManageRepositoryImpl({required this.service});

  @override
  Future<UsersPageResponse> getUsersList(
    int page, {
    String search = '',
    String role = 'all',
  }) => service.getUsers(page, search: search, role: role);

  @override
  Future<void> updateRole(int id, String role) => service.updateRole(id, role);
}
