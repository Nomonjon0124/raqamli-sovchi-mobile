import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/security/secure_storage.dart';
import 'settings_state.dart';

final class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit([SecureStorage? storage])
    : _storage = storage,
      super(const SettingsState());

  static const _localeKey = 'settings.locale';
  static const _themeModeKey = 'settings.theme_mode';

  final SecureStorage? _storage;

  Future<void> load() async {
    final storage = _storage;
    if (storage == null || isClosed) return;

    try {
      final storedLocale = await storage.read(key: _localeKey);
      final storedThemeMode = await storage.read(key: _themeModeKey);
      if (isClosed) return;

      emit(
        state.copyWith(
          locale: _decodeLocale(storedLocale) ?? state.locale,
          themeMode: _decodeThemeMode(storedThemeMode) ?? state.themeMode,
        ),
      );
    } catch (_) {
      // Stored preferences are optional; keep defaults when storage fails.
    }
  }

  void notificationsChanged(bool enabled) {
    emit(state.copyWith(notificationsEnabled: enabled));
  }

  void localeChanged(Locale locale) {
    emit(state.copyWith(locale: locale));
    unawaited(_persist(_localeKey, _encodeLocale(locale)));
  }

  void themeModeChanged(ThemeMode themeMode) {
    emit(state.copyWith(themeMode: themeMode));
    unawaited(_persist(_themeModeKey, themeMode.name));
  }

  Future<void> _persist(String key, String value) async {
    final storage = _storage;
    if (storage == null) return;
    try {
      await storage.write(key: key, value: value);
    } catch (_) {
      // A preference write must not block or fail the settings UI.
    }
  }

  static String _encodeLocale(Locale locale) {
    if (locale.languageCode == 'uz' && locale.scriptCode == 'Cyrl') {
      return 'uz_Cyrl';
    }
    return locale.languageCode;
  }

  static Locale? _decodeLocale(String? value) => switch (value) {
    'uz' => const Locale('uz'),
    'uz_Cyrl' => const Locale.fromSubtags(
      languageCode: 'uz',
      scriptCode: 'Cyrl',
    ),
    'ru' => const Locale('ru'),
    'en' => const Locale('en'),
    _ => null,
  };

  static ThemeMode? _decodeThemeMode(String? value) => switch (value) {
    'system' => ThemeMode.system,
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => null,
  };
}
