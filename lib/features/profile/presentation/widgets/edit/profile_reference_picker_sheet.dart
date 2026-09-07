import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_radius.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_typography.dart';
import '../../../../../l10n/app_localizations.dart';

final class ReferenceItem extends Equatable {
  const ReferenceItem({required this.id, required this.name});

  final String id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}

final class ProfileReferencePickerSheet extends StatefulWidget {
  const ProfileReferencePickerSheet({
    required this.title,
    required this.items,
    required this.selectedId,
    required this.onConfirm,
    this.hasSearch = false,
    this.searchPlaceholder,
    this.hasOther = false,
    this.otherLabel,
    this.otherInputLabel,
    this.onConfirmCustom,
    super.key,
  });

  final String title;
  final List<ReferenceItem> items;
  final String? selectedId;
  final bool hasSearch;
  final String? searchPlaceholder;
  final bool hasOther;
  final String? otherLabel;
  final String? otherInputLabel;
  final ValueChanged<ReferenceItem> onConfirm;
  final ValueChanged<String>? onConfirmCustom;

  static Future<void> show({
    required BuildContext context,
    required String title,
    required List<ReferenceItem> items,
    required String? selectedId,
    required ValueChanged<ReferenceItem> onConfirm,
    bool hasSearch = false,
    String? searchPlaceholder,
    bool hasOther = false,
    String? otherLabel,
    String? otherInputLabel,
    ValueChanged<String>? onConfirmCustom,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ProfileReferencePickerSheet(
        title: title,
        items: items,
        selectedId: selectedId,
        hasSearch: hasSearch,
        searchPlaceholder: searchPlaceholder,
        hasOther: hasOther,
        otherLabel: otherLabel,
        otherInputLabel: otherInputLabel,
        onConfirm: onConfirm,
        onConfirmCustom: onConfirmCustom,
      ),
    );
  }

  @override
  State<ProfileReferencePickerSheet> createState() =>
      _ProfileReferencePickerSheetState();
}

final class _ProfileReferencePickerSheetState
    extends State<ProfileReferencePickerSheet> {
  String? _selectedId;
  String _searchQuery = '';
  late final TextEditingController _searchController;
  late final TextEditingController _otherController;
  bool _isOtherSelected = false;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.selectedId;
    _searchController = TextEditingController();
    _otherController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _otherController.dispose();
    super.dispose();
  }

  bool get _isConfirmEnabled {
    if (_isOtherSelected) {
      return _otherController.text.trim().isNotEmpty;
    }
    return _selectedId != null;
  }

  void _handleConfirm() {
    FocusScope.of(context).unfocus();
    if (_isOtherSelected) {
      final customName = _otherController.text.trim();
      if (customName.isNotEmpty) {
        widget.onConfirmCustom?.call(customName);
      }
    } else {
      final selectedId = _selectedId;
      if (selectedId != null) {
        final selected = widget.items.firstWhere(
          (item) => item.id == selectedId,
        );
        widget.onConfirm(selected);
      }
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final query = _searchQuery.trim().toLowerCase();
    final filtered = widget.items.where((item) {
      if (query.isEmpty) return true;
      return item.name.toLowerCase().contains(query);
    }).toList();

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: DraggableScrollableSheet(
        initialChildSize: 1.0,
        minChildSize: 0.5,
        maxChildSize: 1.0,
        expand: false,
        builder: (context, scrollController) {
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
                Text(widget.title, style: AppTypography.onboardingSheetTitle),
                if (widget.hasSearch) ...[
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() => _searchQuery = val),
                    style: AppTypography.body.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.text,
                    ),
                    decoration: InputDecoration(
                      hintText:
                          widget.searchPlaceholder ??
                          l10n.profileEditSearchPlaceholder,
                      hintStyle: AppTypography.onboardingSearch,
                      filled: true,
                      fillColor: AppColors.mutedSurface,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm + 2,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        size: 20,
                        color: AppColors.placeholder,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.md),
                Expanded(
                  child: ListView.separated(
                    controller: scrollController,
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    itemCount: filtered.length + (widget.hasOther ? 1 : 0),
                    separatorBuilder: (_, _) =>
                        const Divider(height: 1, color: AppColors.mutedSurface),
                    itemBuilder: (context, index) {
                      if (widget.hasOther && index == filtered.length) {
                        return _buildOtherOption(context, l10n);
                      }
                      final item = filtered[index];
                      final isSelected =
                          !_isOtherSelected && item.id == _selectedId;

                      return InkWell(
                        onTap: () => setState(() {
                          _isOtherSelected = false;
                          _selectedId = item.id;
                        }),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.md,
                            horizontal: AppSpacing.xs,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item.name,
                                  style: TextStyle(
                                    fontFamily: 'Manrope',
                                    fontSize: 15,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? AppColors.text
                                        : AppColors.bodyText,
                                  ),
                                ),
                              ),
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.placeholder,
                                    width: 2,
                                  ),
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.transparent,
                                ),
                                child: isSelected
                                    ? const Center(
                                        child: Icon(
                                          Icons.check,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                FilledButton(
                  onPressed: _isConfirmEnabled ? _handleConfirm : null,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.border,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                  ),
                  child: Text(l10n.profileEditSelect),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOtherOption(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () => setState(() {
            _isOtherSelected = true;
            _selectedId = null;
          }),
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.md,
              horizontal: AppSpacing.xs,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.otherLabel ?? l10n.profileEditProfessionOther,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 15,
                      fontWeight: _isOtherSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: _isOtherSelected
                          ? AppColors.text
                          : AppColors.bodyText,
                    ),
                  ),
                ),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _isOtherSelected
                          ? AppColors.primary
                          : AppColors.placeholder,
                      width: 2,
                    ),
                    color: _isOtherSelected
                        ? AppColors.primary
                        : Colors.transparent,
                  ),
                  child: _isOtherSelected
                      ? const Center(
                          child: Icon(
                            Icons.check,
                            size: 14,
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
        if (_isOtherSelected) ...[
          const SizedBox(height: AppSpacing.xs),
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: TextField(
              controller: _otherController,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              style: AppTypography.body.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.text,
              ),
              decoration: InputDecoration(
                hintText:
                    widget.otherInputLabel ??
                    l10n.profileEditProfessionInputLabel,
                hintStyle: AppTypography.onboardingSearch,
                filled: true,
                fillColor: AppColors.mutedSurface,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.input,
                  vertical: AppSpacing.md,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
        ],
      ],
    );
  }
}
