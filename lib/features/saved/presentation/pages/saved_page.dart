import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/service_locator.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/ui/widgets/app_candidate_card.dart';
import '../../../../core/ui/widgets/app_candidate_grid.dart';
import '../../../../core/ui/widgets/app_empty_state.dart';
import '../../../../core/ui/widgets/app_error_view.dart';
import '../../../../core/ui/widgets/app_filter_pill.dart';
import '../../../../core/ui/widgets/app_screen_header.dart';
import '../../../../features/discovery/domain/entities/candidate.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/saved_bloc.dart';
import '../bloc/saved_event.dart';
import '../bloc/saved_state.dart';

final class SavedPage extends StatelessWidget {
  const SavedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          serviceLocator<SavedBloc>()..add(const SavedLoadRequested()),
      child: const _SavedPageView(),
    );
  }
}

final class _SavedPageView extends StatelessWidget {
  const _SavedPageView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, AppSpacing.lg),
            sliver: SliverList.list(
              children: [
                AppScreenHeader(title: l10n.savedTabLabel),
                const SizedBox(height: AppSpacing.lg),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      AppFilterPill(label: l10n.savedFilterAll, selected: true),
                      const SizedBox(width: AppSpacing.sm),
                      AppFilterPill(label: l10n.savedFilterInvited),
                      const SizedBox(width: AppSpacing.sm),
                      AppFilterPill(label: l10n.savedFilterWaiting),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                BlocBuilder<SavedBloc, SavedState>(
                  buildWhen: (previous, current) =>
                      previous.candidates.length != current.candidates.length,
                  builder: (context, state) => Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.savedLimitLabel(
                            state.candidates.length,
                            _savedLimit,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: _body13.copyWith(
                            color: const Color(0xFF525252),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Flexible(
                        child: Text(
                          l10n.savedPremiumCta,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                          style: _body13.copyWith(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
          BlocBuilder<SavedBloc, SavedState>(
            builder: (context, state) {
              return switch (state.status) {
                SavedStatus.initial ||
                SavedStatus.loading => const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator.adaptive()),
                ),
                SavedStatus.failure => SliverFillRemaining(
                  child: Center(
                    child: AppErrorView(
                      message: state.errorMessage ?? l10n.genericError,
                      onRetry: () => context.read<SavedBloc>().add(
                        const SavedLoadRequested(),
                      ),
                    ),
                  ),
                ),
                SavedStatus.empty => SliverFillRemaining(
                  child: AppEmptyState(message: l10n.savedEmptyState),
                ),
                SavedStatus.success => SliverPadding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, AppSpacing.lg),
                  sliver: AppCandidateGrid(
                    candidates: _mapCandidates(state.candidates, l10n),
                    privatePhotoLabel: l10n.privatePhotoLabel,
                    onCandidateTap: (index) => context.push(
                      RouteNames.candidateDetailFor(state.candidates[index].id),
                    ),
                  ),
                ),
              };
            },
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, AppSpacing.xl),
            sliver: SliverToBoxAdapter(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocBuilder<SavedBloc, SavedState>(
                        buildWhen: (previous, current) =>
                            previous.candidates.length !=
                            current.candidates.length,
                        builder: (context, state) => Text(
                          l10n.savedUpsellTitle(
                            _remainingSlots(state.candidates.length),
                          ),
                          style: _upsellTitle,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(l10n.savedUpsellMessage, style: _upsellBody),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static List<AppCandidateCardData> _mapCandidates(
    List<Candidate> candidates,
    AppLocalizations l10n,
  ) => candidates.map((candidate) {
    final age = candidate.age == null ? '' : ', ${candidate.age}';
    final photo = candidate.photosInfo?.isEmpty == false
        ? candidate.photosInfo!
              .firstWhere(
                (item) => item.isMain,
                orElse: () => candidate.photosInfo!.first,
              )
              .image
        : null;
    final score = candidate.compatibilityScore;
    return AppCandidateCardData(
      nameAge: '${candidate.firstName}$age',
      city: candidate.regionName ?? candidate.districtName ?? '',
      matchPercent: score == null
          ? l10n.matchLockedLabel
          : '${score.overallScore.round()}%',
      imageUrl: photo?.isEmpty == true ? null : photo,
    );
  }).toList();

  static const _savedLimit = 10;

  static int _remainingSlots(int savedCount) {
    final remaining = _savedLimit - savedCount;
    return remaining < 0 ? 0 : remaining;
  }

  static const _body13 = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 13,
    height: 18 / 13,
    fontWeight: FontWeight.w600,
  );

  static const _upsellTitle = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 14,
    height: 19 / 14,
    fontWeight: FontWeight.w600,
    color: Color(0xFF92400E),
  );

  static const _upsellBody = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 12,
    height: 19 / 12,
    fontWeight: FontWeight.w400,
    color: Color(0xFF92400E),
  );
}
