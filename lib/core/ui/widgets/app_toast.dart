import 'package:flutter/material.dart';

import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../gen/assets.gen.dart';

enum ToastType { error, warning, info, success }

abstract final class AppToast {
  static void show(
    BuildContext context, {
    required String message,
    ToastType type = ToastType.error,
    Duration duration = const Duration(seconds: 4),
  }) {
    if (message.trim().isEmpty) return;

    debugPrint('[AppToast] Showing toast: type=$type, message=$message');

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();

    final (bgColor, borderColor, textColor, iconColor, icon) = switch (type) {
      ToastType.error => (
        const Color(0xFFFEF2F2),
        const Color(0xFFFCA5A5),
        const Color(0xFF991B1B),
        const Color(0xFFDC2626),
        Assets.icons.icGlyph,
      ),
      ToastType.warning => (
        const Color(0xFFFFFBEB),
        const Color(0xFFFDE68A),
        const Color(0xFF92400E),
        const Color(0xFFD97706),
        Assets.icons.icGlyph,
      ),
      ToastType.info => (
        const Color(0xFFEFF6FF),
        const Color(0xFFBFDBFE),
        const Color(0xFF1E40AF),
        const Color(0xFF2563EB),
        Assets.icons.icNotification,
      ),
      ToastType.success => (
        const Color(0xFFECFDF5),
        const Color(0xFFA7F3D0),
        const Color(0xFF065F46),
        const Color(0xFF059669),
        Assets.icons.icVerifyCheck,
      ),
    };

    messenger.showSnackBar(
      SnackBar(
        elevation: 4,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.zero,
        margin: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        duration: duration,
        content: Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: borderColor, width: 1.2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: 14,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: icon.svg(
                  width: 16,
                  height: 16,
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                  excludeFromSemantics: true,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 13,
                    height: 18 / 13,
                    fontWeight: FontWeight.w600,
                    color: textColor,
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
