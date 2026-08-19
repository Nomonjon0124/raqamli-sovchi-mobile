import 'package:dio/dio.dart';

import '../../../../core/errors/either.dart';
import '../../../../core/errors/exception_mapper.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/candidate.dart';
import '../../domain/entities/discovery_filter.dart';
import '../../domain/repositories/discovery_repository.dart';
import '../data_sources/discovery_data_source.dart';

final class DiscoveryRepositoryImpl implements DiscoveryRepository {
  const DiscoveryRepositoryImpl(this._dataSource);

  final DiscoveryDataSource _dataSource;

  @override
  Future<Either<Failure, List<Candidate>>> getCandidates({
    int page = 1,
    int pageSize = 10,
    DiscoveryFilter filter = DiscoveryFilter.matches,
  }) async {
    try {
      final model = await _dataSource.fetchCandidates(
        page: page,
        pageSize: pageSize,
        filter: filter,
      );
      final entities = model.toEntities();
      return Right(entities);
    } on DioException catch (e) {
      return Left(mapDioException(e));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Candidate>> getCandidate(String id) async {
    try {
      final model = await _dataSource.fetchCandidate(id);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(mapDioException(e));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Candidate>>> getSavedCandidates() async {
    try {
      final model = await _dataSource.fetchSavedCandidates();
      return Right(model.toEntities());
    } on DioException catch (e) {
      return Left(mapDioException(e));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> saveCandidate(String id) async {
    try {
      await _dataSource.saveCandidate(id);
      return const Right(true);
    } on DioException catch (e) {
      return Left(mapDioException(e));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> unsaveCandidate(String id) async {
    try {
      await _dataSource.unsaveCandidate(id);
      return const Right(true);
    } on DioException catch (e) {
      return Left(mapDioException(e));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }
}
