import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/core/errors/either.dart';
import 'package:raqamli_sovchi/core/errors/failure.dart';
import 'package:raqamli_sovchi/features/profile/application/use_cases/get_my_profile.dart';
import 'package:raqamli_sovchi/features/profile/domain/entities/profile_update_params.dart';
import 'package:raqamli_sovchi/features/profile/domain/entities/user_profile.dart';
import 'package:raqamli_sovchi/features/profile/domain/repositories/profile_repository.dart';
import 'package:raqamli_sovchi/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:raqamli_sovchi/features/profile/presentation/bloc/profile_event.dart';
import 'package:raqamli_sovchi/features/profile/presentation/bloc/profile_state.dart';

void main() {
  const profile = UserProfile(
    id: 'profile-id',
    hasAnsweredTest: true,
    answeredQuestionsCount: 10,
    firstName: 'Safarali',
    lastName: 'Muxtorov',
  );

  blocTest<ProfileBloc, ProfileState>(
    'emits loading and success when profile loads',
    build: () => ProfileBloc(
      getMyProfile: const GetMyProfileUseCase(
        _ProfileRepository(Right(profile)),
      ),
    ),
    act: (bloc) => bloc.add(const ProfileLoadRequested()),
    expect: () => const [
      ProfileState(status: ProfileStatus.loading),
      ProfileState(status: ProfileStatus.success, profile: profile),
    ],
  );

  blocTest<ProfileBloc, ProfileState>(
    'emits a typed failure when profile loading fails',
    build: () => ProfileBloc(
      getMyProfile: const GetMyProfileUseCase(
        _ProfileRepository(Left(Failure.noInternet())),
      ),
    ),
    act: (bloc) => bloc.add(const ProfileLoadRequested()),
    expect: () => const [
      ProfileState(status: ProfileStatus.loading),
      ProfileState(
        status: ProfileStatus.failure,
        failure: Failure.noInternet(),
      ),
    ],
  );
}

final class _ProfileRepository implements ProfileRepository {
  const _ProfileRepository(this.result);

  final Either<Failure, UserProfile> result;

  @override
  Future<Either<Failure, UserProfile>> getMyProfile() async => result;

  @override
  Future<Either<Failure, bool>> updateLocation({
    required double latitude,
    required double longitude,
  }) async => const Right(true);

  @override
  Future<Either<Failure, UserProfile>> updateProfile(
    ProfileUpdateParams params,
  ) => throw UnimplementedError();

  @override
  Future<Either<Failure, ProfilePhoto>> uploadPhoto({
    required String profileId,
    required String filePath,
    bool isMain = true,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, ProfilePhoto>> setMainPhoto(String photoId) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, void>> deletePhoto(String photoId) =>
      throw UnimplementedError();
}
