import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../entities/geo_coordinates.dart';
import '../entities/location_access_status.dart';

abstract interface class LocationRepository {
  Future<LocationAccessStatus> checkAccess();

  Future<Either<Failure, GeoCoordinates>> requestCurrentLocation();

  Future<bool> openSettings(LocationAccessStatus status);
}
