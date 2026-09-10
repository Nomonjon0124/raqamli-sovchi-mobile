import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/service_locator.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/ui/widgets/app_round_icon_button.dart';
import '../../../../core/ui/widgets/app_toast.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/user_profile.dart';
import '../bloc/edit_profile/edit_profile_bloc.dart';
import '../bloc/edit_profile/edit_profile_event.dart';
import '../bloc/edit_profile/edit_profile_state.dart';
import '../widgets/edit/profile_edit_avatar_section.dart';
import '../widgets/edit/profile_edit_bio_section.dart';
import '../widgets/edit/profile_edit_bottom_bar.dart';
import '../widgets/edit/profile_edit_field_row.dart';
import '../widgets/edit/profile_edit_status_sheets.dart';
import '../widgets/edit/profile_name_edit_sheet.dart';
import '../widgets/edit/profile_number_picker_sheet.dart';
import '../widgets/edit/profile_reference_picker_sheet.dart';
import 'profile_location_picker_page.dart';

final class ProfileEditPage extends StatelessWidget {
  const ProfileEditPage({this.initialProfile, super.key});

  final UserProfile? initialProfile;

  @override
  Widget build(BuildContext context) {
    final profile = initialProfile;
    return BlocProvider(
      create: (_) {
        final bloc = serviceLocator<EditProfileBloc>();
        if (profile != null) {
          bloc.add(EditProfileStarted(profile));
        }
        return bloc;
      },
      child: const _ProfileEditView(),
    );
  }
}

final class _ProfileEditView extends StatefulWidget {
  const _ProfileEditView();

  @override
  State<_ProfileEditView> createState() => _ProfileEditViewState();
}

