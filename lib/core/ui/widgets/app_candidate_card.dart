import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../gen/assets.gen.dart';
import '../../extensions/gap_extension.dart';

final class AppCandidateCardData {
  const AppCandidateCardData({
    required this.nameAge,
    required this.city,
    required this.matchPercent,
    this.imageUrl,
    this.image,
  });

  final String nameAge;
  final String city;
  final String matchPercent;
  final String? imageUrl;
  final AssetGenImage? image;
}

final class AppCandidateCard extends StatelessWidget {
  const AppCandidateCard({
    required this.candidate,
    required this.privatePhotoLabel,
    this.onTap,
    super.key,
  });

  final AppCandidateCardData candidate;
  final String privatePhotoLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: RepaintBoundary(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 165 / 220,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                      child: Transform.scale(
                        scale: 1.18,
                        child: _buildImage(candidate),
                      ),
                    ),
                    Center(child: _PrivatePhotoPill(label: privatePhotoLabel)),
                    const Positioned(top: 8, right: 8, child: _VerifiedBadge()),
                  ],
                ),
              ),
            ),
            8.g,
            Text(
              candidate.nameAge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                height: 19 / 14,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
            2.g,
            Row(
              children: [
                Flexible(
                  child: Text(
                    '${candidate.city} ·',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      height: 17 / 11,
                      fontWeight: FontWeight.w400,
                      color: AppColors.mutedText,
                    ),
                  ),
                ),
                4.g,
                Text(
                  candidate.matchPercent,
                  style: const TextStyle(
                    fontSize: 11,
                    height: 15 / 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(AppCandidateCardData candidate) {
    final fallbackWidget = const ColoredBox(
      color: AppColors.mutedSurface,
      child: Center(
        child: Icon(Icons.person_rounded, size: 64, color: AppColors.mutedText),
      ),
    );

    if (candidate.imageUrl != null && candidate.imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: candidate.imageUrl!,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.medium,
        placeholder: (context, url) => fallbackWidget,
        errorWidget: (context, url, error) => fallbackWidget,
      );
    }

    return fallbackWidget;
  }
}

final class _PrivatePhotoPill extends StatelessWidget {
  const _PrivatePhotoPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.text,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Assets.icons.icGlyph.svg(
              width: 12,
              height: 12,
              colorFilter: const ColorFilter.mode(
                AppColors.surfaceLight,
                BlendMode.srcIn,
              ),
              excludeFromSemantics: true,
            ),
            5.g,
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                height: 14 / 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
                color: AppColors.surfaceLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _VerifiedBadge extends StatelessWidget {
  const _VerifiedBadge();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: SizedBox(
        width: 22,
        height: 22,
        child: Center(
          child: Assets.icons.icVerifyCheck.svg(
            width: 13,
            height: 13,
            colorFilter: const ColorFilter.mode(
              AppColors.surfaceLight,
              BlendMode.srcIn,
            ),
            excludeFromSemantics: true,
          ),
        ),
      ),
    );
  }
}
