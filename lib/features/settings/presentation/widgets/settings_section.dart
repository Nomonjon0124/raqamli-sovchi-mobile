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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isLight = theme.brightness == Brightness.light;
    final textColor = isLight ? AppColors.text : colorScheme.onSurface;
    final cardColor = isLight ? AppColors.subtleSurface : colorScheme.surface;
    final dividerColor = isLight
        ? AppColors.mutedSurface
        : colorScheme.outlineVariant;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.settingsSectionTitle.copyWith(color: textColor),
        ),
        const SizedBox(height: AppSpacing.inline),
        DecoratedBox(
          decoration: BoxDecoration(
            color: cardColor,
            border: Border.all(color: dividerColor),
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
                    Divider(
                      height: AppSpacing.hairline,
                      thickness: AppSpacing.hairline,
                      color: dividerColor,
                    ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

final class SettingsRow extends StatelessWidget {
  const SettingsRow({
    required this.title,
    required this.onTap,
    this.icon,
    this.leading,
    this.value,
    super.key,
  }) : assert(icon != null || leading != null);

  final SvgGenImage? icon;
  final Widget? leading;
  final String title;
  final String? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isLight = theme.brightness == Brightness.light;
    final textColor = isLight ? AppColors.text : colorScheme.onSurface;
    final iconColor = isLight
        ? AppColors.bodyText
        : colorScheme.onSurfaceVariant;
    final mutedColor = isLight
        ? AppColors.mutedText
        : colorScheme.onSurfaceVariant;
    return Material(
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
              leading ??
                  icon!.svg(
                    width: 19,
                    height: 19,
                    colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                    excludeFromSemantics: true,
                  ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.settingsRowTitle.copyWith(
                    color: textColor,
                  ),
                ),
              ),
              if (value != null) ...[
                const SizedBox(width: AppSpacing.md),
                Text(
                  value!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.settingsRowValue.copyWith(
                    color: mutedColor,
                  ),
                ),
              ],
              const SizedBox(width: AppSpacing.md),
              Assets.icons.settingsChevron.svg(
                width: 16,
                height: 16,
                colorFilter: ColorFilter.mode(mutedColor, BlendMode.srcIn),
                excludeFromSemantics: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final surfaceColor = theme.brightness == Brightness.light
        ? AppColors.surfaceLight
        : colorScheme.surface;
    return ColoredBox(
      color: surfaceColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.settingsRowVertical,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.settingsRowTitle.copyWith(
                      color: theme.brightness == Brightness.light
                          ? AppColors.text
                          : colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.controlInset),
                  Text(
                    subtitle,
                    style: AppTypography.settingsRowCaption.copyWith(
                      color: theme.brightness == Brightness.light
                          ? AppColors.mutedText
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
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