final class _ProfileEditViewState extends State<_ProfileEditView> {
  late final TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<EditProfileBloc>();
    _bioController = TextEditingController(text: bloc.state.bio);
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocConsumer<EditProfileBloc, EditProfileState>(
      listenWhen: (previous, current) =>
          previous.status != current.status ||
          (previous.failure != current.failure && current.failure != null),
      listener: (context, state) async {
        if (state.status == EditProfileStatus.success) {
          await showProfileUpdatedSheet(context);
          if (!context.mounted) return;
          Navigator.of(context).pop(true);
        } else if (state.failure != null) {
          AppToast.show(
            context,
            message: l10n.failureMessage(state.failure!.type.name),
            type: ToastType.error,
          );
        }

        if (_bioController.text != state.bio &&
            state.status == EditProfileStatus.ready) {
          _bioController.text = state.bio;
        }
      },
      builder: (context, state) {
        return PopScope<void>(
          canPop: !state.hasUnsavedChanges && !state.isSubmitting,
          onPopInvokedWithResult: (didPop, _) {
            if (didPop || state.isSubmitting) return;
            _handleCancel(context, state);
          },
          child: Scaffold(
            backgroundColor: AppColors.surfaceLight,
            bottomNavigationBar: ProfileEditBottomBar(
              onSave: () => context.read<EditProfileBloc>().add(
                const EditProfileSubmitted(),
              ),
              onCancel: () => _handleCancel(context, state),
              isLoading: state.isSubmitting,
              isSaveEnabled: state.isSaveEnabled,
            ),
            body: SafeArea(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.section,
                  vertical: AppSpacing.input,
                ),
                children: [
                  _buildHeader(context, state, l10n),
                  const SizedBox(height: AppSpacing.card),
                  ProfileEditAvatarSection(
                    initials: state.initials,
                    photoUrl: state.mainPhotoUrl,
                    localPhotoPath: state.localPhotoPath,
                    isUploading: state.isUploadingPhoto,
                    onChangePhoto: () => _openPhotoManagement(context, state),
                  ),
                  const SizedBox(height: AppSpacing.card),
                  _buildFieldRows(context, state, l10n),
                  const SizedBox(height: AppSpacing.card),
                  ProfileEditBioSection(
                    controller: _bioController,
                    onChanged: (bio) => context.read<EditProfileBloc>().add(
                      EditProfileBioChanged(bio),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _openPhotoManagement(
    BuildContext context,
    EditProfileState state,
  ) async {
    final profile = state.originalProfile;
    if (profile == null || state.isUploadingPhoto) return;
    final updated = await context.push<UserProfile>(
      RouteNames.profilePhotos,
      extra: profile,
    );
    if (!context.mounted || updated == null) return;
    context.read<EditProfileBloc>().add(EditProfilePhotosUpdated(updated));
  }

  Widget _buildHeader(
    BuildContext context,
    EditProfileState state,
    AppLocalizations l10n,
  ) {
    return Row(
      children: [
        AppRoundIconButton(
          icon: Assets.icons.icArrowLeft01Round,
          semanticLabel: l10n.settingsBack,
          onPressed: () => _handleCancel(context, state),
        ),
        Expanded(
          child: Text(
            l10n.profileEditTitle,
            textAlign: TextAlign.center,
            style: AppTypography.settingsPageTitle,
          ),
        ),
        const SizedBox(width: 36, height: 36),
      ],
    );
  }

  Widget _buildFieldRows(
    BuildContext context,
    EditProfileState state,
    AppLocalizations l10n,
  ) {
    final currentYear = DateTime.now().year;

    return Column(
      children: [
        ProfileEditFieldRow(
          label: l10n.profileEditName,
          value: state.displayName,
          placeholder: l10n.profileEditSelectOption,
          hasChevron: false,
          onTap: () => ProfileNameEditSheet.show(
            context: context,
            initialFirstName: state.firstName,
            initialLastName: state.lastName,
            onConfirm: (first, last) => context.read<EditProfileBloc>().add(
              EditProfileNameChanged(firstName: first, lastName: last),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        ProfileEditFieldRow(
          label: l10n.profileEditBirthYear,
          value: state.birthYear != null ? '${state.birthYear}' : '',
          placeholder: l10n.profileEditSelectOption,
          hasChevron: false,
          onTap: () => ProfileNumberPickerSheet.show(
            context: context,
            title: l10n.profileEditBirthYear,
            initialValue: state.birthYear ?? 2000,
            minValue: currentYear - 70,
            maxValue: currentYear - 16,
            unit: '',
            onConfirm: (year) => context.read<EditProfileBloc>().add(
              EditProfileBirthYearChanged(year),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        ProfileEditFieldRow(
          label: l10n.profileEditHeight,
          value: state.height != null ? l10n.profileEditCm(state.height!) : '',
          placeholder: l10n.profileEditSelectOption,
          hasChevron: false,
          onTap: () => ProfileNumberPickerSheet.show(
            context: context,
            title: l10n.profileEditHeight,
            initialValue: state.height ?? 170,
            minValue: 130,
            maxValue: 220,
            unit: 'sm',
            onConfirm: (height) => context.read<EditProfileBloc>().add(
              EditProfileHeightChanged(height),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        ProfileEditFieldRow(
          label: l10n.profileEditWeight,
          value: state.weight != null ? l10n.profileEditKg(state.weight!) : '',
          placeholder: l10n.profileEditSelectOption,
          hasChevron: false,
          onTap: () => ProfileNumberPickerSheet.show(
            context: context,
            title: l10n.profileEditWeight,
            initialValue: state.weight ?? 65,
            minValue: 35,
            maxValue: 160,
            unit: 'kg',
            onConfirm: (weight) => context.read<EditProfileBloc>().add(
              EditProfileWeightChanged(weight),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        ProfileEditFieldRow(
          label: l10n.profileEditEducation,
          value: state.educationLevelName ?? '',
          placeholder: l10n.profileEditSelectOption,
          onTap: () => ProfileReferencePickerSheet.show(
            context: context,
            title: l10n.profileEditEducation,
            items: state.educationLevels,
            selectedId: state.educationLevelId,
            onConfirm: (item) => context.read<EditProfileBloc>().add(
              EditProfileEducationChanged(id: item.id, name: item.name),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        ProfileEditFieldRow(
          label: l10n.profileEditProfession,
          value: state.professionName ?? '',
          placeholder: l10n.profileEditSelectOption,
          onTap: () => ProfileReferencePickerSheet.show(
            context: context,
            title: l10n.profileEditProfession,
            items: state.professions,
            selectedId: state.professionId,
            hasSearch: true,
            searchPlaceholder: l10n.profileEditSearchPlaceholder,
            hasOther: true,
            otherLabel: l10n.profileEditProfessionOther,
            otherInputLabel: l10n.profileEditProfessionInputLabel,
            onConfirm: (item) => context.read<EditProfileBloc>().add(
              EditProfileProfessionChanged(id: item.id, name: item.name),
            ),
            onConfirmCustom: (customName) => context
                .read<EditProfileBloc>()
                .add(EditProfileProfessionCustomSubmitted(customName)),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        ProfileEditFieldRow(
          label: l10n.profileEditRegion,
          value: state.regionName ?? '',
          placeholder: l10n.profileEditSelectOption,
          onTap: () => _openRegionPicker(context, state),
        ),
        const SizedBox(height: AppSpacing.sm),
        ProfileEditFieldRow(
          label: l10n.profileEditDistrict,
          value: state.districtName ?? '',
          placeholder: l10n.profileEditSelectOption,
          onTap: () {
            if (state.regionId == null || state.regionId!.isEmpty) {
              AppToast.show(
                context,
                message: l10n.profileEditSelectRegionFirst,
                type: ToastType.info,
              );
              return;
            }
            _openDistrictPicker(context, state);
          },
        ),
        const SizedBox(height: AppSpacing.sm),
        ProfileEditFieldRow(
          label: l10n.profileEditMaritalStatus,
          value: state.maritalStatusName ?? '',
          placeholder: l10n.profileEditSelectOption,
          onTap: () => ProfileReferencePickerSheet.show(
            context: context,
            title: l10n.profileEditMaritalStatus,
            items: state.maritalStatuses,
            selectedId: state.maritalStatusId,
            onConfirm: (item) => context.read<EditProfileBloc>().add(
              EditProfileMaritalStatusChanged(id: item.id, name: item.name),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openRegionPicker(
    BuildContext context,
    EditProfileState state,
  ) async {
    final bloc = context.read<EditProfileBloc>();
    final selected = await Navigator.of(context).push<ReferenceItem>(
      MaterialPageRoute(
        builder: (_) => ProfileRegionPickerPage(
          regions: state.regions,
          selectedId: state.regionId,
        ),
      ),
    );
    if (selected == null || !context.mounted) return;
    bloc.add(EditProfileRegionChanged(id: selected.id, name: selected.name));
  }

  Future<void> _openDistrictPicker(
    BuildContext context,
    EditProfileState state,
  ) async {
    final bloc = context.read<EditProfileBloc>();
    final selected = await Navigator.of(context).push<ReferenceItem>(
      MaterialPageRoute(
        builder: (_) => ProfileDistrictPickerPage(
          regionName: state.regionName ?? '',
          districts: state.districts,
          selectedId: state.districtId,
        ),
      ),
    );
    if (selected == null || !context.mounted) return;
    bloc.add(EditProfileDistrictChanged(id: selected.id, name: selected.name));
  }

  Future<void> _handleCancel(
    BuildContext context,
    EditProfileState state,
  ) async {
    if (state.isSubmitting) return;

    if (!state.hasUnsavedChanges) {
      await Navigator.of(context).maybePop(false);
      return;
    }

    final shouldExit = await showProfileUnsavedChangesSheet(context);
    if (!shouldExit || !context.mounted) return;
    Navigator.of(context).pop(false);
  }
}
