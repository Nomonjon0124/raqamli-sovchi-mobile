import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/service_locator.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/ui/widgets/app_error_view.dart';
import '../../../../core/ui/widgets/app_toast.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/blocked_user.dart';
import '../bloc/blocked_users/blocked_users_cubit.dart';
import '../bloc/blocked_users/blocked_users_state.dart';
import '../widgets/blocked_user_tile.dart';

final class BlockedUsersPage extends StatelessWidget {
  const BlockedUsersPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => serviceLocator<BlockedUsersCubit>()..loadBlockedUsers(),
    child: const _BlockedUsersView(),
  );
}

final class _BlockedUsersView extends StatelessWidget {
  const _BlockedUsersView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      body: SafeArea(
        child: BlocConsumer<BlockedUsersCubit, BlockedUsersState>(
          listenWhen: (previous, current) =>
              previous.failure != current.failure ||
              previous.actionSuccessMessage != current.actionSuccessMessage,
          listener: (context, state) {
            if (state.failure != null) {
              AppToast.show(
                context,
                message: l10n.failureMessage(state.failure!.type.name),
              );
            }
            if (state.actionSuccessMessage != null) {
              AppToast.show(
                context,
                message: l10n.unblockSuccess,
                type: ToastType.success,
              );
            }
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.section,
                    AppSpacing.input,
                    AppSpacing.section,
                    AppSpacing.xs,
                  ),
                  child: Row(
                    children: [
                      Semantics(
                        button: true,
                        label: l10n.settingsBack,
                        child: Material(
                          color: AppColors.mutedSurface,
                          shape: const CircleBorder(),
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () => context.pop(),
                            child: SizedBox.square(
                              dimension: 36,
                              child: Center(
                                child: Assets.icons.icArrowLeft01Round.svg(
                                  width: 19,
                                  height: 19,
                                  colorFilter: const ColorFilter.mode(
                                    AppColors.text,
                                    BlendMode.srcIn,
                                  ),
                                  excludeFromSemantics: true,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          l10n.blockedUsersTitle,
                          style: AppTypography.settingsPageTitle,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.section,
                    AppSpacing.xs,
                    AppSpacing.section,
                    AppSpacing.md,
                  ),
                  child: Text(
                    l10n.blockedUsersSubtitle,
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 14,
                      color: AppColors.mutedText,
                      height: 1.4,
                    ),
                  ),
                ),
                Expanded(child: _buildContent(context, state, l10n)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    BlockedUsersState state,
    AppLocalizations l10n,
  ) {
    if (state.status == BlockedUsersStatus.loading &&
        state.blockedUsers.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == BlockedUsersStatus.failure &&
        state.blockedUsers.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screen),
          child: AppErrorView(
            message: l10n.failureMessage(state.failure?.type.name ?? 'unknown'),
            onRetry: () => context.read<BlockedUsersCubit>().loadBlockedUsers(),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<BlockedUsersCubit>().loadBlockedUsers(),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.section,
          AppSpacing.sm,
          AppSpacing.section,
          AppSpacing.xxl,
        ),
        children: [
          if (state.blockedUsers.isEmpty)
            _buildEmptyCard(l10n)
          else
            _buildUsersListCard(context, state.blockedUsers, state),
          const SizedBox(height: AppSpacing.lg),
          _buildInfoNote(l10n),
        ],
      ),
    );
  }

  Widget _buildEmptyCard(AppLocalizations l10n) => Container(
    padding: const EdgeInsets.all(AppSpacing.xl),
    decoration: BoxDecoration(
      color: AppColors.surfaceLight,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Assets.icons.settingsLock.svg(
          width: 40,
          height: 40,
          colorFilter: const ColorFilter.mode(
            AppColors.mutedText,
            BlendMode.srcIn,
          ),
          excludeFromSemantics: true,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          l10n.blockedUsersEmpty,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          l10n.blockedUsersEmptySubtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 13,
            color: AppColors.mutedText,
          ),
        ),
      ],
    ),
  );

  Widget _buildUsersListCard(
    BuildContext context,
    List<BlockedUser> users,
    BlockedUsersState state,
  ) => Container(
    decoration: BoxDecoration(
      color: AppColors.surfaceLight,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.border),
    ),
    clipBehavior: Clip.antiAlias,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < users.length; i++) ...[
          if (i > 0)
            const Divider(height: 1, thickness: 1, color: AppColors.border),
          BlockedUserTile(
            blockedUser: users[i],
            isUnblocking: state.isUnblocking(
              users[i].blockedInfo?.id ?? users[i].blocked,
            ),
            onUnblock: () => _confirmAndUnblock(context, users[i]),
          ),
        ],
      ],
    ),
  );

  Widget _buildInfoNote(AppLocalizations l10n) => Container(
    padding: const EdgeInsets.all(AppSpacing.md),
    decoration: BoxDecoration(
      color: AppColors.subtleSurface,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.border),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Assets.icons.settingsInfo.svg(
          width: 20,
          height: 20,
          colorFilter: const ColorFilter.mode(
            AppColors.mutedText,
            BlendMode.srcIn,
          ),
          excludeFromSemantics: true,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            l10n.blockedUsersNote,
            style: const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 13,
              color: AppColors.mutedText,
              height: 1.4,
            ),
          ),
        ),
      ],
    ),
  );

  Future<void> _confirmAndUnblock(
    BuildContext context,
    BlockedUser user,
  ) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          l10n.unblockConfirmTitle,
          style: const TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          l10n.unblockConfirmMessage,
          style: const TextStyle(
            fontFamily: 'Manrope',
            color: AppColors.bodyText,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              l10n.cancel,
              style: const TextStyle(color: AppColors.mutedText),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              l10n.unblockButton,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final userId = (user.blockedInfo?.id.isNotEmpty ?? false)
          ? user.blockedInfo!.id
          : user.blocked;
      unawaited(
        context.read<BlockedUsersCubit>().unblock(
          userId: userId,
          blockedRecordId: user.id,
        ),
      );
    }
  }
}
