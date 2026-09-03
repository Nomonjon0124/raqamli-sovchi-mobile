import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/service_locator.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/extensions/gap_extension.dart';
import '../../../../core/ui/widgets/app_error_view.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../match/domain/entities/match_request.dart';
import '../../domain/entities/candidate.dart';
import '../bloc/candidate_detail_bloc.dart';
import '../bloc/candidate_detail_event.dart';
import '../bloc/candidate_detail_state.dart';
import '../widgets/candidate_block_dialog.dart';
import '../widgets/candidate_detail_bio_section.dart';
import '../widgets/candidate_detail_bottom_bar.dart';
import '../widgets/candidate_detail_header.dart';
import '../widgets/candidate_detail_hero_image.dart';
import '../widgets/candidate_detail_incomplete_profile_card.dart';
import '../widgets/candidate_detail_information_sections.dart';
import '../widgets/candidate_detail_match_card.dart';
import '../widgets/candidate_detail_no_compatibility_card.dart';
import '../widgets/candidate_detail_options_bottom_sheet.dart';
import '../widgets/candidate_detail_sticky_header.dart';
import '../widgets/candidate_detail_voice_player.dart';
import 'candidate_action_result_page.dart';
import 'candidate_blocked_page.dart';
import 'candidate_photo_request_page.dart';
import 'candidate_report_page.dart';

final class CandidateDetailPage extends StatelessWidget {
  const CandidateDetailPage({required this.candidateId, super.key});

  final String candidateId;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) =>
        serviceLocator<CandidateDetailBloc>()
          ..add(CandidateDetailLoadRequested(candidateId)),
    child: _CandidateDetailView(candidateId: candidateId),
  );
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
          (current.matchRequest != null || current.matchRequestError != null),
      listener: (context, state) {
        if (state.matchRequestError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.matchRequestError ?? l10n.genericError),
            ),
          );
          return;
        }

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
            isSaving: state.isSaving,
          );
        },
      ),
    );
  }
}

final class _LoadedCandidateDetail extends StatefulWidget {
  const _LoadedCandidateDetail({
    required this.candidate,
    required this.matchRequest,
    required this.isLoadingMatchRequest,
    required this.isSendingRequest,
    required this.isSaving,
  });

  final Candidate candidate;
  final MatchRequest? matchRequest;
  final bool isLoadingMatchRequest;
  final bool isSendingRequest;
  final bool isSaving;

  @override
  State<_LoadedCandidateDetail> createState() => _LoadedCandidateDetailState();
}

final class _LoadedCandidateDetailState extends State<_LoadedCandidateDetail> {
  static const _heroHeight = 330.0;
  bool _showCompactHeader = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final candidate = widget.candidate;
    final fullName = [
      candidate.firstName,
      candidate.lastName,
      candidate.middleName,
    ].where((value) => value != null && value.trim().isNotEmpty).join(' ');
    final nameAge = candidate.age == null
        ? fullName
        : '$fullName, ${candidate.age}';
    final candidateSubtitle = [
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
        isLoading: widget.isSendingRequest,
        onSendProposal: widget.isLoadingMatchRequest || widget.isSendingRequest
            ? null
            : action.onPressed,
        onMoreOptions: () => _openOptions(
          context,
          candidate: candidate,
          candidateName: nameAge,
          candidateSubtitle: candidateSubtitle,
        ),
      ),
      body: Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              final shouldShow =
                  notification.metrics.pixels >= _heroHeight - 72;
              if (shouldShow != _showCompactHeader) {
                setState(() => _showCompactHeader = shouldShow);
              }
              return false;
            },
            child: SingleChildScrollView(
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
                      candidateSubtitle: candidateSubtitle,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 20, 22, 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CandidateDetailHeader(
                          nameAge: nameAge,
                          subtitle: l10n.candidateDetailLastActivity,
                          isVerified: candidate.isVerified ?? false,
                        ),
                        20.g,
                        if (candidate.compatibilityScore == null)
                          const CandidateDetailNoCompatibilityCard()
                        else
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
                        20.g,
                        CandidateDetailInformationSections(
                          candidate: candidate,
                        ),
                        if (CandidateDetailIncompleteProfileCard.isIncomplete(
                          candidate,
                        )) ...[
                          20.g,
                          CandidateDetailIncompleteProfileCard(
                            candidate: candidate,
                          ),
                        ],
                        if (candidate.bio?.trim().isNotEmpty == true) ...[
                          20.g,
                          CandidateDetailBioSection(bio: candidate.bio!),
                        ],
                        if (candidate.voiceIntro?.trim().isNotEmpty ==
                            true) ...[
                          20.g,
                          CandidateDetailVoicePlayer(
                            voiceUrl: candidate.voiceIntro,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.paddingOf(context).top + 18,
            left: 18,
            right: 18,
            child: CandidateDetailFloatingActions(
              visible: !_showCompactHeader,
              isSaved: candidate.isSaved,
              isSaving: widget.isSaving,
              onBack: () => context.pop(),
              onSave: () => _toggleSaved(context),
            ),
          ),
          CandidateDetailStickyHeader(
            visible: _showCompactHeader,
            nameAge: nameAge,
            imageUrl: imageUrl,
            shouldBlur: candidate.blurPhotos ?? false,
            isVerified: candidate.isVerified ?? false,
            isSaved: candidate.isSaved,
            isSaving: widget.isSaving,
            onBack: () => context.pop(),
            onSave: () => _toggleSaved(context),
          ),
        ],
      ),
    );
  }

  _CandidateRequestAction _requestAction(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final request = widget.matchRequest;
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

  void _toggleSaved(BuildContext context) {
    if (widget.isSaving) return;
    context.read<CandidateDetailBloc>().add(const CandidateDetailSaveToggled());
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
          _toggleSaved(context);
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
        onReport: () {
          Navigator.of(context).pop();
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => CandidateReportPage(
                candidate: candidate,
                candidateName: candidateName,
              ),
            ),
          );
        },
        onBlock: () async {
          Navigator.of(context).pop();
          final isBlocked = await CandidateBlockDialog.show(
            context,
            candidateId: candidate.userId ?? candidate.id,
            candidateName: candidateName,
          );
          if (isBlocked == true && context.mounted) {
            await Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(
                builder: (_) => CandidateBlockedPage(
                  candidateName: candidateName,
                  blockedAt: DateTime.now(),
                ),
              ),
            );
          }
        },
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
          candidateId: candidate.id,
          candidateName: candidateName,
          subtitle: candidateSubtitle,
          imageUrl: _mainImageUrl(candidate),
          matchPercent: candidate.compatibilityScore?.overallScore.round(),
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
