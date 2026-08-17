import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../core/extensions/gap_extension.dart';

final class MatchCategory {
  const MatchCategory({required this.title, required this.percent});

  final String title;
  final int percent;
}

final class CandidateDetailMatchCard extends StatelessWidget {
  const CandidateDetailMatchCard({
    required this.matchPercent,
    required this.scores,
    super.key,
  });

  final int matchPercent;
  final List<MatchCategory> scores;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Umumiy moslik',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 13,
                  height: 18 / 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
              Text(
                '$matchPercent%',
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 24,
                  height: 30 / 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          14.g,
          for (var i = 0; i < scores.length; i++) ...[
            _AnimatedMatchBar(category: scores[i]),
            if (i < scores.length - 1) 14.g,
          ],
        ],
      ),
    );
  }
}

final class _AnimatedMatchBar extends StatelessWidget {
  const _AnimatedMatchBar({required this.category});

  final MatchCategory category;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              category.title,
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 12,
                height: 19 / 12,
                fontWeight: FontWeight.w400,
                color: AppColors.text,
              ),
            ),
            Text(
              '${category.percent}%',
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 12,
                height: 19 / 12,
                fontWeight: FontWeight.w400,
                color: AppColors.mutedText,
              ),
            ),
          ],
        ),
        5.g,
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: category.percent / 100.0),
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) => ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 5,
              color: AppColors.primary,
              backgroundColor: AppColors.mutedSurface,
            ),
          ),
        ),
      ],
    );
  }
}
