import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/extensions/gap_extension.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/candidate.dart';

final class CandidateDetailIncompleteProfileCard extends StatelessWidget {
  const CandidateDetailIncompleteProfileCard({
    required this.candidate,
    super.key,
  });

  final Candidate candidate;

  static bool isIncomplete(Candidate candidate) =>
      _isBlank(candidate.educationLevelName) ||
      _isBlank(candidate.healthStatusName) ||
      _isBlank(candidate.martialStatusName);

  @override
  Widget build(BuildContext context) {
    if (!isIncomplete(candidate)) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.subtleSurface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.border, style: BorderStyle.solid),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.candidateDetailIncompleteProfileTitle,
              style: AppTypography.candidateDetailCardTitle.copyWith(
                color: AppColors.bodyText,
              ),
            ),
            8.g,
            Text(
              l10n.candidateDetailIncompleteProfileDescription,
              style: AppTypography.candidateDetailBody,
            ),
          ],
        ),
      ),
    );
  }

}

bool _isBlank(String? value) => value == null || value.trim().isEmpty;
