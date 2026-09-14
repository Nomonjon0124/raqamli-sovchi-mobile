import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/features/chat/data/models/chat_message_model.dart';

void main() {
  test('maps REST reply_to_info into the chat message quote', () {
    final message = ChatMessageModel.fromJson({
      'id': 'message-2',
      'chat_room_info': {'id': 'room-1'},
      'sender_info': {'id': 'user-2'},
      'content': 'Mana javob',
      'attachment': null,
      'reply_to_info': {
        'id': 'message-1',
        'sender': 'user-1',
        'content': 'Salom',
        'attachment': null,
        'created_at': '2026-09-10T06:51:43+05:00',
      },
      'is_read': false,
      'created_at': '2026-09-10T11:20:00+05:00',
    }).toEntity();

    expect(message.chatRoomId, 'room-1');
    expect(message.senderId, 'user-2');
    expect(message.replyTo?.id, 'message-1');
    expect(message.replyTo?.senderId, 'user-1');
    expect(message.replyTo?.content, 'Salom');
  });

  test('maps WebSocket reply_to and direct room and sender identifiers', () {
    final message = ChatMessageModel.fromJson({
      'id': 'message-2',
      'chat_room': 'room-1',
      'sender': 'user-2',
      'content': 'Mana javob',
      'reply_to': {
        'id': 'message-1',
        'sender': 'user-1',
        'content': 'Salom',
        'attachment': null,
      },
      'is_read': false,
      'created_at': '2026-09-10T11:20:00+05:00',
    }).toEntity();

    expect(message.chatRoomId, 'room-1');
    expect(message.senderId, 'user-2');
    expect(message.replyTo?.id, 'message-1');
  });
}
