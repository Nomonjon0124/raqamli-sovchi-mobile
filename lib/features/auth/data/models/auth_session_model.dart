import 'package:equatable/equatable.dart';

import '../../domain/entities/session.dart';

final class AuthSessionModel extends Equatable {
  const AuthSessionModel({
    required this.userId,
    required this.displayName,
    required this.accessToken,
  });

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    return AuthSessionModel(
      userId: json['user_id'] as String,
      displayName: json['display_name'] as String,
      accessToken: json['access_token'] as String,
    );
  }

  final String userId;
  final String displayName;
  final String accessToken;

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'display_name': displayName,
      'access_token': accessToken,
    };
  }

  Session toEntity() {
    return Session(userId: userId, displayName: displayName);
  }

  @override
  List<Object?> get props => [userId, displayName, accessToken];
}
