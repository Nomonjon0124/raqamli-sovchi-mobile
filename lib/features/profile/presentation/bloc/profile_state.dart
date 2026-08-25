import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/user_profile.dart';

enum ProfileStatus { initial, loading, success, failure }

final class ProfileState extends Equatable {
  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.failure,
    this.isRefreshing = false,
  });

  final ProfileStatus status;
  final UserProfile? profile;
  final Failure? failure;
  final bool isRefreshing;

  ProfileState copyWith({
    ProfileStatus? status,
    UserProfile? profile,
    Failure? failure,
    bool? isRefreshing,
    bool clearFailure = false,
  }) => ProfileState(
    status: status ?? this.status,
    profile: profile ?? this.profile,
    failure: clearFailure ? null : failure ?? this.failure,
    isRefreshing: isRefreshing ?? this.isRefreshing,
  );

  @override
  List<Object?> get props => [status, profile, failure, isRefreshing];
}
