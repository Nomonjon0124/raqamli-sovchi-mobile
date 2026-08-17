import 'package:raqamli_sovchi/core/errors/either.dart';
import 'package:raqamli_sovchi/core/errors/failure.dart';
import 'package:raqamli_sovchi/features/discovery/domain/entities/candidate.dart';

abstract interface class DiscoveryRepository {
  Future<Either<Failure, List<Candidate>>> getCandidates({int page = 1, int pageSize = 10, String? filter});
}
