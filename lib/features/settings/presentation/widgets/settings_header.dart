import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../gen/assets.gen.dart';

final class SettingsHeader extends StatelessWidget {
  const SettingsHeader({
    required this.title,
    required this.backLabel,
    required this.onBack,
    super.key,
  });

  final String title;
  final String backLabel;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Semantics(
          button: true,
          label: backLabel,
          child: Material(
            color: colorScheme.surfaceContainer,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onBack,
              child: SizedBox.square(
                dimension: 36,
                child: Center(
                  child: Assets.icons.icArrowLeft01Round.svg(
                    width: 19,
                    height: 19,
                    colorFilter: ColorFilter.mode(
                      colorScheme.onSurface,
                      BlendMode.srcIn,
                    ),
                    excludeFromSemantics: true,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            title,
            style: AppTypography.settingsPageTitle.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
        ),
        const SizedBox(width: 36),
      ],
    );
  }
}
