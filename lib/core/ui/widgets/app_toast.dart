import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_status_colors.dart';
import '../../../gen/assets.gen.dart';

enum ToastType { error, warning, info, success }

abstract final class AppToast {
  static void show(
    BuildContext context, {
    required String message,
    ToastType type = ToastType.error,
    Duration duration = const Duration(seconds: 4),
  }) {
    if (message.trim().isEmpty) return;

    final messenger = ScaffoldMessenger.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final statusColors = context.statusColors;
    messenger.hideCurrentSnackBar();

    final (bgColor, borderColor, textColor, iconColor, icon) = switch (type) {
      ToastType.error => (
        colorScheme.errorContainer,
        colorScheme.onErrorContainer.withValues(alpha: 0.55),
        colorScheme.onErrorContainer,
        colorScheme.error,
        Assets.icons.icGlyph,
      ),
      ToastType.warning => (
        statusColors.warningContainer,
        statusColors.onWarningContainer.withValues(alpha: 0.55),
        statusColors.onWarningContainer,
        statusColors.onWarningContainer,
        Assets.icons.icGlyph,
      ),
      ToastType.info => (
        statusColors.infoContainer,
        statusColors.onInfoContainer.withValues(alpha: 0.55),
        statusColors.onInfoContainer,
        colorScheme.primary,
        Assets.icons.icNotification,
      ),
      ToastType.success => (
        statusColors.successContainer,
        statusColors.onSuccessContainer.withValues(alpha: 0.55),
        statusColors.onSuccessContainer,
        statusColors.onSuccessContainer,
        Assets.icons.icVerifyCheck,
      ),
    };

    messenger.showSnackBar(
      SnackBar(
        elevation: 4,
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.transparent,
        padding: EdgeInsets.zero,
        margin: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        duration: duration,
        content: Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: borderColor, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow,
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: 14,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: icon.svg(
                  width: 16,
                  height: 16,
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                  excludeFromSemantics: true,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 13,
                    height: 18 / 13,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
