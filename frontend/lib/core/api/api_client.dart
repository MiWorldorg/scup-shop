import 'package:get/get.dart';
import 'package:sculpture_shop/core/api/api_session.dart';
import 'package:sculpture_shop/core/api/url.dart';

/// Shared HTTP transport for every feature service.
class ApiClient extends GetConnect {
  ApiClient() {
    httpClient.baseUrl = BaseUrl.apiUrlV1;
    httpClient.timeout = const Duration(seconds: 20);
  }

  Map<String, String> _headers({
    bool authenticated = false,
    String? bearerToken,
  }) {
    final headers = <String, String>{'Accept': 'application/json'};

    if (bearerToken != null && bearerToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $bearerToken';
    } else if (authenticated && ApiSession.accessToken != null) {
      headers['Authorization'] = 'Bearer ${ApiSession.accessToken}';
    }

    return headers;
  }

  Future<Response<dynamic>> getJson(
    String path, {
    Map<String, String>? query,
    bool authenticated = false,
  }) => get(
    path,
    query: query,
    headers: _headers(authenticated: authenticated),
  );

  Future<Response<dynamic>> postJson(
    String path,
    dynamic body, {
    bool authenticated = false,
    String? bearerToken,
  }) => post(
    path,
    body,
    headers: _headers(
      authenticated: authenticated,
      bearerToken: bearerToken,
    ),
  );

  Future<Response<dynamic>> putJson(
    String path,
    dynamic body, {
    bool authenticated = false,
  }) => put(
    path,
    body,
    headers: _headers(authenticated: authenticated),
  );

  Future<Response<dynamic>> deleteJson(
    String path, {
    Map<String, String>? query,
    bool authenticated = false,
  }) => delete(
    path,
    query: query,
    headers: _headers(authenticated: authenticated),
  );
}
