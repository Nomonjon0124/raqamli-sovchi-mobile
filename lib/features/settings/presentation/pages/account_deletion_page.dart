import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/ui/widgets/app_round_icon_button.dart';
import '../../../../core/ui/widgets/app_toast.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

final class AccountDeletionPage extends StatefulWidget {
  const AccountDeletionPage({super.key});

  @override
  State<AccountDeletionPage> createState() => _AccountDeletionPageState();
}

enum _DeletionReason { foundMatch, noTime, privacy }

final class _AccountDeletionPageState extends State<AccountDeletionPage> {
  _DeletionReason _reason = _DeletionReason.foundMatch;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          previous.failure != current.failure && current.failure != null,
      listener: (context, state) {
        final failure = state.failure;
        if (failure == null) return;
        AppToast.show(
          context,
          message: l10n.failureMessage(failure.type.name),
          type: ToastType.error,
        );
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.section,
              AppSpacing.input,
              AppSpacing.section,
              AppSpacing.sm,
            ),
            child: BlocBuilder<AuthBloc, AuthState>(
              buildWhen: (previous, current) =>
                  previous.status != current.status,
              builder: (context, state) {
                final isLoading = state.status == AuthStatus.loading;
                return Column(
                  children: [
                    _buildHeader(context, l10n, isLoading),
                    const SizedBox(height: AppSpacing.card),
                    Expanded(
                      child: SingleChildScrollView(child: _buildContent(l10n)),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _buildActions(context, l10n, isLoading),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    AppLocalizations l10n,
    bool isLoading,
  ) {
    return Row(
      children: [
        AppRoundIconButton(
          icon: Assets.icons.icArrowLeft01Round,
          semanticLabel: l10n.settingsBack,
          onPressed: isLoading ? null : () => context.pop(),
        ),
        Expanded(
          child: Text(
            l10n.accountDeletionTitle,
            textAlign: TextAlign.center,
            style: AppTypography.settingsPageTitle,
          ),
        ),
        const SizedBox(width: 36, height: 36),
      ],
    );
  }

  Widget _buildContent(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _WarningCard(l10n: l10n),
        const SizedBox(height: AppSpacing.lg),
        Text(
          l10n.accountDeletionItemsTitle,
          style: AppTypography.profileSectionLabel,
        ),
        const SizedBox(height: AppSpacing.md),
        _DeletedItem(text: l10n.accountDeletionPhotos),
        _DeletedItem(text: l10n.accountDeletionQuestionnaire),
        _DeletedItem(text: l10n.accountDeletionChats),
        _DeletedItem(text: l10n.accountDeletionRepresentative),
        const SizedBox(height: AppSpacing.lg),
        Text(
          l10n.accountDeletionReasonTitle,
          style: AppTypography.profileSectionLabel,
        ),
        const SizedBox(height: AppSpacing.md),
        DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
          ),
          child: Column(
            children: [
              _ReasonTile(
                label: l10n.accountDeletionReasonFoundMatch,
                selected: _reason == _DeletionReason.foundMatch,
                onTap: () =>
                    setState(() => _reason = _DeletionReason.foundMatch),
              ),
              Divider(
                height: 1,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              _ReasonTile(
                label: l10n.accountDeletionReasonNoTime,
                selected: _reason == _DeletionReason.noTime,
                onTap: () => setState(() => _reason = _DeletionReason.noTime),
              ),
              Divider(
                height: 1,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              _ReasonTile(
                label: l10n.accountDeletionReasonPrivacy,
                selected: _reason == _DeletionReason.privacy,
                onTap: () => setState(() => _reason = _DeletionReason.privacy),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActions(
    BuildContext context,
    AppLocalizations l10n,
    bool isLoading,
  ) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton.icon(
            onPressed: isLoading
                ? null
                : () => context.read<AuthBloc>().add(
                    const AuthDeleteAccountRequested(),
                  ),
            icon: isLoading
                ? SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Theme.of(context).colorScheme.onError,
                    ),
                  )
                : const Icon(Icons.delete_outline, size: 20),
            label: Text(l10n.accountDeletionConfirm),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
              disabledBackgroundColor: Theme.of(
                context,
              ).colorScheme.error.withValues(alpha: 0.5),
              disabledForegroundColor: Theme.of(context).colorScheme.onError,
              textStyle: AppTypography.onboardingAction,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton.icon(
            onPressed: isLoading ? null : () => context.pop(),
            icon: Assets.icons.icClose.svg(
              width: 14,
              height: 14,
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onSurface,
                BlendMode.srcIn,
              ),
              excludeFromSemantics: true,
            ),
            label: Text(l10n.accountDeletionCancel),
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onSurface,
              textStyle: AppTypography.onboardingAction,
              side: BorderSide(color: Theme.of(context).colorScheme.outline),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

final class _WarningCard extends StatelessWidget {
  const _WarningCard({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppSpacing.controlInset + 10),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.errorContainer,
      border: Border.all(color: Theme.of(context).colorScheme.error),
      borderRadius: BorderRadius.circular(AppRadius.lg),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 1),
          child: Icon(
            Icons.error_outline,
            color: Theme.of(context).colorScheme.onErrorContainer,
            size: 18,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.accountDeletionWarningTitle,
                style: AppTypography.sectionCardTitle.copyWith(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
              ),
              const SizedBox(height: AppSpacing.controlInset + 1),
              Text(
                l10n.accountDeletionWarningMessage,
                style: AppTypography.caption.copyWith(
                  fontSize: 11,
                  height: 17 / 11,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

final class _DeletedItem extends StatelessWidget {
  const _DeletedItem({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.dense),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 1),
          child: Icon(
            Icons.delete_outline,
            color: Theme.of(context).colorScheme.onErrorContainer,
            size: 15,
          ),
        ),
        const SizedBox(width: AppSpacing.dense),
        Expanded(
          child: Text(
            text,
            style: AppTypography.caption.copyWith(
              fontSize: 12,
              height: 19 / 12,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    ),
  );
}

final class _ReasonTile extends StatelessWidget {
  const _ReasonTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.input),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected
                  ? Theme.of(context).colorScheme.primary
                  : AppColors.transparent,
              border: Border.all(
                color: selected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline,
                width: 1.5,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              label,
              style: AppTypography.onboardingReferenceOption.copyWith(
                fontSize: 14,
                height: 19 / 14,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
