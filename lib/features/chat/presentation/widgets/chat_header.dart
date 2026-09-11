import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../gen/assets.gen.dart';

final class ChatHeader extends StatelessWidget {
  const ChatHeader({
    required this.name,
    required this.subtitle,
    required this.isOnline,
    required this.backLabel,
    required this.moreLabel,
    required this.onBack,
    super.key,
  });

  final String name;
  final String subtitle;
  final bool isOnline;
  final String backLabel;
  final String moreLabel;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.surfaceLight,
    child: Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.card,
        vertical: AppSpacing.md,
      ),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.mutedSurface)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            tooltip: backLabel,
            icon: Assets.icons.icArrowLeft01Round.svg(
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                AppColors.text,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primaryTranslucent,
                child: Text(
                  _initials(name),
                  style: AppTypography.chatHeaderName.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
              if (isOnline)
                const Positioned(
                  right: -1,
                  bottom: -1,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.xxs),
                      child: SizedBox(
                        width: AppSpacing.sm,
                        height: AppSpacing.sm,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: AppColors.successText,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.chatHeaderName,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.chatHeaderSubtitle,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: null,
            tooltip: moreLabel,
            icon: Assets.icons.icMoreHorizontal.svg(
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                AppColors.text,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

String _initials(String name) => name
    .split(RegExp(r'\s+'))
    .where((part) => part.isNotEmpty)
    .take(2)
    .map((part) => part[0].toUpperCase())
    .join();
