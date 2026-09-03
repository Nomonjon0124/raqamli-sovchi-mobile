import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/core/network/api_client.dart';
import 'package:raqamli_sovchi/features/profile/data/data_sources/blocked_user_data_source.dart';

void main() {
  test('blocked user create sends schema-backed payload', () async {
    final client = _RecordingApiClient();
    final dataSource = RemoteBlockedUserDataSource(client);

    final result = await dataSource.blockUser(
      blockedUserId: 'user-uuid-123',
      reason: 'inappropriate',
    );

    expect(client.postPath, '/api/v1/accounts/blocked-users/');
    expect(client.postData, {
      'blocked': 'user-uuid-123',
      'reason': 'inappropriate',
    });
    expect(result.id, 'block-1');
    expect(result.blocked, 'user-uuid-123');
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
                  'id': 'block-1',
                  'blocker': 'my-user-uuid',
                  'blocked': 'user-uuid-123',
                  'reason': 'inappropriate',
                  'created_at': '2026-09-03T12:00:00Z',
                },
              }
              as T,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
