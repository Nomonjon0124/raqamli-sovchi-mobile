import 'package:flutter/material.dart';

final class AppStatusColors extends ThemeExtension<AppStatusColors> {
  const AppStatusColors({
    required this.warningContainer,
    required this.onWarningContainer,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.infoContainer,
    required this.onInfoContainer,
    required this.meetingContainer,
    required this.onMeetingContainer,
  });

  final Color warningContainer;
  final Color onWarningContainer;
  final Color successContainer;
  final Color onSuccessContainer;
  final Color infoContainer;
  final Color onInfoContainer;
  final Color meetingContainer;
  final Color onMeetingContainer;

  factory AppStatusColors.fallback(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    return AppStatusColors(
      warningContainer: isLight
          ? const Color(0xFFFFFBEB)
          : const Color(0xFF2A1F0A),
      onWarningContainer: isLight
          ? const Color(0xFF92400E)
          : const Color(0xFFFBBF24),
      successContainer: isLight
          ? const Color(0xFFECFDF5)
          : const Color(0xFF12301F),
      onSuccessContainer: isLight
          ? const Color(0xFF047857)
          : const Color(0xFF6EE7B7),
      infoContainer: isLight
          ? const Color(0xFFE5F3FF)
          : const Color(0xFF0C2942),
      onInfoContainer: isLight
          ? const Color(0xFF0072CC)
          : const Color(0xFF7DD3FC),
      meetingContainer: isLight
          ? const Color(0xFFEEEAFB)
          : const Color(0xFF241F3D),
      onMeetingContainer: isLight
          ? const Color(0xFF5B4BC4)
          : const Color(0xFFC4B5FD),
    );
  }

  @override
  AppStatusColors copyWith({
    Color? warningContainer,
    Color? onWarningContainer,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? infoContainer,
    Color? onInfoContainer,
    Color? meetingContainer,
    Color? onMeetingContainer,
  }) => AppStatusColors(
    warningContainer: warningContainer ?? this.warningContainer,
    onWarningContainer: onWarningContainer ?? this.onWarningContainer,
    successContainer: successContainer ?? this.successContainer,
    onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
    infoContainer: infoContainer ?? this.infoContainer,
    onInfoContainer: onInfoContainer ?? this.onInfoContainer,
    meetingContainer: meetingContainer ?? this.meetingContainer,
    onMeetingContainer: onMeetingContainer ?? this.onMeetingContainer,
  );

  @override
  AppStatusColors lerp(covariant AppStatusColors? other, double t) {
    if (other == null) return this;
    return AppStatusColors(
      warningContainer: Color.lerp(
        warningContainer,
        other.warningContainer,
        t,
      )!,
      onWarningContainer: Color.lerp(
        onWarningContainer,
        other.onWarningContainer,
        t,
      )!,
      successContainer: Color.lerp(
        successContainer,
        other.successContainer,
        t,
      )!,
      onSuccessContainer: Color.lerp(
        onSuccessContainer,
        other.onSuccessContainer,
        t,
      )!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
      onInfoContainer: Color.lerp(onInfoContainer, other.onInfoContainer, t)!,
      meetingContainer: Color.lerp(
        meetingContainer,
        other.meetingContainer,
        t,
      )!,
      onMeetingContainer: Color.lerp(
        onMeetingContainer,
        other.onMeetingContainer,
        t,
      )!,
    );
  }
}

extension AppThemeStatusColors on BuildContext {
  AppStatusColors get statusColors =>
      Theme.of(this).extension<AppStatusColors>() ??
      AppStatusColors.fallback(Theme.of(this).brightness);
}
