import '../../../../core/network/api_client.dart';
import '../models/user_profile_model.dart';

abstract interface class ProfileDataSource {
  Future<UserProfileModel> fetchMyProfile();

  Future<void> updateLocation({
    required double latitude,
    required double longitude,
  });
}

final class RemoteProfileDataSource implements ProfileDataSource {
  const RemoteProfileDataSource(this._client);

  static const _myProfilePath = '/api/v1/accounts/profiles/me/';

  final ApiClient _client;

  @override
  Future<UserProfileModel> fetchMyProfile() async {
    final response = await _client.get<dynamic>(_myProfilePath);
    final raw = response.data;
    final payload = raw is Map && raw['data'] is Map
        ? _asStringMap(raw['data'] as Map)
        : _asStringMap(raw as Map);
    return UserProfileModel.fromJson(payload);
  }

  @override
  Future<void> updateLocation({
    required double latitude,
    required double longitude,
  }) async {
    await _client.patch<dynamic>(
      _myProfilePath,
      data: {
        'latitude': latitude.toStringAsFixed(6),
        'longitude': longitude.toStringAsFixed(6),
      },
    );
  }
}

Map<String, dynamic> _asStringMap(Map<dynamic, dynamic> value) =>
    value.map((key, value) => MapEntry(key.toString(), value));
