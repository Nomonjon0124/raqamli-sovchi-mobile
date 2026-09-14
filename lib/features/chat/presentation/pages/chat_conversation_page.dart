import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/service_locator.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
// import '../../../../core/security/screenshot_guard.dart';
import '../../../../core/ui/widgets/app_error_view.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../discovery/presentation/pages/candidate_report_page.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_thread.dart';
import '../bloc/chat_conversation_bloc.dart';
import '../bloc/chat_conversation_event.dart';
import '../bloc/chat_conversation_state.dart';
import '../widgets/chat_actions_bottom_sheet.dart';
import '../widgets/chat_composer.dart';
import '../widgets/chat_delete_dialog.dart';
import '../widgets/chat_empty_thread.dart';
import '../widgets/chat_header.dart';
import '../widgets/chat_message_bubble.dart';
import '../widgets/chat_typing_indicator.dart';

final class ChatConversationPage extends StatelessWidget {
  const ChatConversationPage({
    required this.chatRoomId,
    this.thread,
    super.key,
  });

  final String chatRoomId;
  final ChatThread? thread;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => serviceLocator<ChatConversationBloc>()
      ..add(
        ChatConversationOpened(
          chatRoomId,
          currentUserId: context.read<AuthBloc>().state.session?.userId,
        ),
      ),
    child: _ChatConversationView(chatRoomId: chatRoomId, thread: thread),
  );
}

final class _ChatConversationView extends StatefulWidget {
  const _ChatConversationView({required this.chatRoomId, this.thread});
  final String chatRoomId;
  final ChatThread? thread;

  @override
  State<_ChatConversationView> createState() => _ChatConversationViewState();
}

