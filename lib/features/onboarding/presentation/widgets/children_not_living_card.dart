import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';

final class ChildrenNotLivingCard extends StatelessWidget {
  const ChildrenNotLivingCard({
    super.key,
    required this.title,
    required this.detail,
    required this.value,
    required this.semanticLabel,
    required this.onChanged,
  });

  final String title;
  final String detail;
  final bool value;
  final String semanticLabel;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      toggled: value,
      label: semanticLabel,
      child: InkWell(
        onTap: () => onChanged(!value),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTypography.onboardingCardTitle),
                    const SizedBox(height: AppSpacing.xs - 2),
                    Text(detail, style: AppTypography.onboardingCardBody),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              _OnboardingToggle(value: value),
            ],
          ),
        ),
      ),
    );
  }
}

final class _OnboardingToggle extends StatelessWidget {
  const _OnboardingToggle({required this.value});

  final bool value;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      width: 44,
      height: 26,
      padding: const EdgeInsets.all(3),
      alignment: value ? Alignment.centerRight : Alignment.centerLeft,
      decoration: BoxDecoration(
        color: value ? AppColors.primary : AppColors.border,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: const DecoratedBox(
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: SizedBox(width: 20, height: 20),
      ),
    );
  }
}
