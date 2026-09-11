import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../domain/entities/chat_message.dart';

final class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({
    required this.message,
    required this.isMine,
    required this.replyLabel,
    required this.onReply,
    required this.onQuotedMessagePressed,
    super.key,
  });

  final ChatMessage message;
  final bool isMine;
  final String replyLabel;
  final VoidCallback onReply;
  final VoidCallback onQuotedMessagePressed;

  @override
  Widget build(BuildContext context) {
    final foreground = isMine ? AppColors.surfaceLight : AppColors.text;
    return Dismissible(
      key: ValueKey('chat-reply-${message.id}'),
      direction: DismissDirection.endToStart,
      dismissThresholds: const {DismissDirection.endToStart: 0.18},
      movementDuration: const Duration(milliseconds: 180),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) onReply();
        return false;
      },
      background: const Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.only(right: AppSpacing.md),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.compact),
              child: Icon(
                Icons.reply_rounded,
                size: 18,
                color: AppColors.surfaceLight,
              ),
            ),
          ),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Align(
          alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
          child: Semantics(
            label: replyLabel,
            button: true,
            child: GestureDetector(
              onLongPress: onReply,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 300),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.input,
                  vertical: AppSpacing.md,
                ),
                decoration: BoxDecoration(
                  color: isMine ? AppColors.primary : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: isMine
                      ? Border.all(color: AppColors.primary)
                      : Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (message.replyTo case final quote?) ...[
                      InkWell(
                        onTap: onQuotedMessagePressed,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(
                            left: AppSpacing.compact,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: isMine
                                    ? AppColors.mutedSurface
                                    : AppColors.primary,
                              ),
                            ),
                          ),
                          child: Text(
                            quote.content,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.chatReply.copyWith(
                              color: isMine
                                  ? AppColors.chatReplyOnPrimary
                                  : AppColors.placeholder,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.compact),
                    ],
                    Text(
                      message.content,
                      style: AppTypography.chatBubble.copyWith(
                        color: foreground,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
