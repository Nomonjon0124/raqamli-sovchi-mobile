import 'package:dio/dio.dart';

import '../../../../core/errors/either.dart';
import '../../../../core/errors/exception_mapper.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_presence.dart';
import '../../domain/entities/chat_realtime_event.dart';
import '../../domain/entities/chat_room.dart';
import '../../domain/repositories/chat_repository.dart';
import '../data_sources/chat_data_source.dart';
import '../services/chat_web_socket_service.dart';

final class ChatRepositoryImpl implements ChatRepository {
  const ChatRepositoryImpl(this._dataSource, this._webSocket);

  final ChatDataSource _dataSource;
  final ChatWebSocketService _webSocket;

  @override
  Stream<ChatRealtimeEvent> get realtimeEvents => _webSocket.events;

  @override
  Future<Either<Failure, List<ChatRoom>>> getChatRooms() => _guard(
    () async => (await _dataSource.fetchChatRooms())
        .map((item) => item.toEntity())
        .toList(),
  );

  @override
  Future<Either<Failure, List<ChatMessage>>> getMessages(String chatRoomId) =>
      _guard(
        () async => (await _dataSource.fetchMessages(
          chatRoomId,
        )).map((item) => item.toEntity()).toList(),
      );

  @override
  Future<Either<Failure, ChatMessage>> sendMessage({
    required String chatRoomId,
    required String content,
    String? replyToId,
  }) => _guard(
    () async => (await _dataSource.createMessage(
      chatRoomId: chatRoomId,
      content: content,
      replyToId: replyToId,
    )).toEntity(),
  );

  @override
  Future<Either<Failure, void>> markRoomRead(String chatRoomId) =>
      _guard(() => _dataSource.markRoomRead(chatRoomId));

  @override
  Future<Either<Failure, ChatPresence>> getRoomPresence(String chatRoomId) =>
      _guard(
        () async =>
            (await _dataSource.fetchRoomPresence(chatRoomId)).toEntity(),
      );

  @override
  Future<Either<Failure, Map<String, ChatPresence>>> getRoomsPresence() =>
      _guard(
        () async => (await _dataSource.fetchRoomsPresence()).map(
          (key, value) => MapEntry(key, value.toEntity()),
        ),
      );

  @override
  Future<Either<Failure, void>> connect(String chatRoomId) =>
      _guard(() => _webSocket.connect(chatRoomId));

  @override
  Future<void> disconnect() => _webSocket.disconnect();

  @override
  void sendTyping() => _webSocket.sendTyping();

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } on DioException catch (error) {
      return Left(mapDioException(error));
    } on FormatException {
      return const Left(Failure.validation());
    } catch (_) {
      return const Left(Failure.unknown());
    }
  }
}
