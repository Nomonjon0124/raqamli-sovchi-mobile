import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/core/security/background_lock_gate.dart';

void main() {
  test('does not lock when resumed before the configured delay', () {
    var now = DateTime.utc(2026, 9, 10, 12);
    final gate = BackgroundLockGate(
      lockDelay: const Duration(minutes: 2),
      now: () => now,
    );

    gate.markBackgrounded();
    now = now.add(const Duration(seconds: 30));

    expect(gate.consumeShouldLockOnResume(), isFalse);
  });

  test('locks when resumed after the configured delay', () {
    var now = DateTime.utc(2026, 9, 10, 12);
    final gate = BackgroundLockGate(
      lockDelay: const Duration(minutes: 2),
      now: () => now,
    );

    gate.markBackgrounded();
    now = now.add(const Duration(minutes: 2));

    expect(gate.consumeShouldLockOnResume(), isTrue);
  });

  test('consumes the background mark after resume', () {
    var now = DateTime.utc(2026, 9, 10, 12);
    final gate = BackgroundLockGate(now: () => now);

    gate.markBackgrounded();
    now = now.add(const Duration(minutes: 3));

    expect(gate.consumeShouldLockOnResume(), isTrue);
    expect(gate.consumeShouldLockOnResume(), isFalse);
  });

  test('does not lock when returning from an active external picker', () {
    var now = DateTime.utc(2026, 9, 10, 12);
    final gate = BackgroundLockGate(now: () => now);

    gate.beginExternalInteraction();
    gate.markBackgrounded();
    now = now.add(const Duration(minutes: 5));

    expect(gate.consumeShouldLockOnResume(), isFalse);

    gate.endExternalInteraction();
  });

  test('does not lock during the external picker resume grace period', () {
    var now = DateTime.utc(2026, 9, 10, 12);
    final gate = BackgroundLockGate(
      externalInteractionResumeGrace: const Duration(seconds: 2),
      now: () => now,
    );

    gate.beginExternalInteraction();
    gate.markBackgrounded();
    now = now.add(const Duration(minutes: 5));
    gate.endExternalInteraction();

    expect(gate.consumeShouldLockOnResume(), isFalse);
  });
}
