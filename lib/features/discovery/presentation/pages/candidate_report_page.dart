import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../app/di/service_locator.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../core/ui/widgets/app_toast.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../moderation/application/use_cases/create_complaint.dart';
import '../../../moderation/domain/entities/complaint.dart';
import '../../domain/entities/candidate.dart';
import 'candidate_report_submitted_page.dart';

final class CandidateReportPage extends StatefulWidget {
  const CandidateReportPage({
    required this.candidate,
    required this.candidateName,
    this.createComplaintUseCase,
    super.key,
  });

  final Candidate candidate;
  final String candidateName;
  final CreateComplaintUseCase? createComplaintUseCase;

  @override
  State<CandidateReportPage> createState() => _CandidateReportPageState();
}

final class _CandidateReportPageState extends State<CandidateReportPage> {
  int? _selectedReasonIndex;
  bool _isSubmitting = false;
  final TextEditingController _noteController = TextEditingController();
  late final CreateComplaintUseCase _createComplaint =
      widget.createComplaintUseCase ?? serviceLocator<CreateComplaintUseCase>();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final selectedReasonIndex = _selectedReasonIndex;
    if (selectedReasonIndex == null || _isSubmitting) return;

    final toUserId =
        widget.candidate.userId != null &&
            widget.candidate.userId!.trim().isNotEmpty
        ? widget.candidate.userId!
        : widget.candidate.id;
    final reason = _reasonOptions(
      AppLocalizations.of(context),
    )[selectedReasonIndex].reason;

