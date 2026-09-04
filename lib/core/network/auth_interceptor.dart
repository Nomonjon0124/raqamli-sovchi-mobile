import 'dart:async';

import 'package:dio/dio.dart';

import '../security/auth_session_manager.dart';

final class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required AuthSessionManager authSessionManager,
    required Dio client,
    required Dio refreshClient,
    Dio? retryClient,
  }) : _authSessionManager = authSessionManager,
       _retryClient = retryClient ?? _createRetryClient(client),
       _refreshClient = refreshClient;

  final AuthSessionManager _authSessionManager;
  final Dio _retryClient;
  final Dio _refreshClient;
  Future<_RefreshResult>? _refreshOperation;

  static const _tokenRefreshPath = '/api/v1/accounts/auth/token/refresh/';
  static const _skipAuthKey = 'skipAuth';
  static const _skipAuthRefreshKey = 'skipAuthRefresh';
  static const _authRetryKey = 'authRetry';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra[_skipAuthKey] == true) {
      handler.next(options);
      return;
    }

    final token = await _authSessionManager.readEffectiveAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final requestOptions = err.requestOptions;
    if (!_shouldRefresh(err, requestOptions)) {
      handler.next(err);
      return;
    }

    final failedAccessToken = _readBearerToken(
      requestOptions.headers['Authorization'],
    );
    final currentAccessToken = await _authSessionManager
        .readEffectiveAccessToken();

    // Another request may have refreshed the token before this 401 reached
    // the interceptor. Reuse that token without starting another refresh.
    if (_isUsableToken(currentAccessToken) &&
        currentAccessToken != failedAccessToken) {
      if (requestOptions.data is FormData) {
        handler.next(err);
        return;
      }
      await _retry(requestOptions, currentAccessToken!, handler, err);
      return;
    }

    final refreshResult = await _getRefreshResult();
    if (refreshResult.accessToken == null) {
      final refreshError = refreshResult.error;
      if (refreshError != null) {
        handler.reject(refreshError);
      } else {
        handler.next(err);
      }
      return;
    }

    if (requestOptions.data is FormData) {
      handler.next(err);
      return;
    }

    await _retry(requestOptions, refreshResult.accessToken!, handler, err);
  }

  bool _shouldRefresh(DioException error, RequestOptions options) {
    return error.response?.statusCode == 401 &&
        options.extra[_skipAuthKey] != true &&
        options.extra[_skipAuthRefreshKey] != true &&
        options.extra[_authRetryKey] != true &&
        !_isTokenRefreshRequest(options);
  }

  bool _isTokenRefreshRequest(RequestOptions options) {
    return options.path == _tokenRefreshPath ||
        options.path.endsWith(_tokenRefreshPath);
  }

  Future<_RefreshResult> _getRefreshResult() {
    final activeOperation = _refreshOperation;
    if (activeOperation != null) return activeOperation;

    final operation = _refreshAccessToken();
    _refreshOperation = operation;
    unawaited(
      operation.whenComplete(() {
        if (identical(_refreshOperation, operation)) {
          _refreshOperation = null;
        }
      }),
    );
    return operation;
  }

  Future<_RefreshResult> _refreshAccessToken() async {
    final String? refreshToken;
    try {
      refreshToken = await _authSessionManager.readEffectiveRefreshToken();
    } catch (_) {
      return const _RefreshResult();
    }
    if (!_isUsableToken(refreshToken)) {
      await _clearSession();
      return const _RefreshResult();
    }

    try {
      final response = await _refreshClient.post<Map<String, dynamic>>(
        _tokenRefreshPath,
        data: {'refresh': refreshToken},
        options: Options(
          extra: {_skipAuthKey: true, _skipAuthRefreshKey: true},
        ),
      );
      final accessToken = response.data?['access']?.toString();
      if (!_isUsableToken(accessToken)) return const _RefreshResult();

      await _authSessionManager.saveRefreshedTokens(
        accessToken: accessToken!,
        refreshToken: refreshToken,
      );
      return _RefreshResult(accessToken: accessToken);
    } on DioException catch (error) {
      final statusCode = error.response?.statusCode;
      if (statusCode == 400 || statusCode == 401) {
        await _clearSession();
        return const _RefreshResult();
      }
      return _RefreshResult(error: error);
    } catch (_) {
      return const _RefreshResult();
    }
  }

  Future<void> _retry(
    RequestOptions options,
    String accessToken,
    ErrorInterceptorHandler handler,
    DioException originalError,
  ) async {
    options
      ..headers['Authorization'] = 'Bearer $accessToken'
      ..extra[_authRetryKey] = true;
    try {
      final response = await _retryClient.fetch<dynamic>(options);
      handler.resolve(response);
    } on DioException catch (error) {
      handler.next(error);
    } catch (_) {
      handler.next(originalError);
    }
  }

  Future<void> _clearSession() async {
    try {
      await _authSessionManager.clearAll();
    } catch (_) {
      // Keep the original request failure if secure storage cleanup fails.
    }
  }

  static bool _isUsableToken(String? token) {
    return token != null && token.isNotEmpty;
  }

  static String? _readBearerToken(Object? header) {
    if (header is! String) return null;
    const prefix = 'Bearer ';
    if (!header.startsWith(prefix)) return null;
    return header.substring(prefix.length);
  }

  static Dio _createRetryClient(Dio source) {
    final options = source.options;
    final client = Dio(
      BaseOptions(
        baseUrl: options.baseUrl,
        connectTimeout: options.connectTimeout,
        receiveTimeout: options.receiveTimeout,
        sendTimeout: options.sendTimeout,
      ),
    );
    client.httpClientAdapter = source.httpClientAdapter;
    return client;
  }
}

final class _RefreshResult {
  const _RefreshResult({this.accessToken, this.error});

  final String? accessToken;
  final DioException? error;
}
