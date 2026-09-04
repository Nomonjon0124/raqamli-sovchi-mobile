import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/complaint.dart';
import '../../domain/repositories/complaint_repository.dart';

final class CreateComplaintUseCase {
  const CreateComplaintUseCase(this._repository);

  final ComplaintRepository _repository;

  Future<Either<Failure, Complaint>> call({
    required String toUserId,
    required ComplaintReason reason,
    String? message,
  }) {
    final normalizedUserId = toUserId.trim();
    if (normalizedUserId.isEmpty) {
      return Future.value(const Left(Failure.validation()));
    }

    final normalizedMessage = message?.trim();
    return _repository.createComplaint(
      toUserId: normalizedUserId,
      reason: reason,
      message: normalizedMessage == null || normalizedMessage.isEmpty
          ? null
          : normalizedMessage,
    );
  }
}
