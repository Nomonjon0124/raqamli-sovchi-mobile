import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_presence.dart';
import '../../domain/entities/chat_room.dart';
import '../../domain/repositories/chat_repository.dart';

final class LoadChatRoomsUseCase {
  const LoadChatRoomsUseCase(this._repository);
  final ChatRepository _repository;
  Future<Either<Failure, List<ChatRoom>>> call() => _repository.getChatRooms();
}

final class LoadChatMessagesUseCase {
  const LoadChatMessagesUseCase(this._repository);
  final ChatRepository _repository;
  Future<Either<Failure, List<ChatMessage>>> call(String chatRoomId) =>
      _repository.getMessages(chatRoomId);
}

final class SendChatMessageUseCase {
  const SendChatMessageUseCase(this._repository);
  final ChatRepository _repository;
  Future<Either<Failure, ChatMessage>> call({
    required String chatRoomId,
    required String content,
    String? replyToId,
  }) => _repository.sendMessage(
    chatRoomId: chatRoomId,
    content: content,
    replyToId: replyToId,
  );
}

final class MarkChatRoomReadUseCase {
  const MarkChatRoomReadUseCase(this._repository);
  final ChatRepository _repository;
  Future<Either<Failure, void>> call(String chatRoomId) =>
      _repository.markRoomRead(chatRoomId);
}

final class LoadChatRoomPresenceUseCase {
  const LoadChatRoomPresenceUseCase(this._repository);
  final ChatRepository _repository;
  Future<Either<Failure, ChatPresence>> call(String chatRoomId) =>
      _repository.getRoomPresence(chatRoomId);
}

final class LoadChatRoomsPresenceUseCase {
  const LoadChatRoomsPresenceUseCase(this._repository);
  final ChatRepository _repository;
  Future<Either<Failure, Map<String, ChatPresence>>> call() =>
      _repository.getRoomsPresence();
}

final class ConnectChatRoomUseCase {
  const ConnectChatRoomUseCase(this._repository);
  final ChatRepository _repository;
  Future<Either<Failure, void>> call(String chatRoomId) =>
      _repository.connect(chatRoomId);
}

final class DisconnectChatRoomUseCase {
  const DisconnectChatRoomUseCase(this._repository);
  final ChatRepository _repository;
  Future<void> call() => _repository.disconnect();
}

final class SendChatTypingUseCase {
  const SendChatTypingUseCase(this._repository);
  final ChatRepository _repository;
  void call() => _repository.sendTyping();
}
