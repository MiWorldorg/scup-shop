import 'package:sculpture_shop/core/api/api_client.dart';
import 'package:sculpture_shop/core/api/api_response.dart';
import 'package:sculpture_shop/core/api/endpoints.dart';

class AuthService {
  final ApiClient client;
  AuthService({required this.client});

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await client.postJson(
      EndPoints.login,
      {'email': email, 'password': password},
    );
    return ApiResponse.object(response);
  }

  Future<Map<String, dynamic>> currentUser() async {
    final response = await client.getJson(EndPoints.me, authenticated: true);
    return ApiResponse.object(response);
  }

  Future<void> logout(String token) async {
    // Use the current session header after ApiSession has been set.
    final response = await client.postJson(
      EndPoints.logout,
      const {},
      authenticated: true,
    );
    ApiResponse.ensureSuccess(response);
  }
}
