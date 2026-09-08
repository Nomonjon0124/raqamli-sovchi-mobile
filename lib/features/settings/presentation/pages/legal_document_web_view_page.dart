import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/ui/widgets/app_button.dart';
import '../../../../l10n/app_localizations.dart';

final class LegalDocumentWebViewPage extends StatefulWidget {
  const LegalDocumentWebViewPage({
    super.key,
    required this.uri,
    required this.title,
    required this.loadingLabel,
    required this.loadErrorMessage,
  });

  final Uri uri;
  final String title;
  final String loadingLabel;
  final String loadErrorMessage;

  @override
  State<LegalDocumentWebViewPage> createState() =>
      _LegalDocumentWebViewPageState();
}

final class _LegalDocumentWebViewPageState
    extends State<LegalDocumentWebViewPage> {
  late final WebViewController _controller;
  var _isLoading = true;
  var _hasLoadError = false;
  var _progress = 0;

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
        },
        onProgress: (progress) {
          if (!mounted) return;
          setState(() => _progress = progress);
        },
        onWebResourceError: (error) {
          if (error.isForMainFrame == false || !mounted) return;
          setState(() {
            _isLoading = false;
            _hasLoadError = true;
          });
        },
      ),
    );
    await _loadDocument();
  }

  Future<void> _loadDocument() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _hasLoadError = false;
        _progress = 0;
      });
    }
    try {
      await _controller.loadRequest(widget.uri);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _hasLoadError = true;
      });
    }
  }

  void _setLoading() {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _hasLoadError = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.text,
        elevation: 0,
        centerTitle: true,
        title: Text(widget.title, style: AppTypography.settingsPageTitle),
        leading: IconButton(
          tooltip: l10n.settingsBack,
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: Stack(
        children: [
          if (_hasLoadError)
            _LegalDocumentError(
              message: widget.loadErrorMessage,
              retryLabel: l10n.retry,
              onRetry: () => unawaited(_loadDocument()),
            )
          else
            WebViewWidget(controller: _controller),
          if (_isLoading)
            Align(
              alignment: Alignment.topCenter,
              child: Semantics(
                label: widget.loadingLabel,
                child: LinearProgressIndicator(
                  value: _progress > 0 && _progress < 100
                      ? _progress / 100
                      : null,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

final class _LegalDocumentError extends StatelessWidget {
  const _LegalDocumentError({
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
