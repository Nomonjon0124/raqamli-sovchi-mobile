
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';

final class HealthStatusOption extends StatelessWidget {
  const HealthStatusOption({super.key, required this.label, required this.selected, required this.onPressed, this.detail});

  final String label;
  final String? detail;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            border: Border.all(color: selected ? AppColors.primary : AppColors.border, width: selected ? 1.5 : 1),
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: AppTypography.onboardingReferenceSelected),
                    if (detail != null) ...[const SizedBox(height: AppSpacing.xs - 2), Text(detail!, style: AppTypography.onboardingCardBody)],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              _HealthRadio(selected: selected),
            ],
          ),
        ),
      ),
    );
  }
}

final class _HealthRadio extends StatelessWidget {
  const _HealthRadio({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : Colors.transparent,
        border: Border.all(color: selected ? AppColors.primary : const Color(0xFFA3A3A3), width: 1.5),
        shape: BoxShape.circle,
      ),
    );
  }
}