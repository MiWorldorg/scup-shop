import 'package:sculpture_shop/features/admin_panel/users/data/entity/users_list_response.dart';

abstract class UsersManageRepository {
  Future<UsersPageResponse> getUsersList(
    int page, {
    String search = '',
    String role = 'all',
  });
  Future<void> updateRole(int id, String role);
}
