import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/discovery_state.dart';

final class CandidatesViewToggle extends StatelessWidget {
  const CandidatesViewToggle({
    required this.viewMode,
    required this.onChanged,
    super.key,
  });

  final DiscoveryViewMode viewMode;
  final ValueChanged<DiscoveryViewMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SizedBox(
      height: 44,
      child: Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.mutedSurface,
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.controlInset),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ViewSegment(
                  semanticLabel: l10n.candidatesViewGrid,
                  assetPath: 'assets/icons/ic_candidate_grid.svg',
                  selected: viewMode == DiscoveryViewMode.grid,
                  onTap: () => onChanged(DiscoveryViewMode.grid),
                ),
                const SizedBox(width: AppSpacing.xxs),
                _ViewSegment(
                  semanticLabel: l10n.candidatesViewMap,
                  assetPath: 'assets/icons/ic_candidate_map.svg',
                  selected: viewMode == DiscoveryViewMode.map,
                  onTap: () => onChanged(DiscoveryViewMode.map),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final class _ViewSegment extends StatelessWidget {
  const _ViewSegment({
    required this.semanticLabel,
    required this.assetPath,
    required this.selected,
    required this.onTap,
  });

  final String semanticLabel;
  final String assetPath;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: semanticLabel,
      child: Material(
        color: selected ? AppColors.surfaceLight : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.full),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: selected ? null : onTap,
          child: SizedBox(
            width: 36,
            height: 28,
            child: Center(
              child: SvgPicture.asset(
                assetPath,
                width: 16,
                height: 16,
                colorFilter: ColorFilter.mode(
                  selected ? AppColors.primary : AppColors.mutedText,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
