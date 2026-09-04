import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/core/network/auth_interceptor.dart';
import 'package:raqamli_sovchi/core/security/auth_session_manager.dart';
import 'package:raqamli_sovchi/core/security/secure_storage.dart';
import 'package:raqamli_sovchi/core/security/token_store.dart';

void main() {
  test('adds the current access token to protected requests', () async {
    final tokenStore = _MemoryTokenStore(
      accessToken: 'access-token',
      refreshToken: 'refresh-token',
    );
    final manager = _createManager(tokenStore);
    final client = Dio(BaseOptions(baseUrl: 'https://api.test'));
    final adapter = _StubAdapter((options) async {
      expect(options.headers['Authorization'], 'Bearer access-token');
      return _jsonResponse(200, {'ok': true});
    });
    client.httpClientAdapter = adapter;
    final refreshClient = Dio(BaseOptions(baseUrl: 'https://api.test'));
    refreshClient.httpClientAdapter = _StubAdapter(
      (_) async => _jsonResponse(500, {'error': 'unexpected'}),
    );
    client.interceptors.add(
      AuthInterceptor(
        authSessionManager: manager,
        client: client,
        refreshClient: refreshClient,
      ),
    );

    final response = await client.get<Map<String, dynamic>>('/protected');

    expect(response.data?['ok'], isTrue);
  });

  test(
    'refreshes once and retries the original request with the new token',
    () async {
      final tokenStore = _MemoryTokenStore(
        accessToken: 'old-access',
        refreshToken: 'refresh-token',
      );
      final manager = _createManager(tokenStore);
      var protectedCalls = 0;
      final client = Dio(BaseOptions(baseUrl: 'https://api.test'));
      client.httpClientAdapter = _StubAdapter((options) async {
        protectedCalls++;
        if (protectedCalls == 1) {
          return _jsonResponse(401, {'error': 'expired'});
        }
        expect(options.headers['Authorization'], 'Bearer new-access');
        return _jsonResponse(200, {'ok': true});
      });
      var refreshCalls = 0;
      final refreshClient = Dio(BaseOptions(baseUrl: 'https://api.test'));
      refreshClient.httpClientAdapter = _StubAdapter((options) async {
        refreshCalls++;
        expect(options.path, '/api/v1/accounts/auth/token/refresh/');
        expect(options.headers['Authorization'], isNull);
        expect(options.data, {'refresh': 'refresh-token'});
        return _jsonResponse(200, {'access': 'new-access'});
      });
      client.interceptors.add(
        AuthInterceptor(
          authSessionManager: manager,
          client: client,
          refreshClient: refreshClient,
        ),
      );

      final response = await client.get<Map<String, dynamic>>('/protected');

      expect(response.data?['ok'], isTrue);
      expect(refreshCalls, 1);
      expect(protectedCalls, 2);
      expect(await tokenStore.readAccessToken(), 'new-access');
      expect(await tokenStore.readRefreshToken(), 'refresh-token');
    },
  );

  test('coalesces parallel expired requests into one refresh', () async {
    final tokenStore = _MemoryTokenStore(
      accessToken: 'old-access',
      refreshToken: 'refresh-token',
    );
    final manager = _createManager(tokenStore);
    var refreshCalls = 0;
    var protectedCalls = 0;
    final client = Dio(BaseOptions(baseUrl: 'https://api.test'));
    client.httpClientAdapter = _StubAdapter((options) async {
      protectedCalls++;
      if (protectedCalls <= 2) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
        return _jsonResponse(401, {'error': 'expired'});
      }
      expect(options.headers['Authorization'], 'Bearer new-access');
      return _jsonResponse(200, {'ok': true});
    });
    final refreshClient = Dio(BaseOptions(baseUrl: 'https://api.test'));
    refreshClient.httpClientAdapter = _StubAdapter((_) async {
      refreshCalls++;
      await Future<void>.delayed(const Duration(milliseconds: 10));
      return _jsonResponse(200, {'access': 'new-access'});
    });
    client.interceptors.add(
      AuthInterceptor(
        authSessionManager: manager,
        client: client,
        refreshClient: refreshClient,
      ),
    );

    final responses = await Future.wait([
      client.get<Map<String, dynamic>>('/protected/one'),
      client.get<Map<String, dynamic>>('/protected/two'),
    ]);

    expect(responses, hasLength(2));
    expect(responses.every((response) => response.data?['ok'] == true), isTrue);
    expect(refreshCalls, 1);
    expect(protectedCalls, 4);
  });

  test('clears credentials when the refresh token is rejected', () async {
    final tokenStore = _MemoryTokenStore(
      accessToken: 'old-access',
      refreshToken: 'invalid-refresh',
    );
    final manager = _createManager(tokenStore);
    final client = Dio(BaseOptions(baseUrl: 'https://api.test'));
    client.httpClientAdapter = _StubAdapter(
      (_) async => _jsonResponse(401, {'error': 'expired'}),
    );
    final refreshClient = Dio(BaseOptions(baseUrl: 'https://api.test'));
    refreshClient.httpClientAdapter = _StubAdapter(
      (_) async => _jsonResponse(401, {'error': 'invalid refresh'}),
    );
    client.interceptors.add(
      AuthInterceptor(
        authSessionManager: manager,
        client: client,
        refreshClient: refreshClient,
      ),
    );

    await expectLater(
      client.get<void>('/protected'),
      throwsA(isA<DioException>()),
    );

    expect(await tokenStore.readAccessToken(), isNull);
    expect(await tokenStore.readRefreshToken(), isNull);
  });

  test('does not refresh skipped requests or retry a retry failure', () async {
    final tokenStore = _MemoryTokenStore(
      accessToken: 'old-access',
      refreshToken: 'refresh-token',
    );
    final manager = _createManager(tokenStore);
    var refreshCalls = 0;
    final client = Dio(BaseOptions(baseUrl: 'https://api.test'));
    client.httpClientAdapter = _StubAdapter(
      (_) async => _jsonResponse(401, {'error': 'unauthorized'}),
    );
    final refreshClient = Dio(BaseOptions(baseUrl: 'https://api.test'));
    refreshClient.httpClientAdapter = _StubAdapter((_) async {
      refreshCalls++;
      return _jsonResponse(200, {'access': 'new-access'});
    });
    client.interceptors.add(
      AuthInterceptor(
        authSessionManager: manager,
        client: client,
        refreshClient: refreshClient,
      ),
    );

    await expectLater(
      client.get<void>('/skipped', options: Options(extra: {'skipAuth': true})),
      throwsA(isA<DioException>()),
    );
    await expectLater(
      client.get<void>(
        '/skipped-refresh',
        options: Options(extra: {'skipAuthRefresh': true}),
      ),
      throwsA(isA<DioException>()),
    );
    await expectLater(
      client.get<void>('/always-unauthorized'),
      throwsA(isA<DioException>()),
    );

    expect(refreshCalls, 1);
  });
}

