import 'package:equatable/equatable.dart';

import '../../domain/entities/blocked_user.dart';

final class BlockedUserModel extends Equatable {
  const BlockedUserModel({
    required this.id,
    required this.blocker,
    required this.blocked,
    this.reason,
    this.createdAt,
  });

  factory BlockedUserModel.fromJson(Map<String, dynamic> json) {
    return BlockedUserModel(
      id: _asString(json['id']),
      blocker: _asString(json['blocker']),
      blocked: _asString(json['blocked']),
      reason: json['reason'] as String?,
      createdAt: _asDateTime(json['created_at']),
    );
  }

  final String id;
  final String blocker;
  final String blocked;
  final String? reason;
  final DateTime? createdAt;

  BlockedUser toEntity() => BlockedUser(
    id: id,
    blocker: blocker,
    blocked: blocked,
    reason: reason,
    createdAt: createdAt,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'blocker': blocker,
    'blocked': blocked,
    if (reason != null) 'reason': reason,
    if (createdAt != null) 'created_at': createdAt?.toIso8601String(),
  };

  @override
  List<Object?> get props => [id, blocker, blocked, reason, createdAt];
}

String _asString(dynamic value) => value?.toString() ?? '';

DateTime? _asDateTime(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  return DateTime.tryParse(value.toString());
}
