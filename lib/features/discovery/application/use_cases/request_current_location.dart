import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/geo_coordinates.dart';
import '../../domain/repositories/location_repository.dart';

final class RequestCurrentLocationUseCase {
  const RequestCurrentLocationUseCase(this._repository);

  final LocationRepository _repository;

  Future<Either<Failure, GeoCoordinates>> call() =>
      _repository.requestCurrentLocation();
}
