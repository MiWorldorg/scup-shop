import 'package:get/get_connect/connect.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class ApiPaginatedResult {
  final List<Map<String, dynamic>> rows;
  final int currentPage;
  final int lastPage;
  final int total;

  const ApiPaginatedResult({
    required this.rows,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });
}

class ApiResponse {
  static void ensureSuccess(Response<dynamic> response) =>
      _throwIfFailed(response);

  static List<Map<String, dynamic>> list(Response<dynamic> response) {
    _throwIfFailed(response);
    final payload = _payload(response.body);
    return _rows(payload is Map ? payload['data'] : payload);
  }

  static ApiPaginatedResult paginated(Response<dynamic> response) {
    _throwIfFailed(response);
    final payload = _payload(response.body);
    final rows = _rows(payload is Map ? payload['data'] : payload);
    if (payload is! Map) {
      return ApiPaginatedResult(
        rows: rows,
        currentPage: 1,
        lastPage: 1,
        total: rows.length,
      );
    }

    final metadata = payload['meta'] is Map
        ? payload['meta'] as Map
        : payload;
    return ApiPaginatedResult(
      rows: rows,
      currentPage: _integer(metadata['current_page'], 1),
      lastPage: _integer(metadata['last_page'], 1),
      total: _integer(metadata['total'], rows.length),
    );
  }

  static Map<String, dynamic> object(Response<dynamic> response) {
    _throwIfFailed(response);
    final body = response.body;
    if (body is Map && body['data'] is Map) {
      return Map<String, dynamic>.from(body['data'] as Map);
    }
    throw const ApiException('The server returned an unexpected response.');
  }

  static void _throwIfFailed(Response<dynamic> response) {
    if (response.statusCode != null && response.statusCode! < 400) return;

    if (response.statusCode == null) {
      throw const ApiException(
        'Could not connect to the service. Check your connection and try again.',
      );
    }

    final body = response.body;
    final message = body is Map && body['message'] is String
        ? body['message'] as String
        : 'The request could not be completed. Please try again.';
    throw ApiException(message, statusCode: response.statusCode);
  }

  static dynamic _payload(dynamic body) {
    if (body is! Map || !body.containsKey('data')) {
      throw const ApiException('The server returned an unexpected response.');
    }
    dynamic payload = body['data'];
    if (payload is List &&
        payload.length == 1 &&
        payload.first is Map &&
        (payload.first as Map).containsKey('data')) {
      payload = payload.first;
    }
    return payload;
  }

  static List<Map<String, dynamic>> _rows(dynamic rows) {
    if (rows == null) return const [];
    if (rows is! List || rows.any((row) => row is! Map)) {
      throw const ApiException('The server returned an unexpected response.');
    }
    return rows
        .map((row) => Map<String, dynamic>.from(row as Map))
        .toList(growable: false);
  }

  static int _integer(dynamic value, int fallback) => value is num
      ? value.toInt()
      : int.tryParse(value?.toString() ?? '') ?? fallback;

  static String userFacingError(Object error) {
    if (error is ApiException && error.message.isNotEmpty) return error.message;
    return 'Could not connect to the service. Check your connection and try again.';
  }
}
