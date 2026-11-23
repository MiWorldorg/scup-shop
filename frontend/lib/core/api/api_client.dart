import 'package:get/get.dart';
import 'package:sculpture_shop/core/api/api_session.dart';
import 'package:sculpture_shop/core/api/url.dart';

/// Shared HTTP transport for all feature services.
class ApiClient extends GetConnect {
  ApiClient() {
    httpClient.baseUrl = BaseUrl.apiUrlV1;
    httpClient.timeout = const Duration(seconds: 20);
  }

  Map<String, String> _headers({bool authenticated = false}) => {
    'Accept': 'application/json',
    if (authenticated) ...ApiSession.headers,
  };

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
  }) => post(
    path,
    body,
    headers: _headers(authenticated: authenticated),
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