final class _ChatConversationViewState extends State<_ChatConversationView> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final Map<String, GlobalKey> _messageKeys = {};
  DateTime? _lastTypingSentAt;
  ChatConversationState? _lastState;

  @override
  void initState() {
    super.initState();
    // unawaited(serviceLocator<ScreenshotGuard>().enableProtection());
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currentUserId = context.read<AuthBloc>().state.session?.userId ?? '';
    final thread = widget.thread;
    final name = thread?.participantName?.trim().isNotEmpty == true
        ? thread!.participantName!
        : thread?.room.participantName?.trim().isNotEmpty == true
        ? thread!.room.participantName!
        : l10n.chatParticipantFallback;
    final icebreakers = [
      l10n.chatIcebreakerGoal,
      l10n.chatIcebreakerFamily,
      l10n.chatIcebreakerBook,
      l10n.chatIcebreakerChange,
    ];

    return BlocConsumer<ChatConversationBloc, ChatConversationState>(
      listenWhen: (previous, current) =>
          previous.isSending != current.isSending ||
          previous.messages.length != current.messages.length ||
          previous.failure != current.failure ||
          previous.isDeleted != current.isDeleted,
      listener: (context, state) {
        final previous = _lastState;
        if (previous?.failure != state.failure && state.failure != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.failureMessage(state.failure!.type.name)),
            ),
          );
        }
        if (previous?.isDeleted != true && state.isDeleted) {
          context.pop(true);
          return;
        }
        if (previous?.isSending == true &&
            !state.isSending &&
            state.failure == null) {
          _controller.clear();
        }
        if (previous?.messages.length != state.messages.length) {
          WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
        }
        _lastState = state;
      },
      builder: (context, state) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
        body: SafeArea(
          child: Column(
            children: [
              ChatHeader(
                name: name,
                subtitle: state.isOtherTyping
                    ? l10n.chatTyping
                    : l10n.chatOpenTimeRemaining,
                subtitleWidget: state.isOtherTyping
                    ? ChatTypingIndicator(label: l10n.chatTyping)
                    : null,
                isOnline: state.presence?.isOnline ?? false,
                avatarUrl: thread?.participantAvatarUrl,
                backLabel: l10n.settingsBack,
                moreLabel: l10n.chatMoreActions,
                onBack: () => context.pop(),
                onMore: () => _showMoreActions(name),
              ),
              Expanded(
                child: _threadBody(context, state, currentUserId, icebreakers),
              ),
              ChatComposer(
                controller: _controller,
                placeholder: l10n.chatWriteMessage,
                sendLabel: l10n.chatSendMessage,
                replyCancelLabel: l10n.chatReplyCancel,
                replyingTo: state.replyingTo,
                isSending: state.isSending,
                onChanged: _onChanged,
                onSend: _send,
                onCancelReply: () => context.read<ChatConversationBloc>().add(
                  const ChatReplyCleared(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _threadBody(
    BuildContext context,
    ChatConversationState state,
    String currentUserId,
    List<String> icebreakers,
  ) {
    final l10n = AppLocalizations.of(context);
    return switch (state.status) {
      ChatConversationStatus.initial || ChatConversationStatus.loading =>
        const Center(child: CircularProgressIndicator.adaptive()),
      ChatConversationStatus.failure => Center(
        child: AppErrorView(
          message: l10n.failureMessage(state.failure!.type.name),
          onRetry: () => context.read<ChatConversationBloc>().add(
            ChatConversationOpened(
              widget.chatRoomId,
              currentUserId: context.read<AuthBloc>().state.session?.userId,
            ),
          ),
        ),
      ),
      ChatConversationStatus.empty => Padding(
        padding: const EdgeInsets.all(AppSpacing.card),
        child: ChatEmptyThread(
          safetyNotice: l10n.chatSafetyNotice,
          icebreakers: icebreakers,
          onIcebreakerPressed: (value) => context
              .read<ChatConversationBloc>()
              .add(ChatMessageSubmitted(value)),
        ),
      ),
      ChatConversationStatus.success => ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.card),
        itemCount: state.messages.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Align(
              child: ChatSystemNotice(message: l10n.chatSafetyNotice),
            );
          }
          if (index == 1) return const SizedBox(height: AppSpacing.md);
          final message = state.messages[index - 2];
          return Padding(
            key: _messageKeys.putIfAbsent(message.id, GlobalKey.new),
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: ChatMessageBubble(
              message: message,
              isMine: _isMyMessage(message, currentUserId),
              replyLabel: l10n.chatReplyTo,
              onReply: () => context.read<ChatConversationBloc>().add(
                ChatReplySelected(message),
              ),
              onQuotedMessagePressed: () => _scrollToMessage(message.replyTo),
            ),
          );
        },
      ),
    };
  }

  void _onChanged(String value) {
    if (value.trim().isEmpty) return;
    final now = DateTime.now();
    if (_lastTypingSentAt != null &&
        now.difference(_lastTypingSentAt!) < const Duration(seconds: 2)) {
      return;
    }
    _lastTypingSentAt = now;
    context.read<ChatConversationBloc>().add(const ChatTypingStarted());
  }

  void _send() => context.read<ChatConversationBloc>().add(
    ChatMessageSubmitted(_controller.text),
  );

  void _scrollToEnd() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  void _scrollToMessage(ChatMessageQuote? quote) {
    final target = quote == null
        ? null
        : _messageKeys[quote.id]?.currentContext;
    if (target != null) Scrollable.ensureVisible(target);
  }

  bool _isMyMessage(ChatMessage message, String currentUserId) {
    final senderId = message.senderId.trim();
    final userId = currentUserId.trim();
    return senderId.isNotEmpty && userId.isNotEmpty && senderId == userId;
  }

  Future<void> _showMoreActions(String name) async {
    final action = await showModalBottomSheet<_ChatAction>(
      context: context,
      backgroundColor: AppColors.transparent,
      isScrollControlled: true,
      builder: (_) => ChatActionsBottomSheet(
        onReport: () => Navigator.of(context).pop(_ChatAction.report),
        onDelete: () => Navigator.of(context).pop(_ChatAction.delete),
      ),
    );
    if (!mounted) return;

    switch (action) {
      case _ChatAction.report:
        await Navigator.of(context).push<void>(
          MaterialPageRoute(
            builder: (_) => CandidateReportPage(
              candidateName: name,
              targetUserId:
                  widget.thread?.room.participantUserId ??
                  widget.thread?.participantProfileId,
            ),
          ),
        );
      case _ChatAction.delete:
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (_) => ChatDeleteDialog(participantName: name),
        );
        if (confirmed == true && mounted) {
          context.read<ChatConversationBloc>().add(
            const ChatConversationDeletionRequested(),
          );
        }
      case null:
        return;
    }
  }
}

enum _ChatAction { report, delete }
