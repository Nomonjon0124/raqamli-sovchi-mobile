import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../gen/assets.gen.dart';

final class ProfileAboutCard extends StatelessWidget {
  const ProfileAboutCard({
    required this.sectionTitle,
    required this.bio,
    required this.emptyText,
    required this.addText,
    required this.onTap,
    super.key,
  });

  final String sectionTitle;
  final String? bio;
  final String emptyText;
  final String addText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasBio = bio?.trim().isNotEmpty ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(sectionTitle, style: AppTypography.profileSectionLabel),
        const SizedBox(height: AppSpacing.sm),
        Material(
          color: AppColors.subtleSurface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.input),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      hasBio ? bio!.trim() : emptyText,
                      maxLines: hasBio ? 4 : 1,
                      overflow: TextOverflow.ellipsis,
                      style: hasBio
                          ? AppTypography.profileCardBody.copyWith(
                              color: AppColors.bodyText,
                            )
                          : AppTypography.profileCardBody,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.mutedSurface,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.inline,
                        vertical: AppSpacing.compact,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          (hasBio
                                  ? Assets.icons.icEdit
                                  : Assets.icons.profileAdd)
                              .svg(
                                width: 14,
                                height: 14,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.text,
                                  BlendMode.srcIn,
                                ),
                                excludeFromSemantics: true,
                              ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            addText,
                            style: AppTypography.profileIdentifier.copyWith(
                              color: AppColors.text,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
