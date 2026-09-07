import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_radius.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_typography.dart';
import '../../../../../l10n/app_localizations.dart';

final class ProfileEditBioSection extends StatelessWidget {
  const ProfileEditBioSection({
    required this.controller,
    required this.onChanged,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.profileEditAboutSection,
          style: AppTypography.onboardingFieldLabel.copyWith(
            color: AppColors.mutedText,
          ),
        ),
        const SizedBox(height: AppSpacing.xs + 2),
        Container(
          constraints: const BoxConstraints(minHeight: 92),
          decoration: BoxDecoration(
            color: AppColors.subtleSurface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.mutedSurface),
          ),
          padding: const EdgeInsets.all(14),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            minLines: 3,
            maxLines: 6,
            keyboardType: TextInputType.multiline,
            textCapitalization: TextCapitalization.sentences,
            style: const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 13,
              fontWeight: FontWeight.w400,
              height: 21 / 13,
              color: AppColors.text,
            ),
            decoration: InputDecoration(
              isCollapsed: true,
              border: InputBorder.none,
              hintText: l10n.profileEditAboutPlaceholder,
              hintStyle: const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 13,
                fontWeight: FontWeight.w400,
                height: 21 / 13,
                color: AppColors.placeholder,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
