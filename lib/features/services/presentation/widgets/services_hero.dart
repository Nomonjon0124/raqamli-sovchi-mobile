import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';

final class ServicesHero extends StatelessWidget {
  const ServicesHero({
    required this.title,
    required this.subtitle,
    required this.stats,
    super.key,
  });

  final String title;
  final String subtitle;
  final List<ServicesHeroStat> stats;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.sheet),
        gradient: const LinearGradient(
          colors: [AppColors.servicesHeroStart, AppColors.servicesHeroEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.sheet),
        child: SizedBox(
          height: 200,
          width: double.infinity,
          child: Stack(
            children: [
              const Positioned(
                right: -80,
                bottom: -130,
                child: _HeroGlow(size: 260),
              ),
              const Positioned(
                right: -40,
                bottom: -170,
                child: _HeroGlow(size: 320),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.section),
                child: SizedBox(
                  width: 306,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTypography.servicesHeroTitle),
                      const SizedBox(height: AppSpacing.sm),
                      Text(subtitle, style: AppTypography.servicesHeroBody),
                      const Spacer(),
                      Row(
                        children: [
                          for (
                            var index = 0;
                            index < stats.length;
                            index++
                          ) ...[
                            if (index > 0)
                              const SizedBox(width: AppSpacing.card),
                            _HeroStat(stat: stats[index]),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class ServicesHeroStat {
  const ServicesHeroStat({required this.value, required this.label});

  final String value;
  final String label;
}

final class _HeroStat extends StatelessWidget {
  const _HeroStat({required this.stat});

  final ServicesHeroStat stat;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            stat.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.servicesHeroStatValue,
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            stat.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.servicesHeroStatLabel,
          ),
        ],
      ),
    );
  }
}

final class _HeroGlow extends StatelessWidget {
  const _HeroGlow({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.surfaceLight.withValues(alpha: .16),
        ),
      ),
      child: SizedBox.square(dimension: size),
    );
  }
}
