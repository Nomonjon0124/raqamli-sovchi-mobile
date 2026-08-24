import 'package:flutter/material.dart';

import '../../../../core/extensions/gap_extension.dart';
import '../../../../core/ui/widgets/app_filter_pill.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/discovery_filter.dart';
import '../bloc/discovery_state.dart';
import 'candidates_view_toggle.dart';

final class CandidatesFilterBar extends StatelessWidget {
  const CandidatesFilterBar({
    required this.selectedFilter,
    required this.onFilterSelected,
    required this.viewMode,
    required this.onViewModeChanged,
    this.showViewToggle = false,
    super.key,
  });

  final DiscoveryFilter selectedFilter;
  final ValueChanged<DiscoveryFilter> onFilterSelected;
  final DiscoveryViewMode viewMode;
  final ValueChanged<DiscoveryViewMode> onViewModeChanged;
  final bool showViewToggle;

  static const _filters = DiscoveryFilter.values;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SizedBox(
      height: 44,
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  for (var index = 0; index < _filters.length; index++) ...[
                    if (index > 0) 8.g,
                    AppFilterPill(
                      label: _getFilterLabel(_filters[index], l10n),
                      selected: _filters[index] == selectedFilter,
                      onTap: _filters[index] == selectedFilter
                          ? null
                          : () => onFilterSelected(_filters[index]),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (showViewToggle) ...[
            8.g,
            CandidatesViewToggle(
              viewMode: viewMode,
              onChanged: onViewModeChanged,
            ),
          ],
        ],
      ),
    );
  }

  String _getFilterLabel(DiscoveryFilter filter, AppLocalizations l10n) {
    return switch (filter) {
      DiscoveryFilter.matches => l10n.candidatesFilterMatches,
      DiscoveryFilter.recommended => l10n.candidatesFilterRecommended,
      DiscoveryFilter.nearby => l10n.candidatesFilterNearby,
    };
  }
}
