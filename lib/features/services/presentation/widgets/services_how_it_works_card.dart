import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';

final class ServicesHowItWorksCard extends StatelessWidget {
  const ServicesHowItWorksCard({required this.steps, super.key});

  final List<ServicesHowStep> steps;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.subtleSurface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.input),
        child: Column(
          children: [
            for (var index = 0; index < steps.length; index++)
              _StepRow(number: index + 1, step: steps[index]),
          ],
        ),
      ),
    );
  }
}

final class ServicesHowStep {
  const ServicesHowStep({required this.title, required this.subtitle});

  final String title;
  final String subtitle;
}

final class _StepRow extends StatelessWidget {
  const _StepRow({required this.number, required this.step});

  final int number;
  final ServicesHowStep step;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.dense),
      child: Row(
        children: [
          DecoratedBox(
            decoration: const BoxDecoration(
              color: AppColors.mutedSurface,
              shape: BoxShape.circle,
            ),
            child: SizedBox.square(
              dimension: 26,
              child: Center(
                child: Text('$number', style: AppTypography.servicesPill),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.servicesStepTitle,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  step.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.servicesCaption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
