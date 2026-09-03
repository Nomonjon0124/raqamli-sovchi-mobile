import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../../../profile/domain/repositories/profile_repository.dart';
import '../../domain/entities/geo_coordinates.dart';

final class UpdateProfileLocationUseCase {
  const UpdateProfileLocationUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Either<Failure, bool>> call(GeoCoordinates coordinates) =>
      _repository.updateLocation(
        latitude: coordinates.latitude,
        longitude: coordinates.longitude,
      );
}
