import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/extensions/gap_extension.dart';
import '../../../../l10n/app_localizations.dart';

final class CandidateDetailBioSection extends StatelessWidget {
  const CandidateDetailBioSection({required this.bio, super.key});

  final String bio;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            l10n.candidateDetailAbout,
            style: AppTypography.candidateDetailSectionTitle,
          ),
        ),
        8.g,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.subtleSurface,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(bio, style: AppTypography.onboardingPledgeBody),
        ),
      ],
    );
  }
}
