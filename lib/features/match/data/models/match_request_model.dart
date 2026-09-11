import 'package:equatable/equatable.dart';

import '../../domain/entities/match_request.dart';

final class MatchRequestModel extends Equatable {
  const MatchRequestModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.status,
    this.visibilityScope,
    this.note,
    this.fromProfileId,
    this.toProfileId,
    this.fromProfileName,
    this.toProfileName,
    this.fromProfileImageUrl,
    this.toProfileImageUrl,
  });

  factory MatchRequestModel.fromJson(Map<String, dynamic> json) {
    final fromProfile = _asMap(json['from_profile_info']);
    final toProfile = _asMap(json['to_profile_info']);
    return MatchRequestModel(
      id: _asString(json['id']) ?? '',
      createdAt:
          _asDateTime(json['created_at']) ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      updatedAt:
          _asDateTime(json['updated_at']) ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      status: MatchRequestStatus.fromApiName(_asString(json['status'])),
      visibilityScope: _visibilityScope(_asString(json['visibility_scope'])),
      note: _asString(json['note']),
      fromProfileId: _asString(json['from_profile'] ?? fromProfile['id']),
      toProfileId: _asString(json['to_profile'] ?? toProfile['id']),
      fromProfileName: _profileName(fromProfile),
      toProfileName: _profileName(toProfile),
      fromProfileImageUrl: _profileImageUrl(fromProfile),
      toProfileImageUrl: _profileImageUrl(toProfile),
    );
  }

  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final MatchRequestStatus? status;
  final MatchRequestVisibilityScope? visibilityScope;
  final String? note;
  final String? fromProfileId;
  final String? toProfileId;
  final String? fromProfileName;
  final String? toProfileName;
  final String? fromProfileImageUrl;
  final String? toProfileImageUrl;

  MatchRequest toEntity() => MatchRequest(
    id: id,
    createdAt: createdAt,
    updatedAt: updatedAt,
    status: status,
    visibilityScope: visibilityScope,
    note: note,
    fromProfileId: fromProfileId,
    toProfileId: toProfileId,
    fromProfileName: fromProfileName,
    toProfileName: toProfileName,
    fromProfileImageUrl: fromProfileImageUrl,
    toProfileImageUrl: toProfileImageUrl,
  );

  @override
  List<Object?> get props => [
    id,
    createdAt,
    updatedAt,
    status,
    visibilityScope,
    note,
    fromProfileId,
    toProfileId,
    fromProfileName,
    toProfileName,
    fromProfileImageUrl,
    toProfileImageUrl,
  ];
}

final class MatchRequestListModel extends Equatable {
  const MatchRequestListModel({required this.results, this.count});

  factory MatchRequestListModel.fromJson(Map<String, dynamic> json) {
    final results = json['results'];
    return MatchRequestListModel(
      count: _asInt(json['count']),
      results: results is List
          ? results
                .whereType<Map>()
                .map((item) => MatchRequestModel.fromJson(_asMap(item)))
                .toList()
          : const [],
    );
  }

  final int? count;
  final List<MatchRequestModel> results;

  List<MatchRequest> toEntities() =>
      results.map((item) => item.toEntity()).toList();

  @override
  List<Object?> get props => [count, results];
}

Map<String, dynamic> _asMap(Object? value) {
  if (value is! Map) return const <String, dynamic>{};
  return value.map((key, value) => MapEntry(key.toString(), value));
}

String? _asString(Object? value) => value?.toString();

int? _asInt(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '');
}

DateTime? _asDateTime(Object? value) =>
    DateTime.tryParse(value?.toString() ?? '');

String? _profileName(Map<String, dynamic> profile) {
  final firstName = _asString(profile['first_name'])?.trim() ?? '';
  final lastName = _asString(profile['last_name'])?.trim() ?? '';
  final name = '$firstName $lastName'.trim();
  return name.isEmpty ? null : name;
}

String? _profileImageUrl(Map<String, dynamic> profile) {
  for (final value in [
    profile['main_photo'],
    profile['avatar'],
    profile['photo'],
    _asMap(profile['main_photo_info'])['image'],
  ]) {
    final url = _asString(value)?.trim();
    if (url != null && url.isNotEmpty) return url;
  }
  return null;
}

MatchRequestVisibilityScope? _visibilityScope(String? value) {
  return switch (value) {
    'only_this_user' => MatchRequestVisibilityScope.onlyThisUser,
    'forward_to_representative' =>
      MatchRequestVisibilityScope.forwardToRepresentative,
    _ => null,
  };
}
