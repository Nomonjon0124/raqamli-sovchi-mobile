import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/service_locator.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/extensions/gap_extension.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/candidate_photo_request_cubit.dart';
import '../cubit/candidate_photo_request_state.dart';
import 'candidate_action_result_page.dart';

final class CandidatePhotoRequestPage extends StatefulWidget {
  const CandidatePhotoRequestPage({
    required this.candidateId,
    required this.candidateName,
    required this.subtitle,
    required this.imageUrl,
    this.matchPercent,
    super.key,
  });

  final String candidateId;
  final String candidateName;
  final String subtitle;
  final String? imageUrl;
  final int? matchPercent;

  @override
  State<CandidatePhotoRequestPage> createState() =>
      _CandidatePhotoRequestPageState();
}

final class _CandidatePhotoRequestPageState
    extends State<CandidatePhotoRequestPage> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          CandidatePhotoRequestCubit(createRequest: serviceLocator()),
      child: _CandidatePhotoRequestView(
        candidateId: widget.candidateId,
        candidateName: widget.candidateName,
        subtitle: widget.subtitle,
        imageUrl: widget.imageUrl,
        matchPercent: widget.matchPercent,
        messageController: _messageController,
      ),
    );
  }
}

final class _CandidatePhotoRequestView extends StatelessWidget {
  const _CandidatePhotoRequestView({
    required this.candidateId,
    required this.candidateName,
    required this.subtitle,
    required this.imageUrl,
    required this.matchPercent,
    required this.messageController,
  });

  final String candidateId;
  final String candidateName;
  final String subtitle;
  final String? imageUrl;
  final int? matchPercent;
  final TextEditingController messageController;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocListener<CandidatePhotoRequestCubit, CandidatePhotoRequestState>(
      listenWhen: (previous, current) =>
          previous.isSubmitting && !current.isSubmitting,
      listener: (context, state) {
        if (state.request != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(
              builder: (_) => CandidateActionResultPage(
                candidateName: candidateName,
                type: CandidateActionResultType.photoPermission,
              ),
            ),
          );
          return;
        }

        final message = state.errorMessage ?? l10n.genericError;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => context.pop(),
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
                        l10n.photoRequestTitle,
                        style: AppTypography.photoRequestTitle,
                      ),
                      14.g,
                      _PersonCard(
                        name: candidateName,
                        subtitle: subtitle,
                        imageUrl: imageUrl,
                        matchPercent: matchPercent,
                      ),
                      14.g,
                      Text(
                        l10n.photoRequestDescription,
                        style: AppTypography.onboardingBody,
                      ),
                      14.g,
                      TextField(
                        controller: messageController,
                        minLines: 4,
                        maxLines: 4,
                        cursorColor: AppColors.primary,
                        style: const TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 14,
                          height: 21 / 14,
                          color: AppColors.text,
                        ),
                        textInputAction: TextInputAction.newline,
                        decoration: InputDecoration(
                          hintText: l10n.photoRequestMessageHint,
                          hintStyle: const TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 14,
                            height: 21 / 14,
                            color: AppColors.placeholder,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.all(12),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                            borderSide: const BorderSide(
                              color: AppColors.border,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      14.g,
                      const _RulesCard(),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  22,
                  12,
                  22,
                  MediaQuery.of(context).padding.bottom + 12,
                ),
                child:
                    BlocBuilder<
                      CandidatePhotoRequestCubit,
                      CandidatePhotoRequestState
                    >(
                      builder: (context, state) => _PrimaryActionButton(
                        label: l10n.photoRequestSubmit,
                        isLoading: state.isSubmitting,
                        onPressed: state.isSubmitting
                            ? null
                            : () => context
                                  .read<CandidatePhotoRequestCubit>()
                                  .submit(
                                    toProfile: candidateId,
                                    note: messageController.text,
                                  ),
                      ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _PrimaryActionButton extends StatelessWidget {
  const _PrimaryActionButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledForegroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
        ),
        child: isLoading
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
                  Flexible(
                    child: Text(
                      label,
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
                  8.g,
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
    );
  }
}

final class _PersonCard extends StatelessWidget {
  const _PersonCard({
    required this.name,
    required this.subtitle,
    required this.imageUrl,
    required this.matchPercent,
  });

  final String name;
  final String subtitle;
  final String? imageUrl;
  final int? matchPercent;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.subtleSurface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            _BlurredThumbnail(imageUrl: imageUrl),
            12.g,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTypography.body.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(subtitle, style: AppTypography.caption),
                ],
              ),
            ),
            if (matchPercent != null)
              Text(
                '$matchPercent%',
                style: AppTypography.body.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

final class _BlurredThumbnail extends StatelessWidget {
  const _BlurredThumbnail({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final fallback = const ColoredBox(
      color: AppColors.mutedSurface,
      child: Icon(Icons.person_rounded, color: AppColors.mutedText),
    );
    final image = imageUrl == null || imageUrl!.isEmpty
        ? fallback
        : CachedNetworkImage(imageUrl: imageUrl!, fit: BoxFit.cover);
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: SizedBox(
        width: 48,
        height: 48,
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Transform.scale(scale: 1.2, child: image),
        ),
      ),
    );
  }
}

final class _RulesCard extends StatelessWidget {
  const _RulesCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.subtleSurface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _RuleRow(
              l10n.photoRequestDurationLabel,
              l10n.photoRequestDurationValue,
            ),
            9.g,
            _RuleRow(
              l10n.photoRequestRejectLabel,
              l10n.photoRequestRejectValue,
            ),
          ],
        ),
      ),
    );
  }
}

final class _RuleRow extends StatelessWidget {
  const _RuleRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 13,
              height: 21 / 13,
              color: AppColors.mutedText,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 13,
            height: 18 / 13,
            color: AppColors.text,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
