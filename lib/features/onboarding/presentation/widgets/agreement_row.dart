import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';

final class AgreementRow extends StatelessWidget {
  const AgreementRow({
    super.key,
    required this.accepted,
    required this.label,
    required this.onChanged,
  });

  final bool accepted;
  final String label;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!accepted),
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            width: 22,
            height: 22,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: accepted
                  ? AppColors.primary
                  : Theme.of(context).colorScheme.surface,
              border: Border.all(
                color: accepted
                    ? AppColors.primary
                    : Theme.of(context).colorScheme.outline,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(AppRadius.sm - 2),
            ),
            child: accepted
                ? Icon(
                    Icons.check,
                    size: 14,
                    color: Theme.of(context).colorScheme.surface,
                  )
                : null,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(label, style: AppTypography.onboardingPledgeBody),
          ),
        ],
      ),
    );
  }
}
