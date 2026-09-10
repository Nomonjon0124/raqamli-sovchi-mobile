import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/service_locator.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/ui/widgets/app_round_icon_button.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../onboarding/presentation/widgets/custom_primary_button.dart';
import '../../../onboarding/presentation/widgets/face_rule_bullet.dart';
import '../../../onboarding/presentation/widgets/onboarding_face_camera.dart';
import '../bloc/profile_face_verification/profile_face_verification_bloc.dart';
import '../bloc/profile_face_verification/profile_face_verification_event.dart';
import '../bloc/profile_face_verification/profile_face_verification_state.dart';

final class ProfileFaceVerificationPage extends StatelessWidget {
  const ProfileFaceVerificationPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => serviceLocator<ProfileFaceVerificationBloc>(),
    child: const _ProfileFaceVerificationView(),
  );
}

final class _ProfileFaceVerificationView extends StatelessWidget {
  const _ProfileFaceVerificationView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<
      ProfileFaceVerificationBloc,
      ProfileFaceVerificationState
    >(
      builder: (context, state) {
        final success = state.status == ProfileFaceVerificationStatus.success;
        final verifying =
            state.status == ProfileFaceVerificationStatus.verifying;
        return Scaffold(
          backgroundColor: AppColors.surfaceLight,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.section,
                AppSpacing.input,
                AppSpacing.section,
                AppSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppRoundIconButton(
                    icon: Assets.icons.icArrowLeft01Round,
                    semanticLabel: l10n.backLabel,
                    onPressed: verifying
                        ? null
                        : () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(l10n.faceCaptureTitle, style: AppTypography.pageTitle),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    l10n.faceCaptureSubtitle,
                    style: AppTypography.onboardingBody,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          if (!success)
                            OnboardingFaceCamera(
                              key: ValueKey(state.status),
                              hint: l10n.faceHint,
                              cameraLabel: l10n.selfieCameraLabel,
                              errorLabel: l10n.faceCameraError,
                              retryLabel: l10n.retry,
                              onCaptured: (path) => context
                                  .read<ProfileFaceVerificationBloc>()
                                  .add(ProfileFaceVerificationCaptured(path)),
                            )
                          else
                            const SizedBox(
                              height: 230,
                              child: Center(
                                child: Icon(
                                  Icons.verified_rounded,
                                  size: 96,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          const SizedBox(height: AppSpacing.lg + AppSpacing.xs),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (final rule in [
                                l10n.faceRuleOne,
                                l10n.faceRuleTwo,
                                l10n.faceRuleThree,
                              ]) ...[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const FaceRuleBullet(),
                                    const SizedBox(width: AppSpacing.inline),
                                    Expanded(
                                      child: Text(
                                        rule,
                                        style:
                                            AppTypography.onboardingPledgeBody,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppSpacing.xs),
                              ],
                            ],
                          ),
                          if (verifying) ...[
                            const SizedBox(height: AppSpacing.lg),
                            const CircularProgressIndicator(),
                          ],
                          if (state.status ==
                              ProfileFaceVerificationStatus.failure) ...[
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              l10n.faceRetryHint,
                              style: AppTypography.onboardingBody,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  CustomPrimaryButton(
                    label: success
                        ? l10n.profileFaceVerificationDone
                        : l10n.takeSelfieLabel,
                    onPressed: success
                        ? () => Navigator.of(context).pop(true)
                        : null,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
