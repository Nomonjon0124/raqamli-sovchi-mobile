import 'package:equatable/equatable.dart';

import 'secure_storage.dart';
import 'token_store.dart';

/// Auth tokens received during onboarding but not yet committed to disk.
///
/// This keeps an unfinished profile from becoming a durable authenticated
/// session after an app restart.
final class PendingAuthSession extends Equatable {
  const PendingAuthSession({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.createdAt,
  });

  final String accessToken;
  final String? refreshToken;
  final String userId;
  final DateTime createdAt;

  @override
  List<Object?> get props => [accessToken, refreshToken, userId, createdAt];
}

abstract interface class AuthSessionManager {
  PendingAuthSession? get pendingSession;

  bool get hasPendingSession;

  Future<String?> readEffectiveAccessToken();

  Future<String?> readEffectiveRefreshToken();

  Future<String?> readCurrentUserId();

  Future<void> saveCurrentUserId(String userId);

  Future<void> saveRefreshedTokens({
    required String accessToken,
    String? refreshToken,
  });

  void stage({
    required String accessToken,
    required String? refreshToken,
    required String userId,
  });

  Future<void> commitPendingTokens({bool profileOnboardingCompleted = true});

  Future<bool?> readProfileOnboardingCompleted();

  Future<void> saveProfileOnboardingCompleted(bool completed);

  void clearPendingSession();

  Future<void> clearAll();
}

final class DefaultAuthSessionManager implements AuthSessionManager {
  DefaultAuthSessionManager(this._tokenStore, this._storage);

  static const _profileOnboardingCompletedKey =
      'auth.profile_onboarding_completed';
  static const _currentUserIdKey = 'auth.current_user_id';

  final TokenStore _tokenStore;
  final SecureStorage _storage;
  PendingAuthSession? _pendingSession;

  @override
  PendingAuthSession? get pendingSession => _pendingSession;

  @override
  bool get hasPendingSession => _pendingSession != null;

  @override
  Future<String?> readEffectiveAccessToken() async {
    return _pendingSession?.accessToken ?? _tokenStore.readAccessToken();
  }

  @override
  Future<String?> readEffectiveRefreshToken() async {
    final pending = _pendingSession;
    return pending != null
        ? pending.refreshToken
        : _tokenStore.readRefreshToken();
  }

  @override
  Future<String?> readCurrentUserId() {
    return _storage.read(key: _currentUserIdKey);
  }

  @override
  Future<void> saveCurrentUserId(String userId) {
    return _storage.write(key: _currentUserIdKey, value: userId);
  }

  @override
  Future<void> saveRefreshedTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    final pending = _pendingSession;
    if (pending != null) {
      _pendingSession = PendingAuthSession(
        accessToken: accessToken,
        refreshToken: refreshToken ?? pending.refreshToken,
        userId: pending.userId,
        createdAt: pending.createdAt,
      );
      return;
    }

    await _tokenStore.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken ?? await _tokenStore.readRefreshToken(),
    );
  }

  @override
  void stage({
    required String accessToken,
    required String? refreshToken,
    required String userId,
  }) {
    _pendingSession = PendingAuthSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
      userId: userId,
      createdAt: DateTime.now().toUtc(),
    );
  }

  @override
  Future<void> commitPendingTokens({
    bool profileOnboardingCompleted = true,
  }) async {
    final pending = _pendingSession;
    if (pending != null) {
      try {
        await _tokenStore.saveTokens(
          accessToken: pending.accessToken,
          refreshToken: pending.refreshToken,
        );
        await _storage.write(key: _currentUserIdKey, value: pending.userId);
      } catch (_) {
        await _tokenStore.clear();
        await _storage.delete(key: _currentUserIdKey);
        rethrow;
      }

      _pendingSession = null;
    }

    await saveProfileOnboardingCompleted(profileOnboardingCompleted);
  }

  @override
  Future<bool?> readProfileOnboardingCompleted() async {
    final value = await _storage.read(key: _profileOnboardingCompletedKey);
    if (value == null || value.isEmpty) return null;
    return value == 'true';
  }

  @override
  Future<void> saveProfileOnboardingCompleted(bool completed) {
    return _storage.write(
      key: _profileOnboardingCompletedKey,
      value: completed.toString(),
    );
  }

  @override
  void clearPendingSession() {
    _pendingSession = null;
  }

  @override
  Future<void> clearAll() async {
    _pendingSession = null;
    await _tokenStore.clear();
    await _storage.delete(key: _profileOnboardingCompletedKey);
    await _storage.delete(key: _currentUserIdKey);
  }
}
