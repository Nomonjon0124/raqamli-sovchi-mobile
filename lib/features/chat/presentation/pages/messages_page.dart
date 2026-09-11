import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/service_locator.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/ui/widgets/app_empty_state.dart';
import '../../../../core/ui/widgets/app_error_view.dart';
import '../../../../core/ui/widgets/app_screen_header.dart';
import '../../../../core/ui/widgets/app_segmented_control.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/chat_list_bloc.dart';
import '../bloc/chat_list_event.dart';
import '../bloc/chat_list_state.dart';
import '../widgets/message_thread_row.dart';

final class MessagesPage extends StatelessWidget {
  const MessagesPage({this.bloc, super.key});

  final ChatListBloc? bloc;

  @override
  Widget build(BuildContext context) => BlocProvider<ChatListBloc>(
    create: (_) =>
        (bloc ?? serviceLocator<ChatListBloc>())
          ..add(const ChatListLoadRequested()),
    child: const _MessagesView(),
  );
}

final class _MessagesView extends StatelessWidget {
  const _MessagesView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<ChatListBloc, ChatListState>(
      builder: (context, state) => SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.card,
                AppSpacing.input,
                AppSpacing.card,
                AppSpacing.lg,
              ),
              sliver: SliverList.list(
                children: [
                  AppScreenHeader(title: l10n.messagesTabLabel),
                  const SizedBox(height: AppSpacing.lg),
                  AppSegmentedControl(
                    labels: [
                      l10n.messagesSegmentChats,
                      l10n.messagesSegmentRequests,
                    ],
                    selectedIndex: 0,
                  ),
                ],
              ),
            ),
            switch (state.status) {
              ChatListStatus.initial ||
              ChatListStatus.loading => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator.adaptive()),
              ),
              ChatListStatus.failure => SliverFillRemaining(
                child: Center(
                  child: AppErrorView(
                    message: l10n.failureMessage(state.failure!.type.name),
                    onRetry: () => context.read<ChatListBloc>().add(
                      const ChatListLoadRequested(),
                    ),
                  ),
                ),
              ),
              ChatListStatus.empty => SliverFillRemaining(
                child: AppEmptyState(message: l10n.chatRoomsEmpty),
              ),
              ChatListStatus.success => SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.card,
                ),
                sliver: SliverList.builder(
                  itemCount: state.threads.length,
                  itemBuilder: (context, index) {
                    final thread = state.threads[index];
                    final presence = thread.room.participantUserId == null
                        ? null
                        : state.presences[thread.room.participantUserId];
                    return MessageThreadRow(
                      thread: thread,
                      name:
                          thread.participantName ??
                          l10n.chatParticipantFallback,
                      preview: l10n.chatThreadOpen,
                      isOnline: presence?.isOnline ?? false,
                      onTap: () => context.push(
                        RouteNames.chatRoomFor(thread.room.id),
                        extra: thread,
                      ),
                    );
                  },
                ),
              ),
            },
          ],
        ),
      ),
    );
  }
}
