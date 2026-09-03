import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/service_locator.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/extensions/gap_extension.dart';
import '../../../../core/ui/widgets/app_candidate_card.dart';
import '../../../../core/ui/widgets/app_candidate_grid.dart';
import '../../../../core/ui/widgets/app_empty_state.dart';
import '../../../../core/ui/widgets/app_error_view.dart';
import '../../../../core/ui/widgets/app_round_icon_button.dart';
import '../../../../core/ui/widgets/app_screen_header.dart';
import '../../../../core/ui/widgets/app_toast.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../notifications/presentation/bloc/notification_bloc.dart';
import '../../../notifications/presentation/bloc/notification_event.dart';
import '../../../notifications/presentation/bloc/notification_state.dart';
import '../../domain/entities/candidate.dart';
import '../../domain/entities/discovery_filter.dart';
import '../bloc/discovery_bloc.dart';
import '../bloc/discovery_event.dart';
import '../bloc/discovery_state.dart';
import '../widgets/candidates_filter_bar.dart';
import '../widgets/nearby_candidates_empty_state.dart';
import '../widgets/nearby_candidates_map.dart';
import '../widgets/nearby_location_permission_state.dart';
import '../widgets/nearby_radius_settings_sheet.dart';
import '../widgets/survey_prompt_card.dart';

final class CandidatesPage extends StatelessWidget {
  const CandidatesPage({this.profileRefreshToken, super.key});

  final String? profileRefreshToken;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      key: ValueKey(profileRefreshToken ?? 'candidates-page'),
      providers: [
        BlocProvider(
          create: (_) => serviceLocator<DiscoveryBloc>()
            ..add(
              const DiscoveryFetchCandidatesRequested(
                filter: DiscoveryFilter.matches,
              ),
            ),
        ),
        BlocProvider(
          create: (_) =>
              serviceLocator<NotificationsBloc>()
                ..add(const NotificationsLoadRequested()),
        ),
      ],
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
    final discoveryStatus = context.select(
      (DiscoveryBloc bloc) => bloc.state.status,
    );
    final viewMode = context.select(
      (DiscoveryBloc bloc) => bloc.state.viewMode,
    );
    final myProfile = context.select(
      (DiscoveryBloc bloc) => bloc.state.myProfile,
    );
    final currentLocation = context.select(
      (DiscoveryBloc bloc) => bloc.state.currentLocation,
    );
    final nearbyClusters = context.select(
      (DiscoveryBloc bloc) => bloc.state.nearbyClusters,
    );
    final nearbyMapItems = context.select(
      (DiscoveryBloc bloc) => bloc.state.nearbyMapItems,
    );
    final nearbyRadiusKm = context.select(
      (DiscoveryBloc bloc) => bloc.state.nearbyRadiusKm,
    );

