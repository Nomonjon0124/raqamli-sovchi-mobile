import '../../../../core/network/api_client.dart';
import '../../domain/entities/discovery_filter.dart';
import '../models/candidate_model.dart';

abstract interface class DiscoveryDataSource {
  Future<CandidateModel> fetchCandidates({
    int page = 1,
    int pageSize = 10,
    DiscoveryFilter filter = DiscoveryFilter.matches,
    double? radiusKm,
  });

  Future<ResultCandidateModel> fetchCandidate(String id);

  Future<CandidateModel> fetchSavedCandidates();

  Future<void> saveCandidate(String id);

  Future<void> unsaveCandidate(String id);
}

final class RemoteDiscoveryDataSource implements DiscoveryDataSource {
  const RemoteDiscoveryDataSource(this._client);

  final ApiClient _client;

  @override
  Future<CandidateModel> fetchCandidates({
    int page = 1,
    int pageSize = 10,
    DiscoveryFilter filter = DiscoveryFilter.matches,
    double? radiusKm,
  }) async {
    final endpoint = switch (filter) {
      DiscoveryFilter.matches => '/api/v1/accounts/profiles/matches/',
      DiscoveryFilter.recommended => '/api/v1/accounts/profiles/',
      DiscoveryFilter.nearby => '/api/v1/accounts/profiles/nearby/',
    };

    final queryParameters = <String, dynamic>{
      'page': page,
      'page_size': pageSize,
    };
    if (filter == DiscoveryFilter.nearby && radiusKm != null) {
      queryParameters['radius'] = radiusKm.round();
    }

    final response = await _client.get<dynamic>(
      endpoint,
      queryParameters: queryParameters,
    );

    final data = response.data;
    return _candidateModelFromResponse(data);
  }

  @override
  Future<ResultCandidateModel> fetchCandidate(String id) async {
    final response = await _client.get<dynamic>(
      '/api/v1/accounts/profiles/$id/',
    );
    final payload = _unwrapMap(response.data);
    return ResultCandidateModel.fromJson(payload);
  }

  @override
  Future<CandidateModel> fetchSavedCandidates() async {
    final response = await _client.get<dynamic>(
      '/api/v1/accounts/profiles/saved/',
    );
    return _candidateModelFromResponse(response.data);
  }

  @override
  Future<void> saveCandidate(String id) async {
    await _client.post<dynamic>('/api/v1/accounts/profiles/$id/save/');
  }

  @override
  Future<void> unsaveCandidate(String id) async {
    await _client.delete<dynamic>('/api/v1/accounts/profiles/$id/unsave/');
  }
}

CandidateModel _candidateModelFromResponse(Object? data) {
  final payload = _unwrapMap(data);
  if (payload.containsKey('results')) {
    return CandidateModel.fromJson(payload);
  }

  final nested = payload['data'];
  if (nested is List) {
    return CandidateModel.fromJson({'results': nested});
  }
  if (nested is Map) {
    final nestedMap = _unwrapMap(nested);
    if (nestedMap.containsKey('results')) {
      return CandidateModel.fromJson(nestedMap);
    }
    return CandidateModel.fromJson({
      'results': [nestedMap],
    });
  }
  if (payload.isNotEmpty && payload['id'] != null) {
    return CandidateModel.fromJson({
      'results': [payload],
    });
  }
  return const CandidateModel();
}

Map<String, dynamic> _unwrapMap(Object? value) {
  if (value is! Map) return const <String, dynamic>{};
  final map = value.map((key, value) => MapEntry(key.toString(), value));
  final data = map['data'];
  if (data is Map) {
    return data.map((key, value) => MapEntry(key.toString(), value));
  }
  return map;
}
