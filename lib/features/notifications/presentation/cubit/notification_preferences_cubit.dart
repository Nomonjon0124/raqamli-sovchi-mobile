import 'package:flutter_bloc/flutter_bloc.dart';

import '../../application/use_cases/notification_use_cases.dart';
import '../../domain/entities/notification_preferences.dart';
import 'notification_preferences_state.dart';

final class NotificationPreferencesCubit
    extends Cubit<NotificationPreferencesState> {
  NotificationPreferencesCubit({
    required LoadNotificationPreferencesUseCase load,
    required UpdateNotificationPreferenceUseCase update,
  }) : _load = load,
       _update = update,
       super(const NotificationPreferencesState());

  final LoadNotificationPreferencesUseCase _load;
  final UpdateNotificationPreferenceUseCase _update;

  Future<void> load() async {
    emit(
      state.copyWith(
        status: NotificationPreferencesStatus.loading,
        clearFailure: true,
      ),
    );
    final result = await _load();
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: NotificationPreferencesStatus.failure,
          failure: failure,
        ),
      ),
      (preferences) => emit(
        state.copyWith(
          status: NotificationPreferencesStatus.success,
          preferences: preferences,
          clearFailure: true,
        ),
      ),
    );
  }

  Future<void> setPreference(
    NotificationPreferenceType type,
    bool enabled,
  ) async {
    if (state.isSaving) return;

    final previous = state.preferences;
    emit(
      state.copyWith(
        preferences: previous.withValue(type, enabled),
        isSaving: true,
        clearFailure: true,
      ),
    );
    final result = await _update(type, enabled);
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          preferences: previous,
          isSaving: false,
          failure: failure,
        ),
      ),
      (preferences) => emit(
        state.copyWith(
          status: NotificationPreferencesStatus.success,
          preferences: preferences,
          isSaving: false,
          clearFailure: true,
        ),
      ),
    );
  }
}
