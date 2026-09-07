import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/core/errors/either.dart';
import 'package:raqamli_sovchi/core/errors/failure.dart';
import 'package:raqamli_sovchi/features/profile/application/use_cases/update_profile.dart';
import 'package:raqamli_sovchi/features/profile/domain/entities/profile_update_params.dart';
import 'package:raqamli_sovchi/features/profile/domain/entities/user_profile.dart';
import 'package:raqamli_sovchi/features/profile/domain/repositories/profile_repository.dart';

void main() {
  final testBirthDate = DateTime(1995, 5, 20);
  final params = ProfileUpdateParams(
    firstName: 'Ali',
    lastName: 'Valiyev',
    birthDate: testBirthDate,
    height: 178,
    weight: 75,
    bio: 'Dasturchi',
  );

  final updatedProfile = UserProfile(
    id: 'profile-1',
    hasAnsweredTest: true,
    answeredQuestionsCount: 10,
    firstName: 'Ali',
    lastName: 'Valiyev',
    birthDate: testBirthDate,
    height: 178,
    bio: 'Dasturchi',
  );

  test(
    'calls repository.updateProfile and returns updated profile on success',
    () async {
      final repository = _FakeProfileRepository(
        updateResult: Right(updatedProfile),
      );
      final useCase = UpdateProfileUseCase(repository);

      final result = await useCase(params);

      expect(result.isRight, isTrue);
      result.fold(
        (failure) => fail('Expected success but got failure: $failure'),
        (profile) => expect(profile, updatedProfile),
      );
      expect(repository.lastParams, params);
    },
  );

  test('returns failure when repository fails', () async {
    final repository = _FakeProfileRepository(
      updateResult: const Left(Failure.noInternet()),
    );
    final useCase = UpdateProfileUseCase(repository);

    final result = await useCase(params);

    expect(result.isLeft, isTrue);
    result.fold(
      (failure) => expect(failure, const Failure.noInternet()),
      (profile) => fail('Expected failure but got profile: $profile'),
    );
  });
}

final class _FakeProfileRepository implements ProfileRepository {
  _FakeProfileRepository({this.updateResult = const Left(Failure.server())});

  final Either<Failure, UserProfile> updateResult;
  ProfileUpdateParams? lastParams;

  @override
  Future<Either<Failure, UserProfile>> getMyProfile() async =>
      const Left(Failure.server());

  @override
  Future<Either<Failure, bool>> updateLocation({
    required double latitude,
    required double longitude,
  }) async => const Right(true);

  @override
  Future<Either<Failure, UserProfile>> updateProfile(
    ProfileUpdateParams params,
  ) async {
    lastParams = params;
    return updateResult;
  }

  @override
  Future<Either<Failure, ProfilePhoto>> uploadPhoto({
    required String profileId,
    required String filePath,
  }) async => const Left(Failure.server());
}
