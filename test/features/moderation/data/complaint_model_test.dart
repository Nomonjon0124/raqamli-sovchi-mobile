import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/features/moderation/data/models/complaint_model.dart';
import 'package:raqamli_sovchi/features/moderation/domain/entities/complaint.dart';

void main() {
  test('parses complaint create response and maps nested entities', () {
    final model = ComplaintModel.fromJson({
      'id': 'complaint-1',
      'reason': 'fake_profile',
      'reason_label': 'Soxta profil',
      'message': 'Profil rasmi mos emas',
      'evidence': {'kind': 'text'},
      'status': 'pending',
      'status_label': 'Ko‘rib chiqilmoqda',
      'created_at': '2026-09-04T10:00:00Z',
      'updated_at': '2026-09-04T10:05:00Z',
      'from_user_info': {
        'id': 'from-user',
        'phone_number': '+998901234567',
        'email': null,
        'display_id': 'RS-100',
        'full_name': 'Ali V.',
        'profile_info': null,
      },
      'to_user_info': {
        'id': 'to-user',
        'phone_number': null,
        'email': 'user@example.com',
        'display_id': 'RS-101',
        'full_name': 'Mohira R.',
        'profile_info': null,
      },
      'chat_room_info': {'id': 'chat-room-1'},
    });

    final entity = model.toEntity();

    expect(model.reason, ComplaintReason.fakeProfile);
    expect(model.status, ComplaintStatus.pending);
    expect(entity.id, 'complaint-1');
    expect(entity.reasonLabel, 'Soxta profil');
    expect(entity.statusLabel, 'Ko‘rib chiqilmoqda');
    expect(entity.message, 'Profil rasmi mos emas');
    expect(entity.fromUser?.fullName, 'Ali V.');
    expect(entity.toUser?.displayId, 'RS-101');
    expect(entity.chatRoom?.id, 'chat-room-1');
  });
}