DefaultAuthSessionManager _createManager(_MemoryTokenStore tokenStore) {
  return DefaultAuthSessionManager(tokenStore, _MemorySecureStorage());
}

ResponseBody _jsonResponse(int statusCode, Map<String, dynamic> data) {
  return ResponseBody.fromString(
    jsonEncode(data),
    statusCode,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );
}

final class _StubAdapter implements HttpClientAdapter {
  _StubAdapter(this._handler);

  final Future<ResponseBody> Function(RequestOptions options) _handler;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    return _handler(options);
  }

  @override
  void close({bool force = false}) {}
}

final class _MemorySecureStorage implements SecureStorage {
  final Map<String, String> _values = <String, String>{};

  @override
  Future<void> delete({required String key}) async {
    _values.remove(key);
  }

  @override
  Future<String?> read({required String key}) async => _values[key];

  @override
  Future<void> write({required String key, required String value}) async {
    _values[key] = value;
  }
}

final class _MemoryTokenStore implements TokenStore {
  _MemoryTokenStore({this.accessToken, this.refreshToken});

  String? accessToken;
  String? refreshToken;

  @override
  Future<String?> readAccessToken() async => accessToken;

  @override
  Future<String?> readRefreshToken() async => refreshToken;

  @override
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    this.accessToken = accessToken;
    if (refreshToken != null) this.refreshToken = refreshToken;
  }

  @override
  Future<void> clear() async {
    accessToken = null;
    refreshToken = null;
  }
}
