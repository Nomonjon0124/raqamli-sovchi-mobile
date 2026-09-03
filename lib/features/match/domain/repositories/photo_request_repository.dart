import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../entities/photo_request.dart';

abstract interface class PhotoRequestRepository {
  Future<Either<Failure, PhotoRequest>> createRequest({
    required String toProfile,
    String? note,
  });
}
