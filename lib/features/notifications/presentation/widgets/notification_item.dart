import 'package:flutter/material.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../gen/assets.gen.dart';
import '../../domain/entities/app_notification.dart';

final class NotificationSection extends StatelessWidget {
  const NotificationSection({
    required this.title,
    required this.items,
    required this.timeLabel,
    required this.onItemTap,
    super.key,
  });

  final String title;
  final List<AppNotification> items;
  final String Function(AppNotification item) timeLabel;
  final ValueChanged<AppNotification> onItemTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final dividerColor = colorScheme.surfaceContainer;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AppSpacing.xs),
          child: Text(
            title,
            style: AppTypography.profileSectionLabel.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        DecoratedBox(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: Column(
              children: [
                for (var index = 0; index < items.length; index++) ...[
                  _NotificationItem(
                    item: items[index],
                    time: timeLabel(items[index]),
                    onTap: () => onItemTap(items[index]),
                  ),
                  if (index != items.length - 1)
                    Divider(
                      height: AppSpacing.hairline,
                      thickness: AppSpacing.hairline,
                      indent: 60,
                      color: dividerColor,
                    ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

final class _NotificationItem extends StatelessWidget {
  const _NotificationItem({
    required this.item,
    required this.time,
    required this.onTap,
  });

  final AppNotification item;
  final String time;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _NotificationIcon(type: item.type, extraData: item.extraData),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.profileCardTitle.copyWith(
                        color: colorScheme.onSurface,
                        fontSize: 13,
                        height: 18 / 13,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      item.message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.profileCardBody.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xxs),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      time,
                      style: AppTypography.profileCardBody.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (!item.isRead) ...[
                      const SizedBox(width: AppSpacing.compact),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const SizedBox(width: 8, height: 8),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _NotificationIcon extends StatelessWidget {
  const _NotificationIcon({required this.type, required this.extraData});

  final String type;
  final Map<String, dynamic> extraData;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final icon = _iconForNotification(type, extraData);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        shape: BoxShape.circle,
      ),
      child: SizedBox(
        width: 36,
        height: 36,
        child: Center(
          child: icon.svg(
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(
              colorScheme.onSurface,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}

SvgGenImage _iconForNotification(String type, Map<String, dynamic> extraData) {
  final eventType = extraData['type']?.toString().toLowerCase();
  if (type == 'new_message' || eventType == 'new_chat_message') {
    return Assets.icons.icMessage;
  }
  if (type == 'profile_viewed' || eventType == 'profile_viewed') {
    return Assets.icons.icPhoto;
  }
  if (eventType?.contains('photo') == true) {
    return Assets.icons.icPhoto;
  }
  if (eventType?.contains('meeting') == true ||
      eventType?.contains('appointment') == true) {
    return Assets.icons.icMeeting;
  }
  if (eventType?.contains('consent') == true ||
      eventType?.contains('approved') == true ||
      eventType?.contains('verified') == true) {
    return Assets.icons.icVerifiead;
  }
  if (eventType?.contains('warn') == true ||
      eventType?.contains('reject') == true ||
      type == 'system') {
    return Assets.icons.icInfo2;
  }
  if (type == 'new_match') {
    return Assets.icons.icHeart;
  }
  return Assets.icons.icStar;
}
