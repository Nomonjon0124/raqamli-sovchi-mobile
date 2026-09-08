import 'package:flutter/material.dart';

import '../../../../core/config/app_config.dart';
import '../../../../l10n/app_localizations.dart';
import 'legal_document_web_view_page.dart';

final class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return LegalDocumentWebViewPage(
      uri: AppConfig.termsOfServiceUri,
      title: l10n.settingsTerms,
      loadingLabel: l10n.termsOfServiceLoadingLabel,
      loadErrorMessage: l10n.termsOfServiceLoadError,
    );
  }
}
