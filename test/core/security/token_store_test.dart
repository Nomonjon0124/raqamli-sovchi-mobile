import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/core/security/secure_storage.dart';
import 'package:raqamli_sovchi/core/security/token_store.dart';

void main() {
  test('stores and clears access and refresh tokens', () async {
    final storage = _MemorySecureStorage();
    final tokenStore = SecureTokenStore(storage);

    await tokenStore.saveTokens(accessToken: 'access', refreshToken: 'refresh');

    expect(await tokenStore.readAccessToken(), 'access');
    expect(await tokenStore.readRefreshToken(), 'refresh');

    await tokenStore.clear();

    expect(await tokenStore.readAccessToken(), isNull);
    expect(await tokenStore.readRefreshToken(), isNull);
  });
}

final class _MemorySecureStorage implements SecureStorage {
  final Map<String, String> _values = {};

  @override
  Future<String?> read({required String key}) async => _values[key];

  @override
  Future<void> write({required String key, required String value}) async {
    _values[key] = value;
  }

  @override
  Future<void> delete({required String key}) async {
    _values.remove(key);
  }
}
