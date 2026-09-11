import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../gen/assets.gen.dart';

final class ChatEmptyThread extends StatelessWidget {
  const ChatEmptyThread({
    required this.safetyNotice,
    required this.icebreakers,
    required this.onIcebreakerPressed,
    super.key,
  });

  final String safetyNotice;
  final List<String> icebreakers;
  final ValueChanged<String> onIcebreakerPressed;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      _SafetyNotice(message: safetyNotice),
      const Spacer(),
      Assets.icons.icChatEmpty.svg(
        width: 140,
        height: 140,
        excludeFromSemantics: true,
      ),
      const Spacer(),
      Align(
        alignment: Alignment.centerRight,
        child: Wrap(
          alignment: WrapAlignment.end,
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: icebreakers
              .map(
                (message) => _IcebreakerChip(
                  label: message,
                  onPressed: () => onIcebreakerPressed(message),
                ),
              )
              .toList(),
        ),
      ),
    ],
  );
}

final class ChatSystemNotice extends StatelessWidget {
  const ChatSystemNotice({required this.message, super.key});
  final String message;

  @override
  Widget build(BuildContext context) => _SafetyNotice(message: message);
}

final class _SafetyNotice extends StatelessWidget {
  const _SafetyNotice({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(maxWidth: 300),
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.compact,
    ),
    decoration: BoxDecoration(
      color: AppColors.mutedSurface,
      borderRadius: BorderRadius.circular(AppRadius.sm),
    ),
    child: Text(
      message,
      textAlign: TextAlign.center,
      style: AppTypography.chatSystem,
    ),
  );
}

final class _IcebreakerChip extends StatelessWidget {
  const _IcebreakerChip({required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.surfaceLight,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      side: const BorderSide(color: AppColors.border),
    ),
    child: InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.input,
          vertical: AppSpacing.dense,
        ),
        child: Text(label, style: AppTypography.chatChip),
      ),
    ),
  );
}
