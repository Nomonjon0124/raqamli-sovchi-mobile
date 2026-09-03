import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/ui/widgets/app_button.dart';
import '../../../../l10n/app_localizations.dart';

final class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

final class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  late final WebViewController _controller;
  var _isLoading = true;
  var _hasLoadError = false;
  var _progress = 0;
  var _canGoBack = false;
  var _allowRoutePop = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController();
    unawaited(_configureController());
  }

  Future<void> _configureController() async {
    await _controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    await _controller.setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (_) => _setLoading(),
        onPageFinished: (_) {
          if (!mounted) return;
          setState(() {
            _isLoading = false;
            _hasLoadError = false;
            _progress = 100;
          });
          unawaited(_refreshCanGoBack());
        },
        onProgress: (progress) {
          if (!mounted) return;
          setState(() => _progress = progress);
        },
        onUrlChange: (_) => unawaited(_refreshCanGoBack()),
        onWebResourceError: (error) {
          if (error.isForMainFrame == false || !mounted) return;
          setState(() {
            _isLoading = false;
            _hasLoadError = true;
          });
        },
      ),
    );
    await _loadPrivacyPolicy();
  }

  Future<void> _loadPrivacyPolicy() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _hasLoadError = false;
        _progress = 0;
      });
    }
    try {
      await _controller.loadRequest(AppConfig.privacyPolicyUri);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _hasLoadError = true;
      });
    }
  }

  Future<void> _refreshCanGoBack() async {
    final canGoBack = await _controller.canGoBack();
    if (!mounted || canGoBack == _canGoBack) return;
    setState(() => _canGoBack = canGoBack);
  }

  void _setLoading() {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _hasLoadError = false;
    });
  }

  Future<void> _handleBack() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
      return;
    }
    if (!mounted) return;
    _popRoute();
  }

  void _popRoute() {
    if (!_canGoBack) {
      _popIfNotFirstRoute();
      return;
    }
    if (_allowRoutePop) {
      _popIfNotFirstRoute();
      return;
    }
    setState(() {
      _allowRoutePop = true;
      _canGoBack = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _popIfNotFirstRoute();
    });
  }

  void _popIfNotFirstRoute() {
    final route = ModalRoute.of(context);
    if (route == null || route.isFirst) return;
    Navigator.of(context).removeRoute(route);
  }

  Future<bool> _handleSystemBack() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
      return true;
    }
    if (!mounted) return false;
    _popRoute();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PopScope<void>(
      canPop: _allowRoutePop || !_canGoBack,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        unawaited(_handleSystemBack());
      },
      child: Scaffold(
        backgroundColor: AppColors.surfaceLight,
        appBar: AppBar(
          backgroundColor: AppColors.surfaceLight,
          foregroundColor: AppColors.text,
          elevation: 0,
          centerTitle: true,
          title: Text(
            l10n.settingsPrivacyPolicy,
            style: AppTypography.settingsPageTitle,
          ),
          leading: IconButton(
            tooltip: l10n.settingsBack,
            onPressed: () => unawaited(_handleBack()),
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
        ),
        body: Stack(
          children: [
            if (_hasLoadError)
              _PrivacyPolicyError(
                message: l10n.privacyPolicyLoadError,
                retryLabel: l10n.retry,
                onRetry: () => unawaited(_loadPrivacyPolicy()),
              )
            else
              WebViewWidget(controller: _controller),
            if (_isLoading)
              Align(
                alignment: Alignment.topCenter,
                child: Semantics(
                  label: l10n.privacyPolicyLoadingLabel,
                  child: LinearProgressIndicator(
                    value: _progress > 0 && _progress < 100
                        ? _progress / 100
                        : null,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

final class _PrivacyPolicyError extends StatelessWidget {
  const _PrivacyPolicyError({
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              size: 40,
              color: AppColors.mutedText,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.onboardingBody,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(label: retryLabel, onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}
