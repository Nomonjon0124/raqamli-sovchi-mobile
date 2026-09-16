import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/features/notifications/data/models/app_notification_model.dart';
import 'package:raqamli_sovchi/features/notifications/data/models/notification_preferences_model.dart';

void main() {
  test('maps backend notification type to domain model', () {
    final model = AppNotificationModel.fromJson({
      'id': 'notification-id',
      'title': 'Profil ko‘rildi',
      'message': 'Profilingiz ko‘rildi',
      'type': 'profile_viewed',
      'is_read': false,
    });

    expect(model.type, 'profile_viewed');
    expect(model.toEntity().type, 'profile_viewed');
  });

  test('maps notification preferences using backend field names', () {
    const model = NotificationPreferencesModel(
      newMatch: false,
      newMessage: true,
      profileViewed: false,
      systemMessages: true,
    );

    expect(model.toJson(), {
      'new_match': false,
      'new_message': true,
      'profile_viewed': false,
      'system_messages': true,
    });
    expect(NotificationPreferencesModel.fromJson(model.toJson()), model);
  });
}
