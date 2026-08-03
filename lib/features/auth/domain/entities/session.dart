import 'package:equatable/equatable.dart';

final class Session extends Equatable {
  const Session({required this.userId, required this.displayName});

  final String userId;
  final String displayName;

  @override
  List<Object?> get props => [userId, displayName];
}
