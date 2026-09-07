import 'package:equatable/equatable.dart';

final class ProfileUpdateParams extends Equatable {
  const ProfileUpdateParams({
    this.firstName,
    this.lastName,
    this.middleName,
    this.birthDate,
    this.height,
    this.weight,
    this.regionId,
    this.districtId,
    this.educationLevelId,
    this.professionId,
    this.maritalStatusId,
    this.bio,
  });

  final String? firstName;
  final String? lastName;
  final String? middleName;
  final DateTime? birthDate;
  final int? height;
  final int? weight;
  final String? regionId;
  final String? districtId;
  final String? educationLevelId;
  final String? professionId;
  final String? maritalStatusId;
  final String? bio;

  Map<String, dynamic> toApiMap() {
    final map = <String, dynamic>{};
    if (firstName != null) map['first_name'] = firstName!.trim();
    if (lastName != null) map['last_name'] = lastName!.trim();
    if (middleName != null) {
      final trimmed = middleName!.trim();
      map['middle_name'] = trimmed.isEmpty ? null : trimmed;
    }
    if (birthDate != null) {
      final y = birthDate!.year.toString().padLeft(4, '0');
      final m = birthDate!.month.toString().padLeft(2, '0');
      final d = birthDate!.day.toString().padLeft(2, '0');
      map['birth_date'] = '$y-$m-$d';
    }
    if (height != null) map['height'] = height;
    if (weight != null) map['weight'] = weight;
    if (regionId != null) map['region'] = regionId;
    if (districtId != null) map['district'] = districtId;
    if (educationLevelId != null) map['education_level'] = educationLevelId;
    if (professionId != null) map['profession'] = professionId;
    if (maritalStatusId != null) map['marital_status'] = maritalStatusId;
    if (bio != null) map['bio'] = bio;
    return map;
  }

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    middleName,
    birthDate,
    height,
    weight,
    regionId,
    districtId,
    educationLevelId,
    professionId,
    maritalStatusId,
    bio,
  ];
}
