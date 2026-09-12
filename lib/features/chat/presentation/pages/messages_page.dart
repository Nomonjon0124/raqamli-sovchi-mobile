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
import '../widgets/chat_request_card.dart';
import '../widgets/message_thread_row.dart';

final class MessagesPage extends StatelessWidget {
  const MessagesPage({this.bloc, this.initialTab = 0, super.key});

  final ChatListBloc? bloc;
  final int initialTab;

  @override
  Widget build(BuildContext context) => BlocProvider<ChatListBloc>(
    create: (_) =>
        (bloc ?? serviceLocator<ChatListBloc>())
          ..add(const ChatListLoadRequested()),
    child: _MessagesView(initialTab: initialTab),
  );
}

final class _MessagesView extends StatefulWidget {
  const _MessagesView({required this.initialTab});

  final int initialTab;

  @override
  State<_MessagesView> createState() => _MessagesViewState();
}

final class _MessagesViewState extends State<_MessagesView> {
  late var _selectedIndex = widget.initialTab.clamp(0, 1);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<ChatListBloc, ChatListState>(
      builder: (context, state) => SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
                      selectedIndex: _selectedIndex,
                      onSelected: (index) =>
                          setState(() => _selectedIndex = index),
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
                  child: AppEmptyState(
                    message: _selectedIndex == 0
                        ? l10n.chatRoomsEmpty
                        : l10n.chatRequestsEmpty,
                  ),
                ),
                ChatListStatus.success =>
                  _selectedIndex == 0
                      ? _chatsSliver(context, state, l10n)
                      : _requestsSliver(context, state),
              },
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    final bloc = context.read<ChatListBloc>();
    final refreshed = bloc.stream.firstWhere(
      (state) =>
          state.status != ChatListStatus.initial &&
          state.status != ChatListStatus.loading,
    );
    bloc.add(const ChatListLoadRequested());
    await refreshed.timeout(
      const Duration(seconds: 10),
      onTimeout: () => bloc.state,
    );
  }

  Widget _chatsSliver(
    BuildContext context,
    ChatListState state,
    AppLocalizations l10n,
  ) {
    if (state.threads.isEmpty) {
      return SliverFillRemaining(
        child: AppEmptyState(message: l10n.chatRoomsEmpty),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.card),
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
                thread.room.participantName ??
                l10n.chatParticipantFallback,
            preview: l10n.chatThreadOpen,
            isOnline: presence?.isOnline ?? false,
            avatarUrl: thread.participantAvatarUrl,
            onTap: () async {
              final deleted = await context.push<bool>(
                RouteNames.chatRoomFor(thread.room.id),
                extra: thread,
              );
              if (context.mounted && deleted == true) {
                context.read<ChatListBloc>().add(const ChatListLoadRequested());
              }
            },
          );
        },
      ),
    );
  }

  Widget _requestsSliver(BuildContext context, ChatListState state) {
    if (state.requests.isEmpty) {
      return SliverFillRemaining(
        child: AppEmptyState(
          message: AppLocalizations.of(context).chatRequestsEmpty,
        ),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.card),
      sliver: SliverList.separated(
        itemCount: state.requests.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (context, index) {
          final request = state.requests[index];
          return ChatRequestCard(
            request: request,
            onTap: () async {
              final changed = await context.push<bool>(
                RouteNames.chatRequestProfileFor(request.id),
                extra: request,
              );
              if (context.mounted && changed == true) {
                context.read<ChatListBloc>().add(const ChatListLoadRequested());
              }
            },
          );
        },
      ),
    );
  }
}
