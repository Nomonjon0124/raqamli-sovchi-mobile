import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../entities/blocked_user.dart';

abstract interface class BlockedUserRepository {
  Future<Either<Failure, BlockedUser>> blockUser({
    required String blockedUserId,
    String? reason,
  });

  Future<Either<Failure, List<BlockedUser>>> getBlockedUsers({int page = 1});

  Future<Either<Failure, bool>> unblockUser({
    required String userId,
    String? blockedRecordId,
  });
}
