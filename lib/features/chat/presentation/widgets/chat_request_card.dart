import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/chat_request_profile.dart';

final class ChatRequestCard extends StatelessWidget {
  const ChatRequestCard({
    required this.request,
    required this.onTap,
    super.key,
  });

  final ChatRequestProfile request;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final name = request.fromProfileName?.trim().isNotEmpty == true
        ? request.fromProfileName!.trim()
        : l10n.chatRequestCandidateFallback;
    final imageUrl = request.fromProfileImageUrl?.trim();

    return Material(
      color: AppColors.subtleSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: const BorderSide(color: AppColors.mutedSurface),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.input),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _RequestAvatar(imageUrl: imageUrl),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.chatRequestCardTitle(name),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.chatRequestCardTitle,
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          l10n.chatRequestProfileUnavailable,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.chatRequestCardBody,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Assets.icons.icArrowRight.svg(
                    width: 18,
                    height: 18,
                    colorFilter: const ColorFilter.mode(
                      AppColors.mutedText,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.mutedSurface,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.inline,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Assets.icons.icInfo.svg(
                        width: 17,
                        height: 17,
                        colorFilter: const ColorFilter.mode(
                          AppColors.mutedText,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          l10n.chatRequestPendingHint,
                          style: AppTypography.chatRequestCardBody,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _RequestAvatar extends StatelessWidget {
  const _RequestAvatar({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    return CircleAvatar(
      radius: 23,
      backgroundColor: AppColors.mutedSurface,
      foregroundImage: url == null || url.isEmpty
          ? null
          : CachedNetworkImageProvider(url),
      child: url == null || url.isEmpty
          ? Assets.icons.icSquareLock.svg(
              width: 18,
              height: 18,
              colorFilter: const ColorFilter.mode(
                AppColors.mutedText,
                BlendMode.srcIn,
              ),
            )
          : null,
    );
  }
}
