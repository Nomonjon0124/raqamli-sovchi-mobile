import 'package:dio/dio.dart';

import '../../../../core/errors/either.dart';
import '../../../../core/errors/exception_mapper.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/geo_coordinates.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../data_sources/profile_data_source.dart';

final class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._dataSource);

  final ProfileDataSource _dataSource;

  @override
  Future<Either<Failure, UserProfile>> getMyProfile() async {
    try {
      final model = await _dataSource.fetchMyProfile();
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(mapDioException(e));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateLocation(
    GeoCoordinates coordinates,
  ) async {
    try {
      await _dataSource.updateLocation(
        latitude: coordinates.latitude,
        longitude: coordinates.longitude,
      );
      return const Right(true);
    } on DioException catch (e) {
      return Left(mapDioException(e));
    } catch (e) {
      return Left(Failure.unknown(technicalReason: e.runtimeType.toString()));
    }
  }
}
