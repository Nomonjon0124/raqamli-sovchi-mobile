import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_typography.dart';

final class PrimaryAction extends StatelessWidget {
  const PrimaryAction({super.key, required this.label, required this.onPressed});

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
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg + AppSpacing.xs,
            vertical: AppSpacing.lg,
          ),
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(AppRadius.full),
          // ),
          minimumSize: const Size.fromHeight(52),
          shape: const StadiumBorder(),
          textStyle: AppTypography.onboardingAction,
        ),
        child: Text(label),
      ),
    );
  }
}