import 'package:flutter/foundation.dart';

class BaseUrl {
  static const String _configuredApiUrl = String.fromEnvironment(
    'API_BASE_URL',
  );

  static String get apiUrlV1 {
    if (_configuredApiUrl.isNotEmpty) return _configuredApiUrl;
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8000/api/v1/';
    }
    return 'http://127.0.0.1:8000/api/v1/';
  }
}
