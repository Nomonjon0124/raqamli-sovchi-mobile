import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/app/theme/app_status_colors.dart';
import 'package:raqamli_sovchi/app/theme/app_theme.dart';
import 'package:raqamli_sovchi/app/theme/app_typography.dart';

void main() {
  test('light theme exposes approved neutral palette', () {
    final scheme = AppTheme.light.colorScheme;

    expect(scheme.surface, const Color(0xFFFFFFFF));
    expect(scheme.surfaceContainerLow, const Color(0xFFFAFAFA));
    expect(scheme.surfaceContainer, const Color(0xFFF5F5F5));
    expect(scheme.onSurface, const Color(0xFF0A0A0A));
    expect(scheme.onSurfaceVariant, const Color(0xFF737373));
    expect(scheme.outline, const Color(0xFFE5E5E5));
    expect(scheme.primary, const Color(0xFF0474F3));
  });

  test('dark theme exposes approved neutral and status palettes', () {
    final theme = AppTheme.dark;
    final scheme = theme.colorScheme;
    final status = theme.extension<AppStatusColors>();

    expect(scheme.surface, const Color(0xFF0F0F0F));
    expect(scheme.surfaceContainerLow, const Color(0xFF1A1A1A));
    expect(scheme.surfaceContainer, const Color(0xFF242424));
    expect(scheme.onSurface, const Color(0xFFFFFFFF));
    expect(scheme.onSurfaceVariant, const Color(0xFFA3A3A3));
    expect(scheme.outline, const Color(0xFF2E2E2E));
    expect(scheme.primary, const Color(0xFF2A8EFF));
    expect(status!.warningContainer, const Color(0xFF2A1F0A));
    expect(status.successContainer, const Color(0xFF12301F));
    expect(status.infoContainer, const Color(0xFF0C2942));
    expect(status.meetingContainer, const Color(0xFF241F3D));
  });

  test('custom typography leaves foreground color to active theme', () {
    expect(AppTypography.pageTitle.color, isNull);
    expect(AppTypography.chatHeaderName.color, isNull);
    expect(AppTypography.servicesCardBody.color, isNull);
  });
}
