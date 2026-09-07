import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:raqamli_sovchi/core/errors/either.dart';
import 'package:raqamli_sovchi/core/errors/failure.dart';
import 'package:raqamli_sovchi/features/onboarding/domain/entities/onboarding_reference.dart';
import 'package:raqamli_sovchi/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:raqamli_sovchi/features/profile/application/use_cases/update_profile.dart';
import 'package:raqamli_sovchi/features/profile/application/use_cases/upload_profile_photo.dart';
import 'package:raqamli_sovchi/features/profile/domain/entities/profile_update_params.dart';
import 'package:raqamli_sovchi/features/profile/domain/entities/user_profile.dart';
import 'package:raqamli_sovchi/features/profile/domain/repositories/profile_repository.dart';
import 'package:raqamli_sovchi/features/profile/presentation/bloc/edit_profile/edit_profile_bloc.dart';
import 'package:raqamli_sovchi/features/profile/presentation/bloc/edit_profile/edit_profile_event.dart';
import 'package:raqamli_sovchi/features/profile/presentation/bloc/edit_profile/edit_profile_state.dart';
import 'package:raqamli_sovchi/features/profile/presentation/widgets/edit/profile_reference_picker_sheet.dart';

final class _MockProfileRepository extends Mock implements ProfileRepository {}

final class _MockOnboardingRepository extends Mock
    implements OnboardingRepository {}

