import 'package:equatable/equatable.dart';

import '../../domain/entities/user_profile.dart';

final class UserProfileModel extends Equatable {
  const UserProfileModel({
    this.id,
    this.hasAnsweredTest,
    this.answeredQuestionsCount,
    this.firstName,
    this.lastName,
    this.middleName,
    this.gender,
    this.candidateType,
    this.birthDate,
    this.birthYear,
    this.height,
    this.weight,
    this.hasChildren,
    this.childrenCount,
    this.expectations,
    this.bio,
    this.voiceIntro,
    this.latitude,
    this.longitude,
    this.location,
    this.blurPhotos,
    this.isVerified,
    this.userInfo,
    this.regionInfo,
    this.districtInfo,
    this.educationLevelInfo,
    this.nationalityInfo,
    this.professionInfo,
    this.healthStatusInfo,
    this.maritalStatusInfo,
    this.photos,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    final birthDate = _asDateTime(json['birth_date']);
    final photos = json['photos_info'] is List
        ? (json['photos_info'] as List)
              .map((value) => ProfilePhotoModel.fromJson(_asMap(value)))
              .toList()
        : const <ProfilePhotoModel>[];
    photos.sort((a, b) {
      if ((a.isMain ?? false) != (b.isMain ?? false)) {
        return (a.isMain ?? false) ? -1 : 1;
      }
      return (a.order ?? 0).compareTo(b.order ?? 0);
    });

    return UserProfileModel(
      id: _asString(json['id']),
      hasAnsweredTest: _asBool(json['has_answered_test']),
      answeredQuestionsCount: _asInt(json['answered_questions_count']),
      firstName: _asString(json['first_name']),
      lastName: _asString(json['last_name']),
      middleName: _asString(json['middle_name']),
      gender: _asString(json['gender']),
      candidateType: _asString(json['candidate_type']),
      birthDate: birthDate,
      birthYear: _asInt(json['birth_year']) ?? birthDate?.year,
      height: _asInt(json['height']),
      weight: _asDouble(json['weight']),
      hasChildren: _asBool(json['has_children']),
      childrenCount: _asInt(json['children_count']),
      expectations: _asString(json['expectations']),
      bio: _asString(json['bio']),
      voiceIntro: _asString(json['voice_intro']),
      latitude: _asString(json['latitude']),
      longitude: _asString(json['longitude']),
      location: _asString(json['location']),
      blurPhotos: _asBool(json['blur_photos']),
      isVerified: _asBool(json['is_verified']),
      userInfo: _modelFromMap(json['user_info'], ProfileUserModel.fromJson),
      regionInfo: _modelFromMap(
        json['region_info'],
        ProfileReferenceModel.fromJson,
      ),
      districtInfo: _modelFromMap(
        json['district_info'],
        ProfileReferenceModel.fromJson,
      ),
      educationLevelInfo: _modelFromMap(
        json['education_level_info'],
        ProfileReferenceModel.fromJson,
      ),
      nationalityInfo: _modelFromMap(
        json['nationality_info'],
        ProfileReferenceModel.fromJson,
      ),
      professionInfo: _modelFromMap(
        json['profession_info'],
        ProfileReferenceModel.fromJson,
      ),
      healthStatusInfo: _modelFromMap(
        json['health_status_info'],
        ProfileReferenceModel.fromJson,
      ),
      maritalStatusInfo: _modelFromMap(
        json['marital_status_info'],
        ProfileReferenceModel.fromJson,
      ),
      photos: photos,
    );
  }

  final String? id;
  final bool? hasAnsweredTest;
  final int? answeredQuestionsCount;
  final String? firstName;
  final String? lastName;
  final String? middleName;
  final String? gender;
  final String? candidateType;
  final DateTime? birthDate;
  final int? birthYear;
  final int? height;
  final double? weight;
  final bool? hasChildren;
  final int? childrenCount;
  final String? expectations;
  final String? bio;
  final String? voiceIntro;
  final String? latitude;
  final String? longitude;
  final String? location;
  final bool? blurPhotos;
  final bool? isVerified;
  final ProfileUserModel? userInfo;
  final ProfileReferenceModel? regionInfo;
  final ProfileReferenceModel? districtInfo;
  final ProfileReferenceModel? educationLevelInfo;
  final ProfileReferenceModel? nationalityInfo;
  final ProfileReferenceModel? professionInfo;
  final ProfileReferenceModel? healthStatusInfo;
  final ProfileReferenceModel? maritalStatusInfo;
  final List<ProfilePhotoModel>? photos;

  UserProfile toEntity() => UserProfile(
    id: id ?? '',
    hasAnsweredTest: hasAnsweredTest ?? false,
    answeredQuestionsCount: answeredQuestionsCount ?? 0,
    firstName: firstName ?? '',
    lastName: lastName ?? '',
    middleName: middleName,
    gender: gender,
    candidateType: candidateType,
    birthDate: birthDate,
    birthYear: birthYear,
    height: height,
    weight: weight,
    hasChildren: hasChildren,
    childrenCount: childrenCount,
    expectations: expectations,
    bio: bio,
    voiceIntro: voiceIntro,
    latitude: latitude,
    longitude: longitude,
    location: location,
    blurPhotos: blurPhotos ?? false,
    isVerified: isVerified ?? false,
    phoneNumber: userInfo?.phoneNumber,
    email: userInfo?.email,
    regionId: regionInfo?.id,
    regionName: regionInfo?.name,
    districtId: districtInfo?.id,
    districtName: districtInfo?.name,
    educationLevelId: educationLevelInfo?.id,
    educationLevelName: educationLevelInfo?.name,
    nationalityName: nationalityInfo?.name,
    professionId: professionInfo?.id,
    professionName: professionInfo?.name,
    healthStatusName: healthStatusInfo?.name,
    maritalStatusId: maritalStatusInfo?.id,
    maritalStatusName: maritalStatusInfo?.name,
    photos: photos?.map((photo) => photo.toEntity()).toList() ?? const [],
  );

  @override
  List<Object?> get props => [
    id,
    hasAnsweredTest,
    answeredQuestionsCount,
    firstName,
    lastName,
    middleName,
    gender,
    candidateType,
    birthDate,
    birthYear,
    height,
    weight,
    hasChildren,
    childrenCount,
    expectations,
    bio,
    voiceIntro,
    latitude,
    longitude,
    location,
    blurPhotos,
    isVerified,
    userInfo,
    regionInfo,
    districtInfo,
    educationLevelInfo,
    nationalityInfo,
    professionInfo,
    healthStatusInfo,
    maritalStatusInfo,
    photos,
  ];
}

final class ProfilePhotoModel extends Equatable {
  const ProfilePhotoModel({this.id, this.image, this.isMain, this.order});

