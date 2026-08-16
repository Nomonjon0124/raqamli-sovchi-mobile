import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/ui/widgets/app_empty_state.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/questionnaire.dart';
import 'questionnaire_primary_button.dart';
import 'questionnaire_section_card.dart';

final class QuestionnaireOverview extends StatelessWidget {
  const QuestionnaireOverview({
    required this.questionnaire,
    required this.onStart,
    required this.onLater,
    super.key,
  });

  final Questionnaire questionnaire;
  final VoidCallback onStart;
  final VoidCallback onLater;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final minutes = (questionnaire.questionCount / 4).ceil();

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.section,
            AppSpacing.xl,
            AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.mutedSurface,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.inline,
                    vertical: AppSpacing.xs + 1,
                  ),
                  child: Text(
                    l10n.questionnaireOptionalBadge.toUpperCase(),
                    style: AppTypography.onboardingFieldLabel.copyWith(
                      color: AppColors.bodyText,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.section),
              Text(
                l10n.questionnaireIntroTitle(
                  questionnaire.questionCount,
                  minutes,
                ),
                style: AppTypography.pageTitle,
              ),
              const SizedBox(height: AppSpacing.section),
              Text(
                l10n.questionnaireIntroDescription,
                style: AppTypography.onboardingBody,
              ),
              const SizedBox(height: AppSpacing.section),
              if (questionnaire.sections.isEmpty)
                AppEmptyState(message: l10n.questionnaireEmpty)
              else
                for (final (index, section)
                    in questionnaire.sections.indexed) ...[
                  QuestionnaireSectionCard(
                    number: index + 1,
                    title: section.name,
                    countLabel: l10n.questionnaireQuestionCount(
                      section.questionCount,
                    ),
                  ),
                  if (index < questionnaire.sections.length - 1)
                    const SizedBox(height: AppSpacing.inline),
                ],
              const SizedBox(height: AppSpacing.screen),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.questionnaireWithoutTitle,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      l10n.questionnaireWithoutBody,
                      style: AppTypography.onboardingCardBody,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.sm,
          AppSpacing.xl,
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            QuestionnairePrimaryButton(
              label: l10n.questionnaireStart,
              onPressed: questionnaire.questions.isEmpty ? null : onStart,
            ),
            const SizedBox(height: AppSpacing.sm),
            TextButton(
              onPressed: onLater,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.mutedText,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                textStyle: AppTypography.onboardingAction,
              ),
              child: Text(l10n.questionnaireLater),
            ),
          ],
        ),
      ),
    );
  }
}
