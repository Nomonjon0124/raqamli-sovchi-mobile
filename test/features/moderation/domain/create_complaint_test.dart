import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/core/errors/either.dart';
import 'package:raqamli_sovchi/core/errors/failure.dart';
import 'package:raqamli_sovchi/features/moderation/application/use_cases/create_complaint.dart';
import 'package:raqamli_sovchi/features/moderation/data/data_sources/complaint_data_source.dart';
import 'package:raqamli_sovchi/features/moderation/data/models/complaint_model.dart';
import 'package:raqamli_sovchi/features/moderation/data/repositories/complaint_repository_impl.dart';
import 'package:raqamli_sovchi/features/moderation/domain/entities/complaint.dart';
import 'package:raqamli_sovchi/features/moderation/domain/repositories/complaint_repository.dart';

void main() {
  test('use case rejects empty target user id', () async {
    final repository = _FakeComplaintRepository();
    final useCase = CreateComplaintUseCase(repository);

    final result = await useCase(
      toUserId: '   ',
      reason: ComplaintReason.other,
    );

    expect(result, isA<Left<Failure, Complaint>>());
    result.fold(
      (failure) => expect(failure.type, FailureType.validation),
      (_) => fail('Expected validation failure'),
    );
    expect(repository.wasCalled, isFalse);
  });

  test(
    'use case trims target user id and message before repository call',
    () async {
      final repository = _FakeComplaintRepository();
      final useCase = CreateComplaintUseCase(repository);

      await useCase(
        toUserId: ' user-uuid-123 ',
        reason: ComplaintReason.spam,
        message: '  Spam xabar  ',
      );

      expect(repository.toUserId, 'user-uuid-123');
      expect(repository.message, 'Spam xabar');
    },
  );

  test('repository maps data source success to entity', () async {
    const dataSource = _FakeComplaintDataSource();
    const repository = ComplaintRepositoryImpl(dataSource);

    final result = await repository.createComplaint(
      toUserId: 'user-uuid-123',
      reason: ComplaintReason.fraud,
    );

    result.fold((_) => fail('Expected success'), (complaint) {
      expect(complaint.id, 'complaint-1');
      expect(complaint.reason, ComplaintReason.fraud);
    });
  });

  test('repository maps DioException to failure', () async {
    final requestOptions = RequestOptions(path: '/api/v1/accounts/complaints/');
    final dataSource = _FakeComplaintDataSource(
      error: DioException(
        requestOptions: requestOptions,
        response: Response<dynamic>(
          requestOptions: requestOptions,
          statusCode: 422,
          data: {
            'error': {
              'details': {
                'reason': ['Invalid reason'],
              },
            },
          },
        ),
        type: DioExceptionType.badResponse,
      ),
    );
    final repository = ComplaintRepositoryImpl(dataSource);

    final result = await repository.createComplaint(
      toUserId: 'user-uuid-123',
      reason: ComplaintReason.other,
    );

    result.fold((failure) {
      expect(failure.type, FailureType.validation);
      expect(failure.message, 'Invalid reason');
    }, (_) => fail('Expected failure'));
  });
}

final class _FakeComplaintRepository implements ComplaintRepository {
  bool wasCalled = false;
  String? toUserId;
  String? message;

  @override
  Future<Either<Failure, Complaint>> createComplaint({
    required String toUserId,
    required ComplaintReason reason,
    String? message,
  }) async {
    wasCalled = true;
    this.toUserId = toUserId;
    this.message = message;
    return Right(
      Complaint(
        id: 'complaint-1',
        reason: reason,
        reasonLabel: reason.apiName,
        status: ComplaintStatus.pending,
        statusLabel: 'Ko‘rib chiqilmoqda',
        createdAt: DateTime.parse('2026-09-04T10:00:00Z'),
        updatedAt: DateTime.parse('2026-09-04T10:00:00Z'),
      ),
    );
  }
}

final class _FakeComplaintDataSource implements ComplaintDataSource {
  const _FakeComplaintDataSource({this.error});

  final Object? error;

  @override
  Future<ComplaintModel> createComplaint({
    required String toUserId,
    required ComplaintReason reason,
    String? message,
  }) async {
    final error = this.error;
    if (error != null) throw error;

    return ComplaintModel(
      id: 'complaint-1',
      reason: reason,
      reasonLabel: reason.apiName,
      status: ComplaintStatus.pending,
      statusLabel: 'Ko‘rib chiqilmoqda',
      createdAt: DateTime.parse('2026-09-04T10:00:00Z'),
      updatedAt: DateTime.parse('2026-09-04T10:00:00Z'),
    );
  }
}
