import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';

final class ChatTypingIndicator extends StatefulWidget {
  const ChatTypingIndicator({required this.label, super.key});

  final String label;

  @override
  State<ChatTypingIndicator> createState() => _ChatTypingIndicatorState();
}

final class _ChatTypingIndicatorState extends State<ChatTypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 950),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _controller,
    builder: (context, _) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(widget.label, style: AppTypography.chatHeaderSubtitle),
        const SizedBox(width: AppSpacing.xs),
        for (var index = 0; index < 3; index++)
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.xxs),
            child: Transform.translate(
              offset: Offset(
                0,
                -math.sin((_controller.value * 2 * math.pi) + index * 0.8) *
                    AppSpacing.xs,
              ),
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: SizedBox(width: AppSpacing.xs, height: AppSpacing.xs),
              ),
            ),
          ),
      ],
    ),
  );
}
