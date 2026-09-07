import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/app/di/service_locator.dart';
import 'package:raqamli_sovchi/core/errors/either.dart';
import 'package:raqamli_sovchi/core/errors/failure.dart';
import 'package:raqamli_sovchi/features/profile/application/use_cases/get_my_profile.dart';
import 'package:raqamli_sovchi/features/profile/domain/entities/profile_update_params.dart';
import 'package:raqamli_sovchi/features/profile/domain/entities/user_profile.dart';
import 'package:raqamli_sovchi/features/profile/domain/repositories/profile_repository.dart';
import 'package:raqamli_sovchi/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:raqamli_sovchi/features/profile/presentation/pages/profile_page.dart';
import 'package:raqamli_sovchi/l10n/app_localizations.dart';

void main() {
  tearDown(() => serviceLocator.reset());

  testWidgets('renders API profile data in the Figma profile layout', (
    tester,
  ) async {
    final profile = UserProfile(
      id: '13f6728f-64f7-4cb1-a351-1234abcdef90',
      hasAnsweredTest: true,
      answeredQuestionsCount: 18,
      firstName: 'Safarali',
      lastName: 'Muxtorov',
      birthYear: DateTime.now().year - 22,
      gender: 'male',
      height: 180,
      isVerified: true,
    );
    serviceLocator.registerFactory<ProfileBloc>(
      () => ProfileBloc(
        getMyProfile: GetMyProfileUseCase(_ProfileRepository(Right(profile))),
      ),
    );
    await tester.binding.setSurfaceSize(const Size(390, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('uz'),
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: ProfilePage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Profil'), findsOneWidget);
    expect(find.text('Safarali Muxtorov, 22'), findsOneWidget);
    expect(find.text('Foydalanuvchi raqami: CDEF90'), findsOneWidget);
    expect(find.text('0/4'), findsOneWidget);
    expect(find.text('Hali to‘ldirilmagan'), findsOneWidget);
    expect(find.text('Rasm tekshiruvi'), findsOneWidget);
    expect(find.text('Xizmatlar'), findsOneWidget);
  });
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
  }) => throw UnimplementedError();
}
