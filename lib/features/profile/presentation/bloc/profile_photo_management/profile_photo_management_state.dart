import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failure.dart';
import '../../../domain/entities/user_profile.dart';

enum ProfilePhotoManagementStatus { initial, ready, failure }

final class ProfilePhotoManagementState extends Equatable {
  const ProfilePhotoManagementState({
    this.status = ProfilePhotoManagementStatus.initial,
    this.profile,
    this.photos = const [],
    this.isBusy = false,
    this.verificationPending = false,
    this.verificationRequired = false,
    this.failure,
  });

  final ProfilePhotoManagementStatus status;
  final UserProfile? profile;
  final List<ProfilePhoto> photos;
  final bool isBusy;
  final bool verificationPending;
  final bool verificationRequired;
  final Failure? failure;

  ProfilePhotoManagementState copyWith({
    ProfilePhotoManagementStatus? status,
    UserProfile? profile,
    List<ProfilePhoto>? photos,
    bool? isBusy,
    bool? verificationPending,
    bool? verificationRequired,
    Failure? failure,
    bool clearFailure = false,
  }) => ProfilePhotoManagementState(
    status: status ?? this.status,
    profile: profile ?? this.profile,
    photos: photos ?? this.photos,
    isBusy: isBusy ?? this.isBusy,
    verificationPending: verificationPending ?? this.verificationPending,
    verificationRequired: verificationRequired ?? this.verificationRequired,
    failure: clearFailure ? null : failure ?? this.failure,
  );

  @override
  List<Object?> get props => [
    status,
    profile,
    photos,
    isBusy,
    verificationPending,
    verificationRequired,
    failure,
  ];
}
