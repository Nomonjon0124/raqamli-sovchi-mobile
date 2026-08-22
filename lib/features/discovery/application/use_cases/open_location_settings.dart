import '../../domain/entities/location_access_status.dart';
import '../../domain/repositories/location_repository.dart';

final class OpenLocationSettingsUseCase {
  const OpenLocationSettingsUseCase(this._repository);

  final LocationRepository _repository;

  Future<bool> call(LocationAccessStatus status) =>
      _repository.openSettings(status);
}
