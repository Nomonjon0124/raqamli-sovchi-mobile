import '../../domain/entities/location_access_status.dart';
import '../../domain/repositories/location_repository.dart';

final class CheckLocationAccessUseCase {
  const CheckLocationAccessUseCase(this._repository);

  final LocationRepository _repository;

  Future<LocationAccessStatus> call() => _repository.checkAccess();
}
