import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_radius.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_typography.dart';
import '../../../../../l10n/app_localizations.dart';

final class ProfileNameEditSheet extends StatefulWidget {
  const ProfileNameEditSheet({
    required this.initialFirstName,
    required this.initialLastName,
    required this.onConfirm,
    super.key,
  });

  final String initialFirstName;
  final String initialLastName;
  final void Function(String firstName, String lastName) onConfirm;

  static Future<void> show({
    required BuildContext context,
    required String initialFirstName,
    required String initialLastName,
    required void Function(String firstName, String lastName) onConfirm,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ProfileNameEditSheet(
        initialFirstName: initialFirstName,
        initialLastName: initialLastName,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  State<ProfileNameEditSheet> createState() => _ProfileNameEditSheetState();
}

final class _ProfileNameEditSheetState extends State<ProfileNameEditSheet> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.initialFirstName);
    _lastNameController = TextEditingController(text: widget.initialLastName);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.md,
          AppSpacing.xl,
          AppSpacing.xl,
        ),
        decoration: const BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              l10n.profileEditName,
              style: AppTypography.onboardingSheetTitle,
            ),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: _firstNameController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: l10n.profileEditFirstName,
                filled: true,
                fillColor: AppColors.mutedSurface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _lastNameController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: l10n.profileEditLastName,
                filled: true,
                fillColor: AppColors.mutedSurface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                final first = _firstNameController.text.trim();
                final last = _lastNameController.text.trim();
                widget.onConfirm(first, last);
                Navigator.of(context).pop();
              },
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
              child: Text(l10n.profileEditSelect),
            ),
          ],
        ),
      ),
    );
  }
}
