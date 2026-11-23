import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiSession {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _tokenKey = 'scup_shop_access_token';

  static String? _accessToken;
  static bool _initialized = false;
  static Object? _storageError;

  static bool get isInitialized => _initialized;
  static bool get isAuthenticated => _accessToken?.isNotEmpty ?? false;
  static String? get accessToken => _accessToken;

  static Map<String, String> get headers => {
    'Accept': 'application/json',
    if (isAuthenticated) 'Authorization': 'Bearer $_accessToken',
  };

  static Future<void> initialize() async {
    if (_initialized) return;
    try {
      _accessToken = await _storage.read(key: _tokenKey);
    } catch (error) {
      _storageError = error;
      _accessToken = null;
    } finally {
      _initialized = true;
    }
  }

  static Future<void> setAccessToken(String token) async {
    final normalized = token.trim();
    if (normalized.isEmpty) {
      await clear();
      return;
    }
    if (_storageError != null) {
      throw StateError('Secure token storage is unavailable.');
    }
    await _storage.write(key: _tokenKey, value: normalized);
    _accessToken = normalized;
    _initialized = true;
  }

  static Future<void> clear() async {
    _accessToken = null;
    _initialized = true;
    try {
      await _storage.delete(key: _tokenKey);
      _storageError = null;
    } catch (error) {
      _storageError = error;
    }
  }
}
