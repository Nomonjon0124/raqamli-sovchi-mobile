import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../domain/entities/questionnaire.dart';

final class QuestionnaireOptionCard extends StatelessWidget {
  const QuestionnaireOptionCard({
    required this.option,
    required this.selected,
    required this.onPressed,
    super.key,
  });

  final QuestionnaireOption option;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? AppColors.text : AppColors.bodyText;
    return Material(
      color: selected ? AppColors.subtleSurface : AppColors.surfaceLight,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: selected ? AppColors.primary : AppColors.border,
          width: selected ? 1.5 : 1,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.input,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: AppSpacing.xl,
                height: AppSpacing.xl,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : AppColors.mutedSurface,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  option.letter,
                  style: AppTypography.caption.copyWith(
                    color: selected
                        ? AppColors.surfaceLight
                        : AppColors.mutedText,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  option.text,
                  style: AppTypography.onboardingPledgeBody.copyWith(
                    color: foreground,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
