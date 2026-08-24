import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../l10n/app_localizations.dart';
import 'nearby_radius_settings_sheet.dart';

final class NearbyCandidatesEmptyState extends StatelessWidget {
  const NearbyCandidatesEmptyState({
    required this.radiusKm,
    required this.notificationsEnabled,
    required this.onExpandRadius,
    required this.onChangeCriteria,
    required this.onNotificationsChanged,
    super.key,
  });

  final double radiusKm;
  final bool notificationsEnabled;
  final VoidCallback onExpandRadius;
  final VoidCallback onChangeCriteria;
  final ValueChanged<bool> onNotificationsChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.card,
        0,
        AppSpacing.card,
        AppSpacing.xl,
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.screen,
              AppSpacing.lg,
              AppSpacing.screen,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            child: Column(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: const BoxDecoration(
                    color: AppColors.mutedSurface,
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/ic_nearby_empty_radar.svg',
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  l10n.nearbyEmptyTitle(radiusKm.round()),
                  textAlign: TextAlign.center,
                  style: AppTypography.onboardingSheetTitle,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.nearbyEmptyDescription,
                  textAlign: TextAlign.center,
                  style: AppTypography.onboardingBody,
                ),
                const SizedBox(height: AppSpacing.lg),
                if (radiusKm < 25) ...[
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton.icon(
                      onPressed: onExpandRadius,
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        textStyle: AppTypography.onboardingAction,
                      ),
                      icon: SvgPicture.asset(
                        'assets/icons/ic_radar.svg',
                        width: 16,
                        height: 16,
                        colorFilter: const ColorFilter.mode(
                          AppColors.surfaceLight,
                          BlendMode.srcIn,
                        ),
                      ),
                      label: Text(l10n.nearbyExpandRadius(25)),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton.icon(
                    onPressed: onChangeCriteria,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.mutedSurface,
                      foregroundColor: AppColors.text,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      textStyle: AppTypography.onboardingAction,
                    ),
                    icon: SvgPicture.asset(
                      'assets/icons/ic_nearby_filter_lines.svg',
                      width: 18,
                      height: 16,
                    ),
                    label: Text(l10n.nearbyChangeCriteria),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.input,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: AppColors.subtleSurface,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.nearbyNotifyTitle,
                        style: AppTypography.nearbyLabel,
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        l10n.nearbyNotifySubtitle,
                        style: AppTypography.onboardingSelectorLabel,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                NearbySwitch(
                  value: notificationsEnabled,
                  onChanged: onNotificationsChanged,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
