import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';

final class AppSegmentedControl extends StatelessWidget {
  const AppSegmentedControl({
    required this.labels,
    required this.selectedIndex,
    this.onSelected,
    super.key,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int>? onSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            for (var index = 0; index < labels.length; index++)
              Expanded(
                child: _SegmentItem(
                  label: labels[index],
                  selected: index == selectedIndex,
                  onTap: onSelected == null ? null : () => onSelected!(index),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

final class _SegmentItem extends StatelessWidget {
  const _SegmentItem({required this.label, required this.selected, this.onTap});

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final content = DecoratedBox(
      decoration: BoxDecoration(
        color: selected ? colorScheme.surface : AppColors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.full),
        boxShadow: selected
            ? const [
                BoxShadow(
                  color: AppColors.chipShadow,
                  offset: Offset(0, 5),
                  blurRadius: 8,
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 13,
            height: 18 / 13,
            fontWeight: FontWeight.w600,
            color: selected
                ? colorScheme.onSurface
                : colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
    return Semantics(
      button: onTap != null,
      selected: selected,
      label: label,
      child: onTap == null
          ? content
          : GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTap,
              child: content,
            ),
    );
  }
}
