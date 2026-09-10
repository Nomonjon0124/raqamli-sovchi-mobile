import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/service_locator.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/ui/widgets/app_round_icon_button.dart';
import '../../../../core/ui/widgets/app_toast.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/services/profile_photo_picker.dart';
import '../../domain/entities/user_profile.dart';
import '../bloc/profile_photo_management/profile_photo_management_bloc.dart';
import '../bloc/profile_photo_management/profile_photo_management_event.dart';
import '../bloc/profile_photo_management/profile_photo_management_state.dart';
import '../widgets/profile_photo_sheets.dart';

final class ProfilePhotoManagementPage extends StatelessWidget {
  const ProfilePhotoManagementPage({required this.initialProfile, super.key});

  final UserProfile initialProfile;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) =>
        serviceLocator<ProfilePhotoManagementBloc>()
          ..add(ProfilePhotoManagementStarted(initialProfile)),
    child: const _ProfilePhotoManagementView(),
  );
}

final class _ProfilePhotoManagementView extends StatelessWidget {
  const _ProfilePhotoManagementView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocConsumer<
      ProfilePhotoManagementBloc,
      ProfilePhotoManagementState
    >(
      listenWhen: (previous, current) =>
          previous.failure != current.failure ||
          previous.verificationPending != current.verificationPending,
      listener: (context, state) async {
        if (state.failure != null) {
          AppToast.show(
            context,
            message: l10n.failureMessage(state.failure!.type.name),
            type: ToastType.error,
          );
        }
        if (!state.verificationPending || !context.mounted) return;
        final bloc = context.read<ProfilePhotoManagementBloc>();
        bloc.add(const ProfilePhotoManagementVerificationOpened());
        final verified = await context.push<bool>(
          RouteNames.profileFaceVerification,
        );
        if (!context.mounted || verified != true) return;
        bloc.add(const ProfilePhotoManagementVerificationCompleted());
        context.pop(bloc.state.profile);
      },
      builder: (context, state) {
        final profile = state.profile;
        return PopScope<UserProfile?>(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop && !state.isBusy && !state.verificationRequired) {
              context.pop(profile);
            }
          },
          child: Scaffold(
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
                    _Header(onBack: () => _back(context, state)),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      l10n.profilePhotoManagementSubtitle,
                      style: AppTypography.onboardingBody.copyWith(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Expanded(
                      child: _PhotoGrid(
                        photos: state.photos,
                        isBusy: state.isBusy,
                        onAdd: () => _pick(context),
                        onTap: (photo) => _openActions(context, photo),
                      ),
                    ),
                    _ConfirmButton(
                      label: l10n.profilePhotoConfirm,
                      enabled: !state.isBusy && !state.verificationRequired,
                      onPressed: () => _back(context, state),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _back(BuildContext context, ProfilePhotoManagementState state) {
    if (state.isBusy || state.verificationRequired) return;
    context.pop(state.profile);
  }

  Future<void> _pick(BuildContext context) async {
    final source = await showProfilePhotoSourceSheet(context);
    if (!context.mounted || source == null) return;
    context.read<ProfilePhotoManagementBloc>().add(
      ProfilePhotoManagementPickRequested(
        source == ProfilePhotoPickerSource.camera
            ? ProfilePhotoSource.camera
            : ProfilePhotoSource.gallery,
      ),
    );
  }

  Future<void> _openActions(BuildContext context, ProfilePhoto photo) async {
    final action = await showProfilePhotoActionsSheet(context);
    if (!context.mounted || action == null) return;
    final bloc = context.read<ProfilePhotoManagementBloc>();
    switch (action) {
      case ProfilePhotoAction.setMain:
        if (photo.isMain) return;
        bloc.add(ProfilePhotoManagementSetMainRequested(photo.id));
      case ProfilePhotoAction.replace:
        final source = await showProfilePhotoSourceSheet(context);
        if (!context.mounted || source == null) return;
        bloc.add(
          ProfilePhotoManagementPickRequested(
            source == ProfilePhotoPickerSource.camera
                ? ProfilePhotoSource.camera
                : ProfilePhotoSource.gallery,
            replacePhotoId: photo.id,
          ),
        );
      case ProfilePhotoAction.delete:
        final confirmed = await showProfilePhotoDeleteDialog(context);
        if (confirmed == true && context.mounted) {
          bloc.add(ProfilePhotoManagementDeleteRequested(photo.id));
        }
    }
  }
}

final class _Header extends StatelessWidget {
  const _Header({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      AppRoundIconButton(
        icon: Assets.icons.icArrowLeft01Round,
        semanticLabel: AppLocalizations.of(context).backLabel,
        onPressed: onBack,
      ),
      const SizedBox(width: AppSpacing.lg),
      Expanded(
        child: Text(
          AppLocalizations.of(context).profilePhotoManagementTitle,
          style: AppTypography.pageTitle,
        ),
      ),
    ],
  );
}

final class _PhotoGrid extends StatelessWidget {
  const _PhotoGrid({
    required this.photos,
    required this.isBusy,
    required this.onAdd,
    required this.onTap,
  });

  final List<ProfilePhoto> photos;
  final bool isBusy;
  final VoidCallback onAdd;
  final ValueChanged<ProfilePhoto> onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: 108.67 / 132,
      ),
      itemCount: photos.length < 5 ? photos.length + 1 : photos.length,
      itemBuilder: (context, index) {
        if (index >= photos.length) {
          return _AddSlot(
            label: l10n.profileAddPhoto,
            enabled: !isBusy,
            onTap: onAdd,
          );
        }
        return _PhotoSlot(
          photo: photos[index],
          mainLabel: l10n.profileMainPhoto,
          semanticLabel: l10n.profilePhotoSemantics(index + 1),
          enabled: !isBusy,
          onTap: () => onTap(photos[index]),
        );
      },
    );
  }
}

final class _PhotoSlot extends StatelessWidget {
  const _PhotoSlot({
    required this.photo,
    required this.mainLabel,
    required this.semanticLabel,
    required this.enabled,
    required this.onTap,
  });

