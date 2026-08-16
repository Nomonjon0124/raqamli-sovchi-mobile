import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raqamli_sovchi/features/onboarding/presentation/widgets/pladge_card.dart';
import 'package:raqamli_sovchi/features/onboarding/presentation/widgets/pledge_confirmation_step.dart';
import 'package:raqamli_sovchi/features/onboarding/presentation/widgets/selection_card.dart';
import 'package:raqamli_sovchi/features/onboarding/presentation/widgets/step_layout.dart';
import 'package:raqamli_sovchi/features/onboarding/presentation/widgets/success_step.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/ui/widgets/app_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/candidate_type.dart';
import '../../domain/entities/onboarding_reference.dart';
import '../../domain/entities/profile_onboarding_draft.dart';
import '../bloc/profile_onboarding_bloc.dart';
import '../bloc/profile_onboarding_event.dart';
import '../bloc/profile_onboarding_state.dart';
import 'about_me_text_area.dart';
import 'agreement_row.dart';
import 'children_count_control.dart';
import 'children_not_living_card.dart';
import 'custom_ghost_button.dart';
import 'custom_primary_button.dart';
import 'education_chip.dart';
import 'face_rule_bullet.dart';
import 'figma_step_layout.dart';
import 'health_status_option.dart';
import 'onboarding_date_wheel_picker.dart';
import 'onboarding_face_camera.dart';
import 'onboarding_height_weight_input.dart';
import 'onboarding_location_selector_row.dart';
import 'onboarding_photo_grid.dart';
import 'onboarding_reference_bottom_sheet.dart';
import 'onboarding_text_field.dart';
import 'onboarding_voice_recorder.dart';

final class ProfileOnboardingStepContent extends StatefulWidget {
  const ProfileOnboardingStepContent({
    required this.step,
    required this.state,
    this.representativeMode = false,
    super.key,
  });

  final OnboardingStep step;
  final ProfileOnboardingState state;
  final bool representativeMode;

  @override
  State<ProfileOnboardingStepContent> createState() =>
      _ProfileOnboardingStepContentState();
}

