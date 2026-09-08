import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failure.dart';
import '../../../domain/entities/blocked_user.dart';

enum BlockedUsersStatus { initial, loading, success, failure }

final class BlockedUsersState extends Equatable {
  const BlockedUsersState({
    this.status = BlockedUsersStatus.initial,
    this.blockedUsers = const <BlockedUser>[],
    this.unblockingUserIds = const <String>{},
    this.failure,
    this.actionSuccessMessage,
  });

  final BlockedUsersStatus status;
  final List<BlockedUser> blockedUsers;
  final Set<String> unblockingUserIds;
  final Failure? failure;
  final String? actionSuccessMessage;

  bool isUnblocking(String userId) => unblockingUserIds.contains(userId);

  BlockedUsersState copyWith({
    BlockedUsersStatus? status,
    List<BlockedUser>? blockedUsers,
    Set<String>? unblockingUserIds,
    Failure? failure,
    bool clearFailure = false,
    String? actionSuccessMessage,
    bool clearSuccessMessage = false,
  }) => BlockedUsersState(
    status: status ?? this.status,
    blockedUsers: blockedUsers ?? this.blockedUsers,
    unblockingUserIds: unblockingUserIds ?? this.unblockingUserIds,
    failure: clearFailure ? null : (failure ?? this.failure),
    actionSuccessMessage: clearSuccessMessage
        ? null
        : (actionSuccessMessage ?? this.actionSuccessMessage),
  );

  @override
  List<Object?> get props => [
    status,
    blockedUsers,
    unblockingUserIds,
    failure,
    actionSuccessMessage,
  ];
}
