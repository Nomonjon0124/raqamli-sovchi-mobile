import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_radius.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_typography.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../l10n/app_localizations.dart';

final class ProfileEditBottomBar extends StatelessWidget {
  const ProfileEditBottomBar({
    required this.onSave,
    required this.onCancel,
    this.isLoading = false,
    this.isSaveEnabled = true,
    super.key,
  });

  final VoidCallback onSave;
  final VoidCallback onCancel;
  final bool isLoading;
  final bool isSaveEnabled;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.section,
            AppSpacing.lg,
            AppSpacing.section,
            AppSpacing.sm,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: (isSaveEnabled && !isLoading) ? onSave : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Theme.of(context).colorScheme.surface,
                    disabledBackgroundColor: Theme.of(
                      context,
                    ).colorScheme.outline,
                    disabledForegroundColor: Theme.of(
                      context,
                    ).colorScheme.onSurfaceVariant,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    textStyle: AppTypography.onboardingAction,
                  ),
                  child: isLoading
                      ? SizedBox.square(
                          dimension: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            color: Theme.of(context).colorScheme.surface,
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(l10n.profileEditSave),
                            const SizedBox(width: AppSpacing.sm),
                            Assets.icons.icArrowRight.svg(
                              width: 18,
                              height: 18,
                              colorFilter: ColorFilter.mode(
                                (isSaveEnabled && !isLoading)
                                    ? Theme.of(context).colorScheme.surface
                                    : Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                BlendMode.srcIn,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: isLoading ? null : onCancel,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    foregroundColor: Theme.of(context).colorScheme.onSurface,
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    textStyle: AppTypography.onboardingAction,
                  ),
                  child: Text(l10n.profileEditCancel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
