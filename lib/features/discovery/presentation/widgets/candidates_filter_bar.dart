import 'package:flutter/material.dart';

import '../../../../core/extensions/gap_extension.dart';
import '../../../../core/ui/widgets/app_filter_pill.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/discovery_filter.dart';

final class CandidatesFilterBar extends StatelessWidget {
  const CandidatesFilterBar({
    required this.selectedFilter,
    required this.onFilterSelected,
    super.key,
  });

  final DiscoveryFilter selectedFilter;
  final ValueChanged<DiscoveryFilter> onFilterSelected;

  static const _filters = DiscoveryFilter.values;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _filters.length,
        separatorBuilder: (context, index) => 8.g,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = filter == selectedFilter;
          return AppFilterPill(
            label: _getFilterLabel(filter, l10n),
            selected: isSelected,
            onTap: isSelected ? null : () => onFilterSelected(filter),
          );
        },
      ),
    );
  }

  String _getFilterLabel(DiscoveryFilter filter, AppLocalizations l10n) {
    return switch (filter) {
      DiscoveryFilter.matches => l10n.candidatesFilterMatches,
      DiscoveryFilter.recommended => l10n.candidatesFilterRecommended,
      DiscoveryFilter.nearby => l10n.candidatesFilterNearby,
      DiscoveryFilter.representative => l10n.candidatesFilterRepresentative,
    };
  }
}
