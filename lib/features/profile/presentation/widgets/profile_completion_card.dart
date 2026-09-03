import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../gen/assets.gen.dart';

final class ProfileCompletionCard extends StatelessWidget {
  const ProfileCompletionCard({
    required this.title,
    required this.subtitle,
    required this.percent,
    required this.onTap,
    super.key,
  });

  final String title;
  final String subtitle;
  final int percent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.profileWarningSurface,
    borderRadius: BorderRadius.circular(AppRadius.lg),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.input),
        child: Row(
          children: [
            Assets.icons.icFire.svg(
              width: 24,
              height: 24,
              excludeFromSemantics: true,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.profileCardTitle),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(subtitle, style: AppTypography.profileCardBody),
                ],
              ),
            ),
            Text(
              '$percent%',
              style: AppTypography.caption.copyWith(
                color: AppColors.profileWarningText,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Assets.icons.profileChevron.svg(
              width: 16,
              height: 16,
              colorFilter: const ColorFilter.mode(
                AppColors.mutedText,
                BlendMode.srcIn,
              ),
              excludeFromSemantics: true,
            ),
          ],
        ),
      ),
    ),
  );
}
