import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:raqamli_sovchi/core/errors/either.dart';
import 'package:raqamli_sovchi/core/errors/failure.dart';
import 'package:raqamli_sovchi/core/security/auth_session_manager.dart';
import 'package:raqamli_sovchi/features/auth/application/use_cases/commit_pending_auth_session.dart';
import 'package:raqamli_sovchi/features/onboarding/application/services/onboarding_location_service.dart';
import 'package:raqamli_sovchi/features/onboarding/application/services/onboarding_media_service.dart';
import 'package:raqamli_sovchi/features/onboarding/domain/entities/profile_onboarding_draft.dart';
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
  blocTest<ProfileOnboardingBloc, ProfileOnboardingState>(
    'profile ready start action completes onboarding for questionnaire route',
    build: () {
      final draftRepository = _MockDraftRepository();
      final mediaService = _MockMediaService();
      when(() => draftRepository.load('user-1')).thenAnswer(
        (_) async => Right(
          ProfileOnboardingDraft(
            ownerUserId: 'user-1',
            currentStep: OnboardingStep.profileReady,
            updatedAt: DateTime.utc(2026, 8, 13),
          ),
        ),
      );
      when(
        () => draftRepository.clear(),
      ).thenAnswer((_) async => const Right<Failure, void>(null));
      when(() => mediaService.dispose()).thenAnswer((_) async {});
      return ProfileOnboardingBloc(
        onboardingRepository: _MockOnboardingRepository(),
        draftRepository: draftRepository,
        mediaService: mediaService,
        locationService: _MockLocationService(),
        commitPendingAuthSession: CommitPendingAuthSessionUseCase(
          _MockAuthSessionManager(),
        ),
      );
    },
    act: (bloc) async {
      bloc.add(const ProfileOnboardingStarted('user-1'));
      await bloc.stream.firstWhere(
        (state) => state.draft?.currentStep == OnboardingStep.profileReady,
      );
      bloc.add(const ProfileReadyQuestionnaireRequested());
    },
    expect: () => [
      isA<ProfileOnboardingState>().having(
        (state) => state.status,
        'loading',
        ProfileOnboardingStatus.loading,
      ),
      isA<ProfileOnboardingState>().having(
        (state) => state.draft?.currentStep,
        'ready step',
        OnboardingStep.profileReady,
      ),
      isA<ProfileOnboardingState>()
          .having(
            (state) => state.status,
            'completed',
            ProfileOnboardingStatus.completed,
          )
          .having(
            (state) => state.openQuestionnaire,
            'questionnaire intent',
            isTrue,
          ),
    ],
  );
}
