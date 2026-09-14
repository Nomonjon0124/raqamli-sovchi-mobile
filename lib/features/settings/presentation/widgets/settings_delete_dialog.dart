import 'package:flutter/material.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';

final class SettingsDeleteDialog extends StatelessWidget {
  const SettingsDeleteDialog({
    required this.title,
    required this.message,
    required this.cancelText,
    required this.confirmText,
    super.key,
  });

  final String title;
  final String message;
  final String cancelText;
  final String confirmText;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Dialog(
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.sheet),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.section),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: AppTypography.settingsPageTitle.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              style: AppTypography.body.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.section),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
                textStyle: AppTypography.settingsAction,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.input),
              ),
              child: Text(confirmText),
            ),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: OutlinedButton.styleFrom(
                textStyle: AppTypography.settingsAction,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.input),
              ),
              child: Text(cancelText),
            ),
          ],
        ),
      ),
    );
  }
}
