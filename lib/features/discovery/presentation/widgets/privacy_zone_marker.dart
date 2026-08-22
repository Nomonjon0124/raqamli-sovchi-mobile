import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/nearby_candidate_cluster.dart';

final class PrivacyZoneMarker extends StatelessWidget {
  const PrivacyZoneMarker({
    required this.cluster,
    required this.diameter,
    super.key,
  });

  final NearbyCandidateCluster cluster;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final zoneName = cluster.zoneName ?? l10n.nearbyUnknownZone;
    final distance = _formatDistance(cluster.distanceKm);

    return RepaintBoundary(
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          CustomPaint(
            painter: const _PrivacyZonePainter(),
            child: SizedBox.square(dimension: diameter),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(AppRadius.full),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.elevatedShadow,
                  offset: Offset(0, 2),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.nearbyCandidateCount(cluster.count),
                    maxLines: 1,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.hairline),
                  Text(
                    l10n.nearbyZoneDistance(zoneName, distance),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.onboardingFieldLabel.copyWith(
                      letterSpacing: 0.2,
                      color: AppColors.placeholder,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDistance(double distanceKm) {
    if (distanceKm < 1) return distanceKm.toStringAsFixed(1);
    return distanceKm.round().toString();
  }
}

final class _PrivacyZonePainter extends CustomPainter {
  const _PrivacyZonePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = math.min(size.width, size.height) / 2 - 1;
    canvas.drawCircle(
      center,
      radius,
      Paint()..color = AppColors.primary.withValues(alpha: 0.16),
    );

    final borderPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.68)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    const dashAngle = 0.09;
    const gapAngle = 0.055;
    for (var start = 0.0; start < math.pi * 2; start += dashAngle + gapAngle) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        dashAngle,
        false,
        borderPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PrivacyZonePainter oldDelegate) => false;
}
