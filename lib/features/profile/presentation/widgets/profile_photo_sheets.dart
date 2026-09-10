import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../l10n/app_localizations.dart';

Future<ProfilePhotoPickerSource?> showProfilePhotoSourceSheet(
  BuildContext context,
) => showModalBottomSheet<ProfilePhotoPickerSource>(
  context: context,
  backgroundColor: Colors.transparent,
  builder: (_) => const _ProfilePhotoSourceSheet(),
);

Future<ProfilePhotoAction?> showProfilePhotoActionsSheet(
  BuildContext context,
) => showModalBottomSheet<ProfilePhotoAction>(
  context: context,
  backgroundColor: Colors.transparent,
  builder: (_) => const _ProfilePhotoActionsSheet(),
);

Future<bool?> showProfilePhotoDeleteDialog(BuildContext context) =>
    showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const _ProfilePhotoDeleteDialog(),
    );

enum ProfilePhotoPickerSource { camera, gallery }

enum ProfilePhotoAction { setMain, replace, delete }

final class _ProfilePhotoSourceSheet extends StatelessWidget {
  const _ProfilePhotoSourceSheet();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _ProfilePhotoSheetFrame(
      roundedTopOnly: true,
      children: [
        Text(l10n.profilePhotoSourceTitle, style: AppTypography.analysisTitle),
        const SizedBox(height: AppSpacing.xs),
        Text(
          l10n.profilePhotoSourceSubtitle,
          style: AppTypography.onboardingBody.copyWith(fontSize: 14),
        ),
        const SizedBox(height: AppSpacing.inline),
        const _ProfilePhotoDivider(),
        _ProfilePhotoActionRow(
          icon: Assets.icons.profileCamera,
          label: l10n.profilePhotoCamera,
          color: AppColors.text,
          onTap: () =>
              Navigator.of(context).pop(ProfilePhotoPickerSource.camera),
        ),
        _ProfilePhotoActionRow(
          icon: Assets.icons.settingsImage,
          label: l10n.profilePhotoGallery,
          color: AppColors.text,
          onTap: () =>
              Navigator.of(context).pop(ProfilePhotoPickerSource.gallery),
        ),
        const SizedBox(height: AppSpacing.inline),
        _ProfilePhotoCancelButton(
          label: l10n.profilePhotoCancel,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

final class _ProfilePhotoActionsSheet extends StatelessWidget {
  const _ProfilePhotoActionsSheet();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _ProfilePhotoSheetFrame(
      roundedTopOnly: true,
      children: [
        Text(l10n.profilePhotoActionsTitle, style: AppTypography.analysisTitle),
        const SizedBox(height: AppSpacing.inline),
        _ProfilePhotoActionRow.material(
          materialIcon: Icons.push_pin_outlined,
          label: l10n.profilePhotoSetMain,
          onTap: () => Navigator.of(context).pop(ProfilePhotoAction.setMain),
        ),
        const _ProfilePhotoDivider(),
        _ProfilePhotoActionRow.material(
          materialIcon: Icons.refresh_rounded,
          label: l10n.profilePhotoReplace,
          onTap: () => Navigator.of(context).pop(ProfilePhotoAction.replace),
        ),
        const _ProfilePhotoDivider(),
        _ProfilePhotoActionRow.material(
          materialIcon: Icons.delete_outline_rounded,
          label: l10n.profilePhotoDelete,
          color: AppColors.dangerText,
          onTap: () => Navigator.of(context).pop(ProfilePhotoAction.delete),
        ),
        const SizedBox(height: AppSpacing.inline),
        _ProfilePhotoCancelButton(
          label: l10n.profilePhotoCancel,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

final class _ProfilePhotoDeleteDialog extends StatelessWidget {
  const _ProfilePhotoDeleteDialog();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Dialog(
      backgroundColor: AppColors.surfaceLight,
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.section),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xxl),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.section,
          AppSpacing.xl,
          AppSpacing.section,
          28,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.profilePhotoDeleteTitle,
              style: AppTypography.analysisTitle,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l10n.profilePhotoDeleteSubtitle,
              style: AppTypography.onboardingBody.copyWith(fontSize: 14),
            ),
            const SizedBox(height: AppSpacing.inline),
            Row(
              children: [
                Expanded(
                  child: _ProfilePhotoCancelButton(
                    label: l10n.profilePhotoCancel,
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: FilledButton.icon(
                      onPressed: () => Navigator.of(context).pop(true),
                      icon: const Icon(Icons.delete_outline_rounded, size: 24),
                      label: Text(l10n.profilePhotoDelete),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.danger,
                        foregroundColor: AppColors.surfaceLight,
                        textStyle: AppTypography.onboardingAction,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.lg,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

final class _ProfilePhotoSheetFrame extends StatelessWidget {
  const _ProfilePhotoSheetFrame({
    required this.children,
    required this.roundedTopOnly,
  });

  final List<Widget> children;
  final bool roundedTopOnly;

  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.section,
        AppSpacing.xl,
        AppSpacing.section,
        28,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: roundedTopOnly
            ? const BorderRadius.vertical(top: Radius.circular(AppRadius.xxl))
            : BorderRadius.circular(AppRadius.xxl),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    ),
  );
}

final class _ProfilePhotoActionRow extends StatelessWidget {
  const _ProfilePhotoActionRow({
    required this.label,
    required this.onTap,
    required this.icon,
    required this.color,
  }) : materialIcon = null;

  final String label;
  final VoidCallback onTap;
  final SvgGenImage? icon;
  final IconData? materialIcon;
  final Color color;

  const _ProfilePhotoActionRow.material({
    required this.label,
    required this.onTap,
    required IconData this.materialIcon,
    this.color = AppColors.text,
  }) : icon = null;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label,
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.settingsRowVertical,
          ),
          child: Row(
            children: [
              if (icon != null)
                icon!.svg(
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                  excludeFromSemantics: true,
                )
              else
                Icon(materialIcon, size: 24, color: color),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.onboardingAction.copyWith(color: color),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

final class _ProfilePhotoDivider extends StatelessWidget {
  const _ProfilePhotoDivider();

  @override
  Widget build(BuildContext context) =>
      const Divider(height: 1, thickness: 1, color: AppColors.subtleSurface);
}

final class _ProfilePhotoCancelButton extends StatelessWidget {
  const _ProfilePhotoCancelButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 56,
    child: OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.text,
        side: const BorderSide(color: AppColors.border),
        textStyle: AppTypography.onboardingAction,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
      ),
      child: Text(label),
    ),
  );
}
