import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/extensions/gap_extension.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../l10n/app_localizations.dart';
import 'candidate_action_result_page.dart';

final class CandidatePhotoRequestPage extends StatefulWidget {
  const CandidatePhotoRequestPage({
    required this.candidateName,
    required this.subtitle,
    required this.imageUrl,
    this.matchPercent,
    super.key,
  });

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
    final l10n = AppLocalizations.of(context);
    return Scaffold(
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
                      name: widget.candidateName,
                      subtitle: widget.subtitle,
                      imageUrl: widget.imageUrl,
                      matchPercent: widget.matchPercent,
                    ),
                    14.g,
                    Text(
                      l10n.photoRequestDescription,
                      style: AppTypography.onboardingBody,
                    ),
                    14.g,
                    TextField(
                      controller: _messageController,
                      minLines: 4,
                      maxLines: 4,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                        hintText: l10n.photoRequestMessageHint,
                        alignLabelWithHint: true,
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
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(
                      builder: (_) => CandidateActionResultPage(
                        candidateName: widget.candidateName,
                        type: CandidateActionResultType.photoPermission,
                      ),
                    ),
                  ),
                  child: Text(l10n.photoRequestSubmit),
                ),
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
        padding: const EdgeInsets.all(AppSpacing.lg),
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
            const Divider(height: 1),
            9.g,
            Text(l10n.photoRequestPrivacyNote, style: AppTypography.caption),
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
        Expanded(child: Text(label, style: AppTypography.caption)),
        Text(
          value,
          style: AppTypography.caption.copyWith(
            color: AppColors.text,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
