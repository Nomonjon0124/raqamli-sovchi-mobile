import 'package:equatable/equatable.dart';

import '../../domain/entities/chat_request_profile.dart';

sealed class ChatRequestProfileEvent extends Equatable {
  const ChatRequestProfileEvent();

  @override
  List<Object?> get props => [];
}

final class ChatRequestProfileOpened extends ChatRequestProfileEvent {
  const ChatRequestProfileOpened({required this.requestId, this.request});

  final String requestId;
  final ChatRequestProfile? request;

  @override
  List<Object?> get props => [requestId, request];
}

final class ChatRequestAccepted extends ChatRequestProfileEvent {
  const ChatRequestAccepted();
}

final class ChatRequestRejected extends ChatRequestProfileEvent {
  const ChatRequestRejected();
}
