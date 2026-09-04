import '../../../../core/network/api_client.dart';
import '../models/blocked_user_model.dart';

abstract interface class BlockedUserDataSource {
  Future<BlockedUserModel> blockUser({
    required String blockedUserId,
    String? reason,
  });
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
}

Map<String, dynamic> _unwrapMap(Object? value) {
  if (value is! Map) return const <String, dynamic>{};
  final map = value.map((key, value) => MapEntry(key.toString(), value));
  final data = map['data'];
  if (data is Map) return _unwrapMap(data);
  return map;
}
