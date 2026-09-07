import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_radius.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_typography.dart';
import '../../../../../l10n/app_localizations.dart';

final class ProfileNumberPickerSheet extends StatefulWidget {
  const ProfileNumberPickerSheet({
    required this.title,
    required this.initialValue,
    required this.minValue,
    required this.maxValue,
    required this.unit,
    required this.onConfirm,
    super.key,
  });

  final String title;
  final int initialValue;
  final int minValue;
  final int maxValue;
  final String unit;
  final ValueChanged<int> onConfirm;

  static Future<void> show({
    required BuildContext context,
    required String title,
    required int initialValue,
    required int minValue,
    required int maxValue,
    required String unit,
    required ValueChanged<int> onConfirm,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ProfileNumberPickerSheet(
        title: title,
        initialValue: initialValue,
        minValue: minValue,
        maxValue: maxValue,
        unit: unit,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  State<ProfileNumberPickerSheet> createState() =>
      _ProfileNumberPickerSheetState();
}

final class _ProfileNumberPickerSheetState
    extends State<ProfileNumberPickerSheet> {
  late int _selectedValue;
  late final FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue.clamp(
      widget.minValue,
      widget.maxValue,
    );
    final initialItemIndex = _selectedValue - widget.minValue;
    _scrollController = FixedExtentScrollController(
      initialItem: initialItemIndex >= 0 ? initialItemIndex : 0,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final itemCount = widget.maxValue - widget.minValue + 1;

    return Container(
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
            widget.title,
            textAlign: TextAlign.center,
            style: AppTypography.onboardingSheetTitle,
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: 180,
            child: ListWheelScrollView.useDelegate(
              controller: _scrollController,
              itemExtent: 44,
              perspective: 0.005,
              diameterRatio: 1.2,
              physics: const FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                setState(() {
                  _selectedValue = widget.minValue + index;
                });
              },
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: itemCount,
                builder: (context, index) {
                  final val = widget.minValue + index;
                  final isSelected = val == _selectedValue;
                  return Center(
                    child: Text(
                      widget.unit.isNotEmpty ? '$val ${widget.unit}' : '$val',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: isSelected ? 22 : 16,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.mutedText,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          FilledButton(
            onPressed: () {
              widget.onConfirm(_selectedValue);
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
    );
  }
}
