import 'package:equatable/equatable.dart';

final class Candidate extends Equatable {
  const Candidate({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.age,
    required this.isSaved,
    required this.birthYear,
    required this.weight,
    required this.hasChildren,
    required this.childrenCount,
    required this.bio,
    required this.voiceIntro,
    required this.latitude,
    required this.longitude,
    required this.blurPhotos,
    required this.phoneNumber,
    required this.email,
    required this.isVerified,
    required this.regionId,
    required this.regionName,
    required this.districtId,
    required this.districtName,
    required this.educationLevelID,
    required this.educationLevelName,
    required this.healthStatusId,
    required this.healthStatusName,
    required this.martialStatusId,
    required this.martialStatusName,
    required this.photosInfo,
  });

  final String id;
  final String firstName;
  final String? lastName;
  final String? middleName;
  final int? age;
  final bool isSaved;
  final int? birthYear;
  final double? weight;
  final bool? hasChildren;
  final int? childrenCount;
  final String? bio;
  final String? voiceIntro;
  final String? latitude;
  final String? longitude;
  final bool? blurPhotos;
  final String? phoneNumber;
  final String? email;
  final bool? isVerified;
  final String? regionId;
  final String? regionName;
  final String? districtId;
  final String? districtName;
  final String? educationLevelID;
  final String? educationLevelName;
  final String? healthStatusId;
  final String? healthStatusName;
  final String? martialStatusId;
  final String? martialStatusName;
  final List<CandidatePhotoInfo>? photosInfo;

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    middleName,
    age,
    isSaved,
    birthYear,
    weight,
    hasChildren,
    childrenCount,
    bio,
    voiceIntro,
    latitude,
    longitude,
    blurPhotos,
    phoneNumber,
    email,
    isVerified,
    regionId,
    regionName,
    districtId,
    districtName,
    educationLevelID,
    educationLevelName,
    healthStatusId,
    healthStatusName,
    martialStatusId,
    martialStatusName,
    photosInfo,
  ];
}

final class CandidatePhotoInfo extends Equatable {
  const CandidatePhotoInfo({required this.id, required this.image, required this.isMain, required this.order});

  final String id;
  final String image;
  final bool isMain;
  final int order;

  @override
  List<Object?> get props => [id, image, isMain, order];
}
