import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/notification_preferences.dart';

enum NotificationPreferencesStatus { initial, loading, success, failure }

final class NotificationPreferencesState extends Equatable {
  const NotificationPreferencesState({
    this.status = NotificationPreferencesStatus.initial,
    this.preferences = const NotificationPreferences(),
    this.isSaving = false,
    this.failure,
  });

  final NotificationPreferencesStatus status;
  final NotificationPreferences preferences;
  final bool isSaving;
  final Failure? failure;

  NotificationPreferencesState copyWith({
    NotificationPreferencesStatus? status,
    NotificationPreferences? preferences,
    bool? isSaving,
    Failure? failure,
    bool clearFailure = false,
  }) => NotificationPreferencesState(
    status: status ?? this.status,
    preferences: preferences ?? this.preferences,
    isSaving: isSaving ?? this.isSaving,
    failure: clearFailure ? null : failure ?? this.failure,
  );

  @override
  List<Object?> get props => [status, preferences, isSaving, failure];
}
