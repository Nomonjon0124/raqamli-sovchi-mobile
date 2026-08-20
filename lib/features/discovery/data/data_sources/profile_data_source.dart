import '../../../../core/network/api_client.dart';
import '../models/user_profile_model.dart';

abstract interface class ProfileDataSource {
  Future<UserProfileModel> fetchMyProfile();
}

final class RemoteProfileDataSource implements ProfileDataSource {
  const RemoteProfileDataSource(this._client);

  static const _myProfilePath = '/api/v1/accounts/profiles/me/';

  final ApiClient _client;

  @override
  Future<UserProfileModel> fetchMyProfile() async {
    final response = await _client.get<dynamic>(_myProfilePath);
    final raw = response.data;
    final payload = (raw is Map && raw['data'] is Map)
        ? raw['data'] as Map<String, dynamic>
        : raw as Map<String, dynamic>;
    return UserProfileModel.fromJson(payload);
  }
}
