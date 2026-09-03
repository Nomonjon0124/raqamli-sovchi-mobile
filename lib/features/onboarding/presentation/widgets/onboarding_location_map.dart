import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../gen/assets.gen.dart';

/// Visual preview shown before requesting the device location permission.
final class OnboardingLocationMap extends StatelessWidget {
  const OnboardingLocationMap({required this.isLoading, super.key});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: SizedBox(
        width: double.infinity,
        height: 180,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Assets.images.mapImage.image(fit: BoxFit.cover),
            Center(
              child: Assets.icons.icLocation.svg(
                width: 36,
                height: 36,
                colorFilter: const ColorFilter.mode(
                  AppColors.primary,
                  BlendMode.srcIn,
                ),
                excludeFromSemantics: true,
              ),
            ),
            if (isLoading)
              const ColoredBox(
                color: Color(0x66000000),
                child: Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
