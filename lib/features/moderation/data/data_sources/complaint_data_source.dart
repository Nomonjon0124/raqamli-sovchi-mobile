import '../../../../core/network/api_client.dart';
import '../../domain/entities/complaint.dart';
import '../models/complaint_model.dart';

abstract interface class ComplaintDataSource {
  Future<ComplaintModel> createComplaint({
    required String toUserId,
    required ComplaintReason reason,
    String? message,
  });
}

final class RemoteComplaintDataSource implements ComplaintDataSource {
  const RemoteComplaintDataSource(this._client);

  static const _complaintsPath = '/api/v1/accounts/complaints/';

  final ApiClient _client;

  @override
  Future<ComplaintModel> createComplaint({
    required String toUserId,
    required ComplaintReason reason,
    String? message,
  }) async {
    final normalizedMessage = message?.trim();
    final response = await _client.post<dynamic>(
      _complaintsPath,
      data: {
        'to_user': toUserId,
        'reason': reason.apiName,
        if (normalizedMessage != null && normalizedMessage.isNotEmpty)
          'message': normalizedMessage,
      },
    );
    return ComplaintModel.fromJson(_unwrapMap(response.data));
  }
}

Map<String, dynamic> _unwrapMap(Object? value) {
  if (value is! Map) return const <String, dynamic>{};
  final map = value.map((key, value) => MapEntry(key.toString(), value));
  final data = map['data'];
  if (data is Map) return _unwrapMap(data);
  return map;
}
