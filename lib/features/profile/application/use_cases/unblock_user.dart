import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/repositories/blocked_user_repository.dart';

final class UnblockUserUseCase {
  const UnblockUserUseCase(this._repository);

  final BlockedUserRepository _repository;

  Future<Either<Failure, bool>> call({
    required String userId,
    String? blockedRecordId,
  }) {
    return _repository.unblockUser(
      userId: userId,
      blockedRecordId: blockedRecordId,
    );
  }
}
