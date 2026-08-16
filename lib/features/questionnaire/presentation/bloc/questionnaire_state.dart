import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/questionnaire.dart';

enum QuestionnaireStatus {
  initial,
  loading,
  overview,
  answering,
  submitting,
  result,
  failure,
}

final class QuestionnaireState extends Equatable {
  const QuestionnaireState({
    this.status = QuestionnaireStatus.initial,
    this.questionnaire,
    this.answers = const {},
    this.currentIndex = 0,
    this.result,
    this.failure,
  });

  final QuestionnaireStatus status;
  final Questionnaire? questionnaire;
  final Map<String, String> answers;
  final int currentIndex;
  final QuestionnaireResult? result;
  final Failure? failure;

  QuestionnaireQuestion? get currentQuestion {
    final questions = questionnaire?.questions;
    if (questions == null ||
        questions.isEmpty ||
        currentIndex < 0 ||
        currentIndex >= questions.length) {
      return null;
    }
    return questions[currentIndex];
  }

  bool get canContinue {
    final question = currentQuestion;
    return question != null && answers.containsKey(question.id);
  }

  QuestionnaireState copyWith({
    QuestionnaireStatus? status,
    Questionnaire? questionnaire,
    Map<String, String>? answers,
    int? currentIndex,
    QuestionnaireResult? result,
    Failure? failure,
    bool clearFailure = false,
    bool clearResult = false,
  }) {
    return QuestionnaireState(
      status: status ?? this.status,
      questionnaire: questionnaire ?? this.questionnaire,
      answers: answers ?? this.answers,
      currentIndex: currentIndex ?? this.currentIndex,
      result: clearResult ? null : result ?? this.result,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [
    status,
    questionnaire,
    answers,
    currentIndex,
    result,
    failure,
  ];
}