  final ProfilePhoto photo;
  final String mainLabel;
  final String semanticLabel;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    image: true,
    label: semanticLabel,
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: photo.isMain ? AppColors.primary : AppColors.border,
              width: photo.isMain ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: photo.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => const ColoredBox(
                    color: AppColors.mutedSurface,
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (_, _, _) => const ColoredBox(
                    color: AppColors.mutedSurface,
                    child: Icon(
                      Icons.person_rounded,
                      color: AppColors.mutedText,
                    ),
                  ),
                ),
                if (photo.isMain)
                  Positioned(
                    top: AppSpacing.xs,
                    left: AppSpacing.xs,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        child: Text(
                          mainLabel,
                          style: AppTypography.onboardingFieldLabel.copyWith(
                            color: AppColors.surfaceLight,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

final class _AddSlot extends StatelessWidget {
  const _AddSlot({
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label,
    child: Material(
      color: AppColors.subtleSurface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: CustomPaint(
          foregroundPainter: _PhotoManagementDashedBorderPainter(),
          child: Center(
            child: Assets.icons.profileAdd.svg(
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                AppColors.mutedText,
                BlendMode.srcIn,
              ),
              excludeFromSemantics: true,
            ),
          ),
        ),
      ),
    ),
  );
}

final class _ConfirmButton extends StatelessWidget {
  const _ConfirmButton({
    required this.label,
    required this.enabled,
    required this.onPressed,
  });

  final String label;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 56,
    child: FilledButton(
      onPressed: enabled ? onPressed : null,
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        disabledBackgroundColor: AppColors.border,
        foregroundColor: AppColors.surfaceLight,
        textStyle: AppTypography.onboardingAction,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          const SizedBox(width: AppSpacing.sm),
          const Icon(Icons.chevron_right_rounded, size: 20),
        ],
      ),
    ),
  );
}

final class _PhotoManagementDashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          const Radius.circular(AppRadius.lg),
        ),
      );
    final metric = path.computeMetrics().first;
    final paint = Paint()
      ..color = AppColors.profileDashedBorder
      ..style = PaintingStyle.stroke;
    for (var distance = 0.0; distance < metric.length;) {
      final end = (distance + 5).clamp(0.0, metric.length);
      canvas.drawPath(metric.extractPath(distance, end), paint);
      distance += 9;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
