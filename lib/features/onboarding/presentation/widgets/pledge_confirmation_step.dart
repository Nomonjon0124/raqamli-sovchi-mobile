import 'package:flutter/material.dart';
import 'package:raqamli_sovchi/features/onboarding/presentation/widgets/step_layout.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/profile_onboarding_draft.dart';
import 'custom_primary_button.dart';

final class PledgeConfirmationStep extends StatefulWidget {
  const PledgeConfirmationStep({
    super.key,
    required this.title,
    required this.subtitle,
    required this.pointOne,
    required this.pointTwo,
    required this.pointThree,
    required this.buttonLabel,
    required this.onConfirm,
    required this.onPrivacyPressed,
  });

  final String title;
  final String subtitle;
  final String pointOne;
  final String pointTwo;
  final String pointThree;
  final String buttonLabel;
  final VoidCallback onConfirm;
  final VoidCallback onPrivacyPressed;

  @override
  State<PledgeConfirmationStep> createState() => _PledgeConfirmationStepState();
}

final class _PledgeConfirmationStepState extends State<PledgeConfirmationStep> {
  final _accepted = <bool>[false, false, false];

  @override
  Widget build(BuildContext context) {
    return StepLayout(
      step: OnboardingStep.success,
      leading: Center(
        child: Assets.icons.icVerifiedDevice.svg(
          width: 86,
          height: 86,
          excludeFromSemantics: true,
        ),
      ),
      title: widget.title,
      subtitle: widget.subtitle,
      bottom: CustomPrimaryButton(
        label: widget.buttonLabel,
        onPressed: _accepted.every((value) => value) ? widget.onConfirm : null,
      ),
      child: Column(
        children: [
          for (var index = 0; index < 3; index++) ...[
            _PledgeConfirmationCard(
              label: [
                widget.pointOne,
                widget.pointTwo,
                widget.pointThree,
              ][index],
              accepted: _accepted[index],
              onChanged: (value) => setState(() => _accepted[index] = value),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          const SizedBox(height: AppSpacing.sm),
          _PrivacyPolicyLink(onPressed: widget.onPrivacyPressed),
        ],
      ),
    );
  }
}

final class _PledgeConfirmationCard extends StatelessWidget {
  const _PledgeConfirmationCard({
    required this.label,
    required this.accepted,
    required this.onChanged,
  });

  final String label;
  final bool accepted;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      onTap: () => onChanged(!accepted),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md + AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: AppColors.mutedSurface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              width: 22,
              height: 22,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: accepted ? AppColors.primary : Colors.white,
                border: Border.all(
                  color: accepted ? AppColors.primary : AppColors.border,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(AppRadius.sm - 2),
              ),
              child: accepted
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(label, style: AppTypography.onboardingCardBody),
            ),
          ],
        ),
      ),
    );
  }
}

final class _PrivacyPolicyLink extends StatelessWidget {
  const _PrivacyPolicyLink({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              foregroundColor: AppColors.primary,
              textStyle: AppTypography.onboardingBody.copyWith(
                color: AppColors.primary,
                decoration: TextDecoration.underline,
              ),
            ),
            child: Text(l10n.settingsPrivacyPolicy),
          ),
          Text(
            l10n.privacyPolicyAgreementSuffix,
            style: AppTypography.onboardingBody,
          ),
        ],
      ),
    );
  }
}
