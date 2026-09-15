import 'package:flutter/material.dart';

import '../../../../app/theme/app_typography.dart';
import '../../../../gen/assets.gen.dart';

final class AuthLogo extends StatelessWidget {
  const AuthLogo({this.onPrimary = false, this.large = false, super.key});

  final bool onPrimary;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final firstColor = onPrimary
        ? Theme.of(context).colorScheme.onPrimary
        : Theme.of(context).colorScheme.onSurfaceVariant;
    final secondColor = onPrimary
        ? Theme.of(context).colorScheme.onPrimary
        : Theme.of(context).colorScheme.onSurface;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Assets.icons.icLogo.svg(
          width: large ? 38 : 32,
          height: large ? 38 : 32,
        ),
        SizedBox(width: large ? 5 : 4),
        RichText(
          text: TextSpan(
            style: AppTypography.body.copyWith(
              fontSize: large ? 28 : 24,
              height: 1,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.6,
            ),
            children: [
              TextSpan(
                text: 'Raqamli ',
                style: TextStyle(
                  color: firstColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(
                text: 'Sovchi',
                style: TextStyle(color: secondColor),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
