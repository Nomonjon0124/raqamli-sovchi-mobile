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
    this.birthDate,
    required this.height,
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
    this.professionId,
    this.professionName,
    required this.healthStatusId,
    required this.healthStatusName,
    required this.martialStatusId,
    required this.martialStatusName,
    required this.photosInfo,
    this.compatibilityScore,
    this.userId,
  });

  final String id;
  final String? userId;
  final String firstName;
  final String? lastName;
  final String? middleName;
  final int? age;
  final bool isSaved;
  final int? birthYear;
  final DateTime? birthDate;
  final int? height;
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
  final String? professionId;
  final String? professionName;
  final String? healthStatusId;
  final String? healthStatusName;
  final String? martialStatusId;
  final String? martialStatusName;
  final List<CandidatePhotoInfo>? photosInfo;
  final CompatibilityScore? compatibilityScore;

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    middleName,
    age,
    isSaved,
    birthYear,
    birthDate,
    height,
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
    professionId,
    professionName,
    healthStatusId,
    healthStatusName,
    martialStatusId,
    martialStatusName,
    photosInfo,
    compatibilityScore,
    userId,
  ];
}

final class CandidatePhotoInfo extends Equatable {
  const CandidatePhotoInfo({
    required this.id,
    required this.image,
    required this.isMain,
    required this.order,
  });

  final String id;
  final String image;
  final bool isMain;
  final int order;

  @override
  List<Object?> get props => [id, image, isMain, order];
}

final class CompatibilityScore extends Equatable {
  const CompatibilityScore({
    required this.overallScore,
    this.sections = const [],
  });

  final double overallScore;
  final List<CompatibilitySection> sections;

  @override
  List<Object?> get props => [overallScore, sections];
}

final class CompatibilitySection extends Equatable {
  const CompatibilitySection({
    required this.sectionId,
    required this.sectionName,
    required this.score,
  });

  final String sectionId;
  final String sectionName;
  final double score;

  @override
  List<Object?> get props => [sectionId, sectionName, score];
}
