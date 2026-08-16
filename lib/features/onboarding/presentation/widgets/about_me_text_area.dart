import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_typography.dart';

final class AboutMeTextArea extends StatelessWidget {
  const AboutMeTextArea({super.key, required this.controller, required this.hint, required this.onChanged});

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 132,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.mutedSurface, borderRadius: BorderRadius.circular(AppRadius.lg)),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        maxLength: 300,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        style: AppTypography.onboardingChip,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTypography.onboardingChip.copyWith(color: AppColors.placeholder),
          border: InputBorder.none,
          isDense: true,
          counterText: '',
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
