import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: AppSpacing.lg),
            Text(l10n.loading),
          ],
        ),
      ),
    );
  }
}
