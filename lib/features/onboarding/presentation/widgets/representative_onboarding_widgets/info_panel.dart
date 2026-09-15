import 'package:flutter/material.dart';

import 'package:raqamli_sovchi/app/theme/app_status_colors.dart';

import '../../../../../app/theme/app_radius.dart';
import '../../../../../app/theme/app_typography.dart';

enum InfoTone { neutral, warning, success }

final class InfoPanel extends StatelessWidget {
  const InfoPanel({
    super.key,
    required this.title,
    required this.body,
    this.tone = InfoTone.neutral,
  });

  final String title;
  final String body;
  final InfoTone tone;

  @override
  Widget build(BuildContext context) {
    final (background, titleColor, bodyColor) = switch (tone) {
      InfoTone.warning => (
        context.statusColors.warningContainer,
        context.statusColors.onWarningContainer,
        context.statusColors.onWarningContainer,
      ),
      InfoTone.success => (
        context.statusColors.successContainer,
        context.statusColors.onSuccessContainer,
        context.statusColors.onSuccessContainer,
      ),
      InfoTone.neutral => (
        Theme.of(context).colorScheme.surfaceContainerLow,
        Theme.of(context).colorScheme.onSurface,
        Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    };
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.onboardingChip.copyWith(
              color: titleColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: AppTypography.onboardingCardBody.copyWith(
              color: bodyColor,
            ),
          ),
        ],
      ),
    );
  }
}
