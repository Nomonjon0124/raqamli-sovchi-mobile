import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../models/user_profile_model.dart';

abstract interface class ProfileDataSource {
  Future<UserProfileModel> fetchMyProfile();

  Future<void> updateLocation({
    required double latitude,
    required double longitude,
  });

  Future<UserProfileModel> updateProfile(Map<String, dynamic> data);

  Future<ProfilePhotoModel> uploadPhoto({
    required String profileId,
    required String localFilePath,
  });
}

final class RemoteProfileDataSource implements ProfileDataSource {
  const RemoteProfileDataSource(this._client);

  static const _myProfilePath = '/api/v1/accounts/profiles/me/';
  static const _photosPath = '/api/v1/accounts/photos/';

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

  @override
  Future<UserProfileModel> updateProfile(Map<String, dynamic> data) async {
    final response = await _client.patch<dynamic>(_myProfilePath, data: data);
    final raw = response.data;
    final payload = raw is Map && raw['data'] is Map
        ? _asStringMap(raw['data'] as Map)
        : _asStringMap(raw as Map);
    return UserProfileModel.fromJson(payload);
  }

  @override
  Future<ProfilePhotoModel> uploadPhoto({
    required String profileId,
    required String localFilePath,
  }) async {
    final response = await _client.post<dynamic>(
      _photosPath,
      data: FormData.fromMap({
        'profile': profileId,
        'image': await MultipartFile.fromFile(localFilePath),
        'is_main': true,
      }),
    );
    final raw = response.data;
    final payload = raw is Map && raw['data'] is Map
        ? _asStringMap(raw['data'] as Map)
        : _asStringMap(raw as Map);
    return ProfilePhotoModel.fromJson(payload);
  }
}

Map<String, dynamic> _asStringMap(Map<dynamic, dynamic> value) =>
    value.map((key, value) => MapEntry(key.toString(), value));
