import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/questionnaire.dart';
import 'questionnaire_primary_button.dart';

final class QuestionnaireResultView extends StatelessWidget {
  const QuestionnaireResultView({
    required this.result,
    required this.onShowCandidates,
    super.key,
  });

  final QuestionnaireResult result;
  final VoidCallback onShowCandidates;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            AppSpacing.section,
            AppSpacing.screen,
            AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.questionnaireResultTitle,
                style: AppTypography.pinTitle,
              ),
              const SizedBox(height: AppSpacing.section),
              for (final (index, section) in result.sections.indexed) ...[
                _AnimatedResultBar(section: section),
                if (index < result.sections.length - 1)
                  const SizedBox(height: AppSpacing.md),
              ],
              const SizedBox(height: AppSpacing.section),
              _InfoCard(
                title: l10n.questionnaireHonestyTitle,
                body: l10n.questionnaireHonestyBody,
              ),
              const SizedBox(height: AppSpacing.screen),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.input,
                ),
                decoration: BoxDecoration(
                  color: AppColors.subtleSurface,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: Row(
                  children: [
                    Container(
                      width: AppSpacing.screen,
                      height: AppSpacing.screen,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        size: AppSpacing.lg,
                        color: AppColors.surfaceLight,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.inline),
                    Expanded(
                      child: Text(
                        l10n.questionnaireSeriousBadge,
                        style: AppTypography.onboardingBody.copyWith(
                          color: AppColors.text,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
          AppSpacing.screen,
          AppSpacing.sm,
          AppSpacing.screen,
          AppSpacing.lg,
        ),
        child: QuestionnairePrimaryButton(
          label: l10n.questionnaireShowCandidates,
          onPressed: onShowCandidates,
        ),
      ),
    );
  }
}

final class _AnimatedResultBar extends StatelessWidget {
  const _AnimatedResultBar({required this.section});

  final QuestionnaireSectionResult section;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final trait = section.score >= .67
        ? l10n.questionnaireTraitTraditional
        : l10n.questionnaireTraitBalanced;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                section.sectionName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.caption.copyWith(color: AppColors.text),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(trait, style: AppTypography.onboardingCardBody),
          ],
        ),
        const SizedBox(height: AppSpacing.compact),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: section.score),
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) => ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: LinearProgressIndicator(
              value: value,
              minHeight: AppSpacing.compact,
              color: AppColors.primary,
              backgroundColor: AppColors.mutedSurface,
            ),
          ),
        ),
      ],
    );
  }
}

final class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            title,
            style: AppTypography.caption.copyWith(color: AppColors.text),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(body, style: AppTypography.onboardingCardBody),
        ],
      ),
    );
  }
}
