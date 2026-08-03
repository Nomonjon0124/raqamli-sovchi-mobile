import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../entities/session.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, Session?>> restoreSession();

  Future<Either<Failure, Session>> signIn();

  Future<Either<Failure, void>> signOut();
}
