import 'package:equatable/equatable.dart';

enum NotificationPreferenceType {
  newMatch('new_match'),
  newMessage('new_message'),
  profileViewed('profile_viewed'),
  systemMessages('system_messages');

  const NotificationPreferenceType(this.backendKey);

  final String backendKey;
}

final class NotificationPreferences extends Equatable {
  const NotificationPreferences({
    this.newMatch = true,
    this.newMessage = true,
    this.profileViewed = false,
    this.systemMessages = true,
  });

  final bool newMatch;
  final bool newMessage;
  final bool profileViewed;
  final bool systemMessages;

  NotificationPreferences copyWith({
    bool? newMatch,
    bool? newMessage,
    bool? profileViewed,
    bool? systemMessages,
  }) => NotificationPreferences(
    newMatch: newMatch ?? this.newMatch,
    newMessage: newMessage ?? this.newMessage,
    profileViewed: profileViewed ?? this.profileViewed,
    systemMessages: systemMessages ?? this.systemMessages,
  );

  bool valueFor(NotificationPreferenceType type) => switch (type) {
    NotificationPreferenceType.newMatch => newMatch,
    NotificationPreferenceType.newMessage => newMessage,
    NotificationPreferenceType.profileViewed => profileViewed,
    NotificationPreferenceType.systemMessages => systemMessages,
  };

  NotificationPreferences withValue(
    NotificationPreferenceType type,
    bool value,
  ) => switch (type) {
    NotificationPreferenceType.newMatch => copyWith(newMatch: value),
    NotificationPreferenceType.newMessage => copyWith(newMessage: value),
    NotificationPreferenceType.profileViewed => copyWith(profileViewed: value),
    NotificationPreferenceType.systemMessages => copyWith(
      systemMessages: value,
    ),
  };

  @override
  List<Object?> get props => [
    newMatch,
    newMessage,
    profileViewed,
    systemMessages,
  ];
}
