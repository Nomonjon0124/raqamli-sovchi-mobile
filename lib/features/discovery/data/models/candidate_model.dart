import 'package:equatable/equatable.dart';

import '../../domain/entities/candidate.dart';

final class CandidateModel extends Equatable {
  const CandidateModel({this.count, this.next, this.previous, this.results});

  factory CandidateModel.fromJson(Map<String, dynamic> json) => CandidateModel(
    count: _asInt(json['count']),
    next: _asString(json['next']),
    previous: _asString(json['previous']),
    results: json['results'] is List
        ? (json['results'] as List)
              .map((e) => ResultCandidateModel.fromJson(_asMap(e)))
              .toList()
        : null,
  );

  final int? count;
  final String? next;
  final String? previous;
  final List<ResultCandidateModel>? results;

  CandidateModel copyWith({
    int? count,
    String? next,
    String? previous,
    List<ResultCandidateModel>? results,
  }) => CandidateModel(
    count: count ?? this.count,
    next: next ?? this.next,
    previous: previous ?? this.previous,
    results: results ?? this.results,
  );

  Map<String, dynamic> toJson() => {
    'count': count,
    'next': next,
    'previous': previous,
    'results': results?.map((e) => e.toJson()).toList(),
  };

  List<Candidate> toEntities() {
    return results?.map((model) => model.toEntity()).toList() ?? [];
  }

  @override
  List<Object?> get props => [count, next, previous, results];
}

final class ResultCandidateModel extends Equatable {
  const ResultCandidateModel({
    this.id,
    this.compatibilityScore,
    this.isSaved,
    this.createdAt,
    this.updatedAt,
    this.firstName,
    this.lastName,
    this.middleName,
    this.gender,
    this.candidateType,
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
    this.photosInfo,
  });

  factory ResultCandidateModel.fromJson(Map<String, dynamic> json) =>
      ResultCandidateModel(
        id: _asString(json['id']),
        compatibilityScore: _compatibilityScore(json['compatibility_score']),
        isSaved: _asBool(json['is_saved']),
        createdAt: _asDateTime(json['created_at']),
        updatedAt: _asDateTime(json['updated_at'] ?? json['update_at']),
        firstName: _asString(json['first_name']),
        lastName: _asString(json['last_name']),
        middleName: _asString(json['middle_name']),
        gender: _asString(json['gender']),
        candidateType: _asString(json['candidate_type']),
        birthYear: _asInt(json['birth_year']),
        height: _asInt(json['height']),
        weight: _asInt(json['weight']),
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
        userInfo: json['user_info'] != null
            ? UserInfo.fromJson(_asMap(json['user_info']))
            : null,
        regionInfo: json['region_info'] != null
            ? Info.fromJson(_asMap(json['region_info']))
            : null,
        districtInfo: json['district_info'] != null
            ? Info.fromJson(_asMap(json['district_info']))
            : null,
        educationLevelInfo: json['education_level_info'] != null
            ? Info.fromJson(_asMap(json['education_level_info']))
            : null,
        nationalityInfo: json['nationality_info'] != null
            ? Info.fromJson(_asMap(json['nationality_info']))
            : null,
        professionInfo: json['profession_info'] != null
            ? Info.fromJson(_asMap(json['profession_info']))
            : null,
        healthStatusInfo: json['health_status_info'] != null
            ? Info.fromJson(_asMap(json['health_status_info']))
            : null,
        maritalStatusInfo: json['marital_status_info'] != null
            ? Info.fromJson(_asMap(json['marital_status_info']))
            : null,
        photosInfo: json['photos_info'] is List
            ? (json['photos_info'] as List)
                  .map((e) => PhotosInfo.fromJson(_asMap(e)))
                  .toList()
            : null,
      );

  final String? id;
  final CompatibilityScoreModel? compatibilityScore;
  final bool? isSaved;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? firstName;
  final String? lastName;
  final String? middleName;
  final String? gender;
  final String? candidateType;
  final int? birthYear;
  final int? height;
  final int? weight;
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
  final UserInfo? userInfo;
  final Info? regionInfo;
  final Info? districtInfo;
  final Info? educationLevelInfo;
  final Info? nationalityInfo;
  final Info? professionInfo;
  final Info? healthStatusInfo;
  final Info? maritalStatusInfo;
  final List<PhotosInfo>? photosInfo;

