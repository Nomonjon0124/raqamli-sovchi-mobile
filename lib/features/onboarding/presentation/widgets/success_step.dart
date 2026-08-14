import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../l10n/app_localizations.dart';
import 'custom_primary_button.dart';

final class SuccessStep extends StatelessWidget {
  const SuccessStep({super.key,
    required this.title,
    required this.subtitle,
    required this.aiTitle,
    required this.aiDescription,
    required this.aiPointOne,
    required this.aiPointTwo,
    required this.aiPointThree,
    required this.startLabel,
    required this.laterLabel,
    required this.onStart,
    required this.onLater,
  });

  final String title;
  final String subtitle;
  final String aiTitle;
  final String aiDescription;
  final String aiPointOne;
  final String aiPointTwo;
  final String aiPointThree;
  final String startLabel;
  final String laterLabel;
  final VoidCallback onStart;
  final VoidCallback onLater;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 28),
                  Center(
                    child: Container(
                      width: 64,
                      height: 64,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                      child: Assets.icons.icVerifyCheck.svg(width: 32, height: 32, excludeFromSemantics: true),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(title, style: AppTypography.onboardingTitle.copyWith()),
                  const SizedBox(height: AppSpacing.sm),
                  Text(subtitle, style: AppTypography.onboardingBody.copyWith()),
                  const SizedBox(height: 20),
                  _AiTestOfferCard(title: aiTitle, description: aiDescription, pointOne: aiPointOne, pointTwo: aiPointTwo, pointThree: aiPointThree),
                  const Spacer(),
                  CustomPrimaryButton(label: startLabel, onPressed: onStart),
                  const SizedBox(height: AppSpacing.md),
                  // CustomGhostButton(label: laterLabel, onPressed: onLater),
                  TextButton(onPressed: onLater, child: Text(laterLabel)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

final class _AiTestOfferCard extends StatelessWidget {
  const _AiTestOfferCard({required this.title, required this.description, required this.pointOne, required this.pointTwo, required this.pointThree});

  final String title;
  final String description;
  final String pointOne;
  final String pointTwo;
  final String pointThree;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.primary, width: 1.5),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _AiBadge(),
          const SizedBox(height: 15),
          Text(title, style: AppTypography.onboardingTitle.copyWith(fontSize: 20, height: 32 / 25, letterSpacing: -0.2)),
          const SizedBox(height: 15),
          Text(description, style: AppTypography.onboardingBody.copyWith(fontSize: 13, height: 25 / 15)),
          const SizedBox(height: 15),
          _AiFeatureRow(icon: Assets.icons.icAi, label: pointOne),
          const SizedBox(height: AppSpacing.md),
          _AiFeatureRow(icon: Assets.icons.icPersons, label: pointTwo),
          const SizedBox(height: AppSpacing.md),
          _AiFeatureRow(icon: Assets.icons.icGlyph, label: pointThree),
        ],
      ),
    );
  }
}

final class _AiBadge extends StatelessWidget {
  const _AiBadge();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(AppRadius.full)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Assets.icons.icAi.svg(
              width: 12,
              height: 12,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              excludeFromSemantics: true,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              AppLocalizations.of(context).aiTestBadge,
              style: AppTypography.onboardingCardBody.copyWith(
                color: Colors.white,
                fontSize: 10,
                height: 16 / 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _AiFeatureRow extends StatelessWidget {
  const _AiFeatureRow({required this.icon, required this.label});

  final SvgGenImage icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: Center(
            child: icon.svg(
              width: 16,
              height: 16,
              colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
              excludeFromSemantics: true,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.inline),
        Expanded(
          child: Text(label, style: AppTypography.onboardingBody.copyWith(fontSize: 12, color: AppColors.bodyText)),
        ),
      ],
    );
  }
}