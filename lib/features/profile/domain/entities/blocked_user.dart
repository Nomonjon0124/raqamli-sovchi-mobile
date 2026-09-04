import 'package:equatable/equatable.dart';

final class BlockedUser extends Equatable {
  const BlockedUser({
    required this.id,
    required this.blocker,
    required this.blocked,
    this.reason,
    this.createdAt,
  });

  final String id;
  final String blocker;
  final String blocked;
  final String? reason;
  final DateTime? createdAt;

  @override
  List<Object?> get props => [id, blocker, blocked, reason, createdAt];
}