  factory ProfilePhotoModel.fromJson(Map<String, dynamic> json) =>
      ProfilePhotoModel(
        id: _asString(json['id']),
        image: _asString(json['image']),
        isMain: _asBool(json['is_main']),
        order: _asInt(json['order']),
      );

  final String? id;
  final String? image;
  final bool? isMain;
  final int? order;

  ProfilePhoto toEntity() => ProfilePhoto(
    id: id ?? '',
    imageUrl: image ?? '',
    isMain: isMain ?? false,
    order: order ?? 0,
  );

  @override
  List<Object?> get props => [id, image, isMain, order];
}

final class ProfileUserModel extends Equatable {
  const ProfileUserModel({
    this.id,
    this.phoneNumber,
    this.email,
    this.profileId,
  });

  factory ProfileUserModel.fromJson(Map<String, dynamic> json) =>
      ProfileUserModel(
        id: _asString(json['id']),
        phoneNumber: _asString(json['phone_number']),
        email: _asString(json['email']),
        profileId: _asString(json['profile']),
      );

  final String? id;
  final String? phoneNumber;
  final String? email;
  final String? profileId;

  @override
  List<Object?> get props => [id, phoneNumber, email, profileId];
}

final class ProfileReferenceModel extends Equatable {
  const ProfileReferenceModel({this.id, this.name});

  factory ProfileReferenceModel.fromJson(Map<String, dynamic> json) =>
      ProfileReferenceModel(
        id: _asString(json['id']),
        name: _asString(json['name']),
      );

  final String? id;
  final String? name;

  @override
  List<Object?> get props => [id, name];
}

Map<String, dynamic> _asMap(Object? value) {
  if (value is! Map) return const <String, dynamic>{};
  return value.map((key, value) => MapEntry(key.toString(), value));
}

T? _modelFromMap<T>(
  Object? value,
  T Function(Map<String, dynamic> json) fromJson,
) => value is Map ? fromJson(_asMap(value)) : null;

String? _asString(Object? value) {
  if (value == null) return null;
  final text = value.toString();
  return text.isEmpty ? null : text;
}

bool? _asBool(Object? value) {
  if (value is bool) return value;
  if (value is String) return bool.tryParse(value.toLowerCase());
  return null;
}

int? _asInt(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

double? _asDouble(Object? value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

DateTime? _asDateTime(Object? value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}
