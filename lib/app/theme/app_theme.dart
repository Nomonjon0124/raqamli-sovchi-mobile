import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_status_colors.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final primary = isLight ? AppColors.primary : AppColors.primaryDark;
    final page = isLight ? AppColors.surfaceLight : AppColors.surfaceDark;
    final text = isLight ? AppColors.text : AppColors.textDark;
    final mutedText = isLight ? AppColors.mutedText : AppColors.mutedTextDark;
    final border = isLight ? AppColors.border : AppColors.borderDark;
    final surfaceContainerLow = isLight
        ? AppColors.subtleSurface
        : AppColors.subtleSurfaceDark;
    final surfaceContainer = isLight
        ? AppColors.mutedSurface
        : AppColors.mutedSurfaceDark;
    final error = isLight ? AppColors.danger : AppColors.dangerDark;
    final onError = isLight ? AppColors.surfaceLight : AppColors.text;
    final scheme =
        ColorScheme.fromSeed(
          seedColor: primary,
          brightness: brightness,
        ).copyWith(
          primary: primary,
          onPrimary: AppColors.surfaceLight,
          surface: page,
          surfaceContainerLowest: page,
          surfaceContainerLow: surfaceContainerLow,
          surfaceContainer: surfaceContainer,
          surfaceContainerHigh: surfaceContainer,
          surfaceContainerHighest: surfaceContainer,
          onSurface: text,
          onSurfaceVariant: mutedText,
          outline: border,
          outlineVariant: surfaceContainer,
          error: error,
          onError: onError,
          errorContainer: isLight
              ? AppColors.dangerSurface
              : const Color(0xFF3F1517),
          onErrorContainer: isLight
              ? const Color(0xFF991B1B)
              : const Color(0xFFFCA5A5),
        );

    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Manrope',
      colorScheme: scheme,
      scaffoldBackgroundColor: page,
      dividerColor: surfaceContainer,
      appBarTheme: AppBarTheme(
        backgroundColor: page,
        foregroundColor: text,
        surfaceTintColor: AppColors.transparent,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: page,
        surfaceTintColor: AppColors.transparent,
        modalBackgroundColor: page,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: page,
        surfaceTintColor: AppColors.transparent,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: surfaceContainer,
        contentTextStyle: TextStyle(color: text),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: page,
        indicatorColor: surfaceContainer,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceContainer,
        hintStyle: TextStyle(
          color: isLight ? AppColors.placeholder : AppColors.placeholderDark,
        ),
        labelStyle: TextStyle(color: mutedText),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
      textTheme: const TextTheme(
        titleLarge: AppTypography.pageTitle,
        bodyLarge: AppTypography.body,
      ).apply(bodyColor: text, displayColor: text),
      extensions: [
        AppStatusColors(
          warningContainer: isLight
              ? AppColors.warningSurface
              : AppColors.warningSurfaceDark,
          onWarningContainer: isLight
              ? AppColors.warningText
              : AppColors.warningTextDark,
          successContainer: isLight
              ? AppColors.successSurface
              : AppColors.servicesVerifySurfaceDark,
          onSuccessContainer: isLight
              ? AppColors.successText
              : const Color(0xFF6EE7B7),
          infoContainer: isLight
              ? AppColors.profileAvatarSurface
              : const Color(0xFF0C2942),
          onInfoContainer: isLight
              ? AppColors.profileAvatarText
              : const Color(0xFF7DD3FC),
          meetingContainer: isLight
              ? AppColors.servicesMeetingSurface
              : AppColors.servicesMeetingSurfaceDark,
          onMeetingContainer: isLight
              ? AppColors.servicesMeetingIcon
              : const Color(0xFFC4B5FD),
        ),
      ],
    );
  }
}
