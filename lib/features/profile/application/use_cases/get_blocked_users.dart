import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/blocked_user.dart';
import '../../domain/repositories/blocked_user_repository.dart';

final class GetBlockedUsersUseCase {
  const GetBlockedUsersUseCase(this._repository);

  final BlockedUserRepository _repository;

  Future<Either<Failure, List<BlockedUser>>> call({int page = 1}) {
    return _repository.getBlockedUsers(page: page);
  }
}
