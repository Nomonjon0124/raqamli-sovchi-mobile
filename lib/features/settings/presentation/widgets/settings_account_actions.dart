import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../gen/assets.gen.dart';

final class SettingsAccountActions extends StatelessWidget {
  const SettingsAccountActions({
    required this.logoutText,
    required this.deleteText,
    required this.isLoading,
    required this.onLogout,
    required this.onDelete,
    super.key,
  });

  final String logoutText;
  final String deleteText;
  final bool isLoading;
  final VoidCallback onLogout;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Material(
        color: AppColors.subtleSurface,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColors.mutedSurface),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: InkWell(
          onTap: isLoading ? null : onLogout,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.input),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isLoading)
                    const SizedBox.square(
                      dimension: 17,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    Assets.icons.settingsLogout.svg(
                      width: 17,
                      height: 17,
                      colorFilter: const ColorFilter.mode(
                        AppColors.text,
                        BlendMode.srcIn,
                      ),
                      excludeFromSemantics: true,
                    ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(logoutText, style: AppTypography.settingsAction),
                ],
              ),
            ),
          ),
        ),
      ),
      const SizedBox(height: AppSpacing.md),
      Semantics(
        button: true,
        enabled: !isLoading,
        child: InkWell(
          onTap: isLoading ? null : onDelete,
          child: SizedBox(
            width: double.infinity,
            child: Text(
              deleteText,
              textAlign: TextAlign.center,
              style: AppTypography.settingsDeleteAction,
            ),
          ),
        ),
      ),
    ],
  );
}
