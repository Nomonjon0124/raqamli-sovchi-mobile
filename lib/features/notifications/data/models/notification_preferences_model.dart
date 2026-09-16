import 'package:equatable/equatable.dart';

import '../../domain/entities/notification_preferences.dart';

final class NotificationPreferencesModel extends Equatable {
  const NotificationPreferencesModel({
    required this.newMatch,
    required this.newMessage,
    required this.profileViewed,
    required this.systemMessages,
  });

  factory NotificationPreferencesModel.fromJson(Map<String, dynamic> json) =>
      NotificationPreferencesModel(
        newMatch: json['new_match'] == true,
        newMessage: json['new_message'] == true,
        profileViewed: json['profile_viewed'] == true,
        systemMessages: json['system_messages'] == true,
      );

  factory NotificationPreferencesModel.fromEntity(
    NotificationPreferences preferences,
  ) => NotificationPreferencesModel(
    newMatch: preferences.newMatch,
    newMessage: preferences.newMessage,
    profileViewed: preferences.profileViewed,
    systemMessages: preferences.systemMessages,
  );

  final bool newMatch;
  final bool newMessage;
  final bool profileViewed;
  final bool systemMessages;

  Map<String, dynamic> toJson() => {
    'new_match': newMatch,
    'new_message': newMessage,
    'profile_viewed': profileViewed,
    'system_messages': systemMessages,
  };

  NotificationPreferences toEntity() => NotificationPreferences(
    newMatch: newMatch,
    newMessage: newMessage,
    profileViewed: profileViewed,
    systemMessages: systemMessages,
  );

  @override
  List<Object?> get props => [
    newMatch,
    newMessage,
    profileViewed,
    systemMessages,
  ];
}
