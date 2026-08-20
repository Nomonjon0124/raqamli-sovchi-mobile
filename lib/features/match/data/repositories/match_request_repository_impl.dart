import 'package:dio/dio.dart';

import '../../../../core/errors/either.dart';
import '../../../../core/errors/exception_mapper.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/match_request.dart';
import '../../domain/repositories/match_request_repository.dart';
import '../data_sources/match_request_data_source.dart';

final class MatchRequestRepositoryImpl implements MatchRequestRepository {
  const MatchRequestRepositoryImpl(this._dataSource);

  final MatchRequestDataSource _dataSource;

  @override
  Future<Either<Failure, List<MatchRequest>>> getRequests({
    String? fromProfile,
    String? toProfile,
    MatchRequestStatus? status,
  }) async {
    try {
      final model = await _dataSource.fetchRequests(
        fromProfile: fromProfile,
        toProfile: toProfile,
        status: status,
      );
      return Right(model.toEntities());
    } on DioException catch (error) {
      return Left(mapDioException(error));
    } catch (_) {
      return const Left(Failure.unknown());
    }
  }

  @override
  Future<Either<Failure, MatchRequest>> getRequest(String id) async {
    try {
      return Right((await _dataSource.fetchRequest(id)).toEntity());
    } on DioException catch (error) {
      return Left(mapDioException(error));
    } catch (_) {
      return const Left(Failure.unknown());
    }
  }

  @override
  Future<Either<Failure, MatchRequest>> createRequest({
    required String fromProfile,
    required String toProfile,
    String? note,
    MatchRequestVisibilityScope visibilityScope =
        MatchRequestVisibilityScope.forwardToRepresentative,
  }) async {
    try {
      return Right(
        (await _dataSource.createRequest(
          fromProfile: fromProfile,
          toProfile: toProfile,
          note: note,
          visibilityScope: visibilityScope,
        )).toEntity(),
      );
    } on DioException catch (error) {
      return Left(mapDioException(error));
    } catch (_) {
      return const Left(Failure.unknown());
    }
  }
}
