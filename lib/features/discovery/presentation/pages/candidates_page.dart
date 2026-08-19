import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/service_locator.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/extensions/gap_extension.dart';
import '../../../../core/ui/widgets/app_candidate_card.dart';
import '../../../../core/ui/widgets/app_candidate_grid.dart';
import '../../../../core/ui/widgets/app_empty_state.dart';
import '../../../../core/ui/widgets/app_error_view.dart';
import '../../../../core/ui/widgets/app_round_icon_button.dart';
import '../../../../core/ui/widgets/app_screen_header.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/candidate.dart';
import '../../domain/entities/discovery_filter.dart';
import '../bloc/discovery_bloc.dart';
import '../bloc/discovery_event.dart';
import '../bloc/discovery_state.dart';
import '../widgets/candidates_filter_bar.dart';
import '../widgets/survey_prompt_card.dart';

final class CandidatesPage extends StatelessWidget {
  const CandidatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<DiscoveryBloc>()
        ..add(const DiscoveryFetchCandidatesRequested(filter: DiscoveryFilter.matches)),
      child: const _CandidatesPageView(),
    );
  }
}

final class _CandidatesPageView extends StatelessWidget {
  const _CandidatesPageView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final selectedFilter = context.select(
      (DiscoveryBloc bloc) => bloc.state.selectedFilter,
    );
    final hasAnsweredTest = context.select(
      (DiscoveryBloc bloc) => bloc.state.myProfile?.hasAnsweredTest ?? false,
    );

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, AppSpacing.lg),
            sliver: SliverList.list(
              children: [
                AppScreenHeader(
                  title: l10n.candidatesTabLabel,
                  trailing: AppRoundIconButton(
                    icon: Assets.icons.icNotification,
                    semanticLabel: l10n.notificationsActionLabel,
                    showUnreadDot: true,
                    onPressed: () {},
                  ),
                ),
                18.g,
                CandidatesFilterBar(
                  selectedFilter: selectedFilter,
                  onFilterSelected: (filter) => context.read<DiscoveryBloc>().add(
                    DiscoveryFetchCandidatesRequested(filter: filter),
                  ),
                ),
                if (!hasAnsweredTest) ...[
                  18.g,
                  SurveyPromptCard(
                    onPressed: () => context.push(RouteNames.questionnaire),
                  ),
                ],
                18.g,
              ],
            ),
          ),
          BlocBuilder<DiscoveryBloc, DiscoveryState>(
            builder: (context, state) {
              return switch (state.status) {
                DiscoveryStatus.initial || DiscoveryStatus.loading =>
                  const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  ),
                DiscoveryStatus.failure => SliverFillRemaining(
                  child: Center(
                    child: AppErrorView(
                      message: state.errorMessage ?? 'Unknown Error',
                      onRetry: () => context.read<DiscoveryBloc>().add(
                        DiscoveryFetchCandidatesRequested(
                          filter: state.selectedFilter,
                        ),
                      ),
                    ),
                  ),
                ),
                DiscoveryStatus.empty => SliverFillRemaining(
                  child: AppEmptyState(message: l10n.candidatesPlaceholder),
                ),
                DiscoveryStatus.success => SliverPadding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, AppSpacing.xl),
                  sliver: AppCandidateGrid(
                    candidates: _mapEntitiesToUiData(state.candidates, l10n),
                    privatePhotoLabel: l10n.privatePhotoLabel,
                    onCandidateTap: (index) {
                      final candidate = state.candidates[index];
                      context.push(
                        RouteNames.candidateDetail,
                        extra: candidate,
                      );
                    },
                  ),
                ),
              };
            },
          ),
        ],
      ),
    );
  }

  List<AppCandidateCardData> _mapEntitiesToUiData(
    List<Candidate> candidates,
    AppLocalizations l10n,
  ) {
    return candidates.map((c) {
      final ageStr = c.age != null ? ', ${c.age}' : '';
      final nameAge = '${c.firstName}$ageStr';
      final city = c.regionName ?? c.districtName ?? '';

      String? mainImageUrl;
      if (c.photosInfo != null && c.photosInfo!.isNotEmpty) {
        final mainPhoto = c.photosInfo!.firstWhere(
          (p) => p.isMain,
          orElse: () => c.photosInfo!.first,
        );
        if (mainPhoto.image.isNotEmpty) {
          mainImageUrl = mainPhoto.image;
        }
      }

      final matchPercent = c.compatibilityScore != null
          ? '${c.compatibilityScore!.overallScore.round()}%'
          : l10n.matchLockedLabel;

      return AppCandidateCardData(
        nameAge: nameAge,
        city: city,
        matchPercent: matchPercent,
        imageUrl: mainImageUrl,
        image: Assets.images.image1,
      );
    }).toList();
  }
}