  ResultCandidateModel copyWith({
    String? id,
    CompatibilityScoreModel? compatibilityScore,
    bool? isSaved,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? firstName,
    String? lastName,
    String? middleName,
    String? gender,
    String? candidateType,
    int? birthYear,
    int? height,
    int? weight,
    bool? hasChildren,
    int? childrenCount,
    String? expectations,
    String? bio,
    String? voiceIntro,
    String? latitude,
    String? longitude,
    String? location,
    bool? blurPhotos,
    bool? isVerified,
    UserInfo? userInfo,
    Info? regionInfo,
    Info? districtInfo,
    Info? educationLevelInfo,
    Info? nationalityInfo,
    Info? professionInfo,
    Info? healthStatusInfo,
    Info? maritalStatusInfo,
    List<PhotosInfo>? photosInfo,
  }) => ResultCandidateModel(
    id: id ?? this.id,
    compatibilityScore: compatibilityScore ?? this.compatibilityScore,
    isSaved: isSaved ?? this.isSaved,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    middleName: middleName ?? this.middleName,
    gender: gender ?? this.gender,
    candidateType: candidateType ?? this.candidateType,
    birthYear: birthYear ?? this.birthYear,
    height: height ?? this.height,
    weight: weight ?? this.weight,
    hasChildren: hasChildren ?? this.hasChildren,
    childrenCount: childrenCount ?? this.childrenCount,
    expectations: expectations ?? this.expectations,
    bio: bio ?? this.bio,
    voiceIntro: voiceIntro ?? this.voiceIntro,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    location: location ?? this.location,
    blurPhotos: blurPhotos ?? this.blurPhotos,
    isVerified: isVerified ?? this.isVerified,
    userInfo: userInfo ?? this.userInfo,
    regionInfo: regionInfo ?? this.regionInfo,
    districtInfo: districtInfo ?? this.districtInfo,
    educationLevelInfo: educationLevelInfo ?? this.educationLevelInfo,
    nationalityInfo: nationalityInfo ?? this.nationalityInfo,
    professionInfo: professionInfo ?? this.professionInfo,
    healthStatusInfo: healthStatusInfo ?? this.healthStatusInfo,
    maritalStatusInfo: maritalStatusInfo ?? this.maritalStatusInfo,
    photosInfo: photosInfo ?? this.photosInfo,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'compatibility_score': compatibilityScore?.toJson(),
    'is_saved': isSaved,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'first_name': firstName,
    'last_name': lastName,
    'middle_name': middleName,
    'gender': gender,
    'candidate_type': candidateType,
    'birth_year': birthYear,
    'height': height,
    'weight': weight,
    'has_children': hasChildren,
    'children_count': childrenCount,
    'expectations': expectations,
    'bio': bio,
    'voice_intro': voiceIntro,
    'latitude': latitude,
    'longitude': longitude,
    'location': location,
    'blur_photos': blurPhotos,
    'is_verified': isVerified,
    'user_info': userInfo?.toJson(),
    'region_info': regionInfo?.toJson(),
    'district_info': districtInfo?.toJson(),
    'education_level_info': educationLevelInfo?.toJson(),
    'nationality_info': nationalityInfo?.toJson(),
    'profession_info': professionInfo?.toJson(),
    'health_status_info': healthStatusInfo?.toJson(),
    'marital_status_info': maritalStatusInfo?.toJson(),
    'photos_info': photosInfo?.map((e) => e.toJson()).toList(),
  };

  Candidate toEntity() {
    final calculatedAge = birthYear != null
        ? DateTime.now().year - birthYear!
        : null;

    return Candidate(
      id: id ?? '',
      firstName: firstName ?? '',
      lastName: lastName,
      middleName: middleName,
      age: calculatedAge,
      isSaved: isSaved ?? false,
      birthYear: birthYear,
      height: height,
      weight: weight?.toDouble(),
      hasChildren: hasChildren,
      childrenCount: childrenCount,
      bio: bio,
      voiceIntro: voiceIntro,
      latitude: latitude,
      longitude: longitude,
      blurPhotos: blurPhotos,
      phoneNumber: userInfo?.phoneNumber,
      email: userInfo?.email,
      isVerified: isVerified,
      regionId: regionInfo?.id,
      regionName: regionInfo?.name,
      districtId: districtInfo?.id,
      districtName: districtInfo?.name,
      educationLevelID: educationLevelInfo?.id,
      educationLevelName: educationLevelInfo?.name,
      professionId: professionInfo?.id,
      professionName: professionInfo?.name,
      healthStatusId: healthStatusInfo?.id,
      healthStatusName: healthStatusInfo?.name,
      martialStatusId: maritalStatusInfo?.id,
      martialStatusName: maritalStatusInfo?.name,
      photosInfo: photosInfo?.map((p) => p.toEntity()).toList(),
      compatibilityScore: compatibilityScore?.toEntity(),
      userId: userInfo?.id,
    );
  }

  @override
  List<Object?> get props => [
    id,
    compatibilityScore,
    isSaved,
    createdAt,
    updatedAt,
    firstName,
    lastName,
    middleName,
    gender,
    candidateType,
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
    photosInfo,
  ];
}

