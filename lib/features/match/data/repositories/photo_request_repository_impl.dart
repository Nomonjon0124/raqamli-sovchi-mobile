import 'package:dio/dio.dart';

import '../../../../core/errors/either.dart';
import '../../../../core/errors/exception_mapper.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/photo_request.dart';
import '../../domain/repositories/photo_request_repository.dart';
import '../data_sources/photo_request_data_source.dart';

final class PhotoRequestRepositoryImpl implements PhotoRequestRepository {
  const PhotoRequestRepositoryImpl(this._dataSource);

  final PhotoRequestDataSource _dataSource;

  @override
  Future<Either<Failure, PhotoRequest>> createRequest({
    required String toProfile,
    String? note,
  }) async {
    try {
      return Right(
        (await _dataSource.createRequest(
          toProfile: toProfile,
          note: note,
        )).toEntity(),
      );
    } on DioException catch (error) {
      return Left(mapDioException(error));
    } catch (_) {
      return const Left(Failure.unknown());
    }
  }
}
