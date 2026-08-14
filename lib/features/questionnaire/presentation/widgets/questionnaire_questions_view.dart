import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/questionnaire.dart';
import '../bloc/questionnaire_state.dart';
import 'questionnaire_option_card.dart';
import 'questionnaire_primary_button.dart';

final class QuestionnaireQuestionsView extends StatefulWidget {
  const QuestionnaireQuestionsView({
    required this.state,
    required this.onBack,
    required this.onAnswerSelected,
    required this.onNext,
    this.errorMessage,
    super.key,
  });

  final QuestionnaireState state;
  final VoidCallback onBack;
  final void Function(String questionId, String optionId) onAnswerSelected;
  final VoidCallback onNext;
  final String? errorMessage;

  @override
  State<QuestionnaireQuestionsView> createState() =>
      _QuestionnaireQuestionsViewState();
}

final class _QuestionnaireQuestionsViewState
    extends State<QuestionnaireQuestionsView> {
  late final PageController _pageController = PageController(
    initialPage: widget.state.currentIndex,
  );

  @override
  void didUpdateWidget(covariant QuestionnaireQuestionsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state.currentIndex == widget.state.currentIndex ||
        !_pageController.hasClients) {
      return;
    }
    _pageController.animateToPage(
      widget.state.currentIndex,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final questionnaire = widget.state.questionnaire!;
    final isLast =
        widget.state.currentIndex == questionnaire.questions.length - 1;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) widget.onBack();
      },
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screen,
                  AppSpacing.lg,
                  AppSpacing.screen,
                  AppSpacing.card,
                ),
                child: _QuestionnaireProgressHeader(
                  current: widget.state.currentIndex + 1,
                  total: questionnaire.questionCount,
                  onBack: widget.onBack,
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: questionnaire.questions.length,
                  itemBuilder: (context, index) {
                    final question = questionnaire.questions[index];
                    return _QuestionContent(
                      question: question,
                      selectedOptionId: widget.state.answers[question.id],
                      onAnswerSelected: widget.onAnswerSelected,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            AppSpacing.sm,
            AppSpacing.screen,
            AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.errorMessage != null) ...[
                Text(
                  widget.errorMessage!,
                  textAlign: TextAlign.center,
                  style: AppTypography.onboardingCardBody.copyWith(
                    color: AppColors.danger,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              QuestionnairePrimaryButton(
                label: isLast
                    ? l10n.questionnaireSubmit
                    : l10n.questionnaireNext,
                onPressed: widget.state.canContinue ? widget.onNext : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _QuestionnaireProgressHeader extends StatelessWidget {
  const _QuestionnaireProgressHeader({
    required this.current,
    required this.total,
    required this.onBack,
  });

  final int current;
  final int total;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final progress = total == 0 ? 0.0 : current / total;
    return Row(
      children: [
        IconButton(
          onPressed: onBack,
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints.tightFor(
            width: AppSpacing.xl,
            height: AppSpacing.xl,
          ),
          iconSize: AppSpacing.section,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        const SizedBox(width: AppSpacing.input),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) => Container(
              height: 3,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: AppColors.mutedSurface,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
                width: constraints.maxWidth * progress,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.input),
        Text(
          l10n.questionnaireProgress(current, total),
          style: AppTypography.onboardingProgress,
        ),
      ],
    );
  }
}

final class _QuestionContent extends StatelessWidget {
  const _QuestionContent({
    required this.question,
    required this.selectedOptionId,
    required this.onAnswerSelected,
  });

  final QuestionnaireQuestion question;
  final String? selectedOptionId;
  final void Function(String questionId, String optionId) onAnswerSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: ValueKey(question.id),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        0,
        AppSpacing.screen,
        AppSpacing.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.sectionName.toUpperCase(),
            style: AppTypography.onboardingFieldLabel.copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.card),
          Text(question.text, style: AppTypography.onboardingSheetTitle),
          const SizedBox(height: AppSpacing.card),
          for (final (index, option) in question.options.indexed) ...[
            QuestionnaireOptionCard(
              option: option,
              selected: selectedOptionId == option.id,
              onPressed: () => onAnswerSelected(question.id, option.id),
            ),
            if (index < question.options.length - 1)
              const SizedBox(height: AppSpacing.inline),
          ],
        ],
      ),
    );
  }
}
