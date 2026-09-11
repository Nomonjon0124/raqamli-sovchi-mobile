import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../gen/assets.gen.dart';

final class ServiceGridTile extends StatelessWidget {
  const ServiceGridTile({
    required this.icon,
    required this.iconBackground,
    required this.title,
    required this.subtitle,
    required this.onTap,
    super.key,
  });

  final SvgGenImage icon;
  final Color iconBackground;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: AppColors.subtleSurface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.input,
              vertical: AppSpacing.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ServiceIconBox(
                  icon: icon,
                  backgroundColor: iconBackground,
                  size: 40,
                  iconSize: 20,
                ),
                const SizedBox(height: AppSpacing.inline),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.servicesTileTitle,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.servicesCaption,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final class ServiceListTile extends StatelessWidget {
  const ServiceListTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    super.key,
  });

  final SvgGenImage icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.subtleSurface,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.input),
          child: Row(
            children: [
              _ServiceIconBox(
                icon: icon,
                backgroundColor: AppColors.primary,
                size: 40,
                iconSize: 20,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.servicesTileTitle,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.servicesCaption,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Assets.icons.icSrvChervon.svg(
                width: 16,
                height: 16,
                colorFilter: const ColorFilter.mode(
                  AppColors.mapLabelText,
                  BlendMode.srcIn,
                ),
                excludeFromSemantics: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _ServiceIconBox extends StatelessWidget {
  const _ServiceIconBox({
    required this.icon,
    required this.backgroundColor,
    required this.size,
    required this.iconSize,
  });

  final SvgGenImage icon;
  final Color backgroundColor;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: SizedBox.square(
        dimension: size,
        child: Center(
          child: icon.svg(
            width: iconSize,
            height: iconSize,
            excludeFromSemantics: true,
          ),
        ),
      ),
    );
  }
}
