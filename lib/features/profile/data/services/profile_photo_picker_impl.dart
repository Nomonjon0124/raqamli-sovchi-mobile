import 'package:image_picker/image_picker.dart';

import '../../../../core/security/background_lock_gate.dart';
import '../../application/services/profile_photo_picker.dart';

final class DeviceProfilePhotoPicker implements ProfilePhotoPicker {
  DeviceProfilePhotoPicker({
    ImagePicker? imagePicker,
    BackgroundLockGate? backgroundLockGate,
  }) : _imagePicker = imagePicker ?? ImagePicker(),
       _backgroundLockGate = backgroundLockGate;

  final ImagePicker _imagePicker;
  final BackgroundLockGate? _backgroundLockGate;

  @override
  Future<String?> pick(ProfilePhotoSource source) async {
    try {
      final picked = await _withExternalInteraction(
        () => _imagePicker.pickImage(
          source: source == ProfilePhotoSource.camera
              ? ImageSource.camera
              : ImageSource.gallery,
          maxWidth: 2048,
          maxHeight: 2048,
          imageQuality: 85,
        ),
      );
      return picked?.path;
    } on Exception {
      throw ProfilePhotoPickerException(source.name);
    }
  }

  Future<T> _withExternalInteraction<T>(Future<T> Function() action) async {
    _backgroundLockGate?.beginExternalInteraction();
    try {
      return await action();
    } finally {
      _backgroundLockGate?.endExternalInteraction();
    }
  }
}
