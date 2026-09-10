import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../gen/assets.gen.dart';
import '../../domain/entities/user_profile.dart';

final class ProfilePhotoGallery extends StatelessWidget {
  const ProfilePhotoGallery({
    required this.title,
    required this.mainLabel,
    required this.addLabel,
    required this.photoSemantics,
    required this.photos,
    required this.onAdd,
    required this.onPhotoTap,
    super.key,
  });

  static const maxPhotos = 4;
  static const visibleSlots = 3;

  final String title;
  final String mainLabel;
  final String addLabel;
  final String Function(int index) photoSemantics;
  final List<ProfilePhoto> photos;
  final VoidCallback onAdd;
  final ValueChanged<ProfilePhoto> onPhotoTap;

  @override
  Widget build(BuildContext context) {
    final visiblePhotos = photos.take(visibleSlots).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(title, style: AppTypography.profileSectionLabel),
            ),
            Text(
              '${photos.length.clamp(0, maxPhotos)}/$maxPhotos',
              style: AppTypography.profileSectionLabel,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: List.generate(visibleSlots, (index) {
            final photo = index < visiblePhotos.length
                ? visiblePhotos[index]
                : null;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: index == visibleSlots - 1 ? 0 : AppSpacing.md,
                ),
                child: photo == null
                    ? _AddPhotoSlot(label: addLabel, onTap: onAdd)
                    : _PhotoSlot(
                        photo: photo,
                        mainLabel: mainLabel,
                        semanticLabel: photoSemantics(index + 1),
                        onTap: () => onPhotoTap(photo),
                      ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

final class _PhotoSlot extends StatelessWidget {
  const _PhotoSlot({
    required this.photo,
    required this.mainLabel,
    required this.semanticLabel,
    required this.onTap,
  });

  final ProfilePhoto photo;
  final String mainLabel;
  final String semanticLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    image: true,
    label: semanticLabel,
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: SizedBox(
            height: 132,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: photo.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const ColoredBox(
                    color: AppColors.mutedSurface,
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, url, error) => const ColoredBox(
                    color: AppColors.mutedSurface,
                    child: Icon(
                      Icons.person_rounded,
                      color: AppColors.mutedText,
                    ),
                  ),
                ),
                if (photo.isMain)
                  Positioned(
                    top: AppSpacing.sm,
                    left: AppSpacing.sm,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        child: Text(
                          mainLabel,
                          style: AppTypography.profileMainBadge,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

final class _AddPhotoSlot extends StatelessWidget {
  const _AddPhotoSlot({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label,
    child: Material(
      color: AppColors.subtleSurface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: CustomPaint(
          foregroundPainter: _DashedBorderPainter(),
          child: SizedBox(
            height: 132,
            child: Center(
              child: Assets.icons.profileAdd.svg(
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  AppColors.mutedText,
                  BlendMode.srcIn,
                ),
                excludeFromSemantics: true,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

final class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          const Radius.circular(AppRadius.lg),
        ),
      );
    final metric = path.computeMetrics().first;
    final paint = Paint()
      ..color = AppColors.profileDashedBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    const dashLength = 5.0;
    const gapLength = 4.0;
    for (var distance = 0.0; distance < metric.length;) {
      final end = (distance + dashLength).clamp(0.0, metric.length);
      canvas.drawPath(metric.extractPath(distance, end), paint);
      distance += dashLength + gapLength;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
