import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/core/network/api_client.dart';
import 'package:raqamli_sovchi/features/profile/data/data_sources/profile_data_source.dart';

void main() {
  test('setMainPhoto sends a partial update to the photo endpoint', () async {
    final client = _RecordingApiClient();
    final dataSource = RemoteProfileDataSource(client);

    final photo = await dataSource.setMainPhoto('photo-1');

    expect(client.patchPath, '/api/v1/accounts/photos/photo-1/');
    expect(client.patchData, {'is_main': true});
    expect(photo.id, 'photo-1');
  });

  test('deletePhoto sends a delete request to the photo endpoint', () async {
    final client = _RecordingApiClient();
    final dataSource = RemoteProfileDataSource(client);

    await dataSource.deletePhoto('photo-1');

    expect(client.deletePath, '/api/v1/accounts/photos/photo-1/');
  });
}

final class _RecordingApiClient implements ApiClient {
  String? patchPath;
  Object? patchData;
  String? deletePath;

  @override
  Future<Response<T>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    patchPath = path;
    patchData = data;
    return Response<T>(
      requestOptions: RequestOptions(path: path),
      data:
          <String, dynamic>{
                'data': <String, dynamic>{
                  'id': 'photo-1',
                  'image': 'https://example.com/photo.jpg',
                  'is_main': true,
                  'order': 1,
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
  }) async {
    deletePath = path;
    return Response<T>(requestOptions: RequestOptions(path: path));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
