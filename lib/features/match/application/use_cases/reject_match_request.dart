import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/match_request.dart';
import '../../domain/repositories/match_request_repository.dart';

final class RejectMatchRequestUseCase {
  const RejectMatchRequestUseCase(this._repository);

  final MatchRequestRepository _repository;

  Future<Either<Failure, MatchRequest>> call(String id) =>
      _repository.rejectRequest(id);
}
