class ApiSession {
  static String? _accessToken;

  static bool get isAuthenticated => _accessToken?.isNotEmpty ?? false;
  static String? get accessToken => _accessToken;

  static Map<String, String> get headers => {
    'Accept': 'application/json',
    if (isAuthenticated) 'Authorization': 'Bearer $_accessToken',
  };

  static void setAccessToken(String token) => _accessToken = token;

  static void clear() => _accessToken = null;
}
