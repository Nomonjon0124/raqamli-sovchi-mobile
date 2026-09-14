import 'package:flutter/material.dart';

import '../../../app/theme/app_radius.dart';
import '../../../gen/assets.gen.dart';

final class AppRoundIconButton extends StatelessWidget {
  const AppRoundIconButton({
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
    this.showUnreadDot = false,
    super.key,
  });

  final SvgGenImage icon;
  final String semanticLabel;
  final VoidCallback? onPressed;
  final bool showUnreadDot;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          color: colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(AppRadius.full),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: SizedBox(
              width: 36,
              height: 36,
              child: Center(
                child: icon.svg(
                  width: 20,
                  height: 20,
                  semanticsLabel: semanticLabel,
                  colorFilter: ColorFilter.mode(
                    colorScheme.onSurface,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (showUnreadDot)
          Positioned(
            top: -1,
            right: 0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: const SizedBox(width: 8, height: 8),
            ),
          ),
      ],
    );
  }
}
