import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/service_locator.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/ui/widgets/app_error_view.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/questionnaire_bloc.dart';
import '../bloc/questionnaire_event.dart';
import '../bloc/questionnaire_state.dart';
import '../widgets/questionnaire_analysis_view.dart';
import '../widgets/questionnaire_overview.dart';
import '../widgets/questionnaire_questions_view.dart';
import '../widgets/questionnaire_result_view.dart';

final class QuestionnairePage extends StatelessWidget {
  const QuestionnairePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          serviceLocator<QuestionnaireBloc>()
            ..add(const QuestionnaireStarted()),
      child: const _QuestionnaireView(),
    );
  }
}

final class _QuestionnaireView extends StatelessWidget {
  const _QuestionnaireView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<QuestionnaireBloc, QuestionnaireState>(
      builder: (context, state) {
        return switch (state.status) {
          QuestionnaireStatus.initial || QuestionnaireStatus.loading =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
          QuestionnaireStatus.failure => Scaffold(
            body: SafeArea(
              child: Center(
                child: AppErrorView(
                  message: l10n.failureMessage(state.failure!.type.name),
                  onRetry: () => context.read<QuestionnaireBloc>().add(
                    const QuestionnaireStarted(),
                  ),
                ),
              ),
            ),
          ),
          QuestionnaireStatus.overview => QuestionnaireOverview(
            questionnaire: state.questionnaire!,
            onStart: () => context.read<QuestionnaireBloc>().add(
              const QuestionnaireStartPressed(),
            ),
            onLater: () => _closeQuestionnaire(context),
          ),
          QuestionnaireStatus.answering => QuestionnaireQuestionsView(
            state: state,
            errorMessage: state.failure == null
                ? null
                : l10n.failureMessage(state.failure!.type.name),
            onBack: () => context.read<QuestionnaireBloc>().add(
              const QuestionnaireBackPressed(),
            ),
            onAnswerSelected: (questionId, optionId) =>
                context.read<QuestionnaireBloc>().add(
                  QuestionnaireAnswerSelected(
                    questionId: questionId,
                    optionId: optionId,
                  ),
                ),
            onNext: () => context.read<QuestionnaireBloc>().add(
              const QuestionnaireNextPressed(),
            ),
          ),
          QuestionnaireStatus.submitting => const QuestionnaireAnalysisView(),
          QuestionnaireStatus.result => QuestionnaireResultView(
            result: state.result!,
            onShowCandidates: () => _openHomeWithFreshProfile(context),
          ),
        };
      },
    );
  }

  void _closeQuestionnaire(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(RouteNames.home);
  }

  void _openHomeWithFreshProfile(BuildContext context) {
    final location = Uri(
      path: RouteNames.home,
      queryParameters: {
        'profileRefresh': DateTime.now().microsecondsSinceEpoch.toString(),
      },
    ).toString();
    context.go(location);
  }
}
