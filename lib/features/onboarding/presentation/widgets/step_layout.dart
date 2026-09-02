import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/ui/widgets/app_round_icon_button.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/candidate_type.dart';
import '../../domain/entities/profile_onboarding_draft.dart';
import '../bloc/profile_onboarding_bloc.dart';
import '../bloc/profile_onboarding_event.dart';

final class StepLayout extends StatelessWidget {
  const StepLayout({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.leading,
    this.step,
    this.bottom,
    this.dateWheel = false,
    this.keyboardAware = false,
  });

  final String title;
  final String? subtitle;

  /// Optional visual shown between the wizard header and the title.
  final Widget? leading;
  final Widget child;
  final OnboardingStep? step;
  final Widget? bottom;
  final bool dateWheel;
  final bool keyboardAware;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (step != null) ...[
          _OnboardingWizardHeader(
            step: step!,
            onBack: () => context.read<ProfileOnboardingBloc>().add(
              const OnboardingStepBackRequested(),
            ),
          ),
          const SizedBox(height: AppSpacing.lg + AppSpacing.xs),
        ],
        if (leading != null) ...[
          leading!,
          const SizedBox(height: AppSpacing.lg),
        ],
        Text(title, style: AppTypography.onboardingTitle),
        if (subtitle != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(subtitle!, style: AppTypography.onboardingBody),
        ],
        const SizedBox(height: AppSpacing.lg + AppSpacing.xs),
        if (dateWheel) ...[
          child,
          if (bottom != null) const Spacer(),
        ] else ...[
          child,
          if (bottom != null) const Spacer(),
        ],
        ..._optionalWidget(bottom),
      ],
    );
    if (bottom == null) {
      return SingleChildScrollView(child: content);
    }
    if (!keyboardAware) {
      return content;
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(child: content),
          ),
        );
      },
    );
  }
}

final class _OnboardingWizardHeader extends StatelessWidget {
  const _OnboardingWizardHeader({required this.step, required this.onBack});

  final OnboardingStep step;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final representativeMode =
        context.read<ProfileOnboardingBloc>().state.draft?.candidateType ==
        CandidateType.representative;
    final progress = representativeMode
        ? switch (step) {
            OnboardingStep.identity => .24,
            OnboardingStep.birthDate => .29,
            OnboardingStep.profession => .35,
            OnboardingStep.education => .38,
            OnboardingStep.height => .41,
            OnboardingStep.location => .47,
            OnboardingStep.healthStatus => .53,
            OnboardingStep.maritalStatus => .59,
            OnboardingStep.photos => .65,
            OnboardingStep.mainPhoto => .71,
            OnboardingStep.aboutMe => .76,
            OnboardingStep.voiceIntro => .82,
            OnboardingStep.locationPermission => .88,
            OnboardingStep.representativeContact => .94,
            OnboardingStep.representativePledge ||
            OnboardingStep.representativeReady => 1.0,
            _ => 0.0,
          }
        : switch (step) {
            OnboardingStep.identity => .08,
            OnboardingStep.birthDate => .15,
            OnboardingStep.profession => .23,
            OnboardingStep.education => .27,
            OnboardingStep.height => .31,
            OnboardingStep.location => .38,
            OnboardingStep.healthStatus => .46,
            OnboardingStep.maritalStatus => .54,
            OnboardingStep.photos => .62,
            OnboardingStep.mainPhoto => .69,
            OnboardingStep.faceVerification => .77,
            OnboardingStep.aboutMe => .85,
            OnboardingStep.voiceIntro => .92,
            OnboardingStep.locationPermission => .96,
            OnboardingStep.success || OnboardingStep.profileReady => 1.0,
            _ => 0.0,
          };
    final percent = (progress * 100).round();
    return SizedBox(
      height: 36,
      child: Row(
        children: [
          AppRoundIconButton(
            icon: Assets.icons.icArrowLeft01Round,
            semanticLabel: AppLocalizations.of(context).backLabel,
            onPressed: onBack,
          ),
          const SizedBox(width: AppSpacing.md + AppSpacing.xs),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.full),
              child: SizedBox(
                height: 3,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    const ColoredBox(color: AppColors.mutedSurface),
                    FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: progress,
                      child: const ColoredBox(color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Text('$percent%', style: AppTypography.onboardingProgress),
        ],
      ),
    );
  }
}

List<Widget> _optionalWidget(Widget? widget) {
  return widget == null ? const <Widget>[] : <Widget>[widget];
}
