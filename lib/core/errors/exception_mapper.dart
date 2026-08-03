import 'package:dio/dio.dart';

import 'failure.dart';

Failure mapDioException(DioException error) {
  return switch (error.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.connectionError => const Failure.networkTimeout(),
    DioExceptionType.badResponse => _mapStatusCode(error.response?.statusCode),
    _ => const Failure.unknown(),
  };
}

Failure _mapStatusCode(int? statusCode) {
  return switch (statusCode) {
    401 => const Failure.unauthorized(),
    403 => const Failure.forbidden(),
    404 => const Failure.notFound(),
    408 || 504 => const Failure.networkTimeout(),
    422 => const Failure.validation(),
    _ => Failure.server(statusCode: statusCode),
  };
}
