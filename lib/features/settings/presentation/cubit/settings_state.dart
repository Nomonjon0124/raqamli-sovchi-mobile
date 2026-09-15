import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

final class SettingsState extends Equatable {
  const SettingsState({
    this.notificationsEnabled = true,
    this.locale = const Locale('uz'),
    this.themeMode = ThemeMode.system,
  });

  final bool notificationsEnabled;
  final Locale locale;
  final ThemeMode themeMode;

  SettingsState copyWith({
    bool? notificationsEnabled,
    Locale? locale,
    ThemeMode? themeMode,
  }) => SettingsState(
    notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    locale: locale ?? this.locale,
    themeMode: themeMode ?? this.themeMode,
  );

  @override
  List<Object?> get props => [notificationsEnabled, locale, themeMode];
}
