import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/core/network/api_client.dart';
import 'package:raqamli_sovchi/features/moderation/data/data_sources/complaint_data_source.dart';
import 'package:raqamli_sovchi/features/moderation/domain/entities/complaint.dart';

void main() {
  test('create complaint sends schema-backed payload', () async {
    final client = _RecordingApiClient();
    final dataSource = RemoteComplaintDataSource(client);

    final result = await dataSource.createComplaint(
      toUserId: 'user-uuid-123',
      reason: ComplaintReason.abusiveLanguage,
      message: '  Dalil bor  ',
    );

    expect(client.postPath, '/api/v1/accounts/complaints/');
    expect(client.postData, {
      'to_user': 'user-uuid-123',
      'reason': 'abusive_language',
      'message': 'Dalil bor',
    });
    expect(result.id, 'complaint-1');
    expect(result.status, ComplaintStatus.pending);
  });

  test('create complaint omits blank optional message', () async {
    final client = _RecordingApiClient();
    final dataSource = RemoteComplaintDataSource(client);

    await dataSource.createComplaint(
      toUserId: 'user-uuid-123',
      reason: ComplaintReason.other,
      message: '   ',
    );

    expect(client.postData, {'to_user': 'user-uuid-123', 'reason': 'other'});
  });
}

final class _RecordingApiClient implements ApiClient {
  String? postPath;
  Object? postData;

  @override
  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    postPath = path;
    postData = data;
    return Response<T>(
      requestOptions: RequestOptions(path: path),
      data:
          <String, dynamic>{
                'data': <String, dynamic>{
                  'id': 'complaint-1',
                  'reason': 'abusive_language',
                  'reason_label': 'Odobsiz so‘z',
                  'message': 'Dalil bor',
                  'evidence': null,
                  'status': 'pending',
                  'status_label': 'Ko‘rib chiqilmoqda',
                  'created_at': '2026-09-04T10:00:00Z',
                  'updated_at': '2026-09-04T10:00:00Z',
                  'from_user_info': null,
                  'to_user_info': <String, dynamic>{
                    'id': 'user-uuid-123',
                    'display_id': 'RS-001',
                    'full_name': 'Mohira R.',
                    'profile_info': null,
                  },
                  'chat_room_info': null,
                },
              }
              as T,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
