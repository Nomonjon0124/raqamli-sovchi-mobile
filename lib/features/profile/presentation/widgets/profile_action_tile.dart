import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../gen/assets.gen.dart';

final class ProfileActionTile extends StatelessWidget {
  const ProfileActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconColor = AppColors.text,
    super.key,
  });

  final SvgGenImage icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color iconColor;

  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.subtleSurface,
    borderRadius: BorderRadius.circular(AppRadius.lg),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.input),
        child: Row(
          children: [
            icon.svg(
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
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
