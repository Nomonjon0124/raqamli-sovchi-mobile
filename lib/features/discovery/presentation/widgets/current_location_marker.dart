import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../l10n/app_localizations.dart';

final class CurrentLocationMarker extends StatelessWidget {
  const CurrentLocationMarker({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SizedBox(
      width: 64,
      height: 82,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Assets.icons.icCurrentLocationHalo.svg(width: 64, height: 64),
          Positioned(
            top: 23,
            child: Assets.icons.icCurrentLocationDot.svg(width: 18, height: 18),
          ),
          Positioned(
            top: 52,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                child: Text(
                  l10n.nearbyYou,
                  style: AppTypography.onboardingFieldLabel.copyWith(
                    color: AppColors.mapLabelText,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
