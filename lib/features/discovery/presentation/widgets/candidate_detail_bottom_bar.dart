import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../core/extensions/gap_extension.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../l10n/app_localizations.dart';

enum CandidateDetailActionVariant { primary, retryLocked }

final class CandidateDetailBottomBar extends StatelessWidget {
  const CandidateDetailBottomBar({
    this.onSendProposal,
    this.onMoreOptions,
    this.actionLabel,
    this.actionVariant = CandidateDetailActionVariant.primary,
    this.isLoading = false,
    super.key,
  });

  final VoidCallback? onSendProposal;
  final VoidCallback? onMoreOptions;
  final String? actionLabel;
  final CandidateDetailActionVariant actionVariant;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        22,
        12,
        22,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 52,
              child: FilledButton(
                onPressed: onSendProposal,
                style: FilledButton.styleFrom(
                  backgroundColor:
                      actionVariant == CandidateDetailActionVariant.retryLocked
                      ? Theme.of(context).colorScheme.errorContainer
                      : AppColors.primary,
                  disabledBackgroundColor:
                      actionVariant == CandidateDetailActionVariant.retryLocked
                      ? Theme.of(context).colorScheme.errorContainer
                      : AppColors.primary,
                  foregroundColor:
                      actionVariant == CandidateDetailActionVariant.retryLocked
                      ? Theme.of(context).colorScheme.onSurfaceVariant
                      : Theme.of(context).colorScheme.onPrimary,
                  disabledForegroundColor:
                      actionVariant == CandidateDetailActionVariant.retryLocked
                      ? Theme.of(context).colorScheme.onSurfaceVariant
                      : Theme.of(context).colorScheme.onPrimary,
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
                        actionLabel ??
                            AppLocalizations.of(
                              context,
                            ).candidateDetailSendProposal,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 15,
                          height: 20 / 15,
                          fontWeight: FontWeight.w600,
                          color: actionVariant == CandidateDetailActionVariant.retryLocked
                              ? Theme.of(context).colorScheme.onSurfaceVariant
                              : Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    if (!isLoading) ...[
                      8.g,
                      Assets.icons.icArrowRight.svg(
                        width: 20,
                        height: 20,
                        colorFilter: ColorFilter.mode(
                          actionVariant ==
                                  CandidateDetailActionVariant.retryLocked
                              ? Theme.of(context).colorScheme.onSurfaceVariant
                              : Theme.of(context).colorScheme.onPrimary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          10.g,
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              shape: BoxShape.circle,
              border: Border.all(color: Theme.of(context).colorScheme.outline),
            ),
            child: InkWell(
              onTap: onMoreOptions,
              customBorder: const CircleBorder(),
              child: Center(
                child: Assets.icons.icMoreHorizontal.svg(width: 20, height: 20, colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.onSurface, BlendMode.srcIn)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
