import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/extensions/gap_extension.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../l10n/app_localizations.dart';

final class CandidateDetailNoCompatibilityCard extends StatelessWidget {
  const CandidateDetailNoCompatibilityCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.subtleSurface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Assets.icons.icGlyph.svg(
                  width: 18,
                  height: 18,
                  colorFilter: const ColorFilter.mode(
                    AppColors.bodyText,
                    BlendMode.srcIn,
                  ),
                ),
                10.g,
                Text(
                  l10n.candidateDetailCompatibilityUnavailableTitle,
                  style: AppTypography.candidateDetailCardTitle,
                ),
              ],
            ),
            10.g,
            Text(
              l10n.candidateDetailCompatibilityUnavailableDescription,
              style: AppTypography.candidateDetailBody,
            ),
          ],
        ),
      ),
    );
  }
}
