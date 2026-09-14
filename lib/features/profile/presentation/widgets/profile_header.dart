import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../gen/assets.gen.dart';

final class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    required this.title,
    required this.editLabel,
    required this.settingsLabel,
    required this.onEdit,
    required this.onSettings,
    super.key,
  });

  final String title;
  final String editLabel;
  final String settingsLabel;
  final VoidCallback onEdit;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTypography.pageTitle.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
        ),
        _HeaderIconButton(
          icon: Assets.icons.icEdit,
          semanticLabel: editLabel,
          onPressed: onEdit,
        ),
        const SizedBox(width: AppSpacing.sm),
        _HeaderIconButton(
          icon: Assets.icons.icSettings,
          semanticLabel: settingsLabel,
          onPressed: onSettings,
        ),
      ],
    );
  }
}

final class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
  });

  final SvgGenImage icon;
  final String semanticLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Semantics(
      button: true,
      label: semanticLabel,
      child: Material(
        color: theme.colorScheme.surfaceContainer,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: SizedBox.square(
            dimension: 36,
            child: Center(
              child: icon.svg(
                width: 18,
                height: 18,
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
    );
  }
}
