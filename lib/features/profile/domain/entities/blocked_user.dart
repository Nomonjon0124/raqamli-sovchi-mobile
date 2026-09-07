import 'package:equatable/equatable.dart';

final class BlockedUser extends Equatable {
  const BlockedUser({
    required this.id,
    required this.blocker,
    required this.blocked,
    this.reason,
    this.createdAt,
    this.blockedInfo,
  });

  final String id;
  final String blocker;
  final String blocked;
  final String? reason;
  final DateTime? createdAt;
  final BlockedUserInfo? blockedInfo;

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

final class BlockedUserInfo extends Equatable {
  const BlockedUserInfo({
    required this.id,
    required this.profileId,
    this.fullName = '',
    this.phoneNumber,
    this.email,
  });

  final String id;
  final String profileId;
  final String fullName;
  final String? phoneNumber;
  final String? email;

  String get initials {
    final parts = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '??';
    if (parts.length == 1) {
      return parts.first
          .substring(0, parts.first.length.clamp(1, 2))
          .toUpperCase();
    }
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  List<Object?> get props => [id, profileId, fullName, phoneNumber, email];
}
