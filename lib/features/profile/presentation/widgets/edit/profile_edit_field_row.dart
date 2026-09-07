import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
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
      color: AppColors.surfaceLight,
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
            border: Border.all(color: AppColors.border),
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
                              color: AppColors.placeholder,
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
                  colorFilter: const ColorFilter.mode(
                    AppColors.placeholder,
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
