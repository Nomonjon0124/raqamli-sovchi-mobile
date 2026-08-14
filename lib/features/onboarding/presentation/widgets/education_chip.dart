import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_typography.dart';

final class EducationChip extends StatelessWidget {
  const EducationChip({super.key, required this.label, required this.selected, required this.onPressed});

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.full),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            color: selected ? AppColors.subtleSurface : Colors.white,
            border: Border.all(color: selected ? AppColors.primary : AppColors.border, width: 1.5),
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          child: Text(label, style: AppTypography.onboardingChip.copyWith(color: selected ? AppColors.primary : AppColors.bodyText)),
        ),
      ),
    );
  }
}