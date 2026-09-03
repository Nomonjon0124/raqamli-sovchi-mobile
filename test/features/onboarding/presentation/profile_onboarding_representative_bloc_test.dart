import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:raqamli_sovchi/core/errors/either.dart';
import 'package:raqamli_sovchi/core/errors/failure.dart';
import 'package:raqamli_sovchi/core/security/auth_session_manager.dart';
import 'package:raqamli_sovchi/features/auth/application/use_cases/commit_pending_auth_session.dart';
import 'package:raqamli_sovchi/features/onboarding/application/services/onboarding_location_service.dart';
import 'package:raqamli_sovchi/features/onboarding/application/services/onboarding_media_service.dart';
import 'package:raqamli_sovchi/features/onboarding/domain/entities/candidate_type.dart';
import 'package:raqamli_sovchi/features/onboarding/domain/entities/onboarding_reference.dart';
import 'package:raqamli_sovchi/features/onboarding/domain/entities/profile_onboarding_draft.dart';
import 'package:raqamli_sovchi/features/onboarding/domain/entities/profile_onboarding_models.dart';
import 'package:raqamli_sovchi/features/onboarding/domain/repositories/onboarding_draft_repository.dart';
import 'package:raqamli_sovchi/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:raqamli_sovchi/features/onboarding/presentation/bloc/profile_onboarding_bloc.dart';
import 'package:raqamli_sovchi/features/onboarding/presentation/bloc/profile_onboarding_event.dart';
import 'package:raqamli_sovchi/features/onboarding/presentation/bloc/profile_onboarding_state.dart';

final class _MockOnboardingRepository extends Mock
    implements OnboardingRepository {}

final class _MockDraftRepository extends Mock
    implements OnboardingDraftRepository {}

final class _MockMediaService extends Mock implements OnboardingMediaService {}

final class _MockLocationService extends Mock
    implements OnboardingLocationService {}

final class _MockAuthSessionManager extends Mock
    implements AuthSessionManager {}

