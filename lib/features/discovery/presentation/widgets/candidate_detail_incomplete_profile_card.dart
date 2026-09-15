import 'package:flutter/material.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/extensions/gap_extension.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/candidate.dart';

final class CandidateDetailIncompleteProfileCard extends StatelessWidget {
  const CandidateDetailIncompleteProfileCard({
    required this.candidate,
    super.key,
  });

  final Candidate candidate;

  static bool isIncomplete(Candidate candidate) =>
      _isBlank(candidate.educationLevelName) ||
      _isBlank(candidate.healthStatusName) ||
      _isBlank(candidate.martialStatusName);

  @override
  Widget build(BuildContext context) {
    if (!isIncomplete(candidate)) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    return CustomPaint(
      foregroundPainter: _DashedBorderPainter(
        color: Theme.of(context).colorScheme.outline,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.candidateDetailIncompleteProfileTitle,
                style: AppTypography.candidateDetailCardTitle.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              8.g,
              Text(
                l10n.candidateDetailIncompleteProfileDescription,
                style: AppTypography.candidateDetailBody,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          const Radius.circular(AppRadius.xl),
        ),
      );

    for (final metric in path.computeMetrics()) {
      for (var distance = 0.0; distance < metric.length; distance += 8) {
        final end = (distance + 5).clamp(0.0, metric.length).toDouble();
        canvas.drawPath(metric.extractPath(distance, end), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color;
}

bool _isBlank(String? value) => value == null || value.trim().isEmpty;
