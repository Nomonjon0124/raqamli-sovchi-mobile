import 'package:equatable/equatable.dart';

sealed class QuestionnaireEvent extends Equatable {
  const QuestionnaireEvent();

  @override
  List<Object?> get props => [];
}

final class QuestionnaireStarted extends QuestionnaireEvent {
  const QuestionnaireStarted();
}

final class QuestionnaireStartPressed extends QuestionnaireEvent {
  const QuestionnaireStartPressed();
}

final class QuestionnaireAnswerSelected extends QuestionnaireEvent {
  const QuestionnaireAnswerSelected({
    required this.questionId,
    required this.optionId,
  });

  final String questionId;
  final String optionId;

  @override
  List<Object?> get props => [questionId, optionId];
}

final class QuestionnaireNextPressed extends QuestionnaireEvent {
  const QuestionnaireNextPressed();
}

final class QuestionnaireBackPressed extends QuestionnaireEvent {
  const QuestionnaireBackPressed();
}
