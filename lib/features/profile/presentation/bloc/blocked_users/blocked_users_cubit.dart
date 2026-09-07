import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/use_cases/get_blocked_users.dart';
import '../../../application/use_cases/unblock_user.dart';
import 'blocked_users_state.dart';

final class BlockedUsersCubit extends Cubit<BlockedUsersState> {
  BlockedUsersCubit({
    required GetBlockedUsersUseCase getBlockedUsers,
    required UnblockUserUseCase unblockUser,
  }) : _getBlockedUsers = getBlockedUsers,
       _unblockUser = unblockUser,
       super(const BlockedUsersState());

  final GetBlockedUsersUseCase _getBlockedUsers;
  final UnblockUserUseCase _unblockUser;

  Future<void> loadBlockedUsers() async {
    emit(
      state.copyWith(
        status: BlockedUsersStatus.loading,
        clearFailure: true,
        clearSuccessMessage: true,
      ),
    );

    final result = await _getBlockedUsers();
    result.fold(
      (failure) => emit(
        state.copyWith(status: BlockedUsersStatus.failure, failure: failure),
      ),
      (users) => emit(
        state.copyWith(status: BlockedUsersStatus.success, blockedUsers: users),
      ),
    );
  }

  Future<void> unblock({
    required String userId,
    String? blockedRecordId,
  }) async {
    if (state.isUnblocking(userId)) return;

    final updatedSet = Set<String>.from(state.unblockingUserIds)..add(userId);
    emit(
      state.copyWith(
        unblockingUserIds: updatedSet,
        clearFailure: true,
        clearSuccessMessage: true,
      ),
    );

    final result = await _unblockUser(
      userId: userId,
      blockedRecordId: blockedRecordId,
    );

    final finalSet = Set<String>.from(state.unblockingUserIds)..remove(userId);

    result.fold(
      (failure) =>
          emit(state.copyWith(unblockingUserIds: finalSet, failure: failure)),
      (_) {
        final updatedList = state.blockedUsers
            .where(
              (u) =>
                  u.id != blockedRecordId &&
                  u.blocked != userId &&
                  u.blockedInfo?.id != userId,
            )
            .toList();
        emit(
          state.copyWith(
            blockedUsers: updatedList,
            unblockingUserIds: finalSet,
            actionSuccessMessage: 'unblockSuccess',
          ),
        );
      },
    );
  }
}
