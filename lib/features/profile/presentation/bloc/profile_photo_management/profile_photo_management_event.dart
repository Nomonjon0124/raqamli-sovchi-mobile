import 'package:equatable/equatable.dart';

import '../../../application/services/profile_photo_picker.dart';
import '../../../domain/entities/user_profile.dart';

sealed class ProfilePhotoManagementEvent extends Equatable {
  const ProfilePhotoManagementEvent();

  @override
  List<Object?> get props => [];
}

final class ProfilePhotoManagementStarted extends ProfilePhotoManagementEvent {
  const ProfilePhotoManagementStarted(this.profile);

  final UserProfile profile;

  @override
  List<Object?> get props => [profile];
}

final class ProfilePhotoManagementPickRequested
    extends ProfilePhotoManagementEvent {
  const ProfilePhotoManagementPickRequested(this.source, {this.replacePhotoId});

  final ProfilePhotoSource source;
  final String? replacePhotoId;

  @override
  List<Object?> get props => [source, replacePhotoId];
}

final class ProfilePhotoManagementSetMainRequested
    extends ProfilePhotoManagementEvent {
  const ProfilePhotoManagementSetMainRequested(this.photoId);

  final String photoId;

  @override
  List<Object?> get props => [photoId];
}

final class ProfilePhotoManagementDeleteRequested
    extends ProfilePhotoManagementEvent {
  const ProfilePhotoManagementDeleteRequested(this.photoId);

  final String photoId;

  @override
  List<Object?> get props => [photoId];
}

final class ProfilePhotoManagementVerificationOpened
    extends ProfilePhotoManagementEvent {
  const ProfilePhotoManagementVerificationOpened();
}

final class ProfilePhotoManagementVerificationCompleted
    extends ProfilePhotoManagementEvent {
  const ProfilePhotoManagementVerificationCompleted();
}
