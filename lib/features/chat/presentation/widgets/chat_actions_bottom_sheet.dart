import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../l10n/app_localizations.dart';

final class ChatActionsBottomSheet extends StatelessWidget {
  const ChatActionsBottomSheet({
    required this.onReport,
    required this.onDelete,
    super.key,
  });

  final VoidCallback onReport;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      top: false,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xxl),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.section,
            AppSpacing.md,
            AppSpacing.section,
            AppSpacing.xl,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.input),
              Text(
                l10n.chatMoreSheetTitle,
                style: AppTypography.chatActionTitle,
              ),
              const SizedBox(height: AppSpacing.input),
              Text(
                l10n.chatMoreSheetSubtitle,
                style: AppTypography.chatActionCaption,
              ),
              const SizedBox(height: AppSpacing.input),
              _ChatActionButton(
                icon: Assets.icons.icSecurity.svg(width: 20, height: 20),
                label: l10n.chatReportAction,
                onTap: onReport,
              ),
              const SizedBox(height: AppSpacing.inline),
              _ChatActionButton(
                icon: const Icon(
                  Icons.delete_outline,
                  size: 20,
                  color: AppColors.dangerText,
                ),
                label: l10n.chatDeleteAction,
                onTap: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _ChatActionButton extends StatelessWidget {
  const _ChatActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final Widget icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.subtleSurface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      side: const BorderSide(color: AppColors.mutedSurface),
    ),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: SizedBox(
        height: AppSpacing.chatActionHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: AppSpacing.sm),
              Text(label, style: AppTypography.chatActionLabel),
            ],
          ),
        ),
      ),
    ),
  );
}
