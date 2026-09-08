import 'package:flutter/material.dart';

import '../../../../core/config/app_config.dart';
import '../../../../l10n/app_localizations.dart';
import 'legal_document_web_view_page.dart';

final class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return LegalDocumentWebViewPage(
      uri: AppConfig.privacyPolicyUri,
      title: l10n.settingsPrivacyPolicy,
      loadingLabel: l10n.privacyPolicyLoadingLabel,
      loadErrorMessage: l10n.privacyPolicyLoadError,
    );
  }
}
