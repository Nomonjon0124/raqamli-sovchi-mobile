import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/discovery_state.dart';

final class NearbyRadiusSettingsResult {
  const NearbyRadiusSettingsResult({
    required this.radiusKm,
    required this.isProfileVisible,
    required this.audience,
  });

  final double radiusKm;
  final bool isProfileVisible;
  final NearbyVisibilityAudience audience;
}

final class NearbyRadiusSettingsSheet extends StatefulWidget {
  const NearbyRadiusSettingsSheet({
    required this.initialRadiusKm,
    required this.initialProfileVisibility,
    required this.initialAudience,
    super.key,
  });

  final double initialRadiusKm;
  final bool initialProfileVisibility;
  final NearbyVisibilityAudience initialAudience;

  @override
  State<NearbyRadiusSettingsSheet> createState() =>
      _NearbyRadiusSettingsSheetState();
}

final class _NearbyRadiusSettingsSheetState
    extends State<NearbyRadiusSettingsSheet> {
  static const _radiusOptions = [2.0, 5.0, 10.0, 25.0];

  late double _radiusKm;
  late bool _isProfileVisible;
  late NearbyVisibilityAudience _audience;

  @override
  void initState() {
    super.initState();
    _radiusKm = widget.initialRadiusKm;
    _isProfileVisible = widget.initialProfileVisibility;
    _audience = widget.initialAudience;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Material(
      color: AppColors.surfaceLight,
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppRadius.sheet),
      ),
      clipBehavior: Clip.antiAlias,
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.card,
            AppSpacing.inline,
            AppSpacing.card,
            AppSpacing.card,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Center(child: _SheetGrabber()),
              const SizedBox(height: AppSpacing.lg),
              Text(
                l10n.nearbySettingsTitle,
                style: AppTypography.photoRequestTitle,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                l10n.nearbySearchRadiusLabel,
                style: AppTypography.nearbyLabel,
              ),
              const SizedBox(height: AppSpacing.inline),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final radius in _radiusOptions)
                    _RadiusChip(
                      label: l10n.nearbyRadiusOption(radius.round()),
                      selected: _radiusKm == radius,
                      onPressed: () => setState(() => _radiusKm = radius),
                    ),
                  Tooltip(
                    message: l10n.nearbyEntireRegionUnavailable,
                    child: _RadiusChip(
                      label: l10n.nearbyEntireRegion,
                      selected: false,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n.nearbyRadiusHint,
                style: AppTypography.onboardingSelectorLabel,
              ),
              const SizedBox(height: AppSpacing.lg),
              _VisibilityCard(
                title: l10n.nearbyVisibilityTitle,
                subtitle: l10n.nearbyVisibilitySubtitle,
                value: _isProfileVisible,
                onChanged: (value) => setState(() => _isProfileVisible = value),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(l10n.nearbyAudienceTitle, style: AppTypography.nearbyLabel),
              const SizedBox(height: AppSpacing.inline),
              _AudienceOption(
                label: l10n.nearbyAudienceAll,
                selected: _audience == NearbyVisibilityAudience.all,
                onPressed: () => _selectAudience(NearbyVisibilityAudience.all),
              ),
              const SizedBox(height: AppSpacing.sm),
              _AudienceOption(
                label: l10n.nearbyAudienceHighMatch,
                subtitle: l10n.nearbyAudienceRecommended,
                selected:
                    _audience == NearbyVisibilityAudience.highCompatibility,
                onPressed: () =>
                    _selectAudience(NearbyVisibilityAudience.highCompatibility),
              ),
              const SizedBox(height: AppSpacing.sm),
              _AudienceOption(
                label: l10n.nearbyAudienceRepresented,
                selected: _audience == NearbyVisibilityAudience.representedOnly,
                onPressed: () =>
                    _selectAudience(NearbyVisibilityAudience.representedOnly),
              ),
              const SizedBox(height: AppSpacing.lg),
              _PrivacyNote(message: l10n.nearbyPrivacyZoneNote),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: _save,
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    textStyle: AppTypography.onboardingAction,
                  ),
                  child: Text(l10n.nearbySettingsSave),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectAudience(NearbyVisibilityAudience audience) {
    setState(() => _audience = audience);
  }

  void _save() {
    Navigator.of(context).pop(
      NearbyRadiusSettingsResult(
        radiusKm: _radiusKm,
        isProfileVisible: _isProfileVisible,
        audience: _audience,
      ),
    );
  }
}

final class _SheetGrabber extends StatelessWidget {
  const _SheetGrabber();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
    );
  }
}

final class _RadiusChip extends StatelessWidget {
  const _RadiusChip({
    required this.label,
    required this.selected,
    this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onPressed == null ? 0.5 : 1,
      child: Material(
        color: selected ? AppColors.primary : AppColors.subtleSurface,
        borderRadius: BorderRadius.circular(AppRadius.full),
        child: InkWell(
          onTap: selected ? null : onPressed,
          borderRadius: BorderRadius.circular(AppRadius.full),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.input,
              vertical: AppSpacing.dense,
            ),
            child: Text(
              label,
              style: AppTypography.caption.copyWith(
                color: selected ? AppColors.surfaceLight : AppColors.bodyText,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final class _VisibilityCard extends StatelessWidget {
  const _VisibilityCard({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                Text(title, style: AppTypography.nearbyLabel),
                const SizedBox(height: AppSpacing.xxs),
                Text(subtitle, style: AppTypography.onboardingSelectorLabel),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          _NearbySwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

final class NearbySwitch extends StatelessWidget {
  const NearbySwitch({required this.value, required this.onChanged, super.key});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return _NearbySwitch(value: value, onChanged: onChanged);
  }
}

final class _NearbySwitch extends StatelessWidget {
  const _NearbySwitch({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      toggled: value,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onChanged(!value),
        child: SizedBox(
          width: 42,
          height: 24,
          child: value
              ? Assets.icons.icNearbySwitchOn.svg()
              : DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.all(3),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          shape: BoxShape.circle,
                        ),
                        child: SizedBox.square(dimension: 18),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

final class _AudienceOption extends StatelessWidget {
  const _AudienceOption({
    required this.label,
    required this.selected,
    required this.onPressed,
    this.subtitle,
  });

  final String label;
  final String? subtitle;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.successSurface : AppColors.subtleSurface,
      borderRadius: BorderRadius.circular(AppRadius.md),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: selected ? null : onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.input,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              (selected
                      ? Assets.icons.icNearbyRadioOn
                      : Assets.icons.icNearbyRadioOff)
                  .svg(width: 18, height: 18),
              const SizedBox(width: AppSpacing.inline),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: AppTypography.nearbyLabel),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: AppTypography.onboardingFieldLabel.copyWith(
                          color: AppColors.successText,
                          letterSpacing: 0,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _PrivacyNote extends StatelessWidget {
  const _PrivacyNote({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.input,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.subtleSurface,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Assets.icons.icNearbyPrivacyLock.svg(width: 13, height: 16),
          const SizedBox(width: AppSpacing.inline),
          Expanded(
            child: Text(
              message,
              style: AppTypography.onboardingSelectorLabel.copyWith(
                color: AppColors.mapLabelText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
