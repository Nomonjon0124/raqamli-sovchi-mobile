import 'package:equatable/equatable.dart';

import '../../application/services/profile_photo_picker.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

final class ProfileLoadRequested extends ProfileEvent {
  const ProfileLoadRequested();
}

final class ProfileRefreshRequested extends ProfileEvent {
  const ProfileRefreshRequested();
}

final class ProfilePhotoPickRequested extends ProfileEvent {
  const ProfilePhotoPickRequested(this.source);

  final ProfilePhotoSource source;

  @override
  List<Object?> get props => [source];
}

final class ProfilePhotoSetMainRequested extends ProfileEvent {
  const ProfilePhotoSetMainRequested(this.photoId);

  final String photoId;

  @override
  List<Object?> get props => [photoId];
}

final class ProfilePhotoDeleteRequested extends ProfileEvent {
  const ProfilePhotoDeleteRequested(this.photoId);

  final String photoId;

  @override
  List<Object?> get props => [photoId];
}
