import 'package:dio/dio.dart';

import '../../../../core/errors/either.dart';
import '../../../../core/errors/exception_mapper.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/questionnaire.dart';
import '../../domain/repositories/questionnaire_repository.dart';
import '../data_sources/questionnaire_data_source.dart';

final class QuestionnaireRepositoryImpl implements QuestionnaireRepository {
  const QuestionnaireRepositoryImpl(this._dataSource);

  final QuestionnaireDataSource _dataSource;

  @override
  Future<Either<Failure, Questionnaire>> loadQuestionnaire() {
    return _call(() async {
      final profile = await _dataSource.getMyProfile();
      final sections = await _dataSource.getSections();
      final allQuestions = await _dataSource.getQuestions();
      final targetGender = profile.targetGender;
      final questions = allQuestions
          .where(
            (question) =>
                question.targetGender == 'all' ||
                targetGender == null ||
                question.targetGender == targetGender,
          )
          .toList(growable: false);
      final questionIds = questions.map((question) => question.id).toSet();
      final savedAnswers = await _dataSource.getSavedAnswers(profile.id);

      return Questionnaire(
        profileId: profile.id,
        sections: sections
            .map(
              (section) => section.toEntity(
                effectiveQuestionCount: questions
                    .where((question) => question.sectionId == section.id)
                    .length,
              ),
            )
            .toList(growable: false),
        questions: questions
            .map((question) => question.toEntity())
            .toList(growable: false),
        savedAnswers: Map.unmodifiable(
          Map.fromEntries(
            savedAnswers.entries.where(
              (answer) => questionIds.contains(answer.key),
            ),
          ),
        ),
      );
    });
  }

  @override
  Future<Either<Failure, void>> submitAnswers({
    required String profileId,
    required List<QuestionnaireAnswer> answers,
  }) {
    return _call(
      () => _dataSource.submitAnswers(
        profileId: profileId,
        answers: {
          for (final answer in answers)
            answer.questionId: answer.selectedOptionId,
        },
      ),
    );
  }

  Future<Either<Failure, T>> _call<T>(Future<T> Function() call) async {
    try {
      return Right(await call());
    } on DioException catch (error) {
      return Left(mapDioException(error));
    } on Object catch (error) {
      return Left(Failure.unknown(technicalReason: error.toString()));
    }
  }
}
