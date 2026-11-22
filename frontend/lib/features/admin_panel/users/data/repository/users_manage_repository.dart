import 'package:sculpture_shop/features/admin_panel/users/data/entity/users_list_response.dart';

abstract class UsersManageRepository {
  Future<List<UsersListResponse>> getUsersList(int page);
}