void main() {
  late _MockOnboardingRepository onboardingRepository;
  late _MockDraftRepository draftRepository;
  late _MockMediaService mediaService;
  late _MockLocationService locationService;
  late _MockAuthSessionManager authSessionManager;

  setUpAll(() {
    registerFallbackValue(
      ProfileOnboardingDraft(
        ownerUserId: 'fallback',
        updatedAt: DateTime.utc(2026, 8, 13),
      ),
    );
    registerFallbackValue(
      const RepresentativeInfoRequest(
        profileId: 'profile-fallback',
        candidateType: CandidateType.bride,
        kinshipId: 'kinship-fallback',
      ),
    );
  });

  setUp(() {
    onboardingRepository = _MockOnboardingRepository();
    draftRepository = _MockDraftRepository();
    mediaService = _MockMediaService();
    locationService = _MockLocationService();
    authSessionManager = _MockAuthSessionManager();
    when(() => mediaService.dispose()).thenAnswer((_) async {});
    when(() => mediaService.deletePrivateFile(any())).thenAnswer((_) async {});
    when(
      () => draftRepository.save(any()),
    ).thenAnswer((_) async => const Right<Failure, void>(null));
  });

  ProfileOnboardingBloc buildBloc() {
    return ProfileOnboardingBloc(
      onboardingRepository: onboardingRepository,
      draftRepository: draftRepository,
      mediaService: mediaService,
      locationService: locationService,
      commitPendingAuthSession: CommitPendingAuthSessionUseCase(
        authSessionManager,
      ),
      now: () => DateTime.utc(2026, 8, 13),
    );
  }

  blocTest<ProfileOnboardingBloc, ProfileOnboardingState>(
    'representative selection opens the dedicated introduction',
    build: () {
      when(() => draftRepository.load('user-1')).thenAnswer(
        (_) async => const Right<Failure, ProfileOnboardingDraft?>(null),
      );
      return buildBloc();
    },
    act: (bloc) async {
      final started = bloc.stream.firstWhere((state) => state.draft != null);
      bloc.add(const ProfileOnboardingStarted('user-1'));
      await started;
      final selected = bloc.stream.firstWhere(
        (state) => state.draft?.candidateType == CandidateType.representative,
      );
      bloc.add(const CandidateTypeSaved(CandidateType.representative));
      await selected;
      bloc.add(const CandidateTypeContinuePressed());
    },
    expect: () => [
      isA<ProfileOnboardingState>().having(
        (state) => state.status,
        'status',
        ProfileOnboardingStatus.loading,
      ),
      isA<ProfileOnboardingState>().having(
        (state) => state.status,
        'status',
        ProfileOnboardingStatus.editing,
      ),
      isA<ProfileOnboardingState>().having(
        (state) => state.draft?.candidateType,
        'candidate type',
        CandidateType.representative,
      ),
      isA<ProfileOnboardingState>().having(
        (state) => state.draft?.currentStep,
        'current step',
        OnboardingStep.representativeIntro,
      ),
    ],
  );

  test('custom profession is created and advances to education', () async {
    when(() => draftRepository.load('user-1')).thenAnswer(
      (_) async => const Right<Failure, ProfileOnboardingDraft?>(null),
    );
    when(() => onboardingRepository.createProfession('Dizayner')).thenAnswer(
      (_) async => const Right<Failure, Profession>(
        Profession(id: 'profession-1', name: 'Dizayner'),
      ),
    );
    final bloc = buildBloc();

    final started = bloc.stream.firstWhere((state) => state.draft != null);
    bloc.add(const ProfileOnboardingStarted('user-1'));
    await started;

    final otherSelected = bloc.stream.firstWhere(
      (state) => state.isOtherProfessionSelected,
    );
    bloc.add(const OtherProfessionSelected());
    await otherSelected;

    final education = bloc.stream.firstWhere(
      (state) =>
          state.draft?.currentStep == OnboardingStep.education &&
          !state.isOtherProfessionSelected,
    );
    bloc.add(const CustomProfessionSubmitted(' Dizayner '));
    final result = await education;

    expect(result.draft?.professionId, 'profession-1');
    expect(result.draft?.professionName, 'Dizayner');
    expect(result.draft?.currentStep, OnboardingStep.education);
    expect(result.isOtherProfessionSelected, isFalse);
    verify(() => onboardingRepository.createProfession('Dizayner')).called(1);
    await bloc.close();
  });

  test('birth date advances to profession before education', () async {
    final draft = ProfileOnboardingDraft(
      ownerUserId: 'user-1',
      currentStep: OnboardingStep.birthDate,
      updatedAt: DateTime.utc(2026, 8, 13),
    );
    when(
      () => draftRepository.load('user-1'),
    ).thenAnswer((_) async => Right<Failure, ProfileOnboardingDraft?>(draft));
    final bloc = buildBloc();

    final started = bloc.stream.firstWhere((state) => state.draft != null);
    bloc.add(const ProfileOnboardingStarted('user-1'));
    await started;

    final profession = bloc.stream.firstWhere(
      (state) => state.draft?.currentStep == OnboardingStep.profession,
    );
    bloc.add(BirthDateSaved(DateTime.utc(2000, 1, 1)));
    final result = await profession;

    expect(result.draft?.currentStep, OnboardingStep.profession);
    await bloc.close();
  });

  test(
    'representative pledge finalizes when consent was saved without server id',
    () async {
      final draft = ProfileOnboardingDraft(
        ownerUserId: 'user-1',
        candidateType: CandidateType.representative,
        representedCandidateType: CandidateType.bride,
        currentStep: OnboardingStep.representativePledge,
        representativeFirstName: 'Vali',
        representativeLastName: 'Aliyev',
        kinshipId: 'kinship-1',
        profileServerId: 'profile-1',
        candidateContact: '+998901234567',
        candidateUsesApp: true,
        consentRequestSent: true,
        representativeAccuracyAccepted: true,
        representativePrivacyAccepted: true,
        representativeInterestAccepted: true,
        birthDate: DateTime.utc(2000),
        firstName: 'Malika',
        lastName: 'Valiyeva',
        professionId: 'profession-1',
        professionName: 'Dizayner',
        educationLevelId: 'education-1',
        heightCm: 165,
        weightKg: 55,
        regionId: 'region-1',
        districtId: 'district-1',
        healthStatusId: 'health-1',
        maritalStatusId: 'marital-1',
        mainPhotoServerId: 'photo-1',
        photos: const [
          OnboardingPhotoDraft(
            localFilePath: '/private/photo.jpg',
            serverId: 'photo-1',
            order: 1,
            isMain: true,
            uploadStatus: PhotoUploadStatus.uploaded,
          ),
        ],
        updatedAt: DateTime.utc(2026, 8, 13),
      );
      when(
        () => draftRepository.load('user-1'),
      ).thenAnswer((_) async => Right<Failure, ProfileOnboardingDraft?>(draft));
      when(
        () => onboardingRepository.submitPledge(
          userId: 'user-1',
          acceptedTerms: true,
          hasSeriousBadge: true,
        ),
      ).thenAnswer((_) async => const Right<Failure, void>(null));
      when(
        () => authSessionManager.commitPendingTokens(
          profileOnboardingCompleted: true,
        ),
      ).thenAnswer((_) async {});
      final bloc = buildBloc();
      addTearDown(bloc.close);

      final started = bloc.stream.firstWhere(
        (state) =>
            state.draft?.currentStep == OnboardingStep.representativePledge,
      );
      bloc.add(const ProfileOnboardingStarted('user-1'));
      await started;

      final ready = bloc.stream.firstWhere(
        (state) =>
            state.draft?.currentStep == OnboardingStep.representativeReady,
      );
      bloc.add(const RepresentativePledgeContinuePressed());
      final result = await ready;

      expect(result.failure, isNull);
      expect(result.draft?.pledgeAcceptedTerms, isTrue);
      verify(
        () => onboardingRepository.submitPledge(
          userId: 'user-1',
          acceptedTerms: true,
          hasSeriousBadge: true,
        ),
      ).called(1);
      verifyNever(() => onboardingRepository.sendRepresentativeConsent(any()));
    },
  );

  blocTest<ProfileOnboardingBloc, ProfileOnboardingState>(
    'representative main photo skips face verification',
    build: () {
      final draft = ProfileOnboardingDraft(
        ownerUserId: 'user-1',
        candidateType: CandidateType.representative,
        representedCandidateType: CandidateType.bride,
        currentStep: OnboardingStep.mainPhoto,
        profileServerId: 'profile-1',
        mainPhotoServerId: 'photo-1',
        photos: const [
          OnboardingPhotoDraft(
            localFilePath: '/private/photo.jpg',
            serverId: 'photo-1',
            order: 1,
            isMain: true,
            uploadStatus: PhotoUploadStatus.uploaded,
          ),
        ],
        updatedAt: DateTime.utc(2026, 8, 13),
      );
      when(
        () => draftRepository.load('user-1'),
      ).thenAnswer((_) async => Right<Failure, ProfileOnboardingDraft?>(draft));
      return buildBloc();
    },
    act: (bloc) async {
      final started = bloc.stream.firstWhere(
        (state) => state.draft?.currentStep == OnboardingStep.mainPhoto,
      );
      bloc.add(const ProfileOnboardingStarted('user-1'));
      await started;
      bloc.add(const MainPhotoContinuePressed());
    },
    expect: () => [
      isA<ProfileOnboardingState>().having(
        (state) => state.status,
        'status',
        ProfileOnboardingStatus.loading,
      ),
      isA<ProfileOnboardingState>().having(
        (state) => state.draft?.currentStep,
        'loaded step',
        OnboardingStep.mainPhoto,
      ),
      isA<ProfileOnboardingState>().having(
        (state) => state.draft?.currentStep,
        'next step',
        OnboardingStep.aboutMe,
      ),
    ],
  );
}
