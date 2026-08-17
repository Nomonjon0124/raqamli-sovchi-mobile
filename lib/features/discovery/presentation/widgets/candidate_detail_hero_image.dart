import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../core/extensions/gap_extension.dart';
import '../../../../gen/assets.gen.dart';

final class CandidateDetailHeroImage extends StatelessWidget {
  const CandidateDetailHeroImage({
    required this.imageUrl,
    required this.shouldBlur,
    this.onRequestPermission,
    super.key,
  });

  final String? imageUrl;
  final bool shouldBlur;
  final VoidCallback? onRequestPermission;

  @override
  Widget build(BuildContext context) {
    const heroHeight = 330.0;

    final Widget imageContent = imageUrl != null && imageUrl!.isNotEmpty
        ? CachedNetworkImage(
            imageUrl: imageUrl!,
            fit: BoxFit.cover,
            placeholder: (context, url) => Assets.images.image1.image(
              fit: BoxFit.cover,
            ),
            errorWidget: (context, url, error) => Assets.images.image1.image(
              fit: BoxFit.cover,
            ),
          )
        : Assets.images.image1.image(fit: BoxFit.cover);

    return Container(
      height: heroHeight,
      width: double.infinity,
      color: AppColors.mutedSurface,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (shouldBlur)
            ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 9, sigmaY: 9),
              child: Transform.scale(scale: 1.15, child: imageContent),
            )
          else
            imageContent,

          // Lock CTA Pill
          if (shouldBlur)
            Positioned(
              left: 18,
              right: 18,
              bottom: 18,
              child: InkWell(
                onTap: onRequestPermission,
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.text,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Assets.icons.icGlyph.svg(
                          width: 15,
                          height: 15,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                        8.g,
                        const Text(
                          'Rasmni koʻrish uchun ruxsat soʻrash',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 12,
                            height: 16 / 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
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
