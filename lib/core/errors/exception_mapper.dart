import 'package:dio/dio.dart';

import 'failure.dart';

Failure mapDioException(DioException error) {
  final message = _extractServerErrorMessage(error.response?.data);
  return switch (error.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.connectionError => Failure.networkTimeout(
      message: message,
    ),
    DioExceptionType.badResponse => _mapStatusCode(
      error.response?.statusCode,
      message: message,
    ),
    _ => Failure.unknown(message: message),
  };
}

Failure _mapStatusCode(int? statusCode, {String? message}) {
  return switch (statusCode) {
    400 || 422 => Failure.validation(message: message),
    401 => Failure.unauthorized(message: message),
    403 => Failure.forbidden(message: message),
    404 => Failure.notFound(message: message),
    408 || 504 => Failure.networkTimeout(message: message),
    _ => Failure.server(statusCode: statusCode, message: message),
  };
}

String? _extractServerErrorMessage(dynamic data) {
  if (data is! Map) return null;
  final payload = data.map((key, value) => MapEntry(key.toString(), value));

  final errorObj = payload['error'];
  if (errorObj is! Map) return null;
  final errorPayload = errorObj.map(
    (key, value) => MapEntry(key.toString(), value),
  );

  final details = errorPayload['details'];
  if (details is Map) {
    for (final value in details.values) {
      if (value is List && value.isNotEmpty) {
        final firstItem = value.first;
        if (firstItem is String && firstItem.trim().isNotEmpty) {
          return firstItem.trim();
        }
      } else if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
  }

  final errorMsg = errorPayload['errorMsg'];
  if (errorMsg is String && errorMsg.trim().isNotEmpty) {
    return errorMsg.trim();
  }

  return null;
}
