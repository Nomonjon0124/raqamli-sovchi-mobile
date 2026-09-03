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
}
