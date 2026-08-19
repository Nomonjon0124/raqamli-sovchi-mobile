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
import '../../../../core/ui/widgets/app_filter_pill.dart';
import '../../../../core/ui/widgets/app_round_icon_button.dart';
import '../../../../core/ui/widgets/app_screen_header.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/candidate.dart';
import '../bloc/discovery_bloc.dart';
import '../bloc/discovery_event.dart';
import '../bloc/discovery_state.dart';
import '../widgets/survey_prompt_card.dart';

final class CandidatesPage extends StatelessWidget {
  const CandidatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<DiscoveryBloc>()
        ..add(const DiscoveryFetchCandidatesRequested(filter: 'matches')),
      child: const _CandidatesPageView(),
    );
  }
}

final class _CandidatesPageView extends StatelessWidget {
  const _CandidatesPageView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final selectedFilter = context.select((DiscoveryBloc bloc) {
      final state = bloc.state;
      return state is DiscoveryLoaded
          ? (state.selectedFilter ?? 'matches')
          : 'matches';
    });

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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      AppFilterPill(
                        label: l10n.candidatesFilterMatches,
                        selected: selectedFilter == 'matches',
                        onTap: () => context.read<DiscoveryBloc>().add(
                          const DiscoveryFetchCandidatesRequested(
                            filter: 'matches',
                          ),
                        ),
                      ),
                      8.g,
                      AppFilterPill(
                        label: l10n.candidatesFilterRecommended,
                        selected: selectedFilter == 'recommended',
                        onTap: () => context.read<DiscoveryBloc>().add(
                          const DiscoveryFetchCandidatesRequested(
                            filter: 'recommended',
                          ),
                        ),
                      ),
                      8.g,
                      AppFilterPill(
                        label: l10n.candidatesFilterNearby,
                        selected: selectedFilter == 'nearby',
                        onTap: () => context.read<DiscoveryBloc>().add(
                          const DiscoveryFetchCandidatesRequested(
                            filter: 'nearby',
                          ),
                        ),
                      ),
                      8.g,
                      AppFilterPill(
                        label: l10n.candidatesFilterRepresentative,
                        selected: selectedFilter == 'representative',
                        onTap: () => context.read<DiscoveryBloc>().add(
                          const DiscoveryFetchCandidatesRequested(
                            filter: 'representative',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                18.g,
                SurveyPromptCard(
                  onPressed: () => context.push(RouteNames.questionnaire),
                ),
                18.g,
              ],
            ),
          ),
          BlocBuilder<DiscoveryBloc, DiscoveryState>(
            builder: (context, state) {
              return switch (state) {
                DiscoveryInitial() || DiscoveryLoading() =>
                  const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  ),
                DiscoveryError(:final message) => SliverFillRemaining(
                  child: Center(
                    child: AppErrorView(
                      message: message,
                      onRetry: () => context.read<DiscoveryBloc>().add(
                        DiscoveryFetchCandidatesRequested(
                          filter: selectedFilter,
                        ),
                      ),
                    ),
                  ),
                ),
                DiscoveryLoaded(:final candidates) when candidates.isEmpty =>
                  SliverFillRemaining(
                    child: AppEmptyState(message: l10n.candidatesPlaceholder),
                  ),
                DiscoveryLoaded(:final candidates) => SliverPadding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, AppSpacing.xl),
                  sliver: AppCandidateGrid(
                    candidates: _mapEntitiesToUiData(candidates, l10n),
                    privatePhotoLabel: l10n.privatePhotoLabel,
                    onCandidateTap: (index) {
                      final candidate = candidates[index];
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
