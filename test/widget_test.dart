import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:raqamli_sovchi/core/errors/either.dart';
import 'package:raqamli_sovchi/core/errors/failure.dart';
import 'package:raqamli_sovchi/features/auth/application/use_cases/restore_session.dart';
import 'package:raqamli_sovchi/features/auth/application/use_cases/sign_in.dart';
import 'package:raqamli_sovchi/features/auth/application/use_cases/sign_out.dart';
import 'package:raqamli_sovchi/features/auth/domain/entities/session.dart';
import 'package:raqamli_sovchi/features/auth/domain/repositories/auth_repository.dart';
import 'package:raqamli_sovchi/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:raqamli_sovchi/features/auth/presentation/pages/login_page.dart';
import 'package:raqamli_sovchi/l10n/app_localizations.dart';

void main() {
  testWidgets('login page sends demo sign-in event', (tester) async {
    final repository = _FakeAuthRepository();
    final authBloc = AuthBloc(
      restoreSession: RestoreSessionUseCase(repository),
      signIn: SignInUseCase(repository),
      signOut: SignOutUseCase(repository),
    );

    await tester.pumpWidget(
      BlocProvider.value(
        value: authBloc,
        child: const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: LoginPage(),
        ),
      ),
    );

    expect(find.text('Sign in as demo user'), findsOneWidget);

    await tester.tap(find.text('Sign in as demo user'));
    await tester.pump();

    expect(repository.signInCalls, 1);
    await authBloc.close();
  });
}

final class _FakeAuthRepository implements AuthRepository {
  int signInCalls = 0;

  @override
  Future<Either<Failure, Session?>> restoreSession() async {
    return const Right<Failure, Session?>(null);
  }

  @override
  Future<Either<Failure, Session>> signIn() async {
    signInCalls++;
    return const Right<Failure, Session>(
      Session(userId: 'test-user', displayName: 'Test User'),
    );
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    return const Right<Failure, void>(null);
  }
}
