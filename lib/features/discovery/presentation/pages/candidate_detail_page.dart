import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/service_locator.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/extensions/gap_extension.dart';
import '../../../../core/ui/widgets/app_error_view.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../match/domain/entities/match_request.dart';
import '../../domain/entities/candidate.dart';
import '../bloc/candidate_detail_bloc.dart';
import '../bloc/candidate_detail_event.dart';
import '../bloc/candidate_detail_state.dart';
import '../widgets/candidate_detail_bottom_bar.dart';
import '../widgets/candidate_detail_header.dart';
import '../widgets/candidate_detail_hero_image.dart';
import '../widgets/candidate_detail_match_card.dart';
import '../widgets/candidate_detail_options_bottom_sheet.dart';
import '../widgets/candidate_detail_voice_player.dart';
import 'candidate_action_result_page.dart';
import 'candidate_photo_request_page.dart';

final class CandidateDetailPage extends StatelessWidget {
  const CandidateDetailPage({required this.candidateId, super.key});

  final String candidateId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          serviceLocator<CandidateDetailBloc>()
            ..add(CandidateDetailLoadRequested(candidateId)),
      child: _CandidateDetailView(candidateId: candidateId),
    );
  }
}

final class _CandidateDetailView extends StatelessWidget {
  const _CandidateDetailView({required this.candidateId});

  final String candidateId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocListener<CandidateDetailBloc, CandidateDetailState>(
      listenWhen: (previous, current) =>
          previous.isSendingRequest &&
          !current.isSendingRequest &&
          current.matchRequest != null,
      listener: (context, state) {
        final candidate = state.candidate;
        if (candidate == null) return;
        final name = [candidate.firstName, candidate.lastName]
            .whereType<String>()
            .where((value) => value.trim().isNotEmpty)
            .join(' ');
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => CandidateActionResultPage(candidateName: name),
          ),
        );
      },
      child: BlocBuilder<CandidateDetailBloc, CandidateDetailState>(
        builder: (context, state) {
          final candidate = state.candidate;
          if (candidate == null &&
              state.status == CandidateDetailStatus.failure) {
            return Scaffold(
              body: Center(
                child: AppErrorView(
                  message: state.errorMessage ?? l10n.genericError,
                  onRetry: () => context.read<CandidateDetailBloc>().add(
                    CandidateDetailLoadRequested(candidateId),
                  ),
                ),
              ),
            );
          }
          if (candidate == null) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator.adaptive()),
            );
          }
          return _LoadedCandidateDetail(
            candidate: candidate,
            matchRequest: state.matchRequest,
            isLoadingMatchRequest: state.isLoadingMatchRequest,
            isSendingRequest: state.isSendingRequest,
          );
        },
      ),
    );
  }
}

final class _LoadedCandidateDetail extends StatelessWidget {
  const _LoadedCandidateDetail({
    required this.candidate,
    required this.matchRequest,
    required this.isLoadingMatchRequest,
    required this.isSendingRequest,
  });

