import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
    required this.onMore,
    this.avatarUrl,
    this.subtitleWidget,
    super.key,
  });

  final String name;
  final String subtitle;
  final bool isOnline;
  final String backLabel;
  final String moreLabel;
  final VoidCallback onBack;
  final VoidCallback onMore;
  final String? avatarUrl;
  final Widget? subtitleWidget;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: colorScheme.surface,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.card,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: colorScheme.surfaceContainer),
          ),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: onBack,
              tooltip: backLabel,
              icon: Assets.icons.icArrowLeft01Round.svg(
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  colorScheme.onSurface,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Stack(
              clipBehavior: Clip.none,
              children: [
                _ChatAvatar(name: name, avatarUrl: avatarUrl),
                if (isOnline)
                  Positioned(
                    right: -1,
                    bottom: -1,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(AppSpacing.xxs),
                        child: SizedBox(
                          width: AppSpacing.sm,
                          height: AppSpacing.sm,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
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
                  subtitleWidget ??
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
              onPressed: onMore,
              tooltip: moreLabel,
              icon: Assets.icons.icMoreHorizontal.svg(
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  colorScheme.onSurface,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _ChatAvatar extends StatelessWidget {
  const _ChatAvatar({required this.name, this.avatarUrl});

  final String name;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final fallback = Text(
      _initials(name),
      style: AppTypography.chatHeaderName.copyWith(color: colorScheme.primary),
    );
    final url = avatarUrl?.trim();
    return CircleAvatar(
      radius: 18,
      backgroundColor: colorScheme.primary.withValues(alpha: .12),
      foregroundImage: url == null || url.isEmpty
          ? null
          : CachedNetworkImageProvider(url),
      child: fallback,
    );
  }
}

String _initials(String name) => name
    .split(RegExp(r'\s+'))
    .where((part) => part.isNotEmpty)
    .take(2)
    .map((part) => part[0].toUpperCase())
    .join();
