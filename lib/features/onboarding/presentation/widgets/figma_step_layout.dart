import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';

final class FigmaStepLayout extends StatelessWidget {
  const FigmaStepLayout({super.key, required this.title, required this.child, required this.bottom, this.subtitle});

  final String title;
  final String? subtitle;
  final Widget child;
  final Widget bottom;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.onboardingTitle),
        if (subtitle != null) ...[const SizedBox(height: AppSpacing.lg + AppSpacing.xs), Text(subtitle!, style: AppTypography.onboardingBody)],
        const SizedBox(height: AppSpacing.lg + AppSpacing.xs),
        child,
        const Spacer(),
        bottom,
      ],
    );
  }
}