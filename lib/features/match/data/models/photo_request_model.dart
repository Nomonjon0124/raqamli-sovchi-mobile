import 'package:equatable/equatable.dart';

import '../../domain/entities/match_request.dart';
import '../../domain/entities/photo_request.dart';

final class PhotoRequestModel extends Equatable {
  const PhotoRequestModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.status,
    this.note,
    this.fromProfileId,
    this.toProfileId,
    this.fromProfileName,
    this.toProfileName,
  });

  factory PhotoRequestModel.fromJson(Map<String, dynamic> json) {
    final fromProfile = _asMap(json['from_profile_info']);
    final toProfile = _asMap(json['to_profile_info']);
    return PhotoRequestModel(
      id: _asString(json['id']) ?? '',
      createdAt:
          _asDateTime(json['created_at']) ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      updatedAt:
          _asDateTime(json['updated_at']) ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      status: MatchRequestStatus.fromApiName(_asString(json['status'])),
      note: _asString(json['note']),
      fromProfileId: _asString(json['from_profile'] ?? fromProfile['id']),
      toProfileId: _asString(json['to_profile'] ?? toProfile['id']),
      fromProfileName: _profileName(fromProfile),
      toProfileName: _profileName(toProfile),
    );
  }

  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final MatchRequestStatus? status;
  final String? note;
  final String? fromProfileId;
  final String? toProfileId;
  final String? fromProfileName;
  final String? toProfileName;

  PhotoRequest toEntity() => PhotoRequest(
    id: id,
    createdAt: createdAt,
    updatedAt: updatedAt,
    status: status,
    note: note,
    fromProfileId: fromProfileId,
    toProfileId: toProfileId,
    fromProfileName: fromProfileName,
    toProfileName: toProfileName,
  );

  @override
  List<Object?> get props => [
    id,
    createdAt,
    updatedAt,
    status,
    note,
    fromProfileId,
    toProfileId,
    fromProfileName,
    toProfileName,
  ];
}

Map<String, dynamic> _asMap(Object? value) {
  if (value is! Map) return const <String, dynamic>{};
  return value.map((key, value) => MapEntry(key.toString(), value));
}

String? _asString(Object? value) => value?.toString();

DateTime? _asDateTime(Object? value) =>
    DateTime.tryParse(value?.toString() ?? '');

String? _profileName(Map<String, dynamic> profile) {
  final firstName = _asString(profile['first_name'])?.trim() ?? '';
  final lastName = _asString(profile['last_name'])?.trim() ?? '';
  final name = '$firstName $lastName'.trim();
  return name.isEmpty ? null : name;
}
