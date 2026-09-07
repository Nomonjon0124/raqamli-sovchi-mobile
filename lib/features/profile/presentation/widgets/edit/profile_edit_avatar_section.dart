import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_radius.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../l10n/app_localizations.dart';

final class ProfileEditAvatarSection extends StatelessWidget {
  const ProfileEditAvatarSection({
    required this.initials,
    required this.onChangePhoto,
    this.photoUrl,
    this.localPhotoPath,
    this.isUploading = false,
    super.key,
  });

  final String initials;
  final String? photoUrl;
  final String? localPhotoPath;
  final bool isUploading;
  final VoidCallback onChangePhoto;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Row(
      children: [
        SizedBox.square(
          dimension: 64,
          child: ClipOval(
            child: Stack(
              fit: StackFit.expand,
              children: [
                _buildAvatarContent(),
                if (isUploading)
                  Container(
                    color: Colors.black38,
                    child: const Center(
                      child: SizedBox.square(
                        dimension: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.profileEditAvatarTitle,
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 19 / 14,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 6),
              Material(
                color: AppColors.mutedSurface,
                borderRadius: BorderRadius.circular(AppRadius.full),
                child: InkWell(
                  onTap: isUploading ? null : onChangePhoto,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 6,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Assets.icons.profileCamera.svg(
                          width: 13,
                          height: 13,
                          colorFilter: const ColorFilter.mode(
                            AppColors.bodyText,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          l10n.profileEditChangePhoto,
                          style: const TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            height: 15 / 11,
                            color: AppColors.bodyText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarContent() {
    if (localPhotoPath != null && localPhotoPath!.isNotEmpty) {
      return Image.file(File(localPhotoPath!), fit: BoxFit.cover);
    }
    if (photoUrl != null && photoUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: photoUrl!,
        fit: BoxFit.cover,
        placeholder: (_, _) => const ColoredBox(
          color: AppColors.profileAvatarSurface,
          child: Center(
            child: SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
        errorWidget: (_, _, _) => _buildInitials(),
      );
    }
    return _buildInitials();
  }

  Widget _buildInitials() {
    return Container(
      color: AppColors.profileAvatarSurface,
      alignment: Alignment.center,
      child: Text(
        initials.isNotEmpty ? initials : 'SM',
        style: const TextStyle(
          fontFamily: 'Manrope',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
          color: AppColors.profileAvatarText,
        ),
      ),
    );
  }
}
