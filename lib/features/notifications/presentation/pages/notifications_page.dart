import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/di/service_locator.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/notifications/notification_event.dart';
import '../../../../core/ui/widgets/app_empty_state.dart';
import '../../../../core/ui/widgets/app_error_view.dart';
import '../../../../core/ui/widgets/app_round_icon_button.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/app_notification.dart';
import '../bloc/notification_bloc.dart';
import '../bloc/notification_event.dart';
import '../bloc/notification_state.dart';
import '../widgets/notification_item.dart';

final class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) =>
        serviceLocator<NotificationsBloc>()
          ..add(const NotificationsLoadRequested()),
    child: const _NotificationsView(),
  );
}

final class _NotificationsView extends StatelessWidget {
  const _NotificationsView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.section,
            AppSpacing.input,
            AppSpacing.section,
            AppSpacing.sm,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  AppRoundIconButton(
                    icon: Assets.icons.icArrowLeft01Round,
                    semanticLabel: l10n.settingsBack,
                    onPressed: context.pop,
                  ),
                  Expanded(
                    child: Text(
                      l10n.notificationsActionLabel,
                      textAlign: TextAlign.center,
                      style: AppTypography.settingsPageTitle.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(width: 36),
                ],
              ),
              const SizedBox(height: AppSpacing.card),
              Expanded(
                child: BlocBuilder<NotificationsBloc, NotificationsState>(
                  builder: (context, state) => switch (state.status) {
                    NotificationsStatus.initial ||
                    NotificationsStatus.loading => const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                    NotificationsStatus.failure => Center(
                      child: AppErrorView(
                        message: state.failure?.message ?? l10n.genericError,
                        onRetry: () => context.read<NotificationsBloc>().add(
                          const NotificationsLoadRequested(),
                        ),
                      ),
                    ),
                    NotificationsStatus.empty => AppEmptyState(
                      message: l10n.notificationsEmpty,
                    ),
                    NotificationsStatus.success => _NotificationsContent(
                      notifications: state.notifications,
                      l10n: l10n,
                    ),
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _NotificationsContent extends StatelessWidget {
  const _NotificationsContent({
    required this.notifications,
    required this.l10n,
  });

  final List<AppNotification> notifications;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final groups = _groupNotifications(notifications);
    return RefreshIndicator(
      onRefresh: () async => context.read<NotificationsBloc>().add(
        const NotificationsLoadRequested(),
      ),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        children: [
          for (final group in groups) ...[
            NotificationSection(
              title: _groupTitle(group.kind, l10n),
              items: group.items,
              timeLabel: (item) => _notificationTime(context, item, l10n),
              onItemTap: (item) => _openNotification(context, item),
            ),
            const SizedBox(height: AppSpacing.section),
          ],
          _NotificationSettingsLink(
            label: l10n.notificationsSettings,
            onTap: () => context.push(RouteNames.notificationTypes),
          ),
        ],
      ),
    );
  }

  void _openNotification(BuildContext context, AppNotification item) {
    if (!item.isRead) {
      context.read<NotificationsBloc>().add(
        NotificationsReadRequested(item.id),
      );
    }

    final requestId = notificationMatchRequestId(item.extraData);
    if (requestId != null) {
      context.push(RouteNames.chatRequestProfileFor(requestId));
      return;
    }
    if (isMatchRequestNotificationData(item.extraData)) {
      context.go('${RouteNames.messages}?tab=requests');
    }
  }
}

final class _NotificationSettingsLink extends StatelessWidget {
  const _NotificationSettingsLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.input),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.profileCardTitle.copyWith(
                    color: colorScheme.onSurface,
                    fontSize: 13,
                    height: 18 / 13,
                  ),
                ),
              ),
              Assets.icons.icArrowRight.svg(
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  colorScheme.onSurfaceVariant,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _NotificationGroupKind { today, yesterday, earlier }

final class _NotificationGroup {
  const _NotificationGroup(this.kind, this.items);

  final _NotificationGroupKind kind;
  final List<AppNotification> items;
}

List<_NotificationGroup> _groupNotifications(
  List<AppNotification> notifications,
) {
  final now = DateTime.now();
  final buckets = <_NotificationGroupKind, List<AppNotification>>{
    _NotificationGroupKind.today: [],
    _NotificationGroupKind.yesterday: [],
    _NotificationGroupKind.earlier: [],
  };

  for (final item in notifications) {
    final date = item.createdAt?.toLocal();
    final kind = date == null
        ? _NotificationGroupKind.earlier
        : _groupKind(now, date);
    buckets[kind]!.add(item);
  }

  return [
    for (final kind in _NotificationGroupKind.values)
      if (buckets[kind]!.isNotEmpty) _NotificationGroup(kind, buckets[kind]!),
  ];
}

_NotificationGroupKind _groupKind(DateTime now, DateTime date) {
  final today = DateTime(now.year, now.month, now.day);
  final dateOnly = DateTime(date.year, date.month, date.day);
  final difference = today.difference(dateOnly).inDays;
  if (difference <= 0) return _NotificationGroupKind.today;
  if (difference == 1) return _NotificationGroupKind.yesterday;
  return _NotificationGroupKind.earlier;
}

String _groupTitle(_NotificationGroupKind kind, AppLocalizations l10n) =>
    switch (kind) {
      _NotificationGroupKind.today => l10n.notificationsToday,
      _NotificationGroupKind.yesterday => l10n.notificationsYesterday,
      _NotificationGroupKind.earlier => l10n.notificationsEarlier,
    };

String _notificationTime(
  BuildContext context,
  AppNotification item,
  AppLocalizations l10n,
) {
  final date = item.createdAt?.toLocal();
  if (date == null) return '';

  final difference = DateTime.now().difference(date);
  if (difference.inMinutes < 1) return l10n.notificationsJustNow;
  if (difference.inHours < 1) {
    return l10n.notificationsMinutesAgo(difference.inMinutes);
  }
  if (difference.inDays < 1) {
    return l10n.notificationsHoursAgo(difference.inHours);
  }
  if (difference.inDays == 1) return l10n.notificationsYesterdayTime;
  return DateFormat(
    'd MMM',
    Intl.canonicalizedLocale(Localizations.localeOf(context).toString()),
  ).format(date);
}
