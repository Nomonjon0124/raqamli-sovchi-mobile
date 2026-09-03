import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/questionnaire.dart';
import 'questionnaire_primary_button.dart';

final class QuestionnaireResultView extends StatelessWidget {
  const QuestionnaireResultView({
    required this.result,
    required this.onShowCandidates,
    super.key,
  });

  final QuestionnaireResult result;
  final VoidCallback onShowCandidates;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            AppSpacing.section,
            AppSpacing.screen,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.questionnaireResultTitle,
                        style: AppTypography.pinTitle,
                      ),
                      const SizedBox(height: AppSpacing.compact),
                      Text(
                        l10n.questionnaireResultSubtitle,
                        style: AppTypography.onboardingBody,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      const _ProfileReadyHero(),
                      const SizedBox(height: AppSpacing.lg),
                      _MatchedCandidatesCard(
                        title: l10n.questionnaireMatchedCandidates(128),
                        subtitle: l10n.questionnaireMatchedCandidatesSubtitle,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _NextStepsCard(l10n: l10n),
                      const SizedBox(height: AppSpacing.xxl),
                    ],
                  ),
                ),
              ),
              SafeArea(
                top: false,
                minimum: const EdgeInsets.only(
                  top: AppSpacing.sm,
                  bottom: AppSpacing.lg,
                ),
                child: QuestionnairePrimaryButton(
                  label: l10n.questionnaireShowCandidates,
                  showArrow: true,
                  onPressed: onShowCandidates,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _ProfileReadyHero extends StatelessWidget {
  const _ProfileReadyHero();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SizedBox(
      width: double.infinity,
      height: 206,
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.section),
          Assets.icons.icTaskListPen.svg(
            width: 120,
            height: 120,
            colorFilter: const ColorFilter.mode(
              AppColors.primary,
              BlendMode.srcIn,
            ),
            excludeFromSemantics: true,
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _TrustPill(label: l10n.questionnaireHonestyPill),
              const SizedBox(width: AppSpacing.sm),
              _TrustPill(label: l10n.questionnaireSeriousPill, width: 140),
            ],
          ),
        ],
      ),
    );
  }
}

final class _TrustPill extends StatelessWidget {
  const _TrustPill({required this.label, this.width});

  final String label;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.full),
        gradient: const LinearGradient(
          colors: [Color(0xFF83C7FF), Color(0xFF8FA8E6), Color(0xFF7EB3F0)],
          stops: [0, 0.52, 1],
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_rounded,
            size: 14,
            color: AppColors.surfaceLight,
          ),
          const SizedBox(width: AppSpacing.compact),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.caption.copyWith(
                color: AppColors.surfaceLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final class _MatchedCandidatesCard extends StatelessWidget {
  const _MatchedCandidatesCard({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return _ResultSurface(
      padding: const EdgeInsets.all(AppSpacing.input),
      child: Row(
        children: [
          const _AvatarStack(),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.onboardingAction),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.profileCardBody,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final class _AvatarStack extends StatelessWidget {
  const _AvatarStack();

  static const _avatarSize = 34.0;
  static const _overlap = 22.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: _avatarSize,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _CandidateAvatar(image: Assets.images.candidate1),
          Positioned(
            left: _overlap,
            child: _CandidateAvatar(image: Assets.images.candidate2),
          ),
          Positioned(
            left: _overlap * 2,
            child: _CandidateAvatar(image: Assets.images.candidate3),
          ),
          Positioned(
            left: _overlap * 3,
            child: Container(
              width: _avatarSize,
              height: _avatarSize,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.mutedSurface,
                borderRadius: BorderRadius.circular(AppRadius.full),
                border: Border.all(
                  color: AppColors.surfaceLight,
                  width: AppSpacing.xxs,
                ),
              ),
              child: Text(
                '+125',
                style: AppTypography.profileCardBody.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.mapLabelText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final class _CandidateAvatar extends StatelessWidget {
  const _CandidateAvatar({required this.image});

  final AssetGenImage image;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _AvatarStack._avatarSize,
      height: _AvatarStack._avatarSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(
          color: AppColors.surfaceLight,
          width: AppSpacing.xxs,
        ),
        image: DecorationImage(image: image.provider(), fit: BoxFit.cover),
      ),
    );
  }
}

final class _NextStepsCard extends StatelessWidget {
  const _NextStepsCard({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return _ResultSurface(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.questionnaireNextStepsTitle,
            style: AppTypography.candidateDetailSectionTitle,
          ),
          const SizedBox(height: AppSpacing.input),
          _NextStepRow(
            icon: Assets.icons.icAiSpark,
            title: l10n.questionnaireAiMatchCalculatedTitle,
            body: l10n.questionnaireAiMatchCalculatedBody,
          ),
          const SizedBox(height: AppSpacing.card),
          _NextStepRow(
            icon: Assets.icons.icEye,
            title: l10n.questionnaireCandidatesVeiledTitle,
            body: l10n.questionnaireCandidatesVeiledBody,
          ),
          const SizedBox(height: AppSpacing.card),
          _NextStepRow(
            icon: Assets.icons.icNearbyPrivacyLock,
            title: l10n.questionnaireConsentOnlyTitle,
            body: l10n.questionnaireConsentOnlyBody,
          ),
        ],
      ),
    );
  }
}

final class _NextStepRow extends StatelessWidget {
  const _NextStepRow({
    required this.icon,
    required this.title,
    required this.body,
  });

  final SvgGenImage icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: AppSpacing.xxl,
          height: AppSpacing.xxl,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.subtleSurface,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: icon.svg(
            width: AppSpacing.lg,
            height: AppSpacing.lg,
            colorFilter: const ColorFilter.mode(
              AppColors.primary,
              BlendMode.srcIn,
            ),
            excludeFromSemantics: true,
          ),
        ),
        const SizedBox(width: AppSpacing.inline),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.candidateDetailSectionTitle),
              const SizedBox(height: AppSpacing.xxs),
              Text(body, style: AppTypography.profileCardBody),
            ],
          ),
        ),
      ],
    );
  }
}

final class _ResultSurface extends StatelessWidget {
  const _ResultSurface({required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.subtleSurface,
        border: Border.all(color: const Color(0xFFF3F3F3)),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: child,
    );
  }
}
