import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/features/chat/data/models/chat_room_model.dart';

void main() {
  test('maps optional participant identity and avatar details', () {
    final room = ChatRoomModel.fromJson({
      'id': 'room-1',
      'created_at': '2026-09-11T08:30:00+05:00',
      'updated_at': '2026-09-11T08:30:00+05:00',
      'participant': {
        'user_id': 'user-2',
        'profile_info': {
          'first_name': 'Aziza',
          'last_name': 'Xolmatova',
          'main_photo': 'https://cdn.example.com/aziza.jpg',
        },
      },
    }).toEntity();

    expect(room.participantUserId, 'user-2');
    expect(room.participantName, 'Aziza Xolmatova');
    expect(room.participantAvatarUrl, 'https://cdn.example.com/aziza.jpg');
  });

  test(
    'keeps the documented partner label when extended fields are absent',
    () {
      final room = ChatRoomModel.fromJson({
        'id': 'room-1',
        'partner_info': 'Aziza Xolmatova',
        'created_at': '2026-09-11T08:30:00+05:00',
        'updated_at': '2026-09-11T08:30:00+05:00',
      }).toEntity();

      expect(room.participantName, 'Aziza Xolmatova');
      expect(room.participantAvatarUrl, isNull);
    },
  );
}
