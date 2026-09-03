import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../gen/assets.gen.dart';

final class QuestionnairePrimaryButton extends StatelessWidget {
  const QuestionnairePrimaryButton({
    required this.label,
    required this.onPressed,
    this.showArrow = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.surfaceLight,
          disabledBackgroundColor: AppColors.mutedSurface,
          disabledForegroundColor: AppColors.placeholder,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.section,
            vertical: AppSpacing.lg,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          textStyle: AppTypography.onboardingAction,
        ),
        child: Builder(
          builder: (context) {
            if (!showArrow) return Text(label);

            final foregroundColor =
                IconTheme.of(context).color ??
                DefaultTextStyle.of(context).style.color ??
                AppColors.surfaceLight;

            return Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Assets.icons.icArrowRight.svg(
                  colorFilter: ColorFilter.mode(
                    foregroundColor,
                    BlendMode.srcIn,
                  ),
                  excludeFromSemantics: true,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
