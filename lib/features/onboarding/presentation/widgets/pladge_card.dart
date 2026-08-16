import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';

final class PledgeCard extends StatelessWidget {
  const PledgeCard({super.key, required this.points});

  final List<String> points;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.card),
      decoration: BoxDecoration(
        color: AppColors.subtleSurface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        children: [
          for (var index = 0; index < points.length; index++) ...[
            if (index > 0) const SizedBox(height: AppSpacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: SizedBox.square(
                    dimension: AppSpacing.lg,
                    child: Center(
                      child: Container(
                        width: AppSpacing.sm,
                        height: AppSpacing.sm,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.inline),
                Expanded(
                  child: Text(
                    points[index],
                    style: AppTypography.onboardingPledgeBody,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
