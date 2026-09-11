import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../gen/assets.gen.dart';

final class FeaturedServiceCard extends StatelessWidget {
  const FeaturedServiceCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.rating,
    required this.description,
    required this.tags,
    required this.price,
    required this.actionLabel,
    required this.onTap,
    super.key,
  });

  final SvgGenImage icon;
  final String title;
  final String subtitle;
  final String rating;
  final String description;
  final List<String> tags;
  final String price;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceLight,
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(AppRadius.card),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.card),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _IconBox(icon: icon),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.servicesCardTitle,
                          ),
                          const SizedBox(height: AppSpacing.xxs),
                          Text(
                            subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.servicesCaption,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    _RatingPill(rating: rating),
                  ],
                ),
                const SizedBox(height: AppSpacing.input),
                Text(description, style: AppTypography.servicesCardBody),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [for (final tag in tags) _InfoPill(label: tag)],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        price,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.servicesHeroStatValue.copyWith(
                          color: AppColors.text,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.inline),
                    _ActionButton(label: actionLabel),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final class _IconBox extends StatelessWidget {
  const _IconBox({required this.icon});

  final SvgGenImage icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: SizedBox.square(
        dimension: 48,
        child: Center(
          child: icon.svg(width: 24, height: 24, excludeFromSemantics: true),
        ),
      ),
    );
  }
}

final class _RatingPill extends StatelessWidget {
  const _RatingPill({required this.rating});

  final String rating;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.servicesWarningSurface,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Assets.icons.icSrvPremium.svg(
              width: 12,
              height: 12,
              excludeFromSemantics: true,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              rating,
              style: AppTypography.servicesPill.copyWith(
                color: AppColors.servicesWarningText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.mutedSurface,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        child: Text(label, style: AppTypography.servicesPill),
      ),
    );
  }
}

final class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: AppTypography.servicesAction),
            const SizedBox(width: AppSpacing.compact),
            Assets.icons.icSrvChervon.svg(
              width: 14,
              height: 14,
              excludeFromSemantics: true,
            ),
          ],
        ),
      ),
    );
  }
}
