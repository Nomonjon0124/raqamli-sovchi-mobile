import 'package:flutter/material.dart';
import 'package:raqamli_sovchi/features/onboarding/presentation/widgets/representative_onboarding_widgets/primary_action.dart';

import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_typography.dart';
import '../../../../../gen/assets.gen.dart';

final class RepresentativeReadyLayout extends StatelessWidget {
  const RepresentativeReadyLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.primaryLabel,
    required this.secondaryLabel,
    required this.onPressed,
  });

  final String title;
  final String subtitle;
  final String primaryLabel;
  final String secondaryLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: [
          const Spacer(flex: 3),
          Assets.icons.icSmileWink.svg(width: 120, height: 120),
          const SizedBox(height: AppSpacing.card),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.onboardingTitle,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: AppTypography.onboardingBody,
          ),
          const Spacer(flex: 5),
          PrimaryAction(label: primaryLabel, onPressed: onPressed),
          const SizedBox(height: AppSpacing.md),
          TextButton(onPressed: onPressed, child: Text(secondaryLabel)),
        ],
      ),
    );
  }
}
