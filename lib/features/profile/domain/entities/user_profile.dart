import 'package:equatable/equatable.dart';

final class UserProfile extends Equatable {
  const UserProfile({
    required this.id,
    required this.hasAnsweredTest,
    required this.answeredQuestionsCount,
    this.firstName = '',
    this.lastName = '',
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
    this.blurPhotos = false,
    this.isVerified = false,
    this.phoneNumber,
    this.email,
    this.regionName,
    this.districtName,
    this.educationLevelName,
    this.nationalityName,
    this.professionName,
    this.healthStatusName,
    this.maritalStatusName,
    this.photos = const [],
  });

  final String id;
  final bool hasAnsweredTest;
  final int answeredQuestionsCount;
  final String firstName;
  final String lastName;
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
  final bool blurPhotos;
  final bool isVerified;
  final String? phoneNumber;
  final String? email;
  final String? regionName;
  final String? districtName;
  final String? educationLevelName;
  final String? nationalityName;
  final String? professionName;
  final String? healthStatusName;
  final String? maritalStatusName;
  final List<ProfilePhoto> photos;

  String get displayName => [
    firstName.trim(),
    lastName.trim(),
  ].where((part) => part.isNotEmpty).join(' ');

  int? get age {
    final date = birthDate;
    if (date != null) return _ageFromBirthDate(date, DateTime.now());
    final year = birthYear;
    if (year == null || year <= 0 || year > DateTime.now().year) return null;
    return DateTime.now().year - year;
  }

  String get initials {
    final parts = [
      firstName.trim(),
      lastName.trim(),
    ].where((part) => part.isNotEmpty).toList();
    if (parts.isEmpty) return '';
    return parts.take(2).map((part) => part[0].toUpperCase()).join();
  }

  String get publicCode {
    final compact = id.replaceAll(RegExp('[^a-zA-Z0-9]'), '').toUpperCase();
    if (compact.length <= 6) return compact;
    return compact.substring(compact.length - 6);
  }

  ProfilePhoto? get mainPhoto {
    for (final photo in photos) {
      if (photo.isMain) return photo;
    }
    return photos.isEmpty ? null : photos.first;
  }

  int get completionPercent {
    final completed = <bool>[
      firstName.trim().isNotEmpty,
      lastName.trim().isNotEmpty,
      birthYear != null,
      gender?.trim().isNotEmpty ?? false,
      height != null,
      regionName?.trim().isNotEmpty ?? false,
      districtName?.trim().isNotEmpty ?? false,
      educationLevelName?.trim().isNotEmpty ?? false,
      professionName?.trim().isNotEmpty ?? false,
      bio?.trim().isNotEmpty ?? false,
      photos.isNotEmpty,
    ].where((value) => value).length;
    return ((completed / 11) * 100).round();
  }

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
    phoneNumber,
    email,
    regionName,
    districtName,
    educationLevelName,
    nationalityName,
    professionName,
    healthStatusName,
    maritalStatusName,
    photos,
  ];
}

int? _ageFromBirthDate(DateTime birthDate, DateTime today) {
  if (birthDate.isAfter(today)) return null;
  var age = today.year - birthDate.year;
  final birthdayHasPassed =
      today.month > birthDate.month ||
      (today.month == birthDate.month && today.day >= birthDate.day);
  if (!birthdayHasPassed) age--;
  return age < 0 ? null : age;
}

final class ProfilePhoto extends Equatable {
  const ProfilePhoto({
    required this.id,
    required this.imageUrl,
    required this.isMain,
    required this.order,
  });

  final String id;
  final String imageUrl;
  final bool isMain;
  final int order;

  @override
  List<Object?> get props => [id, imageUrl, isMain, order];
}
