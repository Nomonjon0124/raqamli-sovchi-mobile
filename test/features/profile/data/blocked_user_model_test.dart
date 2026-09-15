import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/features/profile/data/models/blocked_user_model.dart';

void main() {
  test('parses blocked_info avatar and preserves it in entity mapping', () {
    const avatarUrl = 'https://example.com/nozima.jpg?signature=abc';
    final model = BlockedUserModel.fromJson({
      'id': 'block-1',
      'blocker': 'user-me',
      'blocked': 'user-target',
      'blocked_info': {
        'id': 'user-target',
        'phone_number': '+998900000053',
        'email': null,
        'first_name': 'Nozima',
        'last_name': 'Odileva',
        'avatar': '  $avatarUrl  ',
      },
      'reason': null,
      'created_at': '2026-09-15T10:42:18.369292+05:00',
    });

    expect(model.blockedInfo?.avatarUrl, avatarUrl);
    expect(model.toEntity().blockedInfo?.avatarUrl, avatarUrl);
    expect(model.blockedInfo?.toJson()['avatar'], avatarUrl);
  });

  test('treats missing or blank avatar as null', () {
    final model = BlockedUserModel.fromJson({
      'id': 'block-1',
      'blocker': 'user-me',
      'blocked': 'user-target',
      'blocked_info': {
        'id': 'user-target',
        'profile_id': 'profile-target',
        'avatar': '  ',
      },
    });

    expect(model.blockedInfo?.avatarUrl, isNull);
    expect(model.toEntity().blockedInfo?.avatarUrl, isNull);
  });
}
