import '../../../../core/network/api_client.dart';
import '../models/photo_request_model.dart';

abstract interface class PhotoRequestDataSource {
  Future<PhotoRequestModel> createRequest({
    required String toProfile,
    String? note,
  });
}

final class RemotePhotoRequestDataSource implements PhotoRequestDataSource {
  const RemotePhotoRequestDataSource(this._client);

  static const _requestsPath = '/api/v1/matches/photo-requests/';

  final ApiClient _client;

  @override
  Future<PhotoRequestModel> createRequest({
    required String toProfile,
    String? note,
  }) async {
    final response = await _client.post<dynamic>(
      _requestsPath,
      data: {
        'to_profile': toProfile,
        if (note != null && note.trim().isNotEmpty) 'note': note.trim(),
      },
    );
    return PhotoRequestModel.fromJson(_unwrapMap(response.data));
  }
}

Map<String, dynamic> _unwrapMap(Object? value) {
  if (value is! Map) return const <String, dynamic>{};
  final map = value.map((key, value) => MapEntry(key.toString(), value));
  final data = map['data'];
  if (data is Map) return _unwrapMap(data);
  return map;
}
