import 'package:dio/dio.dart';

import '../../../../core/errors/either.dart';
import '../../../../core/errors/exception_mapper.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/blocked_user.dart';
import '../../domain/repositories/blocked_user_repository.dart';
import '../data_sources/blocked_user_data_source.dart';

final class BlockedUserRepositoryImpl implements BlockedUserRepository {
  const BlockedUserRepositoryImpl(this._dataSource);

  final BlockedUserDataSource _dataSource;

  @override
  Future<Either<Failure, BlockedUser>> blockUser({
    required String blockedUserId,
    String? reason,
  }) async {
    try {
      final model = await _dataSource.blockUser(
        blockedUserId: blockedUserId,
        reason: reason,
      );
      return Right(model.toEntity());
    } on DioException catch (error) {
      return Left(mapDioException(error));
    } catch (_) {
      return const Left(Failure.unknown());
    }
  }
}
