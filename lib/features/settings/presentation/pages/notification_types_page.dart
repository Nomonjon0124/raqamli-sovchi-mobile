import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/service_locator.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/ui/widgets/app_round_icon_button.dart';
import '../../../../core/ui/widgets/app_toast.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../notifications/domain/entities/notification_preferences.dart';
import '../../../notifications/presentation/cubit/notification_preferences_cubit.dart';
import '../../../notifications/presentation/cubit/notification_preferences_state.dart';
import '../widgets/settings_section.dart';

final class NotificationTypesPage extends StatelessWidget {
  const NotificationTypesPage({this.cubit, super.key});

  final NotificationPreferencesCubit? cubit;

  @override
  Widget build(BuildContext context) {
    final providedCubit = cubit;
    if (providedCubit != null) {
      return BlocProvider.value(
        value: providedCubit,
        child: const _NotificationTypesView(),
      );
    }

    return BlocProvider(
      create: (_) => serviceLocator<NotificationPreferencesCubit>()..load(),
      child: const _NotificationTypesView(),
    );
  }
}

final class _NotificationTypesView extends StatelessWidget {
  const _NotificationTypesView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<
      NotificationPreferencesCubit,
      NotificationPreferencesState
    >(
      listenWhen: (previous, current) =>
          previous.failure != current.failure && current.failure != null,
      listener: (context, state) => AppToast.show(
        context,
        message: l10n.failureMessage(state.failure!.type.name),
      ),
      child: Scaffold(
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
                BlocBuilder<
                  NotificationPreferencesCubit,
                  NotificationPreferencesState
                >(
                  builder: (context, state) => _NotificationTypesCard(
                    children: [
                      SettingsToggleRow(
                        title: l10n.settingsNotificationTypeNewMatch,
                        subtitle: l10n.settingsNotificationTypeNewMatchHint,
                        value: state.preferences.newMatch,
                        onChanged: (value) => context
                            .read<NotificationPreferencesCubit>()
                            .setPreference(
                              NotificationPreferenceType.newMatch,
                              value,
                            ),
                      ),
                      SettingsToggleRow(
                        title: l10n.settingsNotificationTypeNewMessage,
                        subtitle: l10n.settingsNotificationTypeNewMessageHint,
                        value: state.preferences.newMessage,
                        onChanged: (value) => context
                            .read<NotificationPreferencesCubit>()
                            .setPreference(
                              NotificationPreferenceType.newMessage,
                              value,
                            ),
                      ),
                      SettingsToggleRow(
                        title: l10n.settingsNotificationTypeProfileViewed,
                        subtitle:
                            l10n.settingsNotificationTypeProfileViewedHint,
                        value: state.preferences.profileViewed,
                        onChanged: (value) => context
                            .read<NotificationPreferencesCubit>()
                            .setPreference(
                              NotificationPreferenceType.profileViewed,
                              value,
                            ),
                      ),
                      SettingsToggleRow(
                        title: l10n.settingsNotificationTypeSystem,
                        subtitle: l10n.settingsNotificationTypeSystemHint,
                        value: state.preferences.systemMessages,
                        onChanged: (value) => context
                            .read<NotificationPreferencesCubit>()
                            .setPreference(
                              NotificationPreferenceType.systemMessages,
                              value,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
