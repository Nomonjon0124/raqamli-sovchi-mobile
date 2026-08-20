import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/match_request.dart';
import '../../domain/repositories/match_request_repository.dart';

final class CreateMatchRequestUseCase {
  const CreateMatchRequestUseCase(this._repository);

  final MatchRequestRepository _repository;

  Future<Either<Failure, MatchRequest>> call({
    required String fromProfile,
    required String toProfile,
    String? note,
  }) {
    return _repository.createRequest(
      fromProfile: fromProfile,
      toProfile: toProfile,
      note: note,
    );
  }
}
