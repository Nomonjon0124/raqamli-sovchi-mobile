import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../domain/entities/chat_thread.dart';

final class MessageThreadRow extends StatelessWidget {
  const MessageThreadRow({
    required this.thread,
    required this.name,
    required this.preview,
    required this.isOnline,
    required this.onTap,
    super.key,
  });

  final ChatThread thread;
  final String name;
  final String preview;
  final bool isOnline;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.mutedSurface)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.input,
        ),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: AppSpacing.xl,
                  backgroundColor: AppColors.primaryTranslucent,
                  child: Text(
                    _initials(name),
                    style: AppTypography.chatHeaderName.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
                if (isOnline)
                  const Positioned(
                    right: 0,
                    bottom: 0,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(AppSpacing.xxs),
                        child: SizedBox(
                          width: AppSpacing.sm,
                          height: AppSpacing.sm,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: AppColors.successText,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: AppSpacing.input),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.chatHeaderName,
                  ),
                  const SizedBox(height: AppSpacing.controlInset),
                  Text(
                    preview,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.chatThreadPreview,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

String _initials(String name) => name
    .split(RegExp(r'\s+'))
    .where((part) => part.isNotEmpty)
    .take(2)
    .map((part) => part[0].toUpperCase())
    .join();
