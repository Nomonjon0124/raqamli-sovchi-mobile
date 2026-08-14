import 'package:flutter/material.dart';
import 'package:raqamli_sovchi/features/onboarding/presentation/widgets/representative_onboarding_widgets/primary_action.dart';
import 'package:raqamli_sovchi/features/onboarding/presentation/widgets/representative_onboarding_widgets/representative_layout.dart';

import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_typography.dart';
import '../../../../../l10n/app_localizations.dart';
import 'info_panel.dart';

final class RepresentativeCandidateConsentView extends StatelessWidget {
  const RepresentativeCandidateConsentView({
    required this.representativeName,
    required this.relation,
    required this.onApprove,
    required this.onReject,
    super.key,
  });

  final String representativeName;
  final String relation;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: RepresentativeLayout(
        eyebrow: l10n.candidateConsentEyebrow,
        title: l10n.candidateConsentTitle,
        subtitle: l10n.candidateConsentBody(representativeName, relation),
        bottom: Column(
          children: [
            PrimaryAction(label: l10n.agreeLabel, onPressed: onApprove),
            const SizedBox(height: AppSpacing.md),
            TextButton(onPressed: onReject, child: Text(l10n.rejectLabel)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoPanel(title: l10n.candidateConsentApproveTitle, body: l10n.candidateConsentApproveBody, tone: InfoTone.success),
            const SizedBox(height: AppSpacing.card),
            Text(l10n.candidateConsentRejectHint, style: AppTypography.onboardingCardBody),
          ],
        ),
      ),
    );
  }
}