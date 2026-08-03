import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/core/errors/either.dart';
import 'package:raqamli_sovchi/core/errors/failure.dart';
import 'package:raqamli_sovchi/features/auth/application/use_cases/restore_session.dart';
import 'package:raqamli_sovchi/features/auth/application/use_cases/sign_in.dart';
import 'package:raqamli_sovchi/features/auth/application/use_cases/sign_out.dart';
import 'package:raqamli_sovchi/features/auth/domain/entities/session.dart';
import 'package:raqamli_sovchi/features/auth/domain/repositories/auth_repository.dart';
import 'package:raqamli_sovchi/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:raqamli_sovchi/features/auth/presentation/bloc/auth_event.dart';
import 'package:raqamli_sovchi/features/auth/presentation/bloc/auth_state.dart';

void main() {
  const session = Session(userId: 'user-1', displayName: 'Test User');

  blocTest<AuthBloc, AuthState>(
    'restores authenticated session',
    build: () => _createBloc(repository: _FakeAuthRepository(session: session)),
    act: (bloc) => bloc.add(const AuthStarted()),
    expect: () => [
      const AuthState(status: AuthStatus.loading),
      const AuthState(status: AuthStatus.authenticated, session: session),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits failure when restore fails',
    build: () => _createBloc(
      repository: _FakeAuthRepository(failure: const Failure.unknown()),
    ),
    act: (bloc) => bloc.add(const AuthStarted()),
    expect: () => [
      const AuthState(status: AuthStatus.loading),
      const AuthState(status: AuthStatus.failure, failure: Failure.unknown()),
    ],
  );
}

AuthBloc _createBloc({required _FakeAuthRepository repository}) {
  return AuthBloc(
    restoreSession: RestoreSessionUseCase(repository),
    signIn: SignInUseCase(repository),
    signOut: SignOutUseCase(repository),
  );
}

final class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({this.session, this.failure});

  final Session? session;
  final Failure? failure;

  @override
  Future<Either<Failure, Session?>> restoreSession() async {
    if (failure != null) {
      return Left<Failure, Session?>(failure!);
    }
    return Right<Failure, Session?>(session);
  }

  @override
  Future<Either<Failure, Session>> signIn() async {
    return Right<Failure, Session>(
      session ?? const Session(userId: 'user-1', displayName: 'Test User'),
    );
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    return const Right<Failure, void>(null);
  }
}
