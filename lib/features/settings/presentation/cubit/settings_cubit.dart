import 'package:flutter_bloc/flutter_bloc.dart';

import 'settings_state.dart';

final class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  void notificationsChanged(bool enabled) {
    emit(state.copyWith(notificationsEnabled: enabled));
  }
}