final class _ProfileOnboardingStepContentState
    extends State<ProfileOnboardingStepContent> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _patronymicController = TextEditingController();
  final _aboutMeController = TextEditingController();
  DateTime? _selectedBirthDate;
  int? _selectedHeight;
  int? _selectedWeight;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _patronymicController.dispose();
    _aboutMeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bloc = context.read<ProfileOnboardingBloc>();
    final draft = widget.state.draft!;
    final content = switch (widget.step) {
      OnboardingStep.candidateType => _candidateType(l10n, draft, bloc),
      OnboardingStep.pledge => _pledge(l10n, draft, bloc),
      OnboardingStep.birthDate => _birthDate(l10n, draft, bloc),
      OnboardingStep.identity => _identity(l10n, draft, bloc),
      OnboardingStep.education => _education(l10n, draft, bloc),
      OnboardingStep.height => _height(l10n, draft, bloc),
      OnboardingStep.location => _location(l10n, draft, bloc),
      OnboardingStep.healthStatus => _healthStatus(l10n, draft, bloc),
      OnboardingStep.maritalStatus => _maritalStatus(l10n, draft, bloc),
      OnboardingStep.photos => StepLayout(
        title: widget.representativeMode
            ? l10n.representativePhotoTitle
            : l10n.photoTitle,
        subtitle: widget.representativeMode
            ? l10n.representativePhotoHint
            : l10n.photoHint,
        step: widget.step,
        bottom: CustomPrimaryButton(
          label: l10n.continueLabel,
          onPressed: draft.photos.isEmpty || widget.state.isBusy
              ? null
              : () => bloc.add(const ProfilePhotosContinuePressed()),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OnboardingPhotoGrid(
              photos: draft.photos,
              addLabel: l10n.photoSlotAddLabel,
              removeLabel: l10n.removePhoto,
              retryLabel: l10n.retry,
              filledLabelBuilder: l10n.photoSlotFilledLabel,
              mainBadgeLabel: l10n.mainPhotoBadge,
              onAdd: draft.photos.length >= 5 || widget.state.isBusy
                  ? null
                  : () => bloc.add(const ProfilePhotoPickRequested()),
              onRemove: (localFilePath) =>
                  bloc.add(ProfilePhotoRemoveRequested(localFilePath)),
              onRetry: (localFilePath) =>
                  bloc.add(ProfilePhotoUploadRetryRequested(localFilePath)),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              l10n.photoPrivacyHint,
              style: AppTypography.onboardingCardBody,
            ),
          ],
        ),
      ),
      OnboardingStep.mainPhoto => StepLayout(
        title: l10n.mainPhotoSelectionHint,
        subtitle: widget.representativeMode
            ? l10n.representativeMainPhotoSubtitle
            : l10n.mainPhotoSubtitle,
        step: widget.step,
        bottom: CustomPrimaryButton(
          label: l10n.confirmLabel,
          onPressed: draft.hasMainPhoto && !widget.state.isBusy
              ? () => bloc.add(const MainPhotoContinuePressed())
              : null,
        ),
        child: OnboardingPhotoGrid(
          photos: draft.photos,
          addLabel: l10n.photoSlotAddLabel,
          removeLabel: l10n.removePhoto,
          retryLabel: l10n.retry,
          filledLabelBuilder: l10n.photoSlotFilledLabel,
          mainBadgeLabel: l10n.mainPhotoBadge,
          onAdd: null,
          onRemove: (localFilePath) =>
              bloc.add(ProfilePhotoRemoveRequested(localFilePath)),
          onRetry: (localFilePath) =>
              bloc.add(ProfilePhotoUploadRetryRequested(localFilePath)),
          onMainSelected: widget.state.isBusy
              ? null
              : (serverId) => bloc.add(ProfilePhotoMainSelected(serverId)),
          showRemoveButton: false,
          showMainBadge: true,
        ),
      ),
      OnboardingStep.faceVerification => _face(l10n, draft, bloc),
      OnboardingStep.aboutMe => _aboutMe(l10n, draft, bloc),
      OnboardingStep.voiceIntro => StepLayout(
        title: widget.representativeMode
            ? l10n.representativeVoiceTitle
            : l10n.voiceTitle,
        subtitle: widget.representativeMode
            ? l10n.representativeVoiceSubtitle
            : l10n.voiceSubtitle,
        step: widget.step,
        bottom: Column(
          children: [
            CustomPrimaryButton(
              label: l10n.continueLabel,
              onPressed: widget.state.isVoiceRecording || widget.state.isBusy
                  ? null
                  : () => bloc.add(const VoiceIntroContinuePressed()),
            ),
            const SizedBox(height: AppSpacing.md),
            CustomGhostButton(
              label: l10n.skipLabel,
              onPressed:
                  widget.state.isVoiceRecording ||
                      widget.state.isVoicePlaying ||
                      widget.state.isBusy
                  ? null
                  : () => bloc.add(const VoiceIntroSkipped()),
            ),
          ],
        ),
        child: OnboardingVoiceRecorder(
          isRecording: widget.state.isVoiceRecording,
          isPlaying: widget.state.isVoicePlaying,
          hasRecording: draft.voiceIntroMetadata != null,
          recordLabel: widget.state.isVoiceRecording
              ? l10n.stopRecording
              : l10n.startRecording,
          playLabel: l10n.playRecording,
          reRecordLabel: l10n.reRecordVoice,
          deleteLabel: l10n.deleteVoice,
          hint: l10n.startRecordingHint,
          recordingHint: l10n.recordedVoiceHint,
          recordingDuration: _formatDuration(
            draft.voiceIntroMetadata?.duration,
          ),
          onRecordPressed: () => bloc.add(
            widget.state.isVoiceRecording
                ? const VoiceRecordingStopped()
                : const VoiceRecordingStarted(),
          ),
          onPlayPressed: draft.voiceIntroMetadata == null
              ? null
              : () => bloc.add(const VoicePlaybackRequested()),
          onRewritePressed: widget.state.isVoicePlaying
              ? null
              : () => bloc.add(const VoiceRecordingStarted()),
          onDeletePressed: widget.state.isVoicePlaying
              ? null
              : () => bloc.add(const VoiceIntroDeleted()),
        ),
      ),
      OnboardingStep.locationPermission => StepLayout(
        title: widget.representativeMode
            ? l10n.representativeLocationPermissionTitle
            : l10n.locationPermissionTitle,
        subtitle: widget.representativeMode
            ? l10n.representativeLocationPermissionSubtitle
            : l10n.locationPermissionSubtitle,
        step: widget.step,
        bottom: CustomPrimaryButton(
          label: l10n.enableLocation,
          onPressed: widget.state.isLocationLoading || widget.state.isBusy
              ? null
              : () => bloc.add(const LocationPermissionRequested()),
        ),
        child: Container(
          width: double.infinity,
          height: 180,
          decoration: BoxDecoration(
            color: AppColors.mutedSurface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          alignment: Alignment.center,
          child: widget.state.isLocationLoading
              ? const CircularProgressIndicator()
              : const Icon(
                  Icons.location_on_outlined,
                  size: 48,
                  color: AppColors.mutedText,
                ),
        ),
      ),
      OnboardingStep.success => PledgeConfirmationStep(
        title: l10n.pledgeConfirmationTitle,
        subtitle: l10n.pledgeConfirmationSubtitle,
        pointOne: l10n.pledgeConfirmationPointOne,
        pointTwo: l10n.pledgeConfirmationPointTwo,
        pointThree: l10n.pledgeConfirmationPointThree,
        buttonLabel: l10n.pledgeConfirmationButton,
        onConfirm: () =>
            bloc.add(const ProfileOnboardingFinalizationRequested()),
      ),
      OnboardingStep.profileReady => SuccessStep(
        title: l10n.onboardingSuccessTitle,
        subtitle: l10n.onboardingSuccessSubtitle,
        aiTitle: l10n.aiTestTitle,
        aiDescription: l10n.aiTestDescription,
        aiPointOne: l10n.aiTestPointOne,
        aiPointTwo: l10n.aiTestPointTwo,
        aiPointThree: l10n.aiTestPointThree,
        startLabel: l10n.startAiTest,
        laterLabel: l10n.viewCandidatesLater,
        onStart: () => bloc.add(const ProfileReadyQuestionnaireRequested()),
        onLater: () => bloc.add(const ProfileReadyHomeRequested()),
      ),
      OnboardingStep.representativeIntro ||
      OnboardingStep.representativeIdentity ||
      OnboardingStep.representativeRelation ||
      OnboardingStep.representativeCandidateType ||
      OnboardingStep.representativeContact ||
      OnboardingStep.representativeConsentSent ||
      OnboardingStep.representativePledge ||
      OnboardingStep.representativeReady => const SizedBox.shrink(),
    };
    return Padding(
      padding:
          widget.step == OnboardingStep.candidateType ||
              widget.step == OnboardingStep.pledge
          ? const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.lg + AppSpacing.xs,
              AppSpacing.xl,
              AppSpacing.xl,
            )
          : const EdgeInsets.all(AppSpacing.xl),
      child: content,
    );
  }

  Widget _candidateType(
    AppLocalizations l10n,
    ProfileOnboardingDraft draft,
    ProfileOnboardingBloc bloc,
  ) {
    return FigmaStepLayout(
      title: l10n.candidateTypeTitle,
      subtitle: l10n.candidateTypeSubtitle,
      bottom: CustomPrimaryButton(
        label: l10n.continueLabel,
        onPressed: draft.candidateType == null
            ? null
            : () => bloc.add(const CandidateTypeContinuePressed()),
      ),
      child: Column(
        children: [
          SelectionCard(
            label: l10n.groomCandidateTitle,
            detail: l10n.groomCandidateSubtitle,
            selected: draft.candidateType == CandidateType.groom,
            onPressed: () =>
                bloc.add(const CandidateTypeSaved(CandidateType.groom)),
          ),
          const SizedBox(height: AppSpacing.md),
          SelectionCard(
            label: l10n.brideCandidateTitle,
            detail: l10n.brideCandidateSubtitle,
            selected: draft.candidateType == CandidateType.bride,
            onPressed: () =>
                bloc.add(const CandidateTypeSaved(CandidateType.bride)),
          ),
          const SizedBox(height: AppSpacing.md),
          SelectionCard(
            label: l10n.representativeCandidateTitle,
            detail: l10n.representativeCandidateSubtitle,
            selected: draft.candidateType == CandidateType.representative,
            onPressed: () => bloc.add(
              const CandidateTypeSaved(CandidateType.representative),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pledge(
    AppLocalizations l10n,
    ProfileOnboardingDraft draft,
    ProfileOnboardingBloc bloc,
  ) {
    return FigmaStepLayout(
      title: l10n.pledgeTitle,
      bottom: CustomPrimaryButton(
        label: l10n.pledgeStart,
        onPressed: draft.pledgeAcceptedTerms
            ? () => bloc.add(const PledgeContinuePressed())
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PledgeCard(
            points: [
              l10n.pledgePointOne,
              l10n.pledgePointTwo,
              l10n.pledgePointThree,
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AgreementRow(
            accepted: draft.pledgeAcceptedTerms,
            label: l10n.pledgeAgreement,
            onChanged: (value) => bloc.add(PledgeAcceptanceChanged(value)),
          ),
        ],
      ),
    );
  }

  Widget _birthDate(
    AppLocalizations l10n,
    ProfileOnboardingDraft draft,
    ProfileOnboardingBloc bloc,
  ) {
    final now = DateTime.now();
    final minimumDate = DateTime(now.year - 60, 1, 1);
    final maximumDate = DateTime(now.year - 18, 12, 31);
    final selectedDate =
        _selectedBirthDate ?? draft.birthDate ?? DateTime(now.year - 25, 1, 1);
    return StepLayout(
      step: widget.step,
      title: widget.representativeMode
          ? l10n.representativeBirthDateTitle
          : l10n.birthDateTitle,
      subtitle: l10n.birthDateSubtitle,
      dateWheel: true,
      keyboardAware: true,
      bottom: CustomPrimaryButton(
        label: l10n.continueLabel,
        onPressed: () => bloc.add(BirthDateSaved(selectedDate)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OnboardingDateWheelPicker(
            value: selectedDate,
            minimumDate: minimumDate,
            maximumDate: maximumDate,
            onChanged: (value) => setState(() => _selectedBirthDate = value),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.birthDateHint,
            textAlign: TextAlign.center,
            style: AppTypography.onboardingBody,
          ),
        ],
      ),
    );
  }

  Widget _identity(
    AppLocalizations l10n,
    ProfileOnboardingDraft draft,
    ProfileOnboardingBloc bloc,
  ) {
    if (_firstNameController.text.isEmpty && draft.firstName != null) {
      _firstNameController.text = draft.firstName!;
    }
    if (_lastNameController.text.isEmpty && draft.lastName != null) {
      _lastNameController.text = draft.lastName!;
    }
    if (_patronymicController.text.isEmpty && draft.patronymic != null) {
      _patronymicController.text = draft.patronymic!;
    }
    return StepLayout(
      step: widget.step,
      title: widget.representativeMode
          ? l10n.representativeCandidateIdentityTitle
          : l10n.identityTitle,
      subtitle: widget.representativeMode
          ? l10n.representativeCandidateIdentitySubtitle
          : l10n.identitySubtitle,
      keyboardAware: true,
      bottom: CustomPrimaryButton(
        label: l10n.continueLabel,
        onPressed:
            _firstNameController.text.trim().isEmpty ||
                _lastNameController.text.trim().isEmpty ||
                _patronymicController.text.trim().isEmpty
            ? null
            : () {
                FocusScope.of(context).unfocus();
                bloc.add(
                  IdentitySaved(
                    firstName: _firstNameController.text,
                    lastName: _lastNameController.text,
                    patronymic: _patronymicController.text,
                  ),
                );
              },
      ),
      child: Column(
        children: [
          OnboardingTextField(
            label: l10n.firstNameLabel,
            controller: _firstNameController,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: AppSpacing.md),
          OnboardingTextField(
            label: l10n.lastNameLabel,
            controller: _lastNameController,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: AppSpacing.md),
          OnboardingTextField(
            label: l10n.patronymicLabel,
            controller: _patronymicController,
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
    );
  }

  Widget _education(
    AppLocalizations l10n,
    ProfileOnboardingDraft draft,
    ProfileOnboardingBloc bloc,
  ) {
    final chips = widget.state.educationLevels
        .where((item) => item.id.isNotEmpty && item.name.isNotEmpty)
        .map(
          (item) => EducationChip(
            label: item.name,
            selected: draft.educationLevelId == item.id,
            onPressed: () => bloc.add(EducationLevelSaved(item.id)),
          ),
        )
        .toList(growable: false);
    return StepLayout(
      step: widget.step,
      title: widget.representativeMode
          ? l10n.representativeEducationTitle
          : l10n.educationTitle,
      bottom: CustomPrimaryButton(
        label: l10n.continueLabel,
        onPressed: draft.educationLevelId?.isNotEmpty == true
            ? () => bloc.add(const EducationContinuePressed())
            : null,
      ),
      child: switch (widget.state.educationStatus) {
        ReferenceStatus.loading => const Center(
          child: CircularProgressIndicator(),
        ),
        ReferenceStatus.empty => const SizedBox.shrink(),
        ReferenceStatus.failure => AppButton(
          label: l10n.retry,
          onPressed: () => bloc.add(const EducationLevelsRequested()),
        ),
        _ => Wrap(
          spacing: AppSpacing.inline,
          runSpacing: AppSpacing.inline,
          children: chips,
        ),
      },
    );
  }

  Widget _height(
    AppLocalizations l10n,
    ProfileOnboardingDraft draft,
    ProfileOnboardingBloc bloc,
  ) {
    final height =
        _selectedHeight ??
        draft.heightCm ??
        _defaultHeight(
          widget.representativeMode
              ? draft.representedCandidateType
              : draft.candidateType,
        );
    final weight =
        _selectedWeight ??
        draft.weightKg ??
        _defaultWeight(
          widget.representativeMode
              ? draft.representedCandidateType
              : draft.candidateType,
        );
    return StepLayout(
      step: widget.step,
      title: widget.representativeMode
          ? l10n.representativeHeightWeightTitle
          : l10n.heightWeightTitle,
      bottom: CustomPrimaryButton(
        label: l10n.continueLabel,
        onPressed: () => bloc.add(HeightSaved(height, weightKg: weight)),
      ),
      child: OnboardingHeightWeightInput(
        height: height,
        weight: weight,
        heightLabel: widget.representativeMode
            ? l10n.representativeHeightInputLabel
            : l10n.heightInputLabel,
        weightLabel: widget.representativeMode
            ? l10n.representativeWeightInputLabel
            : l10n.weightInputLabel,
        heightUnit: l10n.heightUnit,
        weightUnit: l10n.weightUnit,
        decreaseHeightLabel: l10n.decreaseHeightLabel,
        increaseHeightLabel: l10n.increaseHeightLabel,
        decreaseWeightLabel: l10n.decreaseWeightLabel,
        increaseWeightLabel: l10n.increaseWeightLabel,
        onHeightChanged: (value) => setState(() => _selectedHeight = value),
        onWeightChanged: (value) => setState(() => _selectedWeight = value),
      ),
    );
  }

  int _defaultHeight(CandidateType? candidateType) {
    return switch (candidateType) {
      CandidateType.bride => 165,
      CandidateType.groom || CandidateType.representative || null => 175,
    };
  }

  int _defaultWeight(CandidateType? candidateType) {
    return switch (candidateType) {
      CandidateType.bride => 63,
      CandidateType.groom || CandidateType.representative || null => 75,
    };
  }

  Widget _location(
    AppLocalizations l10n,
    ProfileOnboardingDraft draft,
    ProfileOnboardingBloc bloc,
  ) {
    final regionName = _selectedRegionName(draft);
    final districtName = _selectedDistrictName(draft);
    return StepLayout(
      step: widget.step,
      title: widget.representativeMode
          ? l10n.representativeLocationTitle
          : l10n.locationTitle,
      bottom: CustomPrimaryButton(
        label: l10n.continueLabel,
        onPressed: draft.regionId == null || draft.districtId == null
            ? null
            : () => bloc.add(const LocationContinuePressed()),
      ),
      child: Column(
        children: [
          OnboardingLocationSelectorRow(
            label: l10n.regionLabel,
            value: regionName ?? l10n.unselectedValue,
            isPlaceholder: regionName == null,
            onPressed: () => _showRegionSheet(l10n, bloc),
          ),
          const SizedBox(height: AppSpacing.md),
          OnboardingLocationSelectorRow(
            label: l10n.districtLabel,
            value:
                districtName ??
                (draft.regionId == null
                    ? l10n.selectRegionFirstValue
                    : l10n.unselectedValue),
            isPlaceholder: districtName == null,
            onPressed: draft.regionId == null
                ? null
                : () => _showDistrictSheet(l10n, bloc),
          ),
        ],
      ),
    );
  }

  String? _selectedRegionName(ProfileOnboardingDraft draft) {
    final regionId = draft.regionId;
    if (regionId == null) return null;
    return widget.state.regions
        .where((item) => item.id == regionId)
        .firstOrNull
        ?.name;
  }

  String? _selectedDistrictName(ProfileOnboardingDraft draft) {
    final districtId = draft.districtId;
    if (districtId == null) return null;
    return widget.state.districts
        .where((item) => item.id == districtId)
        .firstOrNull
        ?.name;
  }

  Future<void> _showRegionSheet(
    AppLocalizations l10n,
    ProfileOnboardingBloc bloc,
  ) {
    if (bloc.state.regionStatus == ReferenceStatus.idle) {
      bloc.add(const RegionsRequested());
    }
    return showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: BlocBuilder<ProfileOnboardingBloc, ProfileOnboardingState>(
          builder: (context, state) {
            return OnboardingReferenceBottomSheet(
              title: l10n.regionSheetTitle,
              subtitle: l10n.regionSheetCount(state.regions.length),
              status: state.regionStatus,
              onRetry: () => bloc.add(const RegionsRequested()),
              confirmEnabled: state.draft?.regionId?.isNotEmpty == true,
              onConfirm: () => Navigator.of(context).pop(),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: state.regions.length,
                itemBuilder: (context, index) {
                  final item = state.regions[index];
                  return OnboardingReferenceOptionTile(
                    label: item.name,
                    selected: state.draft?.regionId == item.id,
                    onPressed: () {
                      bloc.add(RegionSaved(item.id));
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _showDistrictSheet(
    AppLocalizations l10n,
    ProfileOnboardingBloc bloc,
  ) {
    if (bloc.state.draft?.regionId != null &&
        bloc.state.districtStatus == ReferenceStatus.idle) {
      bloc.add(const DistrictsRequested());
    }
    return showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: BlocBuilder<ProfileOnboardingBloc, ProfileOnboardingState>(
          builder: (context, state) {
            return OnboardingReferenceBottomSheet(
              title: l10n.districtSheetTitle,
              subtitle: l10n.districtSheetSubtitle(
                _selectedRegionName(state.draft!) ?? l10n.regionLabel,
                state.districts.length,
              ),
              status: state.districtStatus,
              onRetry: () => bloc.add(const DistrictsRequested()),
              confirmEnabled: state.draft?.districtId?.isNotEmpty == true,
              onConfirm: () => Navigator.of(context).pop(),
              searchPlaceholder: l10n.locationSearchPlaceholder,
              onSearch: (value) => bloc.add(DistrictsRequested(search: value)),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: state.districts.length,
                itemBuilder: (context, index) {
                  final item = state.districts[index];
                  return OnboardingReferenceOptionTile(
                    label: item.name,
                    selected: state.draft?.districtId == item.id,
                    onPressed: () {
                      bloc.add(DistrictSaved(item.id));
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _healthStatus(
    AppLocalizations l10n,
    ProfileOnboardingDraft draft,
    ProfileOnboardingBloc bloc,
  ) {
    final options = _orderedHealthStatuses(widget.state.healthStatuses);
    return StepLayout(
      step: widget.step,
      title: widget.representativeMode
          ? l10n.representativeHealthStatusTitle
          : l10n.healthStatusTitle,
      subtitle: l10n.healthStatusSubtitle,
      bottom: CustomPrimaryButton(
        label: l10n.continueLabel,
        onPressed: draft.healthStatusId?.isNotEmpty == true
            ? () => bloc.add(const HealthStatusContinuePressed())
            : null,
      ),
      child: switch (widget.state.healthStatusStatus) {
        ReferenceStatus.loading => const Center(
          child: CircularProgressIndicator(),
        ),
        ReferenceStatus.failure => AppButton(
          label: l10n.retry,
          onPressed: () => bloc.add(const HealthStatusesRequested()),
        ),
        ReferenceStatus.empty => const SizedBox.shrink(),
        _ => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.healthDisabilityHint,
              style: AppTypography.onboardingBody,
            ),
            const SizedBox(height: AppSpacing.lg),
            ...options.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: HealthStatusOption(
                  label: item.name,
                  selected: draft.healthStatusId == item.id,
                  onPressed: () => bloc.add(HealthStatusSaved(item.id)),
                ),
              ),
            ),
          ],
        ),
      },
    );
  }

  List<HealthStatus> _orderedHealthStatuses(List<HealthStatus> statuses) {
    final ordered = [...statuses];
    ordered.sort(
      (left, right) =>
          _healthStatusRank(left.name).compareTo(_healthStatusRank(right.name)),
    );
    return ordered;
  }

  int _healthStatusRank(String name) {
    final normalized = name.toLowerCase();
    if (normalized.contains('sog') || normalized.contains('healthy')) {
      return 0;
    }
    return _isDisabilityStatus(name) ? 2 : 1;
  }

  bool _isDisabilityStatus(String name) {
    final normalized = name.toLowerCase();
    return normalized.contains('nogiron') ||
        normalized.contains('disab') ||
        normalized.contains('инвалид');
  }

  Widget _maritalStatus(
    AppLocalizations l10n,
    ProfileOnboardingDraft draft,
    ProfileOnboardingBloc bloc,
  ) {
    final options = _orderedMaritalStatuses(widget.state.maritalStatuses);
    final selected = options
        .where((item) => item.id == draft.maritalStatusId)
        .firstOrNull;
    final isDivorced = selected != null && _isDivorcedStatus(selected.name);
    return StepLayout(
      step: widget.step,
      title: widget.representativeMode
          ? l10n.representativeMaritalStatusTitle
          : l10n.maritalStatusTitle,
      subtitle: isDivorced ? l10n.maritalStatusDivorcedHint : null,
      keyboardAware: true,
      bottom: CustomPrimaryButton(
        label: l10n.continueLabel,
        onPressed: draft.maritalStatusId?.isNotEmpty == true
            ? () => bloc.add(const MaritalStatusContinuePressed())
            : null,
      ),
      child: switch (widget.state.maritalStatusStatus) {
        ReferenceStatus.loading => const Center(
          child: CircularProgressIndicator(),
        ),
        ReferenceStatus.failure => AppButton(
          label: l10n.retry,
          onPressed: () => bloc.add(const MaritalStatusesRequested()),
        ),
        ReferenceStatus.empty => const SizedBox.shrink(),
        _ => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...options.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: HealthStatusOption(
                  label: item.name,
                  detail: _maritalStatusDetail(item.name, l10n),
                  selected: draft.maritalStatusId == item.id,
                  onPressed: () => bloc.add(MaritalStatusSaved(item.id)),
                ),
              ),
            ),
            if (isDivorced) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                widget.representativeMode
                    ? l10n.representativeChildrenCountLabel
                    : l10n.childrenCountLabel,
                style: AppTypography.onboardingChip.copyWith(
                  color: AppColors.bodyText,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              ChildrenCountControl(
                count: draft.childrenCount,
                enabled: !draft.childrenNotLivingWithMe,
                decreaseLabel: l10n.decreaseChildrenLabel,
                increaseLabel: l10n.increaseChildrenLabel,
                onDecrease:
                    draft.childrenNotLivingWithMe || draft.childrenCount == 0
                    ? null
                    : () => bloc.add(
                        ChildrenCountChanged(draft.childrenCount - 1),
                      ),
                onIncrease:
                    draft.childrenNotLivingWithMe || draft.childrenCount >= 99
                    ? null
                    : () => bloc.add(
                        ChildrenCountChanged(draft.childrenCount + 1),
                      ),
              ),
              const SizedBox(height: AppSpacing.lg + AppSpacing.xs),
              ChildrenNotLivingCard(
                title: widget.representativeMode
                    ? l10n.representativeChildrenNotLivingTitle
                    : l10n.childrenNotLivingTitle,
                detail: l10n.childrenNotLivingDetail,
                value: draft.childrenNotLivingWithMe,
                semanticLabel: widget.representativeMode
                    ? l10n.representativeChildrenNotLivingTitle
                    : l10n.childrenNotLivingTitle,
                onChanged: (value) =>
                    bloc.add(ChildrenNotLivingWithMeChanged(value)),
              ),
            ],
          ],
        ),
      },
    );
  }

  List<MaritalStatus> _orderedMaritalStatuses(List<MaritalStatus> statuses) {
    final ordered = [...statuses];
    final divorcedIndex = ordered.indexWhere(
      (item) => _isDivorcedStatus(item.name),
    );
    if (divorcedIndex >= 0 && ordered.length > 1 && divorcedIndex != 1) {
      final divorced = ordered.removeAt(divorcedIndex);
      ordered.insert(1, divorced);
    }
    return ordered;
  }

  bool _isDivorcedStatus(String name) {
    return name.trim().toLowerCase() == 'ajrashgan';
  }

  String _maritalStatusDetail(String name, AppLocalizations l10n) {
    return _isDivorcedStatus(name)
        ? l10n.maritalStatusDivorcedDetail
        : l10n.maritalStatusFirstMarriageDetail;
  }

  Widget _aboutMe(
    AppLocalizations l10n,
    ProfileOnboardingDraft draft,
    ProfileOnboardingBloc bloc,
  ) {
    if (_aboutMeController.text.isEmpty && draft.aboutMe != null) {
      _aboutMeController.text = draft.aboutMe!;
    }
    final count = _aboutMeController.text.length;
    return StepLayout(
      title: widget.representativeMode
          ? l10n.representativeAboutTitle
          : l10n.aboutMeTitle,
      subtitle: widget.representativeMode
          ? l10n.representativeAboutSubtitle
          : l10n.aboutMeSubtitle,
      step: widget.step,
      keyboardAware: true,
      bottom: Column(
        children: [
          CustomPrimaryButton(
            label: l10n.continueLabel,
            onPressed: widget.state.isBusy
                ? null
                : () {
                    FocusScope.of(context).unfocus();
                    bloc.add(AboutMeContinuePressed(_aboutMeController.text));
                  },
          ),
          const SizedBox(height: AppSpacing.lg),
          CustomGhostButton(
            label: l10n.skipLabel,
            onPressed: widget.state.isBusy
                ? null
                : () {
                    FocusScope.of(context).unfocus();
                    _aboutMeController.clear();
                    bloc.add(const AboutMeSkipPressed());
                  },
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AboutMeTextArea(
            controller: _aboutMeController,
            hint: widget.representativeMode
                ? l10n.representativeAboutHint
                : l10n.aboutMeHint,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.aboutMeCounter(count),
            style: AppTypography.onboardingCardBody,
          ),
        ],
      ),
    );
  }

  Widget _face(
    AppLocalizations l10n,
    ProfileOnboardingDraft draft,
    ProfileOnboardingBloc bloc,
  ) {
    final verifying =
        draft.faceVerificationStatus == FaceVerificationStatus.verifying;
    return StepLayout(
      step: widget.step,
      title: l10n.faceCaptureTitle,
      subtitle: l10n.faceCaptureSubtitle,
      bottom: CustomPrimaryButton(
        label: l10n.takeSelfieLabel,
        onPressed: verifying
            ? null
            : () => bloc.add(const FaceVerificationRequested()),
      ),
      child: Column(
        children: [
          OnboardingFaceCamera(
            key: ValueKey(
              draft.faceVerificationStatus ==
                      FaceVerificationStatus.retryableFailure
                  ? 'face-camera-retry'
                  : 'face-camera-live',
            ),
            hint: l10n.faceHint,
            cameraLabel: l10n.selfieCameraLabel,
            errorLabel: l10n.faceCameraError,
            retryLabel: l10n.retry,
            onCaptured: (path) => bloc.add(FaceSelfieCaptured(path)),
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
                        style: AppTypography.onboardingCardBody.copyWith(
                          color: AppColors.bodyText,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (verifying) const CircularProgressIndicator(),
          if (draft.faceVerificationStatus ==
              FaceVerificationStatus.retryableFailure)
            Text(l10n.faceRetryHint, style: AppTypography.onboardingBody),
        ],
      ),
    );
  }
}

String _formatDuration(Duration? duration) {
  final seconds = duration?.inSeconds ?? 0;
  return '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';
}
