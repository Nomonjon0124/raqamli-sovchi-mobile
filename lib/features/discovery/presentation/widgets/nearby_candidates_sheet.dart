import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/candidate.dart';
import '../../domain/entities/nearby_candidate_cluster.dart';

final class NearbyCandidatesSheet extends StatelessWidget {
  const NearbyCandidatesSheet({
    required this.controller,
    required this.items,
    required this.onCandidateTap,
    required this.onShowAll,
    super.key,
  });

  final DraggableScrollableController controller;
  final List<NearbyCandidateMapItem> items;
  final ValueChanged<String> onCandidateTap;
  final VoidCallback onShowAll;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return DraggableScrollableSheet(
      controller: controller,
      initialChildSize: 0.34,
      minChildSize: 0.24,
      maxChildSize: 0.76,
      snap: true,
      snapSizes: const [0.34, 0.76],
      builder: (context, scrollController) {
        return DecoratedBox(
          decoration: const BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadius.sheet),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.softShadow,
                offset: Offset(0, -3),
                blurRadius: 14,
              ),
            ],
          ),
          child: ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.card,
              AppSpacing.inline,
              AppSpacing.card,
              AppSpacing.lg,
            ),
            itemCount: items.length + 2,
            itemBuilder: (context, index) {
              if (index == 0) {
                return const Center(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.mutedSurface,
                      borderRadius: BorderRadius.all(
                        Radius.circular(AppRadius.full),
                      ),
                    ),
                    child: SizedBox(width: 38, height: 4),
                  ),
                );
              }
              if (index == 1) {
                return Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.nearbyAroundCount(items.length),
                          style: AppTypography.onboardingAction.copyWith(
                            color: AppColors.text,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: items.isEmpty ? null : onShowAll,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                          ),
                          minimumSize: const Size(44, 44),
                        ),
                        child: Text(l10n.nearbyShowAll),
                      ),
                    ],
                  ),
                );
              }

              final item = items[index - 2];
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.inline),
                child: _NearbyCandidateRow(
                  item: item,
                  onTap: () => onCandidateTap(item.candidate.id),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

final class _NearbyCandidateRow extends StatelessWidget {
  const _NearbyCandidateRow({required this.item, required this.onTap});

  final NearbyCandidateMapItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final candidate = item.candidate;
    final zoneName = item.zoneName ?? l10n.nearbyUnknownZone;
    final distance = item.distanceKm < 1
        ? item.distanceKm.toStringAsFixed(1)
        : item.distanceKm.round().toString();
    final score = candidate.compatibilityScore?.overallScore;

    return Material(
      color: AppColors.subtleSurface,
      borderRadius: BorderRadius.circular(AppRadius.md),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.inline,
            AppSpacing.dense,
            AppSpacing.md,
            AppSpacing.dense,
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.mutedSurface,
                  shape: BoxShape.circle,
                ),
                child: Assets.icons.icSquareLock.svg(
                  width: 16,
                  height: 16,
                  colorFilter: const ColorFilter.mode(
                    AppColors.mutedText,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _candidateName(candidate),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.sectionCardTitle,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      l10n.nearbyZoneDistance(zoneName, distance),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.onboardingSelectorLabel.copyWith(
                        color: AppColors.mutedText,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                score == null ? l10n.matchLockedLabel : '${score.round()}%',
                style: AppTypography.sectionCardTitle.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _candidateName(Candidate candidate) {
    final lastInitial = candidate.lastName?.trim();
    final lastName = lastInitial == null || lastInitial.isEmpty
        ? ''
        : ' ${lastInitial.characters.first}.';
    final age = candidate.age == null ? '' : ', ${candidate.age}';
    return '${candidate.firstName}$lastName$age';
  }
}
