import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../entities/complaint.dart';

abstract interface class ComplaintRepository {
  Future<Either<Failure, Complaint>> createComplaint({
    required String toUserId,
    required ComplaintReason reason,
    String? message,
  });
}
