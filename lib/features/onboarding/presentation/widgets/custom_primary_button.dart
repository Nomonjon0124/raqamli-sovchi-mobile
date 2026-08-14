import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../gen/assets.gen.dart';

final class CustomPrimaryButton extends StatelessWidget {
  const CustomPrimaryButton({super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.border,
          foregroundColor: Colors.white,
          disabledForegroundColor: AppColors.mutedText,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg + AppSpacing.xs, vertical: AppSpacing.lg),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.full)),
          textStyle: AppTypography.onboardingAction,
        ),
        child: Builder(
          builder: (context) {
            final foregroundColor = IconTheme.of(context).color ?? DefaultTextStyle.of(context).style.color ?? Colors.white;

            return Row(
              spacing: 8,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label),
                Assets.icons.icArrowRight.svg(colorFilter: ColorFilter.mode(foregroundColor, BlendMode.srcIn), excludeFromSemantics: true),
              ],
            );
          },
        ),
      ),
    );
  }
}