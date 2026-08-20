import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../entities/match_request.dart';

abstract interface class MatchRequestRepository {
  Future<Either<Failure, List<MatchRequest>>> getRequests({
    String? fromProfile,
    String? toProfile,
    MatchRequestStatus? status,
  });

  Future<Either<Failure, MatchRequest>> getRequest(String id);

  Future<Either<Failure, MatchRequest>> createRequest({
    required String fromProfile,
    required String toProfile,
    String? note,
    MatchRequestVisibilityScope visibilityScope =
        MatchRequestVisibilityScope.forwardToRepresentative,
  });
}
