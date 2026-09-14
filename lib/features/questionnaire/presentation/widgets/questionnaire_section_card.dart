import 'package:flutter/material.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';

final class QuestionnaireSectionCard extends StatelessWidget {
  const QuestionnaireSectionCard({
    required this.number,
    required this.title,
    required this.countLabel,
    super.key,
  });

  final int number;
  final String title;
  final String countLabel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.input,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border.all(color: colorScheme.outline),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          Text(
            '$number',
            style: AppTypography.caption.copyWith(color: colorScheme.primary),
          ),
          const SizedBox(width: AppSpacing.input),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.sectionCardTitle),
                const SizedBox(height: AppSpacing.xs / 2),
                Text(countLabel, style: AppTypography.onboardingSelectorLabel),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
