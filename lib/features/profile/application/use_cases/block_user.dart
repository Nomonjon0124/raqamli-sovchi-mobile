import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/blocked_user.dart';
import '../../domain/repositories/blocked_user_repository.dart';

final class BlockUserUseCase {
  const BlockUserUseCase(this._repository);

  final BlockedUserRepository _repository;

  Future<Either<Failure, BlockedUser>> call({
    required String blockedUserId,
    String? reason,
  }) {
    return _repository.blockUser(blockedUserId: blockedUserId, reason: reason);
  }
}
