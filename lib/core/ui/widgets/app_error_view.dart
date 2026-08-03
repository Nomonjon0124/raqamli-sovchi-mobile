import 'package:flutter/material.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../l10n/app_localizations.dart';

class AppErrorView extends StatelessWidget {
  const AppErrorView({required this.message, this.onRetry, super.key});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(message, textAlign: TextAlign.center),
        if (onRetry != null) ...[
          const SizedBox(height: AppSpacing.md),
          OutlinedButton(onPressed: onRetry, child: Text(l10n.retry)),
        ],
      ],
    );
  }
}
