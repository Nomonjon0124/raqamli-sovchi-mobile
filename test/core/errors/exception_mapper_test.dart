import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/core/errors/exception_mapper.dart';
import 'package:raqamli_sovchi/core/errors/failure.dart';

void main() {
  test('maps unauthorized response to typed failure', () {
    final error = DioException(
      requestOptions: RequestOptions(path: '/session'),
      type: DioExceptionType.badResponse,
      response: Response<void>(
        requestOptions: RequestOptions(path: '/session'),
        statusCode: 401,
      ),
    );

    expect(mapDioException(error), const Failure.unauthorized());
  });

  test('maps timeout to network timeout failure', () {
    final error = DioException(
      requestOptions: RequestOptions(path: '/session'),
      type: DioExceptionType.receiveTimeout,
    );

    expect(mapDioException(error), const Failure.networkTimeout());
  });
}
