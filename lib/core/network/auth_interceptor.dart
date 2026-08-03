import 'package:dio/dio.dart';

import '../security/token_store.dart';

final class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor(this._tokenStore);

  final TokenStore _tokenStore;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra['skipAuth'] == true) {
      handler.next(options);
      return;
    }

    final token = await _tokenStore.readAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }
}
