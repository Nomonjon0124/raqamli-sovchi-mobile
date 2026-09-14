import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failure.dart';

enum ProfileFaceVerificationStatus { ready, verifying, success, failure }

final class ProfileFaceVerificationState extends Equatable {
  const ProfileFaceVerificationState({
    this.status = ProfileFaceVerificationStatus.ready,
    this.failure,
  });

  final ProfileFaceVerificationStatus status;
  final Failure? failure;

  ProfileFaceVerificationState copyWith({
    ProfileFaceVerificationStatus? status,
    Failure? failure,
    bool clearFailure = false,
  }) => ProfileFaceVerificationState(
    status: status ?? this.status,
    failure: clearFailure ? null : failure ?? this.failure,
  );

  @override
  List<Object?> get props => [status, failure];
}
