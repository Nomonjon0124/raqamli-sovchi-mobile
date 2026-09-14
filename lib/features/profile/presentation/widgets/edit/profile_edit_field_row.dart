import 'package:flutter/material.dart';

import '../../../../../app/theme/app_radius.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_typography.dart';
import '../../../../../gen/assets.gen.dart';

final class ProfileEditFieldRow extends StatelessWidget {
  const ProfileEditFieldRow({
    required this.label,
    required this.value,
    required this.onTap,
    this.hasChevron = true,
    this.placeholder,
    super.key,
  });

  final String label;
  final String value;
  final String? placeholder;
  final VoidCallback onTap;
  final bool hasChevron;

  @override
  Widget build(BuildContext context) {
    final displayValue = value.trim().isNotEmpty ? value : (placeholder ?? '—');
    final isPlaceholder = value.trim().isEmpty;

    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 13,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: Theme.of(context).colorScheme.outline),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: AppTypography.onboardingFieldLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      displayValue,
                      style: isPlaceholder
                          ? AppTypography.onboardingFieldValue.copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            )
                          : AppTypography.onboardingFieldValue,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (hasChevron) ...[
                const SizedBox(width: AppSpacing.sm),
                Assets.icons.profileChevron.svg(
                  width: 18,
                  height: 18,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.onSurfaceVariant,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
