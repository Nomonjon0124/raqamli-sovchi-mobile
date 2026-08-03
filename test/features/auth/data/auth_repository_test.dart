import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/core/errors/either.dart';
import 'package:raqamli_sovchi/core/errors/failure.dart';
import 'package:raqamli_sovchi/core/security/token_store.dart';
import 'package:raqamli_sovchi/features/auth/data/data_sources/mock_auth_data_source.dart';
import 'package:raqamli_sovchi/features/auth/data/repositories/auth_repository_impl.dart';

void main() {
  test('mock repository maps data model to domain session', () async {
    final repository = AuthRepositoryImpl(
      MockAuthDataSource(_MemoryTokenStore()),
    );

    final result = await repository.signIn();

    expect(result, isA<Right<Failure, dynamic>>());
    expect(
      result.fold((_) => null, (session) => session.displayName),
      'Demo User',
    );
  });
}

final class _MemoryTokenStore implements TokenStore {
  String? _accessToken;

  @override
  Future<String?> readAccessToken() async => _accessToken;

  @override
  Future<String?> readRefreshToken() async => null;

  @override
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    _accessToken = accessToken;
  }

  @override
  Future<void> clear() async {
    _accessToken = null;
  }
}
