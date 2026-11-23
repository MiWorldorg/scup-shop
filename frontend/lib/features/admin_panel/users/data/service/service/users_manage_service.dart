import 'package:sculpture_shop/core/api/api_client.dart';
import 'package:sculpture_shop/core/api/api_response.dart';
import 'package:sculpture_shop/core/api/endpoints.dart';
import 'package:sculpture_shop/features/admin_panel/users/data/entity/users_list_response.dart';

class UsersManageService {
  final ApiClient client;
  UsersManageService({required this.client});

  Future<UsersPageResponse> getUsers(
    int page, {
    String search = '',
    String role = 'all',
  }) async {
    final result = await client.getJson(
      EndPoints.apUser,
      query: {
        'page': page.toString(),
        if (search.trim().isNotEmpty) 'search': search.trim(),
        if (role != 'all') 'role': role,
      },
      authenticated: true,
    );
    final response = ApiResponse.paginated(result);
    return UsersPageResponse(
      users: response.rows
          .map(UsersListResponse.fromJson)
          .toList(growable: false),
      currentPage: response.currentPage,
      lastPage: response.lastPage,
      total: response.total,
    );
  }

  Future<void> updateRole(int id, String role) async {
    final response = await client.putJson(
      EndPoints.apUserRole,
      {'id': id, 'role': role},
      authenticated: true,
    );
    ApiResponse.object(response);
  }
}
