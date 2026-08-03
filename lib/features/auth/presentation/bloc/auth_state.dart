import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/session.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, failure }

final class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.initial,
    this.session,
    this.failure,
  });

  final AuthStatus status;
  final Session? session;
  final Failure? failure;

  AuthState copyWith({
    AuthStatus? status,
    Session? session,
    Failure? failure,
    bool clearSession = false,
    bool clearFailure = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      session: clearSession ? null : session ?? this.session,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [status, session, failure];
}
