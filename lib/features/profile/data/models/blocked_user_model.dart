import 'package:equatable/equatable.dart';

import '../../domain/entities/blocked_user.dart';

final class BlockedUserModel extends Equatable {
  const BlockedUserModel({
    required this.id,
    required this.blocker,
    this.blocked = '',
    this.reason,
    this.createdAt,
    this.blockedInfo,
  });

  factory BlockedUserModel.fromJson(Map<String, dynamic> json) {
    final info = json['blocked_info'];
    return BlockedUserModel(
      id: _asString(json['id']),
      blocker: _asString(json['blocker']),
      blocked: _asString(json['blocked']),
      reason: json['reason'] as String?,
      createdAt: _asDateTime(json['created_at']),
      blockedInfo: info is Map
          ? BlockedUserInfoModel.fromJson(
              info.map((k, v) => MapEntry(k.toString(), v)),
            )
          : null,
    );
  }

  final String id;
  final String blocker;
  final String blocked;
  final String? reason;
  final DateTime? createdAt;
  final BlockedUserInfoModel? blockedInfo;

  BlockedUser toEntity() => BlockedUser(
    id: id,
    blocker: blocker,
    blocked: blocked.isNotEmpty ? blocked : (blockedInfo?.id ?? ''),
    reason: reason,
    createdAt: createdAt,
    blockedInfo: blockedInfo?.toEntity(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'blocker': blocker,
    'blocked': blocked,
    if (reason != null) 'reason': reason,
    if (createdAt != null) 'created_at': createdAt?.toIso8601String(),
    if (blockedInfo != null) 'blocked_info': blockedInfo?.toJson(),
  };

  @override
  List<Object?> get props => [
    id,
    blocker,
    blocked,
    reason,
    createdAt,
    blockedInfo,
  ];
}

final class BlockedUserInfoModel extends Equatable {
  const BlockedUserInfoModel({
    required this.id,
    required this.profileId,
    this.fullName = '',
    this.phoneNumber,
    this.email,
    this.avatarUrl,
  });

  factory BlockedUserInfoModel.fromJson(Map<String, dynamic> json) {
    final rawName = _asString(
      json['full_name'] ?? json['display_id'] ?? json['first_name'],
    );
    return BlockedUserInfoModel(
      id: _asString(json['id']),
      profileId: _asString(json['profile'] ?? json['profile_id']),
      fullName: rawName,
      phoneNumber: json['phone_number'] as String?,
      email: json['email'] as String?,
      avatarUrl: _nullableString(json['avatar']),
    );
  }

  final String id;
  final String profileId;
  final String fullName;
  final String? phoneNumber;
  final String? email;
  final String? avatarUrl;

  BlockedUserInfo toEntity() => BlockedUserInfo(
    id: id,
    profileId: profileId,
    fullName: fullName,
    phoneNumber: phoneNumber,
    email: email,
    avatarUrl: avatarUrl,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'profile': profileId,
    if (fullName.isNotEmpty) 'full_name': fullName,
    if (phoneNumber != null) 'phone_number': phoneNumber,
    if (email != null) 'email': email,
    if (avatarUrl != null) 'avatar': avatarUrl,
  };

  @override
  List<Object?> get props => [
    id,
    profileId,
    fullName,
    phoneNumber,
    email,
    avatarUrl,
  ];
}

String _asString(dynamic value) => value?.toString() ?? '';

String? _nullableString(dynamic value) {
  final result = value?.toString().trim();
  return result == null || result.isEmpty ? null : result;
}

DateTime? _asDateTime(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  return DateTime.tryParse(value.toString());
}