    final Widget content;
    if (discoveryStatus == DiscoveryStatus.success &&
        selectedFilter == DiscoveryFilter.nearby &&
        viewMode == DiscoveryViewMode.map &&
        currentLocation != null) {
      content = SafeArea(
        bottom: false,
        child: NearbyCandidatesMap(
          currentLocation: currentLocation,
          clusters: nearbyClusters,
          items: nearbyMapItems,
          radiusKm: nearbyRadiusKm,
          onRadiusPressed: () =>
              _showNearbySettings(context, context.read<DiscoveryBloc>().state),
          onCandidateTap: (candidateId) async {
            final result = await context.push<bool?>(
              RouteNames.candidateDetailFor(candidateId),
            );
            if (context.mounted && result == true) {
              context.read<DiscoveryBloc>().add(
                const DiscoveryRefreshCandidatesRequested(),
              );
            }
          },
          onMapClosed: () => context.read<DiscoveryBloc>().add(
            const DiscoveryViewModeChanged(DiscoveryViewMode.grid),
          ),
          onViewModeChanged: (mode) =>
              context.read<DiscoveryBloc>().add(DiscoveryViewModeChanged(mode)),
        ),
      );
    } else {
      content = SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            final bloc = context.read<DiscoveryBloc>();
            bloc.add(const DiscoveryRefreshCandidatesRequested());
            await bloc.stream
                .firstWhere((state) => state.status != DiscoveryStatus.loading)
                .timeout(
                  const Duration(seconds: 10),
                  onTimeout: () => bloc.state,
                );
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, AppSpacing.lg),
                sliver: SliverList.list(
                  children: [
                    AppScreenHeader(
                      title: l10n.candidatesTabLabel,
                      trailing:
                          BlocSelector<
                            NotificationsBloc,
                            NotificationsState,
                            bool
                          >(
                            selector: (state) => state.unreadCount > 0,
                            builder: (context, hasUnread) => AppRoundIconButton(
                              icon: Assets.icons.icNotification,
                              semanticLabel: l10n.notificationsActionLabel,
                              showUnreadDot: hasUnread,
                              onPressed: () =>
                                  context.push(RouteNames.notifications),
                            ),
                          ),
                    ),
                    18.g,
                    CandidatesFilterBar(
                      selectedFilter: selectedFilter,
                      viewMode: viewMode,
                      showViewToggle:
                          selectedFilter == DiscoveryFilter.nearby &&
                          discoveryStatus != DiscoveryStatus.permissionRequired,
                      onFilterSelected: (filter) =>
                          context.read<DiscoveryBloc>().add(
                            DiscoveryFetchCandidatesRequested(filter: filter),
                          ),
                      onViewModeChanged: (mode) => context
                          .read<DiscoveryBloc>()
                          .add(DiscoveryViewModeChanged(mode)),
                    ),
                    if (myProfile != null &&
                        !myProfile.hasAnsweredTest &&
                        selectedFilter != DiscoveryFilter.nearby) ...[
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
                    DiscoveryStatus.initial ||
                    DiscoveryStatus.loading => const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    ),
                    DiscoveryStatus.failure => SliverFillRemaining(
                      child: Center(
                        child: AppErrorView(
                          message: state.errorMessage ?? l10n.genericError,
                          onRetry: () => context.read<DiscoveryBloc>().add(
                            DiscoveryFetchCandidatesRequested(
                              filter: state.selectedFilter,
                            ),
                          ),
                        ),
                      ),
                    ),
                    DiscoveryStatus.permissionRequired => SliverFillRemaining(
                      child: NearbyLocationPermissionState(
                        accessStatus: state.locationAccessStatus,
                        isLoading: state.isLocationOperationInProgress,
                        onPrimaryPressed: () =>
                            context.read<DiscoveryBloc>().add(
                              const DiscoveryNearbyLocationActionRequested(),
                            ),
                        onDismissed: () => context.read<DiscoveryBloc>().add(
                          const DiscoveryNearbyPermissionDismissed(),
                        ),
                      ),
                    ),
                    DiscoveryStatus.empty
                        when state.selectedFilter == DiscoveryFilter.nearby =>
                      SliverFillRemaining(
                        child: NearbyCandidatesEmptyState(
                          radiusKm: state.nearbyRadiusKm,
                          notificationsEnabled:
                              state.areNearbyNotificationsEnabled,
                          onExpandRadius: () =>
                              context.read<DiscoveryBloc>().add(
                                DiscoveryNearbySettingsSaved(
                                  radiusKm: 25,
                                  isProfileVisible:
                                      state.isNearbyProfileVisible,
                                  audience: state.nearbyVisibilityAudience,
                                ),
                              ),
                          onChangeCriteria: () =>
                              _showNearbySettings(context, state),
                          onNotificationsChanged: (value) => context
                              .read<DiscoveryBloc>()
                              .add(DiscoveryNearbyNotificationsChanged(value)),
                        ),
                      ),
                    DiscoveryStatus.empty => SliverFillRemaining(
                      child: AppEmptyState(message: l10n.candidatesPlaceholder),
                    ),
                    DiscoveryStatus.success => SliverPadding(
                      padding: const EdgeInsets.fromLTRB(
                        18,
                        0,
                        18,
                        AppSpacing.xl,
                      ),
                      sliver: AppCandidateGrid(
                        candidates: _mapEntitiesToUiData(
                          state.candidates,
                          l10n,
                        ),
                        privatePhotoLabel: l10n.privatePhotoLabel,
                        onCandidateTap: (index) async {
                          final candidate = state.candidates[index];
                          final result = await context.push<bool?>(
                            RouteNames.candidateDetailFor(candidate.id),
                          );
                          if (context.mounted && result == true) {
                            context.read<DiscoveryBloc>().add(
                              const DiscoveryRefreshCandidatesRequested(),
                            );
                          }
                        },
                      ),
                    ),
                  };
                },
              ),
            ],
          ),
        ),
      );
    }

    return BlocListener<DiscoveryBloc, DiscoveryState>(
      listenWhen: (previous, current) =>
          current.status == DiscoveryStatus.failure &&
          (previous.status != current.status ||
              previous.errorMessage != current.errorMessage),
      listener: (context, state) {
        AppToast.show(
          context,
          message: state.errorMessage ?? l10n.genericError,
        );
      },
      child: content,
    );
  }

  Future<void> _showNearbySettings(
    BuildContext context,
    DiscoveryState state,
  ) async {
    final result = await showModalBottomSheet<NearbyRadiusSettingsResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.text.withValues(alpha: 0.4),
      useSafeArea: true,
      builder: (sheetContext) => ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.82,
        ),
        child: NearbyRadiusSettingsSheet(
          initialRadiusKm: state.nearbyRadiusKm,
          initialProfileVisibility: state.isNearbyProfileVisible,
          initialAudience: state.nearbyVisibilityAudience,
        ),
      ),
    );
    if (!context.mounted || result == null) return;

    context.read<DiscoveryBloc>().add(
      DiscoveryNearbySettingsSaved(
        radiusKm: result.radiusKm,
        isProfileVisible: result.isProfileVisible,
        audience: result.audience,
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
      );
    }).toList();
  }
}
