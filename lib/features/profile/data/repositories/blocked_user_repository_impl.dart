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

  @override
  Future<Either<Failure, List<BlockedUser>>> getBlockedUsers({
    int page = 1,
  }) async {
    try {
      final models = await _dataSource.getBlockedUsers(page: page);
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (error) {
      return Left(mapDioException(error));
    } catch (error) {
      return Left(
        Failure.unknown(technicalReason: error.runtimeType.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> unblockUser({
    required String userId,
    String? blockedRecordId,
  }) async {
    try {
      final success = await _dataSource.unblockUser(
        userId: userId,
        blockedRecordId: blockedRecordId,
      );
      return Right(success);
    } on DioException catch (error) {
      return Left(mapDioException(error));
    } catch (error) {
      return Left(
        Failure.unknown(technicalReason: error.runtimeType.toString()),
      );
    }
  }
}
