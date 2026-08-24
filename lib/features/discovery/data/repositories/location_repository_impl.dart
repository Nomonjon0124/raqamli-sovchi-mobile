import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/geo_coordinates.dart';
import '../../domain/entities/location_access_status.dart';
import '../../domain/repositories/location_repository.dart';
import '../data_sources/location_data_source.dart';

final class LocationRepositoryImpl implements LocationRepository {
  const LocationRepositoryImpl(this._dataSource);

  final LocationDataSource _dataSource;

  @override
  Future<LocationAccessStatus> checkAccess() => _dataSource.checkAccess();

  @override
  Future<Either<Failure, GeoCoordinates>> requestCurrentLocation() async {
    try {
      final coordinates = await _dataSource.requestCurrentLocation();
      if (!coordinates.isValid) {
        return const Left(
          Failure.validation(message: 'invalid_location_coordinates'),
        );
      }
      return Right(coordinates);
    } on DeviceLocationPermanentlyDeniedException {
      return const Left(
        Failure.forbidden(message: 'location_permanently_denied'),
      );
    } on DeviceLocationDeniedException {
      return const Left(Failure.forbidden(message: 'location_denied'));
    } on DeviceLocationServiceDisabledException {
      return const Left(
        Failure.unsupported(message: 'location_service_disabled'),
      );
    } on DeviceLocationUnavailableException {
      return const Left(Failure.unknown(message: 'location_unavailable'));
    } catch (error) {
      return Left(
        Failure.unknown(technicalReason: error.runtimeType.toString()),
      );
    }
  }

  @override
  Future<bool> openSettings(LocationAccessStatus status) async {
    try {
      return await _dataSource.openSettings(status);
    } catch (_) {
      return false;
    }
  }
}
