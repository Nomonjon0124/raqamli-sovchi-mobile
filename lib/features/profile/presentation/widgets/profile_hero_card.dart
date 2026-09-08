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
    required this.copyLabel,
    required this.onCopy,
    super.key,
  });

  final UserProfile profile;
  final String identifierText;
  final String copyLabel;
  final VoidCallback onCopy;

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
        child: ColoredBox(
          color: AppColors.surfaceLight,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 78),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: AppSpacing.input,
              children: [
                _ProfileAvatar(
                  initials: profile.initials,
                  completionPercent: profile.completionPercent,
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: AppSpacing.xs,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                            const _VerifiedBadge(),
                          ],
                        ],
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              identifierText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.profileCardBody,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Semantics(
                            button: true,
                            label: copyLabel,
                            child: InkResponse(
                              onTap: onCopy,
                              radius: 22,
                              child: SizedBox.square(
                                dimension: 44,
                                child: Center(
                                  child: Assets.icons.icCopy.svg(
                                    width: 13,
                                    height: 13,
                                    colorFilter: const ColorFilter.mode(
                                      AppColors.mutedText,
                                      BlendMode.srcIn,
                                    ),
                                    excludeFromSemantics: true,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final class _VerifiedBadge extends StatelessWidget {
  const _VerifiedBadge();

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(
      color: AppColors.primary,
      shape: BoxShape.circle,
    ),
    child: SizedBox.square(
      dimension: 18,
      child: Center(
        child: Assets.icons.icVerifyCheck.svg(
          width: 11,
          height: 11,
          colorFilter: const ColorFilter.mode(
            AppColors.surfaceLight,
            BlendMode.srcIn,
          ),
          excludeFromSemantics: true,
        ),
      ),
    ),
  );
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
    width: 72,
    height: 78,
    child: Stack(
      clipBehavior: Clip.none,
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
          child: Text(
            initials,
            maxLines: 1,
            overflow: TextOverflow.clip,
            style: AppTypography.profileAvatar,
          ),
        ),
        Positioned(
          left: 15,
          top: 56,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.controlInset,
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
