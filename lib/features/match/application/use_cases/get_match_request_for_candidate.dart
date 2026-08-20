import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/match_request.dart';
import '../../domain/repositories/match_request_repository.dart';

final class GetMatchRequestForCandidateUseCase {
  const GetMatchRequestForCandidateUseCase(this._repository);

  final MatchRequestRepository _repository;

  Future<Either<Failure, MatchRequest?>> call({
    required String fromProfile,
    required String toProfile,
  }) async {
    final listResult = await _repository.getRequests(
      fromProfile: fromProfile,
      toProfile: toProfile,
    );

    return listResult.fold(
      (failure) => failure.type == FailureType.notFound
          ? const Right(null)
          : Left(failure),
      (requests) async {
        if (requests.isEmpty) return const Right(null);
        final requestResult = await _repository.getRequest(requests.first.id);
        return requestResult.fold(
          (failure) => failure.type == FailureType.notFound
              ? const Right(null)
              : Left(failure),
          Right.new,
        );
      },
    );
  }
}
