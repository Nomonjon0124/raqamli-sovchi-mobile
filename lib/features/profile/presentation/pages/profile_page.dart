import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/service_locator.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/ui/widgets/app_error_view.dart';
import '../../../../core/ui/widgets/app_toast.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/user_profile.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../widgets/profile_about_card.dart';
import '../widgets/profile_action_tile.dart';
import '../widgets/profile_completion_card.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_hero_card.dart';
import '../widgets/profile_photo_gallery.dart';

final class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) =>
        serviceLocator<ProfileBloc>()..add(const ProfileLoadRequested()),
    child: const _ProfileView(),
  );
}

final class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ColoredBox(
      color: AppColors.surfaceLight,
      child: SafeArea(
        bottom: false,
        child: BlocConsumer<ProfileBloc, ProfileState>(
          listenWhen: (previous, current) =>
              previous.failure != current.failure && current.failure != null,
          listener: (context, state) {
            if (state.profile == null || state.failure == null) return;
            AppToast.show(
              context,
              message: l10n.failureMessage(state.failure!.type.name),
            );
          },
          builder: (context, state) {
            if (state.status == ProfileStatus.loading &&
                state.profile == null) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == ProfileStatus.failure &&
                state.profile == null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.screen),
                  child: AppErrorView(
                    message: l10n.failureMessage(
                      state.failure?.type.name ?? 'unknown',
                    ),
                    onRetry: () => context.read<ProfileBloc>().add(
                      const ProfileLoadRequested(),
                    ),
                  ),
                ),
              );
            }

            final profile = state.profile;
            if (profile == null) return const SizedBox.shrink();

            return RefreshIndicator(
              onRefresh: () => _refresh(context),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.section,
                  AppSpacing.input,
                  AppSpacing.section,
                  AppSpacing.xl,
                ),
                children: [
                  ProfileHeader(
                    title: l10n.profileTabLabel,
                    editLabel: l10n.profileEdit,
                    settingsLabel: l10n.profileSettings,
                    onEdit: () => _openEdit(context, profile),
                    onSettings: () => context.push(RouteNames.settings),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  ProfileHeroCard(
                    profile: profile,
                    identifierText: l10n.profileIdentifier(profile.publicCode),
                    previewText: l10n.profilePreview,
                    copyLabel: l10n.profileCopyIdentifier,
                    onCopy: () => _copyIdentifier(context, profile.publicCode),
                    onPreview: () => _showComingSoon(context),
                  ),
                  if (profile.completionPercent < 100) ...[
                    const SizedBox(height: AppSpacing.lg),
                    ProfileCompletionCard(
                      title: l10n.profileCompleteTitle,
                      subtitle: l10n.profileCompleteSubtitle,
                      percent: profile.completionPercent,
                      onTap: () => _openEdit(context, profile),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  ProfilePhotoGallery(
                    title: l10n.profileMyPhotos,
                    mainLabel: l10n.profileMainPhoto,
                    addLabel: l10n.profileAddPhoto,
                    photoSemantics: l10n.profilePhotoSemantics,
                    photos: profile.photos,
                    onAdd: () => _openEdit(context, profile),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  ProfileAboutCard(
                    sectionTitle: l10n.profileAboutSection,
                    bio: profile.bio,
                    emptyText: l10n.profileNotFilled,
                    addText: profile.bio?.trim().isNotEmpty ?? false
                        ? l10n.profileEditShort
                        : l10n.profileAdd,
                    onTap: () => _openEdit(context, profile),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  ProfileActionTile(
                    icon: Assets.icons.profileCamera,
                    title: l10n.profilePhotoVerification,
                    subtitle: l10n.profilePhotoVerificationSubtitle,
                    onTap: () => _showComingSoon(context),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ProfileActionTile(
                    icon: Assets.icons.icSettings,
                    iconColor: AppColors.primary,
                    title: l10n.profileServices,
                    subtitle: l10n.profileServicesSubtitle,
                    onTap: () => context.go(RouteNames.services),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _openEdit(BuildContext context, UserProfile profile) async {
    final updated = await context.push<bool>(
      RouteNames.profileEdit,
      extra: profile,
    );
    if (updated == true && context.mounted) {
      context.read<ProfileBloc>().add(const ProfileRefreshRequested());
    }
  }

  Future<void> _refresh(BuildContext context) async {
    final bloc = context.read<ProfileBloc>();
    bloc.add(const ProfileRefreshRequested());
    await bloc.stream.firstWhere((state) => !state.isRefreshing);
  }

  Future<void> _copyIdentifier(BuildContext context, String code) async {
    if (code.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: code));
    if (!context.mounted) return;
    AppToast.show(
      context,
      message: AppLocalizations.of(context).profileIdentifierCopied,
      type: ToastType.success,
    );
  }

  void _showComingSoon(BuildContext context) => AppToast.show(
    context,
    message: AppLocalizations.of(context).profileActionComingSoon,
    type: ToastType.info,
  );
}
