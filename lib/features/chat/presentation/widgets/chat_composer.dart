import 'package:flutter/material.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../gen/assets.gen.dart';
import '../../domain/entities/chat_message.dart';

final class ChatComposer extends StatelessWidget {
  const ChatComposer({
    required this.controller,
    required this.placeholder,
    required this.sendLabel,
    required this.replyCancelLabel,
    required this.isSending,
    required this.onChanged,
    required this.onSend,
    required this.onCancelReply,
    this.replyingTo,
    super.key,
  });

  final TextEditingController controller;
  final String placeholder;
  final String sendLabel;
  final String replyCancelLabel;
  final bool isSending;
  final ValueChanged<String> onChanged;
  final VoidCallback onSend;
  final VoidCallback onCancelReply;
  final ChatMessage? replyingTo;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.card,
        AppSpacing.md,
        AppSpacing.card,
        AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(top: BorderSide(color: colorScheme.surfaceContainer)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (replyingTo case final message?) ...[
            _ReplyPreview(
              message: message,
              cancelLabel: replyCancelLabel,
              onCancel: onCancelReply,
            ),
            const SizedBox(height: AppSpacing.inline),
          ],
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: onChanged,
                  onSubmitted: (_) => onSend(),
                  textInputAction: TextInputAction.send,
                  minLines: 1,
                  maxLines: 4,
                  style: AppTypography.body,
                  decoration: InputDecoration(
                    hintText: placeholder,
                    hintStyle: AppTypography.body.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.input,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      borderSide: BorderSide(color: colorScheme.outline),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      borderSide: BorderSide(color: colorScheme.primary),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.inline),
              Semantics(
                label: sendLabel,
                button: true,
                child: SizedBox(
                  width: 44,
                  height: 44,
                  child: FilledButton(
                    onPressed: isSending ? null : onSend,
                    style: FilledButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: const CircleBorder(),
                      backgroundColor: colorScheme.primary,
                    ),
                    child: isSending
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator.adaptive(
                              strokeWidth: AppSpacing.xxs,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                colorScheme.onPrimary,
                              ),
                            ),
                          )
                        : Assets.icons.icChatSend.svg(
                            width: 20,
                            height: 20,
                            colorFilter: ColorFilter.mode(
                              colorScheme.onPrimary,
                              BlendMode.srcIn,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

final class _ReplyPreview extends StatelessWidget {
  const _ReplyPreview({
    required this.message,
    required this.cancelLabel,
    required this.onCancel,
  });

  final ChatMessage message;
  final String cancelLabel;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: AppSpacing.compact),
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: colorScheme.primary)),
            ),
            child: Text(
              message.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.body.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: onCancel,
          tooltip: cancelLabel,
          icon: Assets.icons.icClose.svg(
            width: 18,
            height: 18,
            colorFilter: ColorFilter.mode(
              colorScheme.onSurfaceVariant,
              BlendMode.srcIn,
            ),
          ),
        ),
      ],
    );
  }
}
