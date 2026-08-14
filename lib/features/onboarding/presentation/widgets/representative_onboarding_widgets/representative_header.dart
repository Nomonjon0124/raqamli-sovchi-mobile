import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_radius.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_typography.dart';
import '../../../../../core/ui/widgets/app_round_icon_button.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../bloc/profile_onboarding_bloc.dart';
import '../../bloc/profile_onboarding_event.dart';

final class RepresentativeHeader extends StatelessWidget {
  const RepresentativeHeader({super.key, required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: Row(
        children: [
          AppRoundIconButton(
            icon: Assets.icons.icArrowLeft01Round,
            semanticLabel: AppLocalizations.of(context).backLabel,
            onPressed: () => context.read<ProfileOnboardingBloc>().add(const OnboardingStepBackRequested()),
          ),
          const SizedBox(width: AppSpacing.lg + 2),
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
          Text('${(progress * 100).round()}%', style: AppTypography.onboardingProgress),
        ],
      ),
    );
  }
}