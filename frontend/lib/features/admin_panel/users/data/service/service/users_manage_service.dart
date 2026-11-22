import 'package:get/get_connect/connect.dart';
import 'package:sculpture_shop/core/api/api_response.dart';
import 'package:sculpture_shop/core/api/api_session.dart';
import 'package:sculpture_shop/core/api/endpoints.dart';
import 'package:sculpture_shop/core/api/url.dart';
import 'package:sculpture_shop/features/admin_panel/users/data/entity/users_list_response.dart';

class UsersManageService extends GetConnect {
  Future<UsersPageResponse> getUsers(
    int page, {
    String search = '',
    String role = 'all',
  }) async {
    try {
      final url = Uri.parse('${BaseUrl.apiUrlV1}${EndPoints.apUser}').replace(
        queryParameters: {
          'page': page.toString(),
          if (search.trim().isNotEmpty) 'search': search.trim(),
          if (role != 'all') 'role': role,
        },
      );
      final response = await get(url.toString(), headers: ApiSession.headers);
      final result = ApiResponse.paginated(response);
      return UsersPageResponse(
        users: result.rows
            .map(UsersListResponse.fromJson)
            .toList(growable: false),
        currentPage: result.currentPage,
        lastPage: result.lastPage,
        total: result.total,
      );
    } catch (_) {
      rethrow;
    }
  }

  Future<void> updateRole(int id, String role) async {
    final url = Uri.parse('${BaseUrl.apiUrlV1}${EndPoints.apUserRole}');
    final response = await put(url.toString(), {
      'id': id,
      'role': role,
    }, headers: ApiSession.headers);
    ApiResponse.object(response);
  }
}
