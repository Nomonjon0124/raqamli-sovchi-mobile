import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/questionnaire.dart';
import '../../domain/repositories/questionnaire_repository.dart';

final class LoadQuestionnaireUseCase {
  const LoadQuestionnaireUseCase(this._repository);

  final QuestionnaireRepository _repository;

  Future<Either<Failure, Questionnaire>> call() {
    return _repository.loadQuestionnaire();
  }
}
