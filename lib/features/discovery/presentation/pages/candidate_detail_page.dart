import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/service_locator.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/extensions/gap_extension.dart';
import '../../../../core/ui/widgets/app_error_view.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/candidate.dart';
import '../bloc/candidate_detail_bloc.dart';
import '../bloc/candidate_detail_event.dart';
import '../bloc/candidate_detail_state.dart';
import 'candidate_action_result_page.dart';
import '../widgets/candidate_detail_bottom_bar.dart';
import '../widgets/candidate_detail_header.dart';
import '../widgets/candidate_detail_hero_image.dart';
import '../widgets/candidate_detail_match_card.dart';
import '../widgets/candidate_detail_options_bottom_sheet.dart';
import '../widgets/candidate_detail_voice_player.dart';

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
    return BlocBuilder<CandidateDetailBloc, CandidateDetailState>(
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
        return _LoadedCandidateDetail(candidate: candidate);
      },
    );
  }
}

final class _LoadedCandidateDetail extends StatelessWidget {
  const _LoadedCandidateDetail({required this.candidate});

  final Candidate candidate;

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

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CandidateDetailBottomBar(
        onSendProposal: () =>
            _openActionResult(context, candidateName: nameAge),
        onMoreOptions: () => _openOptions(context, candidateName: nameAge),
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
                  onRequestPermission: () => _openActionResult(
                    context,
                    candidateName: nameAge,
                    type: CandidateActionResultType.photoPermission,
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

  void _openActionResult(
    BuildContext context, {
    required String candidateName,
    CandidateActionResultType type = CandidateActionResultType.proposal,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            CandidateActionResultPage(candidateName: candidateName, type: type),
      ),
    );
  }

  void _openOptions(BuildContext context, {required String candidateName}) {
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
          _openActionResult(
            context,
            candidateName: candidateName,
            type: CandidateActionResultType.photoPermission,
          );
        },
        onReport: () => Navigator.of(context).pop(),
        onBlock: () => Navigator.of(context).pop(),
        onCancel: () => Navigator.of(context).pop(),
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
