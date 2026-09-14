import 'package:flutter/material.dart';

import 'package:raqamli_sovchi/app/theme/app_status_colors.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../l10n/app_localizations.dart';

enum CandidateActionResultType { proposal, photoPermission }

final class CandidateActionResultPage extends StatelessWidget {
  const CandidateActionResultPage({
    required this.candidateName,
    this.type = CandidateActionResultType.proposal,
    super.key,
  });

  final String candidateName;
  final CandidateActionResultType type;

  bool get isProposal => type == CandidateActionResultType.proposal;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      bottomNavigationBar: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(22, 12, 22, 12),
        child: FilledButton(
          onPressed: () => isProposal
              ? context.go(RouteNames.home)
              : Navigator.of(context).pop(),
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            backgroundColor: AppColors.primary,
            foregroundColor: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  isProposal
                      ? l10n.candidateProposalSentReturn
                      : l10n.candidatePhotoPermissionSentReturn,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 15,
                    height: 20 / 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Assets.icons.icArrowRight.svg(width: 20, height: 20),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Assets.icons.icArrowLeft01Round.svg(
                  width: 20,
                  height: 20,
                ),
                tooltip: l10n.backLabel,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 8, 22, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isProposal)
                      Assets.icons.icSendEmailFly.svg(width: 86, height: 86)
                    else
                      Container(
                        width: 68,
                        height: 68,
                        decoration: BoxDecoration(
                          color: context.statusColors.successContainer,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Assets.icons.icVerifyCheck.svg(
                          width: 32,
                          height: 32,
                          colorFilter: ColorFilter.mode(
                            context.statusColors.onSuccessContainer,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    Text(
                      isProposal
                          ? l10n.candidateProposalSentTitle
                          : l10n.candidatePhotoPermissionSentTitle,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 24,
                        height: 30 / 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isProposal
                          ? l10n.candidateProposalSentDescription(candidateName)
                          : l10n.candidatePhotoPermissionSentDescription(
                              candidateName,
                            ),
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 14,
                        height: 21 / 14,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (isProposal) ...[
                      const SizedBox(height: 16),
                      _ProposalTimeline(candidateName: candidateName),
                      const SizedBox(height: 16),
                      const _ProposalQuota(),
                      const SizedBox(height: 16),
                      const _ProposalNote(),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _ProposalTimeline extends StatelessWidget {
  const _ProposalTimeline({required this.candidateName});

  final String candidateName;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _ResultCard(
      child: Column(
        children: [
          _TimelineRow(
            status: _TimelineStatus.complete,
            label: l10n.candidateProposalSentTimelineSent,
          ),
          _TimelineRow(
            status: _TimelineStatus.active,
            label: l10n.candidateProposalSentTimelineReview(candidateName),
          ),
          _TimelineRow(
            status: _TimelineStatus.pending,
            label: l10n.candidateProposalSentTimelineChat,
          ),
        ],
      ),
    );
  }
}

final class _ProposalQuota extends StatelessWidget {
  const _ProposalQuota();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _ResultCard(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.candidateProposalSentQuotaLabel,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 13,
                    height: 21 / 13,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Text(
                l10n.candidateProposalSentQuotaValue,
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 13,
                  height: 18 / 13,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: SizedBox(
              height: 6,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ColoredBox(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                  ),
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 2 / 3,
                    child: ColoredBox(color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final class _ProposalNote extends StatelessWidget {
  const _ProposalNote();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.statusColors.infoContainer,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Text(
          l10n.candidateProposalSentNote(2),
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 12,
            height: 19 / 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

final class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }
}

enum _TimelineStatus { complete, active, pending }

final class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.status, required this.label});

  final _TimelineStatus status;
  final String label;

  @override
  Widget build(BuildContext context) {
    final isComplete = status == _TimelineStatus.complete;
    final isActive = status == _TimelineStatus.active;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: isComplete
                  ? context.statusColors.successContainer
                  : isActive
                  ? AppColors.primary
                  : Theme.of(context).colorScheme.outline,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: isComplete
                ? Assets.icons.icVerifyCheck.svg(
                    width: 13,
                    height: 13,
                    colorFilter: ColorFilter.mode(
                      context.statusColors.onSuccessContainer,
                      BlendMode.srcIn,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 13,
                height: isComplete ? 18 / 13 : 21 / 13,
                fontWeight: isComplete || isActive
                    ? FontWeight.w600
                    : FontWeight.w400,
                color: isActive || isComplete
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
