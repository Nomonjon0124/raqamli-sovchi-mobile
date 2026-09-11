import 'package:flutter_test/flutter_test.dart';

import 'package:raqamli_sovchi/features/match/data/models/match_request_model.dart';
import 'package:raqamli_sovchi/features/match/domain/entities/match_request.dart';

void main() {
  test('maps wrapped match request fields to the domain model', () {
    final model = MatchRequestModel.fromJson({
      'id': 'request-1',
      'created_at': '2026-08-01T10:00:00Z',
      'updated_at': '2026-08-02T10:00:00Z',
      'status': 'rejected',
      'visibility_scope': 'forward_to_representative',
      'note': 'Assalomu alaykum',
      'from_profile_info': {
        'id': 'profile-1',
        'first_name': 'Ali',
        'last_name': 'Valiyev',
        'main_photo': 'https://cdn.example.com/ali.jpg',
      },
      'to_profile_info': {
        'id': 'profile-2',
        'first_name': 'Mohira',
        'last_name': 'Rasulova',
        'main_photo': 'https://cdn.example.com/mohira.jpg',
      },
    });

    final request = model.toEntity();

    expect(request.id, 'request-1');
    expect(request.status, MatchRequestStatus.rejected);
    expect(request.fromProfileId, 'profile-1');
    expect(request.toProfileId, 'profile-2');
    expect(request.toProfileName, 'Mohira Rasulova');
    expect(request.fromProfileImageUrl, 'https://cdn.example.com/ali.jpg');
    expect(request.toProfileImageUrl, 'https://cdn.example.com/mohira.jpg');
    expect(request.canRetryAt(DateTime.parse('2026-08-09T10:00:00Z')), isTrue);
  });
}
