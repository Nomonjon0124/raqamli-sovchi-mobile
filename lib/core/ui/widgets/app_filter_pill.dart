import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';

final class AppFilterPill extends StatelessWidget {
  const AppFilterPill({
    required this.label,
    this.selected = false,
    this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.full),
        splashColor:
            (selected ? Colors.white : AppColors.primary).withValues(alpha: 0.12),
        highlightColor: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : AppColors.mutedSurface,
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 13,
              height: 18 / 13,
              fontWeight: FontWeight.w600,
              color:
                  selected ? AppColors.surfaceLight : const Color(0xFF525252),
            ),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
