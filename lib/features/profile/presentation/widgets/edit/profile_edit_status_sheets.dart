import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_radius.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_typography.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../l10n/app_localizations.dart';

Future<bool> showProfileUnsavedChangesSheet(BuildContext context) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => const _ProfileUnsavedChangesSheet(),
  );
  return result ?? false;
}

Future<void> showProfileUpdatedSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.transparent,
    builder: (_) => const _ProfileUpdatedSheet(),
  );
}

final class _ProfileUnsavedChangesSheet extends StatelessWidget {
  const _ProfileUnsavedChangesSheet();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return _ProfileSheetFrame(
      children: [
        Text(l10n.profileEditUnsavedTitle, style: AppTypography.analysisTitle),
        const SizedBox(height: AppSpacing.sm),
        Text(
          l10n.profileEditUnsavedMessage,
          style: AppTypography.onboardingBody.copyWith(fontSize: 14),
        ),
        const SizedBox(height: AppSpacing.card),
        _ProfileSheetActionButton(
          label: l10n.profileEditStayEditing,
          onPressed: () => Navigator.of(context).pop(false),
        ),
        const SizedBox(height: AppSpacing.sm),
        _ProfileSheetActionButton(
          label: l10n.profileEditExit,
          onPressed: () => Navigator.of(context).pop(true),
          isPrimary: false,
        ),
      ],
    );
  }
}

final class _ProfileUpdatedSheet extends StatelessWidget {
  const _ProfileUpdatedSheet();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return _ProfileSheetFrame(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppColors.successSurface,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Assets.icons.icVerifyCheck.svg(
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                AppColors.successText,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(l10n.profileEditUpdatedTitle, style: AppTypography.analysisTitle),
        const SizedBox(height: AppSpacing.sm),
        Text(
          l10n.profileEditUpdatedMessage,
          style: AppTypography.onboardingBody.copyWith(fontSize: 14),
        ),
        const SizedBox(height: AppSpacing.card),
        _ProfileSheetActionButton(
          label: l10n.profileEditUpdatedOk,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

final class _ProfileSheetFrame extends StatelessWidget {
  const _ProfileSheetFrame({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.section,
          AppSpacing.xl,
          AppSpacing.section,
          28,
        ),
        decoration: const BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }
}

final class _ProfileSheetActionButton extends StatelessWidget {
  const _ProfileSheetActionButton({
    required this.label,
    required this.onPressed,
    this.isPrimary = true,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    if (isPrimary) {
      return SizedBox(
        height: 52,
        child: FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.surfaceLight,
            textStyle: AppTypography.onboardingAction,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
          ),
          child: Text(label),
        ),
      );
    }

    return SizedBox(
      height: 52,
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
        ),
        child: Text(label),
      ),
    );
  }
}
