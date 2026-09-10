final class BackgroundLockGate {
  BackgroundLockGate({
    this.lockDelay = const Duration(minutes: 2),
    this.externalInteractionResumeGrace = const Duration(seconds: 2),
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final Duration lockDelay;
  final Duration externalInteractionResumeGrace;
  final DateTime Function() _now;

  DateTime? _backgroundedAt;
  DateTime? _ignoreResumesUntil;
  int _externalInteractionDepth = 0;

  void beginExternalInteraction() {
    _externalInteractionDepth += 1;
    _ignoreResumesUntil = null;
  }

  void endExternalInteraction() {
    if (_externalInteractionDepth > 0) {
      _externalInteractionDepth -= 1;
    }
    _ignoreResumesUntil = _now().add(externalInteractionResumeGrace);
  }

  void markBackgrounded() {
    _backgroundedAt ??= _now();
  }

  bool consumeShouldLockOnResume() {
    final backgroundedAt = _backgroundedAt;
    _backgroundedAt = null;
    if (backgroundedAt == null) return false;
    if (_isExternalInteractionResume()) return false;

    final elapsed = _now().difference(backgroundedAt);
    return !elapsed.isNegative && elapsed >= lockDelay;
  }

  bool _isExternalInteractionResume() {
    if (_externalInteractionDepth > 0) return true;

    final ignoreResumesUntil = _ignoreResumesUntil;
    if (ignoreResumesUntil == null) return false;

    final shouldIgnore = !_now().isAfter(ignoreResumesUntil);
    if (!shouldIgnore) _ignoreResumesUntil = null;
    return shouldIgnore;
  }
}