    setState(() => _isSubmitting = true);
    final result = await _createComplaint(
      toUserId: toUserId,
      reason: reason,
      message: _noteController.text,
    );
    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() => _isSubmitting = false);
        final error = failure.message;
        AppToast.show(
          context,
          message: error == null || error.isEmpty
              ? AppLocalizations.of(context).genericError
              : error,
        );
      },
      (complaint) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => CandidateReportSubmittedPage(
              candidateName: widget.candidateName,
              reportNumber: complaint.id,
              submittedAt: complaint.createdAt,
              statusLabel: complaint.statusLabel,
            ),
          ),
        );
      },
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final reasons = _reasonOptions(l10n);

    final photoUrl = _mainImageUrl(widget.candidate);
    final shouldBlur = widget.candidate.blurPhotos ?? true;

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(22, 12, 22, 12),
        child: FilledButton(
          onPressed: _selectedReasonIndex != null && !_isSubmitting
              ? _handleSubmit
              : null,
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            backgroundColor: AppColors.primary,
            disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.4),
            foregroundColor: Colors.white,
            disabledForegroundColor: Colors.white.withValues(alpha: 0.8),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
          ),
          child: _isSubmitting
              ? const SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.candidateReportSubmitAction,
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 15,
                        height: 20 / 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Assets.icons.icArrowRight.svg(
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
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
                    Text(
                      l10n.candidateReportTitle,
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 24,
                        height: 30 / 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.candidateReportSubtitle,
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 14,
                        height: 20 / 14,
                        color: AppColors.mutedText,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Candidate card
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                      ),
                      child: Row(
                        children: [
                          _BlurredAvatar(
                            imageUrl: photoUrl,
                            shouldBlur: shouldBlur,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.candidateName,
                                  style: const TextStyle(
                                    fontFamily: 'Manrope',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.text,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  l10n.candidateReportTargetProfile,
                                  style: const TextStyle(
                                    fontFamily: 'Manrope',
                                    fontSize: 13,
                                    color: AppColors.mutedText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      l10n.candidateReportReasonSection,
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Reasons list
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                      ),
                      child: Column(
                        children: List.generate(reasons.length, (index) {
                          final isSelected = _selectedReasonIndex == index;
                          final isLast = index == reasons.length - 1;
                          return Column(
                            children: [
                              InkWell(
                                onTap: _isSubmitting
                                    ? null
                                    : () => setState(
                                        () => _selectedReasonIndex = index,
                                      ),
                                borderRadius: BorderRadius.vertical(
                                  top: index == 0
                                      ? const Radius.circular(AppRadius.xl)
                                      : Radius.zero,
                                  bottom: isLast
                                      ? const Radius.circular(AppRadius.xl)
                                      : Radius.zero,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  child: Row(
                                    children: [
                                      _RadioIndicator(isSelected: isSelected),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Text(
                                          reasons[index].label,
                                          style: const TextStyle(
                                            fontFamily: 'Manrope',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.text,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (!isLast)
                                const Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: Color(0xFFF3F4F6),
                                ),
                            ],
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Optional note field
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.candidateReportNoteLabel,
                            style: const TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 12,
                              color: AppColors.mutedText,
                            ),
                          ),
                          TextField(
                            controller: _noteController,
                            enabled: !_isSubmitting,
                            maxLines: 2,
                            style: const TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 14,
                              color: AppColors.text,
                            ),
                            decoration: InputDecoration(
                              hintText: l10n.candidateReportNoteHint,
                              hintStyle: const TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 14,
                                color: Color(0xFF9CA3AF),
                              ),
                              isDense: true,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.only(top: 6),
                            ),
                          ),
                        ],
                      ),
                    ),
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

List<_ComplaintReasonOption> _reasonOptions(AppLocalizations l10n) => [
  _ComplaintReasonOption(
    reason: ComplaintReason.abusiveLanguage,
    label: l10n.candidateReportReasonAbusiveLanguage,
  ),
  _ComplaintReasonOption(
    reason: ComplaintReason.fakeProfile,
    label: l10n.candidateReportReasonFakeProfile,
  ),
  _ComplaintReasonOption(
    reason: ComplaintReason.fraud,
    label: l10n.candidateReportReasonFraud,
  ),
  _ComplaintReasonOption(
    reason: ComplaintReason.spam,
    label: l10n.candidateReportReasonSpam,
  ),
  _ComplaintReasonOption(
    reason: ComplaintReason.falseInformation,
    label: l10n.candidateReportReasonFalseInformation,
  ),
  _ComplaintReasonOption(
    reason: ComplaintReason.threat,
    label: l10n.candidateReportReasonThreat,
  ),
  _ComplaintReasonOption(
    reason: ComplaintReason.noSeriousIntent,
    label: l10n.candidateReportReasonNoSeriousIntent,
  ),
  _ComplaintReasonOption(
    reason: ComplaintReason.other,
    label: l10n.candidateReportReasonOther,
  ),
];

final class _ComplaintReasonOption {
  const _ComplaintReasonOption({required this.reason, required this.label});

  final ComplaintReason reason;
  final String label;
}

final class _BlurredAvatar extends StatelessWidget {
  const _BlurredAvatar({required this.imageUrl, required this.shouldBlur});

  final String? imageUrl;
  final bool shouldBlur;

  @override
  Widget build(BuildContext context) {
    const size = 48.0;

    final fallback = Container(
      width: size,
      height: size,
      color: AppColors.profileAvatarSurface,
      child: const Icon(
        Icons.person,
        size: 26,
        color: AppColors.profileAvatarText,
      ),
    );

    final image = (imageUrl != null && imageUrl!.isNotEmpty)
        ? CachedNetworkImage(
            imageUrl: imageUrl!,
            width: size,
            height: size,
            fit: BoxFit.cover,
            placeholder: (_, _) => fallback,
            errorWidget: (_, _, _) => fallback,
          )
        : fallback;

    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: SizedBox(
        width: size,
        height: size,
        child: shouldBlur
            ? ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Transform.scale(scale: 1.15, child: image),
              )
            : image,
      ),
    );
  }
}

final class _RadioIndicator extends StatelessWidget {
  const _RadioIndicator({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? AppColors.primary : Colors.transparent,
        border: Border.all(
          color: isSelected ? AppColors.primary : const Color(0xFFD1D5DB),
          width: 2,
        ),
      ),
      alignment: Alignment.center,
      child: isSelected
          ? Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            )
          : null,
    );
  }
}
