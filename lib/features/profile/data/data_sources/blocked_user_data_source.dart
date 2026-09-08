import '../../../../core/network/api_client.dart';
import '../models/blocked_user_model.dart';

abstract interface class BlockedUserDataSource {
  Future<BlockedUserModel> blockUser({
    required String blockedUserId,
    String? reason,
  });

  Future<List<BlockedUserModel>> getBlockedUsers({int page = 1});

  Future<bool> unblockUser({required String userId, String? blockedRecordId});
}

final class RemoteBlockedUserDataSource implements BlockedUserDataSource {
  const RemoteBlockedUserDataSource(this._client);

  static const _blockedUsersPath = '/api/v1/accounts/blocked-users/';

  final ApiClient _client;

  @override
  Future<BlockedUserModel> blockUser({
    required String blockedUserId,
    String? reason,
  }) async {
    final response = await _client.post<dynamic>(
      _blockedUsersPath,
      data: {
        'blocked': blockedUserId,
        if (reason != null && reason.trim().isNotEmpty) 'reason': reason.trim(),
      },
    );
    return BlockedUserModel.fromJson(_unwrapMap(response.data));
  }

  @override
  Future<List<BlockedUserModel>> getBlockedUsers({int page = 1}) async {
    final response = await _client.get<dynamic>(
      _blockedUsersPath,
      queryParameters: {'page': page},
    );
    final map = _unwrapMap(response.data);
    final results = map['results'];
    if (results is List) {
      return results
          .whereType<Map>()
          .map(
            (item) => BlockedUserModel.fromJson(
              item.map((k, v) => MapEntry(k.toString(), v)),
            ),
          )
          .toList();
    }
    if (response.data is List) {
      return (response.data as List)
          .whereType<Map>()
          .map(
            (item) => BlockedUserModel.fromJson(
              item.map((k, v) => MapEntry(k.toString(), v)),
            ),
          )
          .toList();
    }
    return const <BlockedUserModel>[];
  }

  @override
  Future<bool> unblockUser({
    required String userId,
    String? blockedRecordId,
  }) async {
    try {
      await _client.post<dynamic>(
        '/api/v1/accounts/users/$userId/unblock/',
        data: const {'reason': 'mistake'},
      );
      return true;
    } catch (_) {
      if (blockedRecordId != null && blockedRecordId.isNotEmpty) {
        await _client.delete<dynamic>('$_blockedUsersPath$blockedRecordId/');
        return true;
      }
      rethrow;
    }
  }
}

Map<String, dynamic> _unwrapMap(Object? value) {
  if (value is! Map) return const <String, dynamic>{};
  final map = value.map((key, value) => MapEntry(key.toString(), value));
  final data = map['data'];
  if (data is Map) return _unwrapMap(data);
  return map;
}
