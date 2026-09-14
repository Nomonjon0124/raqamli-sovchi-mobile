import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';

final class SettingsLanguageSheet extends StatelessWidget {
  const SettingsLanguageSheet({
    required this.title,
    required this.selectedLocale,
    required this.uzbekLatinLabel,
    required this.uzbekCyrillicLabel,
    required this.russianLabel,
    required this.englishLabel,
    required this.onSelected,
    super.key,
  });

  final String title;
  final Locale selectedLocale;
  final String uzbekLatinLabel;
  final String uzbekCyrillicLabel;
  final String russianLabel;
  final String englishLabel;
  final ValueChanged<Locale> onSelected;

  @override
  Widget build(BuildContext context) => _SettingsPreferenceSheet(
    title: title,
    children: [
      _LanguageOption(
        label: uzbekLatinLabel,
        locale: const Locale('uz'),
        selectedLocale: selectedLocale,
        flag: '🇺🇿',
        onSelected: onSelected,
      ),
      _LanguageOption(
        label: uzbekCyrillicLabel,
        locale: const Locale.fromSubtags(
          languageCode: 'uz',
          scriptCode: 'Cyrl',
        ),
        selectedLocale: selectedLocale,
        flag: '🇺🇿',
        onSelected: onSelected,
      ),
      _LanguageOption(
        label: russianLabel,
        locale: const Locale('ru'),
        selectedLocale: selectedLocale,
        flag: '🇷🇺',
        onSelected: onSelected,
      ),
      _LanguageOption(
        label: englishLabel,
        locale: const Locale('en'),
        selectedLocale: selectedLocale,
        flag: '🇬🇧',
        onSelected: onSelected,
      ),
    ],
  );
}

final class SettingsThemeSheet extends StatelessWidget {
  const SettingsThemeSheet({
    required this.title,
    required this.selectedThemeMode,
    required this.systemLabel,
    required this.lightLabel,
    required this.darkLabel,
    required this.onSelected,
    super.key,
  });

  final String title;
  final ThemeMode selectedThemeMode;
  final String systemLabel;
  final String lightLabel;
  final String darkLabel;
  final ValueChanged<ThemeMode> onSelected;

  @override
  Widget build(BuildContext context) => _SettingsPreferenceSheet(
    title: title,
    children: [
      _ThemeOption(
        label: systemLabel,
        icon: Icons.brightness_auto_outlined,
        mode: ThemeMode.system,
        selectedMode: selectedThemeMode,
        onSelected: onSelected,
      ),
      _ThemeOption(
        label: lightLabel,
        icon: Icons.wb_sunny_outlined,
        mode: ThemeMode.light,
        selectedMode: selectedThemeMode,
        onSelected: onSelected,
      ),
      _ThemeOption(
        label: darkLabel,
        icon: Icons.dark_mode_outlined,
        mode: ThemeMode.dark,
        selectedMode: selectedThemeMode,
        onSelected: onSelected,
      ),
    ],
  );
}

final class _SettingsPreferenceSheet extends StatelessWidget {
  const _SettingsPreferenceSheet({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppRadius.xxl),
      ),
    ),
    child: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.section,
          AppSpacing.xl,
          AppSpacing.section,
          AppSpacing.xxl - AppSpacing.xs,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTypography.settingsSheetTitle.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.inline),
            Divider(height: AppSpacing.hairline, color: _dividerColor(context)),
            const SizedBox(height: AppSpacing.xs),
            ...children,
          ],
        ),
      ),
    ),
  );

  Color _dividerColor(BuildContext context) => Theme.of(context).dividerColor;
}

final class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.label,
    required this.locale,
    required this.selectedLocale,
    required this.flag,
    required this.onSelected,
  });

  final String label;
  final Locale locale;
  final Locale selectedLocale;
  final String flag;
  final ValueChanged<Locale> onSelected;

  @override
  Widget build(BuildContext context) => _PreferenceOption(
    label: label,
    selected: _sameLocale(locale, selectedLocale),
    leading: Text(flag, style: AppTypography.settingsSheetFlag),
    onTap: () => onSelected(locale),
  );
}

final class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.label,
    required this.icon,
    required this.mode,
    required this.selectedMode,
    required this.onSelected,
  });

  final String label;
  final IconData icon;
  final ThemeMode mode;
  final ThemeMode selectedMode;
  final ValueChanged<ThemeMode> onSelected;

  @override
  Widget build(BuildContext context) => _PreferenceOption(
    label: label,
    selected: mode == selectedMode,
    leading: Icon(
      icon,
      size: 24,
      color: Theme.of(context).colorScheme.onSurface,
    ),
    onTap: () => onSelected(mode),
  );
}

final class _PreferenceOption extends StatelessWidget {
  const _PreferenceOption({
    required this.label,
    required this.selected,
    required this.leading,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Widget leading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.settingsRowVertical,
          ),
          child: Row(
            children: [
              SizedBox(width: 24, child: Center(child: leading)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.settingsSheetOption.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              if (selected)
                Icon(Icons.check, color: colorScheme.primary, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}

bool _sameLocale(Locale first, Locale second) =>
    first.languageCode == second.languageCode &&
    first.scriptCode == second.scriptCode;
