import '../../../../core/network/api_client.dart';
import '../../domain/entities/match_request.dart';
import '../models/match_request_model.dart';

abstract interface class MatchRequestDataSource {
  Future<MatchRequestListModel> fetchRequests({
    String? fromProfile,
    String? toProfile,
    MatchRequestStatus? status,
  });

  Future<MatchRequestModel> fetchRequest(String id);

  Future<MatchRequestModel> createRequest({
    required String fromProfile,
    required String toProfile,
    String? note,
    required MatchRequestVisibilityScope visibilityScope,
  });
}

final class RemoteMatchRequestDataSource implements MatchRequestDataSource {
  const RemoteMatchRequestDataSource(this._client);

  static const _requestsPath = '/api/v1/matches/match-requests/';

  final ApiClient _client;

  @override
  Future<MatchRequestListModel> fetchRequests({
    String? fromProfile,
    String? toProfile,
    MatchRequestStatus? status,
  }) async {
    final response = await _client.get<dynamic>(
      _requestsPath,
      queryParameters: {
        'from_profile': ?fromProfile,
        'to_profile': ?toProfile,
        'status': ?status?.apiName,
      },
    );
    final payload = _unwrapMap(response.data);
    return MatchRequestListModel.fromJson(
      payload.containsKey('results') ? payload : {'results': payload['data']},
    );
  }

  @override
  Future<MatchRequestModel> fetchRequest(String id) async {
    final response = await _client.get<dynamic>('$_requestsPath$id/');
    return MatchRequestModel.fromJson(_unwrapMap(response.data));
  }

  @override
  Future<MatchRequestModel> createRequest({
    required String fromProfile,
    required String toProfile,
    String? note,
    required MatchRequestVisibilityScope visibilityScope,
  }) async {
    final response = await _client.post<dynamic>(
      _requestsPath,
      data: {'to_profile': toProfile},
    );
    return MatchRequestModel.fromJson(_unwrapMap(response.data));
  }
}

Map<String, dynamic> _unwrapMap(Object? value) {
  if (value is! Map) return const <String, dynamic>{};
  final map = value.map((key, value) => MapEntry(key.toString(), value));
  final data = map['data'];
  if (data is Map) return _unwrapMap(data);
  return map;
}
