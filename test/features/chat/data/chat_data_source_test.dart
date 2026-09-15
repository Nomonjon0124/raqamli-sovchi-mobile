import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/core/network/api_client.dart';
import 'package:raqamli_sovchi/features/chat/data/data_sources/chat_data_source.dart';

void main() {
  test('deletes a chat room through the room destroy endpoint', () async {
    final client = _RecordingApiClient();
    final dataSource = RemoteChatDataSource(client);

    await dataSource.deleteChatRoom('room-1');

    expect(client.deletePath, '/api/v1/matches/chat-rooms/room-1/');
  });
}

final class _RecordingApiClient implements ApiClient {
  String? deletePath;

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
