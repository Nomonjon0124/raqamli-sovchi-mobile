import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/location_access_status.dart';

final class NearbyLocationPermissionState extends StatelessWidget {
  const NearbyLocationPermissionState({
    required this.accessStatus,
    required this.isLoading,
    required this.onPrimaryPressed,
    required this.onDismissed,
    super.key,
  });

  final LocationAccessStatus accessStatus;
  final bool isLoading;
  final VoidCallback onPrimaryPressed;
  final VoidCallback onDismissed;

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
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.subtleSurface,
              border: Border.all(color: AppColors.mutedSurface),
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.screen,
                AppSpacing.lg,
                AppSpacing.section,
              ),
              child: Column(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryTranslucent,
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/ic_location.svg',
                      colorFilter: const ColorFilter.mode(
                        AppColors.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    l10n.nearbyPermissionTitle,
                    textAlign: TextAlign.center,
                    style: AppTypography.onboardingSheetTitle,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l10n.nearbyPermissionDescription,
                    textAlign: TextAlign.center,
                    style: AppTypography.onboardingBody,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _PrivacyRules(l10n: l10n),
                  const SizedBox(height: AppSpacing.md),
                  _PermissionButton(
                    label: _primaryLabel(l10n),
                    isLoading: isLoading,
                    primary: true,
                    onPressed: onPrimaryPressed,
                  ),
                  const SizedBox(height: AppSpacing.inline),
                  _PermissionButton(
                    label: l10n.nearbyPermissionNotNow,
                    isLoading: false,
                    primary: false,
                    onPressed: isLoading ? null : onDismissed,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.nearbyPermissionFootnote,
            textAlign: TextAlign.center,
            style: AppTypography.onboardingSelectorLabel.copyWith(
              color: AppColors.placeholder,
            ),
          ),
        ],
      ),
    );
  }

  String _primaryLabel(AppLocalizations l10n) {
    return switch (accessStatus) {
      LocationAccessStatus.permanentlyDenied =>
        l10n.nearbyPermissionOpenSettings,
      LocationAccessStatus.serviceDisabled =>
        l10n.nearbyPermissionEnableService,
      _ => l10n.nearbyPermissionAllow,
    };
  }
}

final class _PrivacyRules extends StatelessWidget {
  const _PrivacyRules({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.input),
        child: Column(
          children: [
            _PrivacyRule(
              assetPath: 'assets/icons/ic_square_lock.svg',
              label: l10n.nearbyPermissionRuleHidden,
              backgroundColor: AppColors.successSurface,
            ),
            const SizedBox(height: AppSpacing.inline),
            _PrivacyRule(
              assetPath: 'assets/icons/ic_radar.svg',
              label: l10n.nearbyPermissionRuleZone,
              backgroundColor: AppColors.successSurface,
            ),
            const SizedBox(height: AppSpacing.inline),
            _PrivacyRule(
              assetPath: 'assets/icons/ic_setting.svg',
              label: l10n.nearbyPermissionRuleSettings,
              backgroundColor: AppColors.subtleSurface,
            ),
          ],
        ),
      ),
    );
  }
}

final class _PrivacyRule extends StatelessWidget {
  const _PrivacyRule({
    required this.assetPath,
    required this.label,
    required this.backgroundColor,
  });

  final String assetPath;
  final String label;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 27,
          height: 27,
          padding: const EdgeInsets.all(AppSpacing.compact),
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(assetPath),
        ),
        const SizedBox(width: AppSpacing.inline),
        Expanded(child: Text(label, style: AppTypography.onboardingPledgeBody)),
      ],
    );
  }
}

final class _PermissionButton extends StatelessWidget {
  const _PermissionButton({
    required this.label,
    required this.isLoading,
    required this.primary,
    required this.onPressed,
  });

  final String label;
  final bool isLoading;
  final bool primary;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: primary ? AppColors.primary : AppColors.mutedSurface,
          foregroundColor: primary
              ? AppColors.surfaceLight
              : AppColors.bodyText,
          disabledBackgroundColor: primary
              ? AppColors.primary.withValues(alpha: 0.7)
              : AppColors.mutedSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
        child: isLoading
            ? const SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.surfaceLight,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (primary) ...[
                    SvgPicture.asset(
                      'assets/icons/ic_location.svg',
                      width: 16,
                      height: 16,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.onboardingAction,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
