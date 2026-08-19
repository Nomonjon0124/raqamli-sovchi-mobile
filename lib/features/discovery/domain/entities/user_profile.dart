import 'package:equatable/equatable.dart';

final class UserProfile extends Equatable {
  const UserProfile({
    required this.id,
    required this.hasAnsweredTest,
    required this.answeredQuestionsCount,
  });

  final String id;
  final bool hasAnsweredTest;
  final int answeredQuestionsCount;

  @override
  List<Object?> get props => [id, hasAnsweredTest, answeredQuestionsCount];
}
