import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/questionnaire.dart';
import '../../domain/repositories/questionnaire_repository.dart';

final class SubmitQuestionnaireUseCase {
  const SubmitQuestionnaireUseCase(this._repository);

  final QuestionnaireRepository _repository;

  Future<Either<Failure, QuestionnaireResult>> call({
    required Questionnaire questionnaire,
    required Map<String, String> answers,
  }) async {
    if (questionnaire.questions.any(
      (question) => !answers.containsKey(question.id),
    )) {
      return const Left(Failure.validation());
    }

    final submission = await _repository.submitAnswers(
      profileId: questionnaire.profileId,
      answers: questionnaire.questions
          .map(
            (question) => QuestionnaireAnswer(
              questionId: question.id,
              selectedOptionId: answers[question.id]!,
            ),
          )
          .toList(growable: false),
    );

    return submission.fold(
      Left.new,
      (_) => Right(_buildResult(questionnaire, answers)),
    );
  }

  QuestionnaireResult _buildResult(
    Questionnaire questionnaire,
    Map<String, String> answers,
  ) {
    final results = <QuestionnaireSectionResult>[];
    for (final section in questionnaire.sections) {
      final questions = questionnaire.questions
          .where((question) => question.sectionId == section.id)
          .toList(growable: false);
      if (questions.isEmpty) continue;

      var totalWeight = 0;
      for (final question in questions) {
        final selectedId = answers[question.id];
        final selected = question.options
            .where((option) => option.id == selectedId)
            .firstOrNull;
        totalWeight += selected?.weight ?? 0;
      }
      results.add(
        QuestionnaireSectionResult(
          sectionId: section.id,
          sectionName: section.name,
          score: (totalWeight / (questions.length * 10)).clamp(0, 1),
        ),
      );
    }
    return QuestionnaireResult(sections: results);
  }
}
