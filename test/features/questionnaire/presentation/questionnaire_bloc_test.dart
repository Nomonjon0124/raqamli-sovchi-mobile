import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/core/errors/either.dart';
import 'package:raqamli_sovchi/core/errors/failure.dart';
import 'package:raqamli_sovchi/features/questionnaire/application/use_cases/load_questionnaire.dart';
import 'package:raqamli_sovchi/features/questionnaire/application/use_cases/submit_questionnaire.dart';
import 'package:raqamli_sovchi/features/questionnaire/domain/entities/questionnaire.dart';
import 'package:raqamli_sovchi/features/questionnaire/domain/repositories/questionnaire_repository.dart';
import 'package:raqamli_sovchi/features/questionnaire/presentation/bloc/questionnaire_bloc.dart';
import 'package:raqamli_sovchi/features/questionnaire/presentation/bloc/questionnaire_event.dart';
import 'package:raqamli_sovchi/features/questionnaire/presentation/bloc/questionnaire_state.dart';

void main() {
  late _FakeQuestionnaireRepository repository;

  setUp(() => repository = _FakeQuestionnaireRepository());

  QuestionnaireBloc buildBloc() => QuestionnaireBloc(
    loadQuestionnaire: LoadQuestionnaireUseCase(repository),
    submitQuestionnaire: SubmitQuestionnaireUseCase(repository),
    minimumAnalysisDuration: Duration.zero,
  );

  blocTest<QuestionnaireBloc, QuestionnaireState>(
    'does not advance until current question has an answer',
    build: buildBloc,
    act: (bloc) async {
      bloc.add(const QuestionnaireStarted());
      await bloc.stream.firstWhere(
        (state) => state.status == QuestionnaireStatus.overview,
      );
      bloc.add(const QuestionnaireStartPressed());
      await bloc.stream.firstWhere(
        (state) => state.status == QuestionnaireStatus.answering,
      );
      bloc.add(const QuestionnaireNextPressed());
    },
    wait: const Duration(milliseconds: 10),
    expect: () => [
      isA<QuestionnaireState>().having(
        (state) => state.status,
        'loading',
        QuestionnaireStatus.loading,
      ),
      isA<QuestionnaireState>().having(
        (state) => state.status,
        'overview',
        QuestionnaireStatus.overview,
      ),
      isA<QuestionnaireState>().having(
        (state) => state.status,
        'answering',
        QuestionnaireStatus.answering,
      ),
    ],
  );

  blocTest<QuestionnaireBloc, QuestionnaireState>(
    'keeps editable answers, submits all questions, and builds result',
    build: buildBloc,
    act: (bloc) async {
      bloc.add(const QuestionnaireStarted());
      await bloc.stream.firstWhere(
        (state) => state.status == QuestionnaireStatus.overview,
      );
      bloc.add(const QuestionnaireStartPressed());
      await bloc.stream.firstWhere(
        (state) => state.status == QuestionnaireStatus.answering,
      );
      bloc.add(
        const QuestionnaireAnswerSelected(questionId: 'q1', optionId: 'q1-a'),
      );
      await bloc.stream.firstWhere((state) => state.answers['q1'] == 'q1-a');
      bloc.add(const QuestionnaireNextPressed());
      await bloc.stream.firstWhere((state) => state.currentIndex == 1);
      bloc.add(
        const QuestionnaireAnswerSelected(questionId: 'q2', optionId: 'q2-b'),
      );
      await bloc.stream.firstWhere((state) => state.answers['q2'] == 'q2-b');
      bloc.add(const QuestionnaireBackPressed());
      await bloc.stream.firstWhere(
        (state) => state.currentIndex == 0 && state.answers.length == 2,
      );
      bloc.add(const QuestionnaireNextPressed());
      await bloc.stream.firstWhere((state) => state.currentIndex == 1);
      bloc.add(const QuestionnaireNextPressed());
    },
    wait: const Duration(milliseconds: 20),
    verify: (bloc) {
      expect(repository.submittedAnswers, const [
        QuestionnaireAnswer(questionId: 'q1', selectedOptionId: 'q1-a'),
        QuestionnaireAnswer(questionId: 'q2', selectedOptionId: 'q2-b'),
      ]);
      expect(bloc.state.status, QuestionnaireStatus.result);
      expect(bloc.state.result!.sections.single.score, .75);
    },
  );
}

final class _FakeQuestionnaireRepository implements QuestionnaireRepository {
  List<QuestionnaireAnswer> submittedAnswers = const [];

  @override
  Future<Either<Failure, Questionnaire>> loadQuestionnaire() async {
    return const Right(
      Questionnaire(
        profileId: 'profile-1',
        sections: [
          QuestionnaireSection(
            id: 'section-1',
            name: 'Values',
            questionCount: 2,
          ),
        ],
        questions: [
          QuestionnaireQuestion(
            id: 'q1',
            sectionId: 'section-1',
            sectionName: 'Values',
            text: 'Question one?',
            order: 1,
            isTrapQuestion: false,
            options: [
              QuestionnaireOption(
                id: 'q1-a',
                letter: 'A',
                text: 'Answer A',
                weight: 10,
              ),
            ],
          ),
          QuestionnaireQuestion(
            id: 'q2',
            sectionId: 'section-1',
            sectionName: 'Values',
            text: 'Question two?',
            order: 2,
            isTrapQuestion: false,
            options: [
              QuestionnaireOption(
                id: 'q2-b',
                letter: 'B',
                text: 'Answer B',
                weight: 5,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Future<Either<Failure, void>> submitAnswers({
    required String profileId,
    required List<QuestionnaireAnswer> answers,
  }) async {
    submittedAnswers = answers;
    return const Right(null);
  }
}