  final Candidate candidate;
  final MatchRequest? matchRequest;
  final bool isLoadingMatchRequest;
  final bool isSendingRequest;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final fullName = [
      candidate.firstName,
      candidate.lastName,
      candidate.middleName,
    ].where((value) => value != null && value.trim().isNotEmpty).join(' ');
    final nameAge = candidate.age == null
        ? fullName
        : '$fullName, ${candidate.age}';
    final subtitle = [
      candidate.regionName,
      candidate.districtName,
      if (candidate.height != null) '${candidate.height} ${l10n.heightUnit}',
      candidate.educationLevelName,
    ].where((value) => value != null && value.trim().isNotEmpty).join(' · ');
    final imageUrl = _mainImageUrl(candidate);
    final scores = candidate.compatibilityScore?.sections
        .map(
          (section) => MatchCategory(
            title: section.sectionName,
            percent: section.score.round().clamp(0, 100).toInt(),
          ),
        )
        .toList();
    final action = _requestAction(context);

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CandidateDetailBottomBar(
        actionLabel: action.label,
        actionVariant: action.variant,
        isLoading: isSendingRequest,
        onSendProposal: isLoadingMatchRequest || isSendingRequest
            ? null
            : action.onPressed,
        onMoreOptions: () => _openOptions(
          context,
          candidate: candidate,
          candidateName: nameAge,
          candidateSubtitle: subtitle,
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CandidateDetailHeroImage(
                  imageUrl: imageUrl,
                  shouldBlur: candidate.blurPhotos ?? false,
                  onRequestPermission: () => _openPhotoRequest(
                    context,
                    candidate: candidate,
                    candidateName: nameAge,
                    candidateSubtitle: subtitle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 20, 22, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CandidateDetailHeader(
                        nameAge: nameAge,
                        subtitle: subtitle,
                        isVerified: candidate.isVerified ?? false,
                      ),
                      if (candidate.compatibilityScore != null) ...[
                        18.g,
                        CandidateDetailMatchCard(
                          matchPercent: candidate
                              .compatibilityScore!
                              .overallScore
                              .round()
                              .clamp(0, 100)
                              .toInt(),
                          scores: scores ?? const [],
                          title: l10n.candidateDetailCompatibilityTitle,
                        ),
                      ],
                      if (candidate.voiceIntro?.trim().isNotEmpty == true) ...[
                        18.g,
                        CandidateDetailVoicePlayer(
                          voiceUrl: candidate.voiceIntro,
                        ),
                      ],
                      if (candidate.bio?.trim().isNotEmpty == true) ...[
                        18.g,
                        Text(
                          candidate.bio!,
                          style: const TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 13,
                            height: 21 / 13,
                            fontWeight: FontWeight.w400,
                            color: AppColors.bodyText,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 18,
            left: 18,
            right: 18,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCircularButton(
                  icon: Assets.icons.icArrowLeft01Round.svg(
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      AppColors.text,
                      BlendMode.srcIn,
                    ),
                  ),
                  semanticLabel: l10n.backLabel,
                  onTap: () => context.pop(),
                ),
                BlocBuilder<CandidateDetailBloc, CandidateDetailState>(
                  buildWhen: (previous, current) =>
                      previous.candidate?.isSaved !=
                          current.candidate?.isSaved ||
                      previous.isSaving != current.isSaving,
                  builder: (context, state) => _buildCircularButton(
                    icon: Assets.icons.icPreservedBtv.svg(
                      width: 20,
                      height: 20,
                      colorFilter: ColorFilter.mode(
                        state.candidate?.isSaved == true
                            ? AppColors.primary
                            : AppColors.text,
                        BlendMode.srcIn,
                      ),
                    ),
                    semanticLabel: state.candidate?.isSaved == true
                        ? l10n.candidateDetailUnsave
                        : l10n.candidateDetailSave,
                    onTap: state.isSaving
                        ? null
                        : () => context.read<CandidateDetailBloc>().add(
                            const CandidateDetailSaveToggled(),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _CandidateRequestAction _requestAction(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final request = matchRequest;
    if (request == null) {
      return _CandidateRequestAction(
        label: l10n.candidateDetailSendProposal,
        onPressed: () => context.read<CandidateDetailBloc>().add(
          const CandidateDetailRequestSubmitted(),
        ),
      );
    }

    return switch (request.status) {
      MatchRequestStatus.pending => _CandidateRequestAction(
        label: l10n.candidateRequestPending,
      ),
      MatchRequestStatus.forwardedToRepresentative => _CandidateRequestAction(
        label: l10n.candidateRequestForwarded,
      ),
      MatchRequestStatus.accepted => _CandidateRequestAction(
        label: l10n.candidateRequestChat,
        onPressed: () => context.go(RouteNames.messages),
      ),
      MatchRequestStatus.rejected =>
        request.canRetryAt(DateTime.now())
            ? _CandidateRequestAction(
                label: l10n.candidateRequestRetry,
                onPressed: () => context.read<CandidateDetailBloc>().add(
                  const CandidateDetailRequestSubmitted(),
                ),
              )
            : _CandidateRequestAction(
                label: l10n.candidateRequestRetryAt(
                  _formatDate(request.retryAvailableAt),
                ),
                variant: CandidateDetailActionVariant.retryLocked,
              ),
      null => _CandidateRequestAction(
        label: l10n.candidateDetailSendProposal,
        onPressed: () => context.read<CandidateDetailBloc>().add(
          const CandidateDetailRequestSubmitted(),
        ),
      ),
    };
  }

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    return '$day.$month.${local.year}';
  }

  void _openOptions(
    BuildContext context, {
    required Candidate candidate,
    required String candidateName,
    required String candidateSubtitle,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CandidateDetailOptionsBottomSheet(
        candidateName: candidateName,
        onSave: () {
          Navigator.of(context).pop();
          context.read<CandidateDetailBloc>().add(
            const CandidateDetailSaveToggled(),
          );
        },
        onShare: () => Navigator.of(context).pop(),
        onRequestPhotoPermission: () {
          Navigator.of(context).pop();
          _openPhotoRequest(
            context,
            candidate: candidate,
            candidateName: candidateName,
            candidateSubtitle: candidateSubtitle,
          );
        },
        onReport: () => Navigator.of(context).pop(),
        onBlock: () => Navigator.of(context).pop(),
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }

  void _openPhotoRequest(
    BuildContext context, {
    required Candidate candidate,
    required String candidateName,
    required String candidateSubtitle,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CandidatePhotoRequestPage(
          candidateName: candidateName,
          subtitle: candidateSubtitle,
          imageUrl: _mainImageUrl(candidate),
          matchPercent: candidate.compatibilityScore?.overallScore.round(),
        ),
      ),
    );
  }

  Widget _buildCircularButton({
    required Widget icon,
    required String semanticLabel,
    required VoidCallback? onTap,
  }) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: Material(
        color: Colors.white,
        shape: const CircleBorder(),
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: SizedBox(width: 36, height: 36, child: Center(child: icon)),
        ),
      ),
    );
  }

  String? _mainImageUrl(Candidate candidate) {
    final photos = candidate.photosInfo;
    if (photos == null || photos.isEmpty) return null;
    final photo = photos.firstWhere(
      (item) => item.isMain,
      orElse: () => photos.first,
    );
    return photo.image.trim().isEmpty ? null : photo.image;
  }
}

final class _CandidateRequestAction {
  const _CandidateRequestAction({
    required this.label,
    this.onPressed,
    this.variant = CandidateDetailActionVariant.primary,
  });

  final String label;
  final VoidCallback? onPressed;
  final CandidateDetailActionVariant variant;
}
