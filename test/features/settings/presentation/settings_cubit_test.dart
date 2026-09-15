import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/core/security/secure_storage.dart';
import 'package:raqamli_sovchi/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:raqamli_sovchi/features/settings/presentation/cubit/settings_state.dart';

void main() {
  test('defaults to system theme mode', () {
    expect(SettingsCubit().state.themeMode, ThemeMode.system);
  });

  blocTest<SettingsCubit, SettingsState>(
    'updates the notifications preference',
    build: SettingsCubit.new,
    act: (cubit) => cubit.notificationsChanged(false),
    expect: () => const [SettingsState(notificationsEnabled: false)],
  );

  blocTest<SettingsCubit, SettingsState>(
    'updates locale and theme preferences',
    build: SettingsCubit.new,
    act: (cubit) {
      cubit.localeChanged(const Locale('uz', 'Cyrl'));
      cubit.themeModeChanged(ThemeMode.dark);
    },
    expect: () => const [
      SettingsState(locale: Locale('uz', 'Cyrl')),
      SettingsState(locale: Locale('uz', 'Cyrl'), themeMode: ThemeMode.dark),
    ],
  );

  test('restores persisted locale and theme mode', () async {
    final storage = _MemoryStorage({
      'settings.locale': 'uz_Cyrl',
      'settings.theme_mode': 'dark',
    });
    final cubit = SettingsCubit(storage);

    await cubit.load();

    expect(
      cubit.state.locale,
      const Locale.fromSubtags(languageCode: 'uz', scriptCode: 'Cyrl'),
    );
    expect(cubit.state.themeMode, ThemeMode.dark);
    await cubit.close();
  });

  test('persists locale and theme changes', () {
    final storage = _MemoryStorage();
    final cubit = SettingsCubit(storage);

    cubit.localeChanged(const Locale('ru'));
    cubit.themeModeChanged(ThemeMode.light);

    expect(storage.values['settings.locale'], 'ru');
    expect(storage.values['settings.theme_mode'], 'light');
  });
}

final class _MemoryStorage implements SecureStorage {
  _MemoryStorage([Map<String, String>? initial]) : values = {...?initial};

  final Map<String, String> values;

  @override
  Future<String?> read({required String key}) async => values[key];

  @override
  Future<void> write({required String key, required String value}) async {
    values[key] = value;
  }

  @override
  Future<void> delete({required String key}) async {
    values.remove(key);
  }
}
