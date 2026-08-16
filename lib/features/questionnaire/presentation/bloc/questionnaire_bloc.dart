import 'package:flutter_bloc/flutter_bloc.dart';

import '../../application/use_cases/load_questionnaire.dart';
import '../../application/use_cases/submit_questionnaire.dart';
import 'questionnaire_event.dart';
import 'questionnaire_state.dart';

final class QuestionnaireBloc
    extends Bloc<QuestionnaireEvent, QuestionnaireState> {
  QuestionnaireBloc({
    required LoadQuestionnaireUseCase loadQuestionnaire,
    required SubmitQuestionnaireUseCase submitQuestionnaire,
    Duration minimumAnalysisDuration = const Duration(seconds: 3),
  }) : _loadQuestionnaire = loadQuestionnaire,
       _submitQuestionnaire = submitQuestionnaire,
       _minimumAnalysisDuration = minimumAnalysisDuration,
       super(const QuestionnaireState()) {
    on<QuestionnaireStarted>(_onStarted);
    on<QuestionnaireStartPressed>(_onStartPressed);
    on<QuestionnaireAnswerSelected>(_onAnswerSelected);
    on<QuestionnaireNextPressed>(_onNextPressed);
    on<QuestionnaireBackPressed>(_onBackPressed);
  }

  final LoadQuestionnaireUseCase _loadQuestionnaire;
  final SubmitQuestionnaireUseCase _submitQuestionnaire;
  final Duration _minimumAnalysisDuration;

  Future<void> _onStarted(
    QuestionnaireStarted event,
    Emitter<QuestionnaireState> emit,
  ) async {
    emit(
      state.copyWith(
        status: QuestionnaireStatus.loading,
        clearFailure: true,
        clearResult: true,
      ),
    );
    final result = await _loadQuestionnaire();
    result.fold(
      (failure) => emit(
        state.copyWith(status: QuestionnaireStatus.failure, failure: failure),
      ),
      (questionnaire) => emit(
        state.copyWith(
          status: QuestionnaireStatus.overview,
          questionnaire: questionnaire,
          answers: Map.unmodifiable(questionnaire.savedAnswers),
          currentIndex: 0,
          clearFailure: true,
        ),
      ),
    );
  }

  void _onStartPressed(
    QuestionnaireStartPressed event,
    Emitter<QuestionnaireState> emit,
  ) {
    if (state.questionnaire?.questions.isEmpty ?? true) return;
    emit(
      state.copyWith(status: QuestionnaireStatus.answering, currentIndex: 0),
    );
  }

  void _onAnswerSelected(
    QuestionnaireAnswerSelected event,
    Emitter<QuestionnaireState> emit,
  ) {
    final question = state.currentQuestion;
    if (state.status != QuestionnaireStatus.answering ||
        question == null ||
        question.id != event.questionId ||
        question.options.every((option) => option.id != event.optionId)) {
      return;
    }
    emit(
      state.copyWith(
        answers: Map.unmodifiable({
          ...state.answers,
          event.questionId: event.optionId,
        }),
      ),
    );
  }

  Future<void> _onNextPressed(
    QuestionnaireNextPressed event,
    Emitter<QuestionnaireState> emit,
  ) async {
    final questionnaire = state.questionnaire;
    if (state.status != QuestionnaireStatus.answering ||
        questionnaire == null ||
        !state.canContinue) {
      return;
    }
    if (state.currentIndex < questionnaire.questions.length - 1) {
      emit(state.copyWith(currentIndex: state.currentIndex + 1));
      return;
    }

    emit(
      state.copyWith(
        status: QuestionnaireStatus.submitting,
        clearFailure: true,
      ),
    );
    final submission = _submitQuestionnaire(
      questionnaire: questionnaire,
      answers: state.answers,
    );
    await Future.wait<void>([
      submission.then<void>((_) {}),
      Future<void>.delayed(_minimumAnalysisDuration),
    ]);
    final result = await submission;
    result.fold(
      (failure) => emit(
        state.copyWith(status: QuestionnaireStatus.answering, failure: failure),
      ),
      (questionnaireResult) => emit(
        state.copyWith(
          status: QuestionnaireStatus.result,
          result: questionnaireResult,
          clearFailure: true,
        ),
      ),
    );
  }

  void _onBackPressed(
    QuestionnaireBackPressed event,
    Emitter<QuestionnaireState> emit,
  ) {
    if (state.status != QuestionnaireStatus.answering) return;
    if (state.currentIndex > 0) {
      emit(state.copyWith(currentIndex: state.currentIndex - 1));
      return;
    }
    emit(state.copyWith(status: QuestionnaireStatus.overview));
  }
}
