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

  test('extracts detailed image error message from backend 400 JSON response', () {
    final error = DioException(
      requestOptions: RequestOptions(path: '/onboarding/photos'),
      type: DioExceptionType.badResponse,
      response: Response<Map<String, dynamic>>(
        requestOptions: RequestOptions(path: '/onboarding/photos'),
        statusCode: 400,
        data: {
          'data': null,
          'error': {
            'errorId': 400,
            'errorCode': 'invalid',
            'isFriendly': true,
            'errorMsg': "Ma'lumotlarni tekshirishda xatolik yuzaga keldi.",
            'details': {
              'image': [
                "Yuz aniqlanmadi. Iltimos, kameraga to'g'ri qarab qayta urinib ko'ring.",
              ],
            },
          },
          'success': false,
        },
      ),
    );

    final failure = mapDioException(error);
    expect(failure.type, FailureType.validation);
    expect(
      failure.message,
      "Yuz aniqlanmadi. Iltimos, kameraga to'g'ri qarab qayta urinib ko'ring.",
    );
  });

  test('extracts errorMsg fallback when details map is empty', () {
    final error = DioException(
      requestOptions: RequestOptions(path: '/onboarding/photos'),
      type: DioExceptionType.badResponse,
      response: Response<Map<String, dynamic>>(
        requestOptions: RequestOptions(path: '/onboarding/photos'),
        statusCode: 400,
        data: {
          'data': null,
          'error': {
            'errorId': 400,
            'errorCode': 'invalid',
            'isFriendly': true,
            'errorMsg': "Keltirilgan ma'lumotlar yaroqsiz.",
            'details': {},
          },
          'success': false,
        },
      ),
    );

    final failure = mapDioException(error);
    expect(failure.type, FailureType.validation);
    expect(failure.message, "Keltirilgan ma'lumotlar yaroqsiz.");
  });
}
