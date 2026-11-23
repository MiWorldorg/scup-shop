import 'package:get/get_connect/connect.dart';
import 'package:sculpture_shop/core/api/api_response.dart';
import 'package:sculpture_shop/core/api/api_session.dart';
import 'package:sculpture_shop/core/api/endpoints.dart';
import 'package:sculpture_shop/core/api/url.dart';

class AuthService extends GetConnect {
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await post(
      '${BaseUrl.apiUrlV1}${EndPoints.login}',
      {'email': email, 'password': password},
      headers: const {'Accept': 'application/json'},
    );
    return ApiResponse.object(response);
  }

  Future<Map<String, dynamic>> currentUser() async {
    final response = await get(
      '${BaseUrl.apiUrlV1}${EndPoints.me}',
      headers: ApiSession.headers,
    );
    return ApiResponse.object(response);
  }

  Future<void> logout(String token) async {
    final response = await post(
      '${BaseUrl.apiUrlV1}${EndPoints.logout}',
      const {},
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    ApiResponse.ensureSuccess(response);
  }
}
