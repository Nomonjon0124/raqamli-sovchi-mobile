import 'package:flutter/material.dart';
import 'package:raqamli_sovchi/features/onboarding/presentation/widgets/representative_onboarding_widgets/representative_header.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_typography.dart';

final class RepresentativeLayout extends StatelessWidget {
  const RepresentativeLayout({super.key,
    required this.title,
    required this.child,
    required this.bottom,
    this.subtitle,
    this.eyebrow,
    this.progress,
    this.keyboardAware = false,
  });

  final String title;
  final String? subtitle;
  final String? eyebrow;
  final double? progress;
  final Widget child;
  final Widget bottom;
  final bool keyboardAware;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (progress != null) ...[RepresentativeHeader(progress: progress!), const SizedBox(height: AppSpacing.lg + AppSpacing.xs)],
        if (eyebrow != null) ...[
          Text(eyebrow!, style: AppTypography.onboardingFieldLabel.copyWith(color: AppColors.primary)),
          const SizedBox(height: AppSpacing.xl),
        ],
        Text(title, style: AppTypography.onboardingTitle),
        if (subtitle != null) ...[const SizedBox(height: AppSpacing.sm), Text(subtitle!, style: AppTypography.onboardingBody)],
        const SizedBox(height: AppSpacing.lg + AppSpacing.xs),
        child,
        const Spacer(),
        bottom,
      ],
    );
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: keyboardAware
          ? LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(child: content),
          ),
        ),
      )
          : LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(child: content),
          ),
        ),
      ),
    );
  }
}