import 'package:equatable/equatable.dart';

final class QuestionnaireSection extends Equatable {
  const QuestionnaireSection({
    required this.id,
    required this.name,
    required this.questionCount,
  });

  final String id;
  final String name;
  final int questionCount;

  @override
  List<Object?> get props => [id, name, questionCount];
}

final class QuestionnaireOption extends Equatable {
  const QuestionnaireOption({
    required this.id,
    required this.letter,
    required this.text,
    required this.weight,
  });

  final String id;
  final String letter;
  final String text;
  final int weight;

  @override
  List<Object?> get props => [id, letter, text, weight];
}

final class QuestionnaireQuestion extends Equatable {
  const QuestionnaireQuestion({
    required this.id,
    required this.sectionId,
    required this.sectionName,
    required this.text,
    required this.order,
    required this.isTrapQuestion,
    required this.options,
  });

  final String id;
  final String sectionId;
  final String sectionName;
  final String text;
  final int order;
  final bool isTrapQuestion;
  final List<QuestionnaireOption> options;

  @override
  List<Object?> get props => [
    id,
    sectionId,
    sectionName,
    text,
    order,
    isTrapQuestion,
    options,
  ];
}

final class QuestionnaireAnswer extends Equatable {
  const QuestionnaireAnswer({
    required this.questionId,
    required this.selectedOptionId,
  });

  final String questionId;
  final String selectedOptionId;

  @override
  List<Object?> get props => [questionId, selectedOptionId];
}

final class Questionnaire extends Equatable {
  const Questionnaire({
    required this.profileId,
    required this.sections,
    required this.questions,
    this.savedAnswers = const {},
  });

  final String profileId;
  final List<QuestionnaireSection> sections;
  final List<QuestionnaireQuestion> questions;
  final Map<String, String> savedAnswers;

  int get questionCount => questions.length;

  @override
  List<Object?> get props => [profileId, sections, questions, savedAnswers];
}

final class QuestionnaireSectionResult extends Equatable {
  const QuestionnaireSectionResult({
    required this.sectionId,
    required this.sectionName,
    required this.score,
  });

  final String sectionId;
  final String sectionName;
  final double score;

  @override
  List<Object?> get props => [sectionId, sectionName, score];
}

final class QuestionnaireResult extends Equatable {
  const QuestionnaireResult({required this.sections});

  final List<QuestionnaireSectionResult> sections;

  @override
  List<Object?> get props => [sections];
}
