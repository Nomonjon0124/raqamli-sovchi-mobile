import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/core/config/app_config.dart';
import 'package:raqamli_sovchi/features/settings/presentation/pages/privacy_policy_page.dart';
import 'package:raqamli_sovchi/features/settings/presentation/pages/terms_of_service_page.dart';
import 'package:raqamli_sovchi/l10n/app_localizations.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

void main() {
  late _FakeWebViewPlatform webViewPlatform;

  setUp(() {
    webViewPlatform = _FakeWebViewPlatform();
    WebViewPlatform.instance = webViewPlatform;
  });

  testWidgets('loads the configured privacy policy URL in a WebView', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp(const PrivacyPolicyPage()));
    await tester.pump();

    final controller = webViewPlatform.controllers.single;
    expect(find.text('Maxfiylik siyosati'), findsOneWidget);
    expect(find.byKey(const ValueKey('fake-webview')), findsOneWidget);
    expect(controller.javaScriptMode, JavaScriptMode.unrestricted);
    expect(controller.lastRequest?.uri, AppConfig.privacyPolicyUri);
    expect(controller.loadRequestCount, 1);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
  });

  testWidgets('shows a localized error and retries the same URL', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp(const PrivacyPolicyPage()));
    await tester.pump();

    webViewPlatform.delegates.single.onWebResourceError?.call(
      const WebResourceError(
        errorCode: -2,
        description: 'Host lookup failed',
        isForMainFrame: true,
      ),
    );
    await tester.pump();

    expect(find.textContaining('yuklab bo‘lmadi'), findsOneWidget);
    expect(find.text('Qayta urinish'), findsOneWidget);

    await tester.tap(find.text('Qayta urinish'));
    await tester.pump();

    final controller = webViewPlatform.controllers.single;
    expect(controller.loadRequestCount, 2);
    expect(controller.lastRequest?.uri, AppConfig.privacyPolicyUri);
    expect(find.textContaining('yuklab bo‘lmadi'), findsNothing);
  });

  testWidgets('loads the configured terms of service URL in a WebView', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp(const TermsOfServicePage()));
    await tester.pump();

    final controller = webViewPlatform.controllers.single;
    expect(find.text('Foydalanish shartlari'), findsOneWidget);
    expect(find.byKey(const ValueKey('fake-webview')), findsOneWidget);
    expect(controller.javaScriptMode, JavaScriptMode.unrestricted);
    expect(controller.lastRequest?.uri, AppConfig.termsOfServiceUri);
    expect(controller.loadRequestCount, 1);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
  });

  testWidgets('app bar back closes the page without WebView history', (
    tester,
  ) async {
    await tester.pumpWidget(_navigatorTestApp());
    await tester.tap(find.text('Open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();

    final controller = webViewPlatform.controllers.single;
    controller.canGoBackValue = true;

    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();

    expect(controller.goBackCount, 0);
    expect(find.text('Open'), findsOneWidget);
    expect(find.byType(PrivacyPolicyPage), findsNothing);
  });
}

Widget _testApp(Widget child) => MaterialApp(
  locale: const Locale('uz'),
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: AppLocalizations.supportedLocales,
  home: child,
);

Widget _navigatorTestApp() => _testApp(
  Builder(
    builder: (context) => Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const PrivacyPolicyPage()),
          ),
          child: const Text('Open'),
        ),
      ),
    ),
  ),
);

final class _FakeWebViewPlatform extends WebViewPlatform {
  final controllers = <_FakePlatformWebViewController>[];
  final delegates = <_FakePlatformNavigationDelegate>[];

  @override
  PlatformNavigationDelegate createPlatformNavigationDelegate(
    PlatformNavigationDelegateCreationParams params,
  ) {
    final delegate = _FakePlatformNavigationDelegate(params);
    delegates.add(delegate);
    return delegate;
  }

  @override
  PlatformWebViewController createPlatformWebViewController(
    PlatformWebViewControllerCreationParams params,
  ) {
    final controller = _FakePlatformWebViewController(params);
    controllers.add(controller);
    return controller;
  }

  @override
  PlatformWebViewWidget createPlatformWebViewWidget(
    PlatformWebViewWidgetCreationParams params,
  ) {
    return _FakePlatformWebViewWidget(params);
  }
}

final class _FakePlatformWebViewController extends PlatformWebViewController {
  _FakePlatformWebViewController(super.params) : super.implementation();

  JavaScriptMode? javaScriptMode;
  LoadRequestParams? lastRequest;
  var loadRequestCount = 0;
  var canGoBackValue = false;
  var goBackCount = 0;

  @override
  Future<void> setJavaScriptMode(JavaScriptMode javaScriptMode) async {
    this.javaScriptMode = javaScriptMode;
  }

  @override
  Future<void> setPlatformNavigationDelegate(
    PlatformNavigationDelegate handler,
  ) async {}

  @override
  Future<void> loadRequest(LoadRequestParams params) async {
    lastRequest = params;
    loadRequestCount++;
  }

  @override
  Future<bool> canGoBack() async => canGoBackValue;

  @override
  Future<void> goBack() async {
    goBackCount++;
    canGoBackValue = false;
  }
}

final class _FakePlatformNavigationDelegate extends PlatformNavigationDelegate {
  _FakePlatformNavigationDelegate(super.params) : super.implementation();

  PageEventCallback? onPageStarted;
  PageEventCallback? onPageFinished;
  ProgressCallback? onProgress;
  UrlChangeCallback? onUrlChange;
  WebResourceErrorCallback? onWebResourceError;

  @override
  Future<void> setOnPageStarted(PageEventCallback onPageStarted) async {
    this.onPageStarted = onPageStarted;
  }

  @override
  Future<void> setOnPageFinished(PageEventCallback onPageFinished) async {
    this.onPageFinished = onPageFinished;
  }

  @override
  Future<void> setOnProgress(ProgressCallback onProgress) async {
    this.onProgress = onProgress;
  }

  @override
  Future<void> setOnUrlChange(UrlChangeCallback onUrlChange) async {
    this.onUrlChange = onUrlChange;
  }

  @override
  Future<void> setOnWebResourceError(
    WebResourceErrorCallback onWebResourceError,
  ) async {
    this.onWebResourceError = onWebResourceError;
  }
}

final class _FakePlatformWebViewWidget extends PlatformWebViewWidget {
  _FakePlatformWebViewWidget(super.params) : super.implementation();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand(key: ValueKey('fake-webview'));
  }
}
