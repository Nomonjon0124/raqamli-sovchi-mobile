import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/service_locator.dart';
import '../../../../core/ui/widgets/app_error_view.dart';
import '../../../../core/ui/widgets/app_toast.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/chat_request_profile.dart';
import '../bloc/chat_request_profile_bloc.dart';
import '../bloc/chat_request_profile_event.dart';
import '../bloc/chat_request_profile_state.dart';
import '../widgets/chat_request_profile_view.dart';

final class ChatRequestProfilePage extends StatelessWidget {
  const ChatRequestProfilePage({
    required this.requestId,
    this.request,
    super.key,
  });

  final String requestId;
  final ChatRequestProfile? request;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => serviceLocator<ChatRequestProfileBloc>()
      ..add(ChatRequestProfileOpened(requestId: requestId, request: request)),
    child: const _ChatRequestProfileView(),
  );
}

final class _ChatRequestProfileView extends StatelessWidget {
  const _ChatRequestProfileView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocConsumer<ChatRequestProfileBloc, ChatRequestProfileState>(
      listener: (context, state) {
        if (state.actionStatus == ChatRequestActionStatus.failure &&
            state.failure != null) {
          AppToast.show(
            context,
            message: state.failure!.message ?? l10n.genericError,
          );
        }
        if (state.actionStatus == ChatRequestActionStatus.success &&
            state.actionResult != null) {
          final message = state.actionResult == ChatRequestActionResult.accepted
              ? l10n.chatRequestAccepted
              : l10n.chatRequestRejected;
          AppToast.show(context, message: message, type: ToastType.success);
          Navigator.of(context).pop(true);
        }
      },
      builder: (context, state) {
        if (state.status == ChatRequestProfileStatus.failure) {
          return Scaffold(
            body: Center(
              child: AppErrorView(
                message: state.failure?.message ?? l10n.genericError,
                onRetry: () => context.read<ChatRequestProfileBloc>().add(
                  ChatRequestProfileOpened(
                    requestId: state.request?.id ?? '',
                    request: state.request,
                  ),
                ),
              ),
            ),
          );
        }
        final request = state.request;
        if (request == null ||
            state.status == ChatRequestProfileStatus.initial ||
            state.status == ChatRequestProfileStatus.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator.adaptive()),
          );
        }
        return ChatRequestProfileView(
          request: request,
          candidate: state.candidate,
          isActionLoading:
              state.actionStatus == ChatRequestActionStatus.loading,
          onAccept: () => context.read<ChatRequestProfileBloc>().add(
            const ChatRequestAccepted(),
          ),
          onReject: () => context.read<ChatRequestProfileBloc>().add(
            const ChatRequestRejected(),
          ),
          onBack: () => Navigator.of(context).pop(),
        );
      },
    );
  }
}
