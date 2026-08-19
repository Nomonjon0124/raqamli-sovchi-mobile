import 'package:flutter/foundation.dart';

import '../../../../core/network/api_client.dart';
import '../models/candidate_model.dart';

abstract interface class DiscoveryDataSource {
  Future<CandidateModel> fetchCandidates({
    int page = 1,
    int pageSize = 10,
    String? filter,
  });
}

final class RemoteDiscoveryDataSource implements DiscoveryDataSource {
  const RemoteDiscoveryDataSource(this._client);

  final ApiClient _client;

  @override
  Future<CandidateModel> fetchCandidates({
    int page = 1,
    int pageSize = 10,
    String? filter,
  }) async {
    final endpoint = filter == 'matches'
        ? '/api/v1/accounts/profiles/matches/'
        : '/api/v1/accounts/profiles/';

    final response = await _client.get<dynamic>(
      endpoint,
      queryParameters: {
        'page': page,
        'page_size': pageSize,
      },
    );

    final data = response.data;
    if (data is Map<String, dynamic>) {
      debugPrint('discovery raw response data: $data');
      final payload = data['data'] is Map<String, dynamic>
          ? data['data'] as Map<String, dynamic>
          : data;
      return CandidateModel.fromJson(payload);
    }

    return const CandidateModel();
  }
}
