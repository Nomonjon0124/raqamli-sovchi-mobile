import 'package:flutter/foundation.dart';
import 'package:screen_protector/screen_protector.dart';

abstract interface class ScreenshotGuard {
  Future<void> enableProtection();

  Future<void> disableProtectionForDebugOnly();
}

final class SecureScreenshotGuard implements ScreenshotGuard {
  @override
  Future<void> enableProtection() async {
    if (!_isSupportedPlatform) {
      return;
    }

    try {
      await ScreenProtector.protectDataLeakageOn();
    } on Object {
      // App must remain startable on unsupported plugin/device combinations.
    }
  }

  @override
  Future<void> disableProtectionForDebugOnly() async {
    if (!kDebugMode || !_isSupportedPlatform) {
      return;
    }

    await ScreenProtector.protectDataLeakageOff();
  }

  bool get _isSupportedPlatform {
    if (kIsWeb) {
      return false;
    }

    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }
}
