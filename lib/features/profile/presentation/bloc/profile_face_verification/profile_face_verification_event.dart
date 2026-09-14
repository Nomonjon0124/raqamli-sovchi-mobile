import 'package:equatable/equatable.dart';

sealed class ProfileFaceVerificationEvent extends Equatable {
  const ProfileFaceVerificationEvent();

  @override
  List<Object?> get props => [];
}

final class ProfileFaceVerificationCaptured
    extends ProfileFaceVerificationEvent {
  const ProfileFaceVerificationCaptured(this.sourcePath);

  final String sourcePath;

  @override
  List<Object?> get props => [sourcePath];
}
