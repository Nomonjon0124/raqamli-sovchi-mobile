import 'package:dio/dio.dart';

import '../../../../core/errors/either.dart';
import '../../../../core/errors/exception_mapper.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/complaint.dart';
import '../../domain/repositories/complaint_repository.dart';
import '../data_sources/complaint_data_source.dart';

final class ComplaintRepositoryImpl implements ComplaintRepository {
  const ComplaintRepositoryImpl(this._dataSource);

  final ComplaintDataSource _dataSource;

  @override
  Future<Either<Failure, Complaint>> createComplaint({
    required String toUserId,
    required ComplaintReason reason,
    String? message,
  }) async {
    try {
      final model = await _dataSource.createComplaint(
        toUserId: toUserId,
        reason: reason,
        message: message,
      );
      return Right(model.toEntity());
    } on DioException catch (error) {
      return Left(mapDioException(error));
    } catch (_) {
      return const Left(Failure.unknown());
    }
  }
}
