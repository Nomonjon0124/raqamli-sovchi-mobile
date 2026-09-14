enum ProfilePhotoSource { camera, gallery }

abstract interface class ProfilePhotoPicker {
  Future<String?> pick(ProfilePhotoSource source);
}

final class ProfilePhotoPickerException implements Exception {
  const ProfilePhotoPickerException(this.reason);

  final String reason;
}
