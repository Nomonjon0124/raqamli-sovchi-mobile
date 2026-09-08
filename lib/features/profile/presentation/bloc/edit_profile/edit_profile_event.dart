import 'package:equatable/equatable.dart';

import '../../../domain/entities/user_profile.dart';

sealed class EditProfileEvent extends Equatable {
  const EditProfileEvent();

  @override
  List<Object?> get props => [];
}

final class EditProfileStarted extends EditProfileEvent {
  const EditProfileStarted(this.profile);

  final UserProfile profile;

  @override
  List<Object?> get props => [profile];
}

final class EditProfileNameChanged extends EditProfileEvent {
  const EditProfileNameChanged({
    required this.firstName,
    required this.lastName,
  });

  final String firstName;
  final String lastName;

  @override
  List<Object?> get props => [firstName, lastName];
}

final class EditProfileBirthYearChanged extends EditProfileEvent {
  const EditProfileBirthYearChanged(this.birthYear);

  final int birthYear;

  @override
  List<Object?> get props => [birthYear];
}

final class EditProfileHeightChanged extends EditProfileEvent {
  const EditProfileHeightChanged(this.height);

  final int height;

  @override
  List<Object?> get props => [height];
}

final class EditProfileWeightChanged extends EditProfileEvent {
  const EditProfileWeightChanged(this.weight);

  final int weight;

  @override
  List<Object?> get props => [weight];
}

final class EditProfileEducationChanged extends EditProfileEvent {
  const EditProfileEducationChanged({required this.id, required this.name});

  final String id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}

final class EditProfileProfessionChanged extends EditProfileEvent {
  const EditProfileProfessionChanged({required this.id, required this.name});

  final String id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}

final class EditProfileProfessionCustomSubmitted extends EditProfileEvent {
  const EditProfileProfessionCustomSubmitted(this.name);

  final String name;

  @override
  List<Object?> get props => [name];
}

final class EditProfileRegionChanged extends EditProfileEvent {
  const EditProfileRegionChanged({required this.id, required this.name});

  final String id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}

final class EditProfileDistrictChanged extends EditProfileEvent {
  const EditProfileDistrictChanged({required this.id, required this.name});

  final String id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}

final class EditProfileMaritalStatusChanged extends EditProfileEvent {
  const EditProfileMaritalStatusChanged({required this.id, required this.name});

  final String id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}

final class EditProfileBioChanged extends EditProfileEvent {
  const EditProfileBioChanged(this.bio);

  final String bio;

  @override
  List<Object?> get props => [bio];
}

final class EditProfilePhotoPickRequested extends EditProfileEvent {
  const EditProfilePhotoPickRequested();
}

final class EditProfileSubmitted extends EditProfileEvent {
  const EditProfileSubmitted();
}
