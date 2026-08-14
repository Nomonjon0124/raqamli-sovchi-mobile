import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../l10n/app_localizations.dart';

final class QuestionnaireAnalysisView extends StatelessWidget {
  const QuestionnaireAnalysisView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox.square(
                  dimension: 56,
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                    backgroundColor: AppColors.mutedSurface,
                    strokeWidth: 3,
                  ),
                ),
                const SizedBox(height: AppSpacing.screen),
                Text(
                  l10n.questionnaireAnalysisTitle,
                  textAlign: TextAlign.center,
                  style: AppTypography.analysisTitle,
                ),
                const SizedBox(height: AppSpacing.lg),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 270),
                  child: Text(
                    l10n.questionnaireAnalysisBody,
                    textAlign: TextAlign.center,
                    style: AppTypography.onboardingBody,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
