import '../../../../core/network/api_client.dart';
import '../models/chat_message_model.dart';
import '../models/chat_presence_model.dart';
import '../models/chat_room_model.dart';

abstract interface class ChatDataSource {
  Future<List<ChatRoomModel>> fetchChatRooms();
  Future<List<ChatMessageModel>> fetchMessages(String chatRoomId);
  Future<ChatMessageModel> createMessage({
    required String chatRoomId,
    required String content,
    String? replyToId,
  });
  Future<void> markRoomRead(String chatRoomId);
  Future<ChatPresenceModel> fetchRoomPresence(String chatRoomId);
  Future<Map<String, ChatPresenceModel>> fetchRoomsPresence();
  Future<String> createWebSocketTicket();
}

final class RemoteChatDataSource implements ChatDataSource {
  const RemoteChatDataSource(this._client);

  static const _roomsPath = '/api/v1/matches/chat-rooms/';
  static const _messagesPath = '/api/v1/matches/messages/';
  static const _ticketPath = '/api/v1/accounts/notifications/tickets/';
  final ApiClient _client;

  @override
  Future<List<ChatRoomModel>> fetchChatRooms() async {
    final response = await _client.get<dynamic>(_roomsPath);
    return _results(
      _unwrapMap(response.data),
    ).map(ChatRoomModel.fromJson).toList();
  }

  @override
  Future<List<ChatMessageModel>> fetchMessages(String chatRoomId) async {
    final response = await _client.get<dynamic>(
      _messagesPath,
      queryParameters: {'chat_room': chatRoomId},
    );
    return _results(
      _unwrapMap(response.data),
    ).map(ChatMessageModel.fromJson).toList();
  }

  @override
  Future<ChatMessageModel> createMessage({
    required String chatRoomId,
    required String content,
    String? replyToId,
  }) async {
    final response = await _client.post<dynamic>(
      _messagesPath,
      data: {
        'chat_room': chatRoomId,
        'content': content,
        'reply_to': ?replyToId,
      },
    );
    return ChatMessageModel.fromJson(_unwrapMap(response.data));
  }

  @override
  Future<void> markRoomRead(String chatRoomId) => _client.post<dynamic>(
    '${_messagesPath}mark-read/',
    data: {'chat_room': chatRoomId},
  );

  @override
  Future<ChatPresenceModel> fetchRoomPresence(String chatRoomId) async {
    final response = await _client.get<dynamic>(
      '$_roomsPath$chatRoomId/presence/',
    );
    return ChatPresenceModel.fromJson(_unwrapMap(response.data));
  }

  @override
  Future<Map<String, ChatPresenceModel>> fetchRoomsPresence() async {
    final response = await _client.get<dynamic>('${_roomsPath}presence/');
    final data = _unwrapMap(response.data);
    return data.map(
      (userId, value) => MapEntry(
        userId,
        ChatPresenceModel.fromJson(_unwrapMap(value), userId: userId),
      ),
    );
  }

  @override
  Future<String> createWebSocketTicket() async {
    final response = await _client.post<dynamic>(_ticketPath);
    final ticket = _unwrapMap(response.data)['ticket']?.toString();
    if (ticket == null || ticket.isEmpty) {
      throw const FormatException('Missing chat WebSocket ticket.');
    }
    return ticket;
  }
}

Map<String, dynamic> _unwrapMap(Object? value) {
  if (value is! Map) return const {};
  final map = value.map((key, item) => MapEntry(key.toString(), item));
  return map['data'] is Map ? _unwrapMap(map['data']) : map;
}

List<Map<String, dynamic>> _results(Map<String, dynamic> data) {
  final values = data['results'] is List ? data['results'] as List : const [];
  return values.whereType<Map>().map(_unwrapMap).toList();
}
