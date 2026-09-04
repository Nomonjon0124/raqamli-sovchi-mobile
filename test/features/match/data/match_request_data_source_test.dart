import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/core/network/api_client.dart';
import 'package:raqamli_sovchi/features/match/data/data_sources/match_request_data_source.dart';
import 'package:raqamli_sovchi/features/match/data/data_sources/photo_request_data_source.dart';
import 'package:raqamli_sovchi/features/match/domain/entities/match_request.dart';

void main() {
  test('match request create sends schema-backed payload', () async {
    final client = _RecordingApiClient();
    final dataSource = RemoteMatchRequestDataSource(client);

    await dataSource.createRequest(
      fromProfile: 'profile-1',
      toProfile: 'profile-2',
      note: 'ignored by current schema',
      visibilityScope: MatchRequestVisibilityScope.forwardToRepresentative,
    );

    expect(client.postPath, '/api/v1/matches/match-requests/');
    expect(client.postData, {'to_profile': 'profile-2'});
  });

  test('photo request create sends candidate id and optional note', () async {
    final client = _RecordingApiClient();
    final dataSource = RemotePhotoRequestDataSource(client);

    await dataSource.createRequest(
      toProfile: 'profile-2',
      note: '  Assalomu alaykum  ',
    );

    expect(client.postPath, '/api/v1/matches/photo-requests/');
    expect(client.postData, {
      'to_profile': 'profile-2',
      'note': 'Assalomu alaykum',
    });
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
                  'id': 'request-1',
                  'created_at': '2026-08-01T10:00:00Z',
                  'updated_at': '2026-08-01T10:00:00Z',
                  'status': 'pending',
                  'from_profile_info': {'id': 'profile-1'},
                  'to_profile_info': {'id': 'profile-2'},
                },
              }
              as T,
    );
  }

  @override
  Future<Response<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) => throw UnimplementedError();

  @override
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) => throw UnimplementedError();

  @override
  Future<Response<T>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) => throw UnimplementedError();

  @override
  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) => throw UnimplementedError();
}
