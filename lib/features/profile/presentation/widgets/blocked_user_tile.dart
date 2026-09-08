import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/blocked_user.dart';

final class BlockedUserTile extends StatelessWidget {
  const BlockedUserTile({
    required this.blockedUser,
    required this.isUnblocking,
    required this.onUnblock,
    super.key,
  });

  final BlockedUser blockedUser;
  final bool isUnblocking;
  final VoidCallback onUnblock;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final info = blockedUser.blockedInfo;
    final name = (info?.fullName.trim().isNotEmpty ?? false)
        ? info!.fullName.trim()
        : l10n.appTitle; // fallback name
    final initials = info?.initials ?? '??';

    final isComplaint =
        blockedUser.reason != null &&
        (blockedUser.reason!.toLowerCase().contains('complaint') ||
            blockedUser.reason!.toLowerCase().contains('shikoyat'));

    final String subtitle;
    if (isComplaint) {
      subtitle = l10n.blockedAfterComplaint;
    } else if (blockedUser.createdAt != null) {
      final date = blockedUser.createdAt!;
      final formattedDate =
          '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
      subtitle = l10n.blockedAtDate(formattedDate);
    } else {
      subtitle = l10n.settingsBlockedUsers;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.input,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.profileAvatarSurface,
            child: Text(
              initials,
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.profileAvatarText,
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
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 13,
                    color: AppColors.mutedText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Semantics(
            button: true,
            label: l10n.unblockButton,
            child: Material(
              color: AppColors.mutedSurface,
              borderRadius: BorderRadius.circular(18),
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: isUnblocking ? null : onUnblock,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  child: isUnblocking
                      ? const SizedBox.square(
                          dimension: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.text,
                          ),
                        )
                      : Text(
                          l10n.unblockButton,
                          style: const TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.text,
                          ),
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
