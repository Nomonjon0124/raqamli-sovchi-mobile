import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/mock_auth_data_source.dart';

final class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._dataSource);

  final AuthDataSource _dataSource;

  @override
  Future<Either<Failure, Session?>> restoreSession() async {
    try {
      final model = await _dataSource.restoreSession();
      return Right<Failure, Session?>(model?.toEntity());
    } on Object {
      return const Left<Failure, Session?>(Failure.unknown());
    }
  }

  @override
  Future<Either<Failure, Session>> signIn() async {
    try {
      final model = await _dataSource.signIn();
      return Right<Failure, Session>(model.toEntity());
    } on Object {
      return const Left<Failure, Session>(Failure.unknown());
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _dataSource.signOut();
      return const Right<Failure, void>(null);
    } on Object {
      return const Left<Failure, void>(Failure.unknown());
    }
  }
}
