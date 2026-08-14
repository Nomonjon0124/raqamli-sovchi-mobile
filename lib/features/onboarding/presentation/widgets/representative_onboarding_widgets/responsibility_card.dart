import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_radius.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_typography.dart';

final class ResponsibilityCard extends StatelessWidget {
  const ResponsibilityCard({super.key, required this.label, required this.accepted, required this.onChanged});

  final String label;
  final bool accepted;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!accepted),
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.mutedSurface, borderRadius: BorderRadius.circular(AppRadius.lg)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: accepted,
              activeColor: AppColors.primary,
              onChanged: (value) => onChanged(value ?? false),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Text(label, style: AppTypography.onboardingPledgeBody)),
          ],
        ),
      ),
    );
  }
}