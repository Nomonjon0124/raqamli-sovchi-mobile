import 'package:equatable/equatable.dart';

final class SettingsState extends Equatable {
  const SettingsState({this.notificationsEnabled = true});

  final bool notificationsEnabled;

  SettingsState copyWith({bool? notificationsEnabled}) => SettingsState(
    notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
  );

  @override
  List<Object?> get props => [notificationsEnabled];
}
