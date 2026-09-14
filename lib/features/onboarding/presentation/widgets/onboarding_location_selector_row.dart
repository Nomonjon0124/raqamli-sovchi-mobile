import 'package:flutter/material.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';

final class OnboardingLocationSelectorRow extends StatelessWidget {
  const OnboardingLocationSelectorRow({
    required this.label,
    required this.value,
    required this.onPressed,
    this.isPlaceholder = false,
    super.key,
  });

  final String label;
  final String? value;
  final VoidCallback? onPressed;
  final bool isPlaceholder;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return Semantics(
      button: true,
      enabled: enabled,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border.all(color: Theme.of(context).colorScheme.outline),
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: AppTypography.onboardingSelectorLabel),
                    if (value?.isNotEmpty == true) ...[
                      const SizedBox(height: AppSpacing.xs - 1),
                      Text(
                        value!,
                        style: AppTypography.onboardingSelectorValue.copyWith(
                          color: isPlaceholder || enabled
                              ? Theme.of(context).colorScheme.onSurface
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: enabled
                    ? Theme.of(context).colorScheme.onSurfaceVariant
                    : Theme.of(context).colorScheme.outline,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
