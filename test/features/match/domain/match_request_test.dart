import 'package:flutter_test/flutter_test.dart';

import 'package:raqamli_sovchi/features/match/domain/entities/match_request.dart';

void main() {
  test('retry is unavailable before seven full days', () {
    final request = MatchRequest(
      id: 'request-1',
      createdAt: DateTime.parse('2026-08-01T10:00:00Z'),
      updatedAt: DateTime.parse('2026-08-02T10:00:00Z'),
      status: MatchRequestStatus.rejected,
      visibilityScope: MatchRequestVisibilityScope.forwardToRepresentative,
      note: null,
      fromProfileId: 'profile-1',
      toProfileId: 'profile-2',
    );

    expect(request.retryAvailableAt, DateTime.parse('2026-08-09T10:00:00Z'));
    expect(request.canRetryAt(DateTime.parse('2026-08-09T09:59:59Z')), isFalse);
    expect(request.canRetryAt(DateTime.parse('2026-08-09T10:00:00Z')), isTrue);
  });
}
