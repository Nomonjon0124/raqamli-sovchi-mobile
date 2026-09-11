import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../entities/chat_message.dart';
import '../entities/chat_presence.dart';
import '../entities/chat_realtime_event.dart';
import '../entities/chat_room.dart';

abstract interface class ChatRepository {
  Stream<ChatRealtimeEvent> get realtimeEvents;

  Future<Either<Failure, List<ChatRoom>>> getChatRooms();
  Future<Either<Failure, List<ChatMessage>>> getMessages(String chatRoomId);
  Future<Either<Failure, ChatMessage>> sendMessage({
    required String chatRoomId,
    required String content,
    String? replyToId,
  });
  Future<Either<Failure, void>> markRoomRead(String chatRoomId);
  Future<Either<Failure, ChatPresence>> getRoomPresence(String chatRoomId);
  Future<Either<Failure, Map<String, ChatPresence>>> getRoomsPresence();
  Future<Either<Failure, void>> connect(String chatRoomId);
  Future<void> disconnect();
  void sendTyping();
}
