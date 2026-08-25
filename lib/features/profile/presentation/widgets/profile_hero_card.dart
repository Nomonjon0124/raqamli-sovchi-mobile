import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../gen/assets.gen.dart';
import '../../domain/entities/user_profile.dart';

final class ProfileHeroCard extends StatelessWidget {
  const ProfileHeroCard({
    required this.profile,
    required this.identifierText,
    required this.previewText,
    required this.copyLabel,
    required this.onCopy,
    required this.onPreview,
    super.key,
  });

  final UserProfile profile;
  final String identifierText;
  final String previewText;
  final String copyLabel;
  final VoidCallback onCopy;
  final VoidCallback onPreview;

  @override
  Widget build(BuildContext context) {
    final age = profile.age;
    final title = age == null
        ? profile.displayName
        : '${profile.displayName}, $age';

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.subtleSurface,
        border: Border.all(color: AppColors.mutedSurface),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _ProfileAvatar(
              initials: profile.initials,
              completionPercent: profile.completionPercent,
            ),
            const SizedBox(width: AppSpacing.input),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.profileName,
                        ),
                      ),
                      if (profile.isVerified) ...[
                        const SizedBox(width: AppSpacing.compact),
                        Assets.icons.profileVerified.svg(
                          width: 18,
                          height: 18,
                          excludeFromSemantics: true,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          identifierText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.profileIdentifier,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Semantics(
                        button: true,
                        label: copyLabel,
                        child: InkResponse(
                          onTap: onCopy,
                          radius: 18,
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.xs),
                            child: Assets.icons.icCopy.svg(
                              width: 14,
                              height: 14,
                              colorFilter: const ColorFilter.mode(
                                AppColors.mutedText,
                                BlendMode.srcIn,
                              ),
                              excludeFromSemantics: true,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Material(
                    color: AppColors.mutedSurface,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      onTap: onPreview,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.inline,
                          vertical: AppSpacing.compact,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Assets.icons.profilePreview.svg(
                              width: 15,
                              height: 15,
                              colorFilter: const ColorFilter.mode(
                                AppColors.mutedText,
                                BlendMode.srcIn,
                              ),
                              excludeFromSemantics: true,
                            ),
                            const SizedBox(width: AppSpacing.compact),
                            Flexible(
                              child: Text(
                                previewText,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.profileIdentifier.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({
    required this.initials,
    required this.completionPercent,
  });

  final String initials;
  final int completionPercent;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 76,
    height: 82,
    child: Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          width: 72,
          height: 72,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.profileAvatarSurface,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary, width: 2),
          ),
          child: Text(initials, style: AppTypography.profileAvatar),
        ),
        Positioned(
          bottom: 0,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppRadius.full),
              border: Border.all(color: AppColors.surfaceLight, width: 2),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xxs,
              ),
              child: Text(
                '$completionPercent%',
                style: AppTypography.profileProgress,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
