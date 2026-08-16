import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';

final class ChildrenCountControl extends StatelessWidget {
  const ChildrenCountControl({
    super.key,
    required this.count,
    required this.enabled,
    required this.decreaseLabel,
    required this.increaseLabel,
    required this.onDecrease,
    required this.onIncrease,
  });

  final int count;
  final bool enabled;
  final String decreaseLabel;
  final String increaseLabel;
  final VoidCallback? onDecrease;
  final VoidCallback? onIncrease;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ChildrenCountAction(label: decreaseLabel, icon: Icons.remove, onPressed: onDecrease),
        const SizedBox(width: AppSpacing.md),
        Container(
          constraints: const BoxConstraints(minWidth: 56, minHeight: 52),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.primary, width: 1.5),
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Text('$count', style: AppTypography.onboardingMeasurementValue.copyWith(color: enabled ? AppColors.primary : AppColors.mutedText)),
        ),
        const SizedBox(width: AppSpacing.md),
        _ChildrenCountAction(label: increaseLabel, icon: Icons.add, onPressed: onIncrease),
      ],
    );
  }
}

final class _ChildrenCountAction extends StatelessWidget {
  const _ChildrenCountAction({required this.label, required this.icon, required this.onPressed});

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: label,
      child: IconButton.filled(
        onPressed: onPressed,
        icon: Icon(icon),
        style: IconButton.styleFrom(
          backgroundColor: AppColors.mutedSurface,
          disabledBackgroundColor: AppColors.mutedSurface,
          foregroundColor: AppColors.bodyText,
          disabledForegroundColor: AppColors.mutedText,
          fixedSize: const Size(40, 40),
          minimumSize: const Size(40, 40),
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
