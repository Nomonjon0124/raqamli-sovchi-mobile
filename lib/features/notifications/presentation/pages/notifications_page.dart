import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/service_locator.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/ui/widgets/app_empty_state.dart';
import '../../../../core/ui/widgets/app_error_view.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/notification_bloc.dart';
import '../bloc/notification_event.dart';
import '../bloc/notification_state.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notificationsActionLabel),
        actions: [
          IconButton(
            onPressed: () => context.read<NotificationsBloc>().add(
              const NotificationsReadAllRequested(),
            ),
            icon: const Icon(Icons.done_all_outlined),
            tooltip: l10n.notificationsMarkAllRead,
          ),
        ],
      ),
      body: BlocBuilder<NotificationsBloc, NotificationsState>(
        builder: (context, state) => switch (state.status) {
          NotificationsStatus.initial || NotificationsStatus.loading =>
            const Center(child: CircularProgressIndicator.adaptive()),
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
          NotificationsStatus.success => RefreshIndicator(
            onRefresh: () async => context.read<NotificationsBloc>().add(
              const NotificationsLoadRequested(),
            ),
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: state.notifications.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final item = state.notifications[index];
                return Card(
                  child: ListTile(
                    onTap: item.isRead
                        ? null
                        : () => context.read<NotificationsBloc>().add(
                            NotificationsReadRequested(item.id),
                          ),
                    leading: Icon(
                      item.isRead
                          ? Icons.notifications_none
                          : Icons.notifications,
                      color: item.isRead
                          ? null
                          : Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(item.title),
                    subtitle: Text(
                      item.message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: item.isRead
                        ? null
                        : const Icon(Icons.circle, size: AppSpacing.sm),
                  ),
                );
              },
            ),
          ),
        },
      ),
    );
  }
}