void main() {
  late _MockProfileRepository mockProfileRepository;
  late _MockOnboardingRepository mockOnboardingRepository;
  late UpdateProfileUseCase updateProfileUseCase;
  late UploadProfilePhotoUseCase uploadPhotoUseCase;

  const initialProfile = UserProfile(
    id: 'user-profile-id',
    hasAnsweredTest: true,
    answeredQuestionsCount: 10,
    firstName: 'Sherzod',
    lastName: 'Karimov',
    birthYear: 1993,
    height: 175,
    weight: 70,
    educationLevelId: 'edu-1',
    educationLevelName: 'Oliy',
    professionId: 'prof-1',
    professionName: 'Dasturchi',
    regionId: 'reg-1',
    regionName: 'Toshkent',
    districtId: 'dist-1',
    districtName: 'Chilonzor',
    maritalStatusId: 'mar-1',
    maritalStatusName: 'Uylanmagan',
    bio: 'Assalomu alaykum',
  );

  setUpAll(() {
    registerFallbackValue(const ProfileUpdateParams());
  });

  setUp(() {
    mockProfileRepository = _MockProfileRepository();
    mockOnboardingRepository = _MockOnboardingRepository();
    updateProfileUseCase = UpdateProfileUseCase(mockProfileRepository);
    uploadPhotoUseCase = UploadProfilePhotoUseCase(mockProfileRepository);

    when(() => mockOnboardingRepository.getEducationLevels(any())).thenAnswer(
      (_) async => const Right(
        ReferencePage(
          items: [EducationLevel(id: 'edu-1', name: 'Oliy')],
          page: 1,
          hasNextPage: false,
        ),
      ),
    );

    when(
      () => mockOnboardingRepository.getProfessions(
        page: any(named: 'page'),
        search: any(named: 'search'),
      ),
    ).thenAnswer(
      (_) async => const Right(
        ReferencePage(
          items: [Profession(id: 'prof-1', name: 'Dasturchi')],
          page: 1,
          hasNextPage: false,
        ),
      ),
    );

    when(() => mockOnboardingRepository.getRegions(any())).thenAnswer(
      (_) async => const Right(
        ReferencePage(
          items: [Region(id: 'reg-1', name: 'Toshkent')],
          page: 1,
          hasNextPage: false,
        ),
      ),
    );

    when(
      () => mockOnboardingRepository.getDistricts(
        regionId: any(named: 'regionId'),
        page: any(named: 'page'),
      ),
    ).thenAnswer(
      (_) async => const Right(
        ReferencePage(
          items: [District(id: 'dist-1', name: 'Chilonzor', regionId: 'reg-1')],
          page: 1,
          hasNextPage: false,
        ),
      ),
    );

    when(() => mockOnboardingRepository.getMaritalStatuses(any())).thenAnswer(
      (_) async => const Right(
        ReferencePage(
          items: [MaritalStatus(id: 'mar-1', name: 'Uylanmagan')],
          page: 1,
          hasNextPage: false,
        ),
      ),
    );
  });

  EditProfileBloc buildBloc() {
    return EditProfileBloc(
      updateProfile: updateProfileUseCase,
      uploadPhoto: uploadPhotoUseCase,
      onboardingRepository: mockOnboardingRepository,
    );
  }

  group('EditProfileBloc', () {
    test('initial state has initial status', () {
      expect(buildBloc().state.status, EditProfileStatus.initial);
    });

    test('hasUnsavedChanges tracks profile edits', () {
      const unchanged = EditProfileState(
        status: EditProfileStatus.ready,
        originalProfile: initialProfile,
        firstName: 'Sherzod',
        lastName: 'Karimov',
        birthYear: 1993,
        height: 175,
        weight: 70,
        educationLevelId: 'edu-1',
        professionId: 'prof-1',
        regionId: 'reg-1',
        districtId: 'dist-1',
        maritalStatusId: 'mar-1',
        bio: 'Assalomu alaykum',
      );

      expect(unchanged.hasUnsavedChanges, isFalse);
      expect(unchanged.isSaveEnabled, isFalse);

      final changed = unchanged.copyWith(height: 180);

      expect(changed.hasUnsavedChanges, isTrue);
      expect(changed.isSaveEnabled, isTrue);
    });

    blocTest<EditProfileBloc, EditProfileState>(
      'EditProfileStarted sets profile fields and loads references',
      build: buildBloc,
      act: (bloc) => bloc.add(const EditProfileStarted(initialProfile)),
      expect: () => [
        const EditProfileState(
          status: EditProfileStatus.ready,
          originalProfile: initialProfile,
          firstName: 'Sherzod',
          lastName: 'Karimov',
          birthYear: 1993,
          height: 175,
          weight: 70,
          educationLevelId: 'edu-1',
          educationLevelName: 'Oliy',
          professionId: 'prof-1',
          professionName: 'Dasturchi',
          regionId: 'reg-1',
          regionName: 'Toshkent',
          districtId: 'dist-1',
          districtName: 'Chilonzor',
          maritalStatusId: 'mar-1',
          maritalStatusName: 'Uylanmagan',
          bio: 'Assalomu alaykum',
        ),
        const EditProfileState(
          status: EditProfileStatus.ready,
          originalProfile: initialProfile,
          firstName: 'Sherzod',
          lastName: 'Karimov',
          birthYear: 1993,
          height: 175,
          weight: 70,
          educationLevelId: 'edu-1',
          educationLevelName: 'Oliy',
          professionId: 'prof-1',
          professionName: 'Dasturchi',
          regionId: 'reg-1',
          regionName: 'Toshkent',
          districtId: 'dist-1',
          districtName: 'Chilonzor',
          maritalStatusId: 'mar-1',
          maritalStatusName: 'Uylanmagan',
          bio: 'Assalomu alaykum',
          educationLevels: [ReferenceItem(id: 'edu-1', name: 'Oliy')],
          professions: [ReferenceItem(id: 'prof-1', name: 'Dasturchi')],
          regions: [ReferenceItem(id: 'reg-1', name: 'Toshkent')],
          maritalStatuses: [ReferenceItem(id: 'mar-1', name: 'Uylanmagan')],
        ),
        const EditProfileState(
          status: EditProfileStatus.ready,
          originalProfile: initialProfile,
          firstName: 'Sherzod',
          lastName: 'Karimov',
          birthYear: 1993,
          height: 175,
          weight: 70,
          educationLevelId: 'edu-1',
          educationLevelName: 'Oliy',
          professionId: 'prof-1',
          professionName: 'Dasturchi',
          regionId: 'reg-1',
          regionName: 'Toshkent',
          districtId: 'dist-1',
          districtName: 'Chilonzor',
          maritalStatusId: 'mar-1',
          maritalStatusName: 'Uylanmagan',
          bio: 'Assalomu alaykum',
          educationLevels: [ReferenceItem(id: 'edu-1', name: 'Oliy')],
          professions: [ReferenceItem(id: 'prof-1', name: 'Dasturchi')],
          regions: [ReferenceItem(id: 'reg-1', name: 'Toshkent')],
          districts: [ReferenceItem(id: 'dist-1', name: 'Chilonzor')],
          maritalStatuses: [ReferenceItem(id: 'mar-1', name: 'Uylanmagan')],
        ),
      ],
    );

    blocTest<EditProfileBloc, EditProfileState>(
      'field change events update corresponding state values',
      build: buildBloc,
      act: (bloc) {
        bloc.add(
          const EditProfileNameChanged(firstName: 'Bobur', lastName: 'Salimov'),
        );
        bloc.add(const EditProfileHeightChanged(182));
        bloc.add(const EditProfileWeightChanged(78));
        bloc.add(const EditProfileBioChanged('Yangi bio'));
      },
      expect: () => [
        const EditProfileState(firstName: 'Bobur', lastName: 'Salimov'),
        const EditProfileState(
          firstName: 'Bobur',
          lastName: 'Salimov',
          height: 182,
        ),
        const EditProfileState(
          firstName: 'Bobur',
          lastName: 'Salimov',
          height: 182,
          weight: 78,
        ),
        const EditProfileState(
          firstName: 'Bobur',
          lastName: 'Salimov',
          height: 182,
          weight: 78,
          bio: 'Yangi bio',
        ),
      ],
    );

    blocTest<EditProfileBloc, EditProfileState>(
      'EditProfileRegionChanged clears selected district and reloads districts',
      build: buildBloc,
      seed: () => const EditProfileState(
        status: EditProfileStatus.ready,
        originalProfile: initialProfile,
        firstName: 'Sherzod',
        lastName: 'Karimov',
        regionId: 'reg-1',
        regionName: 'Toshkent',
        districtId: 'dist-1',
        districtName: 'Chilonzor',
        districts: [ReferenceItem(id: 'dist-1', name: 'Chilonzor')],
      ),
      act: (bloc) => bloc.add(
        const EditProfileRegionChanged(id: 'reg-2', name: 'Fargʻona'),
      ),
      expect: () => [
        const EditProfileState(
          status: EditProfileStatus.ready,
          originalProfile: initialProfile,
          firstName: 'Sherzod',
          lastName: 'Karimov',
          regionId: 'reg-2',
          regionName: 'Fargʻona',
          districts: [],
        ),
        const EditProfileState(
          status: EditProfileStatus.ready,
          originalProfile: initialProfile,
          firstName: 'Sherzod',
          lastName: 'Karimov',
          regionId: 'reg-2',
          regionName: 'Fargʻona',
          districts: [ReferenceItem(id: 'dist-1', name: 'Chilonzor')],
        ),
      ],
      verify: (_) {
        verify(
          () =>
              mockOnboardingRepository.getDistricts(regionId: 'reg-2', page: 1),
        ).called(1);
      },
    );

    blocTest<EditProfileBloc, EditProfileState>(
      'EditProfileSubmitted emits submitting and success on successful update',
      build: () {
        when(
          () => mockProfileRepository.updateProfile(any()),
        ).thenAnswer((_) async => const Right(initialProfile));
        return buildBloc();
      },
      seed: () => const EditProfileState(
        status: EditProfileStatus.ready,
        originalProfile: initialProfile,
        firstName: 'Sherzod',
        lastName: 'Karimov',
        birthYear: 1993,
        height: 180,
      ),
      act: (bloc) => bloc.add(const EditProfileSubmitted()),
      expect: () => [
        const EditProfileState(
          status: EditProfileStatus.submitting,
          originalProfile: initialProfile,
          firstName: 'Sherzod',
          lastName: 'Karimov',
          birthYear: 1993,
          height: 180,
        ),
        const EditProfileState(
          status: EditProfileStatus.success,
          originalProfile: initialProfile,
          firstName: 'Sherzod',
          lastName: 'Karimov',
          birthYear: 1993,
          height: 180,
          updatedProfile: initialProfile,
        ),
      ],
      verify: (_) {
        verify(() => mockProfileRepository.updateProfile(any())).called(1);
      },
    );

    blocTest<EditProfileBloc, EditProfileState>(
      'EditProfileSubmitted emits failure when repository fails',
      build: () {
        when(() => mockProfileRepository.updateProfile(any())).thenAnswer(
          (_) async => const Left(Failure.server(message: 'Update error')),
        );
        return buildBloc();
      },
      seed: () => const EditProfileState(
        status: EditProfileStatus.ready,
        originalProfile: initialProfile,
        firstName: 'Sherzod',
        lastName: 'Karimov',
        bio: 'Yangi bio',
      ),
      act: (bloc) => bloc.add(const EditProfileSubmitted()),
      expect: () => [
        const EditProfileState(
          status: EditProfileStatus.submitting,
          originalProfile: initialProfile,
          firstName: 'Sherzod',
          lastName: 'Karimov',
          bio: 'Yangi bio',
        ),
        const EditProfileState(
          status: EditProfileStatus.failure,
          originalProfile: initialProfile,
          firstName: 'Sherzod',
          lastName: 'Karimov',
          bio: 'Yangi bio',
          failure: Failure.server(message: 'Update error'),
        ),
      ],
    );

    blocTest<EditProfileBloc, EditProfileState>(
      'EditProfileProfessionCustomSubmitted calls createProfession and updates profession',
      build: () {
        when(
          () => mockOnboardingRepository.createProfession('Arxitektor'),
        ).thenAnswer(
          (_) async =>
              const Right(Profession(id: 'prof-new', name: 'Arxitektor')),
        );
        return buildBloc();
      },
      seed: () => const EditProfileState(
        status: EditProfileStatus.ready,
        originalProfile: initialProfile,
        professions: [ReferenceItem(id: 'prof-1', name: 'Dasturchi')],
      ),
      act: (bloc) =>
          bloc.add(const EditProfileProfessionCustomSubmitted('Arxitektor')),
      expect: () => [
        const EditProfileState(
          status: EditProfileStatus.ready,
          originalProfile: initialProfile,
          professions: [ReferenceItem(id: 'prof-1', name: 'Dasturchi')],
          isCreatingProfession: true,
        ),
        const EditProfileState(
          status: EditProfileStatus.ready,
          originalProfile: initialProfile,
          professions: [
            ReferenceItem(id: 'prof-1', name: 'Dasturchi'),
            ReferenceItem(id: 'prof-new', name: 'Arxitektor'),
          ],
          professionId: 'prof-new',
          professionName: 'Arxitektor',
          isCreatingProfession: false,
        ),
      ],
      verify: (_) {
        verify(
          () => mockOnboardingRepository.createProfession('Arxitektor'),
        ).called(1);
      },
    );

    blocTest<EditProfileBloc, EditProfileState>(
      'EditProfileProfessionCustomSubmitted emits failure when createProfession fails',
      build: () {
        when(
          () => mockOnboardingRepository.createProfession('Xato kasb'),
        ).thenAnswer(
          (_) async => const Left(Failure.server(message: 'Creation failed')),
        );
        return buildBloc();
      },
      seed: () => const EditProfileState(
        status: EditProfileStatus.ready,
        originalProfile: initialProfile,
      ),
      act: (bloc) =>
          bloc.add(const EditProfileProfessionCustomSubmitted('Xato kasb')),
      expect: () => [
        const EditProfileState(
          status: EditProfileStatus.ready,
          originalProfile: initialProfile,
          isCreatingProfession: true,
        ),
        const EditProfileState(
          status: EditProfileStatus.ready,
          originalProfile: initialProfile,
          isCreatingProfession: false,
          failure: Failure.server(message: 'Creation failed'),
        ),
      ],
    );
  });
}
