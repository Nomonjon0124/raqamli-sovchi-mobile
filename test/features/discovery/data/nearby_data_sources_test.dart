import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/core/network/api_client.dart';
import 'package:raqamli_sovchi/features/discovery/data/data_sources/discovery_data_source.dart';
import 'package:raqamli_sovchi/features/discovery/domain/entities/discovery_filter.dart';
import 'package:raqamli_sovchi/features/profile/data/data_sources/profile_data_source.dart';

void main() {
  test(
    'nearby request sends the backend radius and paging parameters',
    () async {
      final client = _RecordingApiClient();
      final dataSource = RemoteDiscoveryDataSource(client);

      await dataSource.fetchCandidates(
        page: 2,
        pageSize: 100,
        filter: DiscoveryFilter.nearby,
        radiusKm: 5,
      );

      expect(client.getPath, '/api/v1/accounts/profiles/nearby/');
      expect(client.getQuery, {'page': 2, 'page_size': 100, 'radius': 5});
    },
  );

  test('profile location PATCH uses six-decimal string coordinates', () async {
    final client = _RecordingApiClient();
    final dataSource = RemoteProfileDataSource(client);

    await dataSource.updateLocation(latitude: 41.311081, longitude: 69.240562);

    expect(client.patchPath, '/api/v1/accounts/profiles/me/');
    expect(client.patchData, {
      'latitude': '41.311081',
      'longitude': '69.240562',
    });
  });
}

final class _RecordingApiClient implements ApiClient {
  String? getPath;
  Map<String, dynamic>? getQuery;
  String? patchPath;
  Object? patchData;

  @override
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    getPath = path;
    getQuery = queryParameters;
    return Response<T>(
      requestOptions: RequestOptions(path: path),
      data:
          <String, dynamic>{
                'data': <String, dynamic>{'results': <Object>[]},
              }
              as T,
    );
  }

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
      data: <String, dynamic>{} as T,
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
  Future<Response<T>> post<T>(
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
