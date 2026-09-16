import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/ui/widgets/app_round_icon_button.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/settings_section.dart';

final class NotificationTypesPage extends StatefulWidget {
  const NotificationTypesPage({super.key});

  @override
  State<NotificationTypesPage> createState() => _NotificationTypesPageState();
}

final class _NotificationTypesPageState extends State<NotificationTypesPage> {
  bool _newMatchEnabled = true;
  bool _newMessageEnabled = true;
  bool _profileViewedEnabled = false;
  bool _psychologistReminderEnabled = true;
  bool _systemMessagesEnabled = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.section,
            AppSpacing.input,
            AppSpacing.section,
            AppSpacing.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  AppRoundIconButton(
                    icon: Assets.icons.icArrowLeft01Round,
                    semanticLabel: l10n.settingsBack,
                    onPressed: context.pop,
                  ),
                  Expanded(
                    child: Text(
                      l10n.settingsNotificationTypesTitle,
                      textAlign: TextAlign.center,
                      style: AppTypography.settingsPageTitle.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(width: 36),
                ],
              ),
              const SizedBox(height: AppSpacing.card),
              Text(
                l10n.settingsNotificationTypesSubtitle,
                style: AppTypography.settingsPageSubtitle.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.card),
              _NotificationTypesCard(
                children: [
                  SettingsToggleRow(
                    title: l10n.settingsNotificationTypeNewMatch,
                    subtitle: l10n.settingsNotificationTypeNewMatchHint,
                    value: _newMatchEnabled,
                    onChanged: _setNewMatchEnabled,
                  ),
                  SettingsToggleRow(
                    title: l10n.settingsNotificationTypeNewMessage,
                    subtitle: l10n.settingsNotificationTypeNewMessageHint,
                    value: _newMessageEnabled,
                    onChanged: _setNewMessageEnabled,
                  ),
                  SettingsToggleRow(
                    title: l10n.settingsNotificationTypeProfileViewed,
                    subtitle: l10n.settingsNotificationTypeProfileViewedHint,
                    value: _profileViewedEnabled,
                    onChanged: _setProfileViewedEnabled,
                  ),
                  SettingsToggleRow(
                    title: l10n.settingsNotificationTypePsychologistReminder,
                    subtitle:
                        l10n.settingsNotificationTypePsychologistReminderHint,
                    value: _psychologistReminderEnabled,
                    onChanged: _setPsychologistReminderEnabled,
                  ),
                  SettingsToggleRow(
                    title: l10n.settingsNotificationTypeSystem,
                    subtitle: l10n.settingsNotificationTypeSystemHint,
                    value: _systemMessagesEnabled,
                    onChanged: _setSystemMessagesEnabled,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _setNewMatchEnabled(bool value) {
    setState(() => _newMatchEnabled = value);
  }

  void _setNewMessageEnabled(bool value) {
    setState(() => _newMessageEnabled = value);
  }

  void _setProfileViewedEnabled(bool value) {
    setState(() => _profileViewedEnabled = value);
  }

  void _setPsychologistReminderEnabled(bool value) {
    setState(() => _psychologistReminderEnabled = value);
  }

  void _setSystemMessagesEnabled(bool value) {
    setState(() => _systemMessagesEnabled = value);
  }
}

final class _NotificationTypesCard extends StatelessWidget {
  const _NotificationTypesCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final borderColor = colorScheme.outlineVariant;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        border: Border.all(color: borderColor),
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
                  color: borderColor,
                ),
            ],
          ],
        ),
      ),
    );
  }
}
