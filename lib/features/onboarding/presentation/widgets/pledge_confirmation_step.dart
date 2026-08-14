import 'package:flutter/material.dart';
import 'package:raqamli_sovchi/features/onboarding/presentation/widgets/step_layout.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../domain/entities/profile_onboarding_draft.dart';
import 'custom_primary_button.dart';

final class PledgeConfirmationStep extends StatelessWidget {
  const PledgeConfirmationStep({super.key,
    required this.title,
    required this.subtitle,
    required this.pointOne,
    required this.pointTwo,
    required this.pointThree,
    required this.buttonLabel,
    required this.onConfirm,
  });

  final String title;
  final String subtitle;
  final String pointOne;
  final String pointTwo;
  final String pointThree;
  final String buttonLabel;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return StepLayout(
      step: OnboardingStep.success,
      title: title,
      subtitle: subtitle,
      bottom: CustomPrimaryButton(label: buttonLabel, onPressed: onConfirm),
      child: Column(
        children: [
          for (final point in [pointOne, pointTwo, pointThree]) ...[_PledgeConfirmationCard(label: point), const SizedBox(height: AppSpacing.sm)],
        ],
      ),
    );
  }
}

final class _PledgeConfirmationCard extends StatelessWidget {
  const _PledgeConfirmationCard({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md + AppSpacing.xs),
      decoration: BoxDecoration(color: AppColors.mutedSurface, borderRadius: BorderRadius.circular(AppRadius.lg)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 22),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Text(label, style: AppTypography.onboardingCardBody)),
        ],
      ),
    );
  }
}