final class CompatibilityScoreModel extends Equatable {
  const CompatibilityScoreModel({this.overallScore, this.sections});

  factory CompatibilityScoreModel.fromJson(Map<String, dynamic> json) =>
      CompatibilityScoreModel(
        overallScore: _asDouble(json['overall_score']),
        sections: json['sections'] is List
            ? (json['sections'] as List)
                  .map((e) => CompatibilitySectionModel.fromJson(_asMap(e)))
                  .toList()
            : null,
      );

  final double? overallScore;
  final List<CompatibilitySectionModel>? sections;

  Map<String, dynamic> toJson() => {
    'overall_score': overallScore,
    'sections': sections?.map((e) => e.toJson()).toList(),
  };

  CompatibilityScore? toEntity() {
    if (overallScore == null) return null;
    return CompatibilityScore(
      overallScore: overallScore!,
      sections: sections?.map((s) => s.toEntity()).toList() ?? const [],
    );
  }

  @override
  List<Object?> get props => [overallScore, sections];
}

final class CompatibilitySectionModel extends Equatable {
  const CompatibilitySectionModel({
    this.sectionId,
    this.sectionName,
    this.score,
  });

  factory CompatibilitySectionModel.fromJson(Map<String, dynamic> json) =>
      CompatibilitySectionModel(
        sectionId: _asString(json['section_id']),
        sectionName: _asString(json['section_name']),
        score: _asDouble(json['score']),
      );

  final String? sectionId;
  final String? sectionName;
  final double? score;

  Map<String, dynamic> toJson() => {
    'section_id': sectionId,
    'section_name': sectionName,
    'score': score,
  };

  CompatibilitySection toEntity() => CompatibilitySection(
    sectionId: sectionId ?? '',
    sectionName: sectionName ?? '',
    score: score ?? 0.0,
  );

  @override
  List<Object?> get props => [sectionId, sectionName, score];
}

final class Info extends Equatable {
  const Info({this.id, this.name});

  factory Info.fromJson(Map<String, dynamic> json) =>
      Info(id: _asString(json['id']), name: _asString(json['name']));

  final String? id;
  final String? name;

  Info copyWith({String? id, String? name}) =>
      Info(id: id ?? this.id, name: name ?? this.name);

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  @override
  List<Object?> get props => [id, name];
}

final class PhotosInfo extends Equatable {
  const PhotosInfo({
    this.id,
    this.image,
    this.isMain,
    this.order,
    this.createdAt,
    this.updatedAt,
  });

  factory PhotosInfo.fromJson(Map<String, dynamic> json) => PhotosInfo(
    id: _asString(json['id']),
    image: _asString(json['image']),
    isMain: _asBool(json['is_main']),
    order: _asInt(json['order']),
    createdAt: _asDateTime(json['created_at']),
    updatedAt: _asDateTime(json['updated_at']),
  );

  final String? id;
  final String? image;
  final bool? isMain;
  final int? order;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CandidatePhotoInfo toEntity() => CandidatePhotoInfo(
    id: id ?? '',
    image: image ?? '',
    isMain: isMain ?? false,
    order: order ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'image': image,
    'is_main': isMain,
    'order': order,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };

  @override
  List<Object?> get props => [id, image, isMain, order, createdAt, updatedAt];
}

final class UserInfo extends Equatable {
  const UserInfo({this.id, this.phoneNumber, this.email, this.profile});

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
    id: _asString(json['id']),
    phoneNumber: _asString(json['phone_number']),
    email: _asString(json['email']),
    profile: _asString(json['profile']),
  );

  final String? id;
  final String? phoneNumber;
  final String? email;
  final String? profile;

  UserInfo copyWith({
    String? id,
    String? phoneNumber,
    String? email,
    String? profile,
  }) => UserInfo(
    id: id ?? this.id,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    email: email ?? this.email,
    profile: profile ?? this.profile,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'phone_number': phoneNumber,
    'email': email,
    'profile': profile,
  };

  @override
  List<Object?> get props => [id, phoneNumber, email, profile];
}

Map<String, dynamic> _asMap(Object? value) {
  if (value is! Map) return const <String, dynamic>{};
  return value.map((key, value) => MapEntry(key.toString(), value));
}

String? _asString(Object? value) {
  if (value == null) return null;
  return value.toString();
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
  if (value is double) return value;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

CompatibilityScoreModel? _compatibilityScore(Object? value) {
  if (value is Map) {
    return CompatibilityScoreModel.fromJson(_asMap(value));
  }
  final score = _asDouble(value);
  return score == null ? null : CompatibilityScoreModel(overallScore: score);
}

DateTime? _asDateTime(Object? value) {
  final stringValue = _asString(value);
  if (stringValue == null || stringValue.isEmpty) return null;
  return DateTime.tryParse(stringValue);
}
