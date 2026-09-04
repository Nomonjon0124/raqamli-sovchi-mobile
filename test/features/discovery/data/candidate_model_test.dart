import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/features/discovery/data/models/candidate_model.dart';

void main() {
  test(
    'maps profession reference from candidate response to domain entity',
    () {
      final model = ResultCandidateModel.fromJson({
        'id': 'candidate-id',
        'first_name': 'Mohira',
        'profession_info': {'id': 'profession-id', 'name': 'Dasturchi'},
      });

      final candidate = model.toEntity();

      expect(candidate.professionId, 'profession-id');
      expect(candidate.professionName, 'Dasturchi');
    },
  );

  test('maps full birth date and calculates age before birthday correctly', () {
    final today = DateTime.now();
    final birthDate = DateTime(today.year - 25, 12, 31);
    final model = ResultCandidateModel.fromJson({
      'id': 'candidate-id',
      'first_name': 'Mohira',
      'birth_date': birthDate.toIso8601String().split('T').first,
    });

    final candidate = model.toEntity();
    final birthdayHasPassed =
        today.month > birthDate.month ||
        (today.month == birthDate.month && today.day >= birthDate.day);
    final expectedAge =
        today.year - birthDate.year - (birthdayHasPassed ? 0 : 1);

    expect(candidate.birthDate, birthDate);
    expect(candidate.birthYear, birthDate.year);
    expect(candidate.age, expectedAge);
    expect(
      model.toJson()['birth_date'],
      birthDate.toIso8601String().split('T').first,
    );
    expect(model.toJson().containsKey('birth_year'), isFalse);
  });
}
