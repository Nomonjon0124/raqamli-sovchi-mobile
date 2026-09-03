import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../gen/assets.gen.dart';

final class SettingsSection extends StatelessWidget {
  const SettingsSection({
    required this.title,
    required this.children,
    super.key,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: AppTypography.settingsSectionTitle),
      const SizedBox(height: AppSpacing.inline),
      DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.subtleSurface,
          border: Border.all(color: AppColors.mutedSurface),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var index = 0; index < children.length; index++) ...[
                children[index],
                if (index != children.length - 1)
                  const Divider(
                    height: AppSpacing.hairline,
                    thickness: AppSpacing.hairline,
                    color: AppColors.mutedSurface,
                  ),
              ],
            ],
          ),
        ),
      ),
    ],
  );
}

final class SettingsRow extends StatelessWidget {
  const SettingsRow({
    required this.icon,
    required this.title,
    required this.onTap,
    this.value,
    super.key,
  });

  final SvgGenImage icon;
  final String title;
  final String? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.input,
          vertical: AppSpacing.settingsRowVertical,
        ),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  icon.svg(
                    width: 19,
                    height: 19,
                    colorFilter: const ColorFilter.mode(
                      AppColors.bodyText,
                      BlendMode.srcIn,
                    ),
                    excludeFromSemantics: true,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.settingsRowTitle,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (value != null) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    value!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.settingsRowValue,
                  ),
                ],
                const SizedBox(width: AppSpacing.sm),
                Assets.icons.settingsChevron.svg(
                  width: 16,
                  height: 16,
                  colorFilter: const ColorFilter.mode(
                    AppColors.mutedText,
                    BlendMode.srcIn,
                  ),
                  excludeFromSemantics: true,
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

final class SettingsToggleRow extends StatelessWidget {
  const SettingsToggleRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: AppColors.surfaceLight,
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.input,
        vertical: AppSpacing.settingsRowVertical,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.settingsRowTitle),
                const SizedBox(height: AppSpacing.controlInset),
                Text(subtitle, style: AppTypography.settingsRowCaption),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.input),
          _SettingsSwitch(value: value, onChanged: onChanged),
        ],
      ),
    ),
  );
}

final class _SettingsSwitch extends StatelessWidget {
  const _SettingsSwitch({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => Semantics(
    toggled: value,
    button: true,
    child: InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(AppRadius.full),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: 44,
        height: 26,
        padding: const EdgeInsets.all(AppSpacing.controlInset),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        decoration: BoxDecoration(
          color: value ? AppColors.primary : AppColors.border,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Assets.icons.settingsToggleKnob.svg(
          width: 20,
          height: 20,
          excludeFromSemantics: true,
        ),
      ),
    ),
  );
}
