import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/service_locator.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/ui/widgets/app_toast.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../profile/application/use_cases/get_my_profile.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';
import '../widgets/settings_account_actions.dart';
import '../widgets/settings_header.dart';
import '../widgets/settings_section.dart';

final class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => serviceLocator<SettingsCubit>(),
    child: const _SettingsView(),
  );
}

final class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listenWhen: (previous, current) =>
              previous.failure != current.failure && current.failure != null,
          listener: (context, state) => AppToast.show(
            context,
            message: l10n.failureMessage(state.failure!.type.name),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.section,
                  AppSpacing.input,
                  AppSpacing.section,
                  AppSpacing.sm,
                ),
                child: SettingsHeader(
                  title: l10n.settingsTitle,
                  backLabel: l10n.settingsBack,
                  onBack: () => context.pop(),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.section,
                    AppSpacing.card,
                    AppSpacing.section,
                    AppSpacing.xxl,
                  ),
                  children: [
                    SettingsSection(
                      title: l10n.settingsAccountSection,
                      children: [
                        SettingsRow(
                          icon: Assets.icons.settingsEdit,
                          title: l10n.settingsEditProfile,
                          onTap: () => _openEditProfile(context),
                        ),
                        // SettingsRow(
                        //   icon: Assets.icons.settingsImage,
                        //   title: l10n.settingsPhotoPrivacy,
                        //   value: l10n.settingsPhotoPrivacyAll,
                        //   onTap: () => _showComingSoon(context),
                        // ),
                        SettingsRow(
                          icon: Assets.icons.settingsLock,
                          title: l10n.settingsBlockedUsers,
                          onTap: () => context.push(RouteNames.blockedUsers),
                        ),
                        // SettingsRow(
                        //   icon: Assets.icons.settingsShield,
                        //   title: l10n.settingsRecoveryQuestion,
                        //   onTap: () => _showComingSoon(context),
                        // ),
                      ],
                    ),
                    // Maxfiylik va suhbat qismi hozircha ishlatilmaydi
                    // const SizedBox(height: AppSpacing.card),
                    // SettingsSection(
                    //   title: l10n.settingsPrivacyChatSection,
                    //   children: [
                    //     SettingsRow(
                    //       icon: Assets.icons.settingsEye,
                    //       title: l10n.settingsPrivacyVeil,
                    //       onTap: () => _showComingSoon(context),
                    //     ),
                    //     SettingsRow(
                    //       icon: Assets.icons.settingsLock,
                    //       title: l10n.settingsChatLimits,
                    //       value: l10n.settingsChatLimitValue,
                    //       onTap: () => _showComingSoon(context),
                    //     ),
                    //     SettingsRow(
                    //       icon: Assets.icons.settingsParent,
                    //       title: l10n.settingsParentLink,
                    //       onTap: () => _showComingSoon(context),
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(height: AppSpacing.card),
                    SettingsSection(
                      title: l10n.settingsNotificationAppearanceSection,
                      children: [
                        BlocBuilder<SettingsCubit, SettingsState>(
                          buildWhen: (previous, current) =>
                              previous.notificationsEnabled !=
                              current.notificationsEnabled,
                          builder: (context, state) => SettingsToggleRow(
                            title: l10n.settingsNotifications,
                            subtitle: l10n.settingsNotificationsSubtitle,
                            value: state.notificationsEnabled,
                            onChanged: context
                                .read<SettingsCubit>()
                                .notificationsChanged,
                          ),
                        ),
                        SettingsRow(
                          icon: Assets.icons.settingsBell,
                          title: l10n.settingsNotificationTypes,
                          onTap: () => _showComingSoon(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.card),
                    SettingsSection(
                      title: l10n.settingsDocumentsSection,
                      children: [
                        SettingsRow(
                          icon: Assets.icons.settingsInfo,
                          title: l10n.settingsPrivacyPolicy,
                          onTap: () => context.push(RouteNames.privacyPolicy),
                        ),
                        SettingsRow(
                          icon: Assets.icons.settingsDocument,
                          title: l10n.settingsTerms,
                          onTap: () => _showComingSoon(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.card),
                    SettingsSection(
                      title: l10n.settingsHelpInfoSection,
                      children: [
                        SettingsRow(
                          icon: Assets.icons.settingsServices,
                          title: l10n.settingsServices,
                          onTap: () => context.go(RouteNames.services),
                        ),
                        SettingsRow(
                          icon: Assets.icons.settingsSupport,
                          title: l10n.settingsHelpCenter,
                          onTap: () => _showComingSoon(context),
                        ),
                        SettingsRow(
                          icon: Assets.icons.settingsShare,
                          title: l10n.settingsShareApp,
                          onTap: () => _showComingSoon(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    BlocBuilder<AuthBloc, AuthState>(
                      buildWhen: (previous, current) =>
                          previous.status != current.status,
                      builder: (context, state) => SettingsAccountActions(
                        logoutText: l10n.settingsLogout,
                        deleteText: l10n.deleteAccount,
                        isLoading: state.status == AuthStatus.loading,
                        onLogout: () => context.read<AuthBloc>().add(
                          const AuthSignOutRequested(),
                        ),
                        onDelete: () =>
                            context.push(RouteNames.accountDeletion),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openEditProfile(BuildContext context) async {
    final result = await serviceLocator<GetMyProfileUseCase>()();
    if (!context.mounted) return;
    final profile = result.fold((_) => null, (p) => p);
    await context.push(RouteNames.profileEdit, extra: profile);
  }

  void _showComingSoon(BuildContext context) => AppToast.show(
    context,
    message: AppLocalizations.of(context).settingsActionComingSoon,
    type: ToastType.info,
  );
}
