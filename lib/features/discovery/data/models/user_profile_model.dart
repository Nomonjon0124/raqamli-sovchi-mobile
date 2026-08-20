import 'package:equatable/equatable.dart';

import '../../domain/entities/user_profile.dart';

final class UserProfileModel extends Equatable {
  const UserProfileModel({
    this.id,
    this.hasAnsweredTest,
    this.answeredQuestionsCount,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
        id: json['id']?.toString(),
        hasAnsweredTest: _asBool(json['has_answered_test']),
        answeredQuestionsCount:
            (json['answered_questions_count'] as num?)?.toInt() ?? 0,
      );

  final String? id;
  final bool? hasAnsweredTest;
  final int? answeredQuestionsCount;

  UserProfile toEntity() => UserProfile(
    id: id ?? '',
    hasAnsweredTest: hasAnsweredTest ?? false,
    answeredQuestionsCount: answeredQuestionsCount ?? 0,
  );

  @override
  List<Object?> get props => [id, hasAnsweredTest, answeredQuestionsCount];
}

bool? _asBool(Object? value) {
  if (value is bool) return value;
  if (value is String) return bool.tryParse(value.toLowerCase());
  return null;
}
