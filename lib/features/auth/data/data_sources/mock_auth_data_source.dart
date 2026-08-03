import '../../../../core/security/token_store.dart';
import '../models/auth_session_model.dart';

abstract interface class AuthDataSource {
  Future<AuthSessionModel?> restoreSession();

  Future<AuthSessionModel> signIn();

  Future<void> signOut();
}

final class MockAuthDataSource implements AuthDataSource {
  const MockAuthDataSource(this._tokenStore);

  static const _mockAccessToken = 'mock-access-token';
  static const _mockUserId = 'mock-user';
  static const _mockDisplayName = 'Demo User';

  final TokenStore _tokenStore;

  @override
  Future<AuthSessionModel?> restoreSession() async {
    final token = await _tokenStore.readAccessToken();
    if (token == null || token.isEmpty) {
      return null;
    }

    return AuthSessionModel(
      userId: _mockUserId,
      displayName: _mockDisplayName,
      accessToken: token,
    );
  }

  @override
  Future<AuthSessionModel> signIn() async {
    await _tokenStore.saveTokens(accessToken: _mockAccessToken);
    return const AuthSessionModel(
      userId: _mockUserId,
      displayName: _mockDisplayName,
      accessToken: _mockAccessToken,
    );
  }

  @override
  Future<void> signOut() {
    return _tokenStore.clear();
  }
}
