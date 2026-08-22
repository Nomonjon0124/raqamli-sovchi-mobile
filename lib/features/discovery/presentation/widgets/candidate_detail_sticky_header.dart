import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/extensions/gap_extension.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../l10n/app_localizations.dart';

final class CandidateDetailStickyHeader extends StatelessWidget {
  const CandidateDetailStickyHeader({
    required this.visible,
    required this.nameAge,
    required this.imageUrl,
    required this.shouldBlur,
    required this.isVerified,
    required this.isSaved,
    required this.isSaving,
    required this.onBack,
    required this.onSave,
    super.key,
  });

  final bool visible;
  final String nameAge;
  final String? imageUrl;
  final bool shouldBlur;
  final bool isVerified;
  final bool isSaved;
  final bool isSaving;
  final VoidCallback onBack;
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    final l10n = AppLocalizations.of(context);
    return IgnorePointer(
      ignoring: !visible,
      child: AnimatedSlide(
        offset: visible ? Offset.zero : const Offset(0, -1),
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        child: AnimatedOpacity(
          opacity: visible ? 1 : 0,
          duration: const Duration(milliseconds: 140),
          child: Material(
            color: Colors.white,
            child: Container(
              padding: EdgeInsets.fromLTRB(22, topInset + 12, 18, 12),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: onBack,
                    tooltip: l10n.backLabel,
                    icon: Assets.icons.icArrowLeft01Round.svg(
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(
                        AppColors.text,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  8.g,
                  _CandidateAvatar(imageUrl: imageUrl, shouldBlur: shouldBlur),
                  8.g,
                  Expanded(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            nameAge,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.candidateDetailCardTitle,
                          ),
                        ),
                        if (isVerified) ...[
                          6.g,
                          const _VerifiedBadge(size: 18),
                        ],
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: isSaving ? null : onSave,
                    tooltip: isSaved
                        ? l10n.candidateDetailUnsave
                        : l10n.candidateDetailSave,
                    icon: Assets.icons.icPreservedBtv.svg(
                      width: 22,
                      height: 22,
                      colorFilter: ColorFilter.mode(
                        isSaved ? AppColors.primary : AppColors.text,
                        BlendMode.srcIn,
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
}

final class CandidateDetailFloatingActions extends StatelessWidget {
  const CandidateDetailFloatingActions({
    required this.visible,
    required this.isSaved,
    required this.isSaving,
    required this.onBack,
    required this.onSave,
    super.key,
  });

  final bool visible;
  final bool isSaved;
  final bool isSaving;
  final VoidCallback onBack;
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return IgnorePointer(
      ignoring: !visible,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: const Duration(milliseconds: 120),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _RoundActionButton(
              label: l10n.backLabel,
              icon: Assets.icons.icArrowLeft01Round.svg(
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(
                  AppColors.text,
                  BlendMode.srcIn,
                ),
              ),
              onPressed: onBack,
            ),
            _RoundActionButton(
              label: isSaved
                  ? l10n.candidateDetailUnsave
                  : l10n.candidateDetailSave,
              icon: Assets.icons.icPreservedBtv.svg(
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  isSaved ? AppColors.primary : AppColors.text,
                  BlendMode.srcIn,
                ),
              ),
              onPressed: isSaving ? null : onSave,
            ),
          ],
        ),
      ),
    );
  }
}

final class _RoundActionButton extends StatelessWidget {
  const _RoundActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final Widget icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    shape: const CircleBorder(),
    elevation: 2,
    shadowColor: Colors.black.withValues(alpha: 0.08),
    child: IconButton(
      onPressed: onPressed,
      tooltip: label,
      icon: icon,
      constraints: const BoxConstraints.tightFor(width: 36, height: 36),
      padding: EdgeInsets.zero,
    ),
  );
}

final class _CandidateAvatar extends StatelessWidget {
  const _CandidateAvatar({required this.imageUrl, required this.shouldBlur});

  final String? imageUrl;
  final bool shouldBlur;

  @override
  Widget build(BuildContext context) {
    final image = imageUrl == null || imageUrl!.trim().isEmpty
        ? const ColoredBox(color: AppColors.mutedSurface)
        : CachedNetworkImage(imageUrl: imageUrl!, fit: BoxFit.cover);
    return ClipOval(
      child: SizedBox(
        width: 28,
        height: 28,
        child: shouldBlur
            ? ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Transform.scale(scale: 1.2, child: image),
              )
            : image,
      ),
    );
  }
}

final class _VerifiedBadge extends StatelessWidget {
  const _VerifiedBadge({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: const BoxDecoration(
      color: AppColors.primary,
      shape: BoxShape.circle,
    ),
    alignment: Alignment.center,
    child: Assets.icons.icVerifyCheck.svg(
      width: size * .6,
      height: size * .6,
      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
    ),
  );
}
