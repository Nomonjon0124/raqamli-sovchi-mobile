import 'package:flutter_bloc/flutter_bloc.dart';

import '../../application/use_cases/restore_session.dart';
import '../../application/use_cases/sign_in.dart';
import '../../application/use_cases/sign_out.dart';
import 'auth_event.dart';
import 'auth_state.dart';

final class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required RestoreSessionUseCase restoreSession,
    required SignInUseCase signIn,
    required SignOutUseCase signOut,
  }) : _restoreSession = restoreSession,
       _signIn = signIn,
       _signOut = signOut,
       super(const AuthState()) {
    on<AuthStarted>(_onStarted);
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
  }

  final RestoreSessionUseCase _restoreSession;
  final SignInUseCase _signIn;
  final SignOutUseCase _signOut;

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    emit(const AuthState(status: AuthStatus.loading));
    final result = await _restoreSession();

    result.fold(
      (failure) =>
          emit(AuthState(status: AuthStatus.failure, failure: failure)),
      (session) => emit(
        session == null
            ? const AuthState(status: AuthStatus.unauthenticated)
            : AuthState(status: AuthStatus.authenticated, session: session),
      ),
    );
  }

  Future<void> _onSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState(status: AuthStatus.loading));
    final result = await _signIn();

    result.fold(
      (failure) =>
          emit(AuthState(status: AuthStatus.failure, failure: failure)),
      (session) =>
          emit(AuthState(status: AuthStatus.authenticated, session: session)),
    );
  }

  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState(status: AuthStatus.loading));
    final result = await _signOut();

    result.fold(
      (failure) =>
          emit(AuthState(status: AuthStatus.failure, failure: failure)),
      (_) => emit(const AuthState(status: AuthStatus.unauthenticated)),
    );
  }
}
