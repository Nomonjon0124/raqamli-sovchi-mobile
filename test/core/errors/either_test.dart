import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/core/errors/either.dart';

void main() {
  test('fold calls left branch for failure', () {
    const Either<String, int> result = Left<String, int>('failure');

    expect(result.fold((left) => left, (right) => right.toString()), 'failure');
  });

  test('fold calls right branch for success', () {
    const Either<String, int> result = Right<String, int>(42);

    expect(result.fold((left) => left, (right) => right.toString()), '42');
  });
}
