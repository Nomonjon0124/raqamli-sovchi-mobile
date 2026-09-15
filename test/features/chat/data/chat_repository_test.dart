import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/features/chat/data/data_sources/chat_data_source.dart';
import 'package:raqamli_sovchi/features/chat/data/models/chat_message_model.dart';
import 'package:raqamli_sovchi/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:raqamli_sovchi/features/chat/data/services/chat_web_socket_service.dart';

void main() {
  test('deletes the chat room without loading or deleting messages', () async {
    final dataSource = _RecordingChatDataSource();
    final webSocket = ChatWebSocketService(dataSource);
    final repository = ChatRepositoryImpl(dataSource, webSocket);

    final result = await repository.deleteConversation('room-1');

    expect(result.fold((_) => false, (_) => true), isTrue);
    expect(dataSource.deletedChatRoomId, 'room-1');
    expect(dataSource.fetchMessagesCalls, 0);
    await webSocket.dispose();
  });
}

final class _RecordingChatDataSource implements ChatDataSource {
  String? deletedChatRoomId;
  var fetchMessagesCalls = 0;

  @override
  Future<void> deleteChatRoom(String chatRoomId) async {
    deletedChatRoomId = chatRoomId;
  }

  @override
  Future<List<ChatMessageModel>> fetchMessages(String chatRoomId) async {
    fetchMessagesCalls++;
    return const [];
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
