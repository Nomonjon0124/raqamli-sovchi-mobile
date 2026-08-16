import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../entities/questionnaire.dart';

abstract interface class QuestionnaireRepository {
  Future<Either<Failure, Questionnaire>> loadQuestionnaire();

  Future<Either<Failure, void>> submitAnswers({
    required String profileId,
    required List<QuestionnaireAnswer> answers,
  });
}
