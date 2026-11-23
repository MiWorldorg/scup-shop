import 'package:sculpture_shop/core/api/api_client.dart';
import 'package:sculpture_shop/core/api/api_response.dart';
import 'package:sculpture_shop/core/api/endpoints.dart';

/// Sends public contact messages through the Laravel mail workflow.
class ContactService {
  final ApiClient client;

  ContactService({required this.client});

  Future<void> sendMessage({
    required String firstName,
    required String lastName,
    required String email,
    required String message,
  }) async {
    final response = await client.postJson(EndPoints.contact, {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'message': message,
      'website': '',
    });

    ApiResponse.ensureSuccess(response);
  }
}
