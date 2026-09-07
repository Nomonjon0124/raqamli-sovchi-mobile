import 'package:flutter/material.dart';
import 'package:raqamli_sovchi/core/extensions/gap_extension.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/ui/widgets/app_round_icon_button.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/edit/profile_reference_picker_sheet.dart';

final class ProfileRegionPickerPage extends StatelessWidget {
  const ProfileRegionPickerPage({
    required this.regions,
    required this.selectedId,
    super.key,
  });

  final List<ReferenceItem> regions;
  final String? selectedId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return _ProfileLocationPickerScaffold(
      title: l10n.profileEditRegion,
      searchHint: l10n.profileEditRegionSearchHint,
      items: regions,
      selectedId: selectedId,
    );
  }
}

final class ProfileDistrictPickerPage extends StatelessWidget {
  const ProfileDistrictPickerPage({
    required this.regionName,
    required this.districts,
    required this.selectedId,
    super.key,
  });

  final String regionName;
  final List<ReferenceItem> districts;
  final String? selectedId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return _ProfileLocationPickerScaffold(
      title: l10n.profileEditDistrict,
      subtitle: regionName.trim().isEmpty
          ? null
          : l10n.profileEditDistrictRegionCaption(regionName),
      searchHint: l10n.profileEditDistrictSearchHint,
      items: districts,
      selectedId: selectedId,
    );
  }
}

final class _ProfileLocationPickerScaffold extends StatefulWidget {
  const _ProfileLocationPickerScaffold({
    required this.title,
    required this.searchHint,
    required this.items,
    required this.selectedId,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final String searchHint;
  final List<ReferenceItem> items;
  final String? selectedId;

  @override
  State<_ProfileLocationPickerScaffold> createState() =>
      _ProfileLocationPickerScaffoldState();
}

final class _ProfileLocationPickerScaffoldState
    extends State<_ProfileLocationPickerScaffold> {
  late final TextEditingController _searchController;
  String _searchQuery = '';
  String? _selectedId;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.selectedId;
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSelect() {
    FocusScope.of(context).unfocus();
    final selectedId = _selectedId;
    if (selectedId == null) return;
    final selected = widget.items.firstWhere((item) => item.id == selectedId);
    Navigator.of(context).pop(selected);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final query = _searchQuery.trim().toLowerCase();
    final filteredItems = widget.items.where((item) {
      if (query.isEmpty) return true;
      return item.name.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.section,
            AppSpacing.input,
            AppSpacing.section,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _LocationPickerHeader(title: widget.title),
              if (widget.subtitle != null) ...[
                AppSpacing.card.g,
                Text(
                  widget.subtitle!,
                  textAlign: TextAlign.start,
                  style: AppTypography.onboardingSheetCaption,
                ),
              ],
              AppSpacing.card.g,
              _LocationSearchField(
                controller: _searchController,
                hintText: widget.searchHint,
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
              AppSpacing.md.g,
              Expanded(
                child: filteredItems.isEmpty
                    ? Center(
                        child: Text(
                          l10n.profileEditNoOptions,
                          style: AppTypography.onboardingBody,
                        ),
                      )
                    : _LocationOptionList(
                        items: filteredItems,
                        selectedId: _selectedId,
                        onChanged: (id) => setState(() => _selectedId = id),
                      ),
              ),
              _LocationPickerBottomBar(
                isEnabled: _selectedId != null,
                onSelect: _handleSelect,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _LocationPickerHeader extends StatelessWidget {
  const _LocationPickerHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Row(
      children: [
        AppRoundIconButton(
          icon: Assets.icons.icArrowLeft01Round,
          semanticLabel: l10n.settingsBack,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.settingsPageTitle,
          ),
        ),
        const SizedBox(width: 36, height: 36),
      ],
    );
  }
}

final class _LocationSearchField extends StatelessWidget {
  const _LocationSearchField({
    required this.controller,
    required this.hintText,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: AppTypography.body.copyWith(
        fontWeight: FontWeight.w500,
        color: AppColors.text,
      ),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: AppColors.mutedSurface,
        hintText: hintText,
        hintStyle: AppTypography.onboardingSearch,
        prefixIcon: const Icon(
          Icons.search,
          size: 18,
          color: AppColors.placeholder,
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 40,
          minHeight: 18,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.input,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

final class _LocationOptionList extends StatelessWidget {
  const _LocationOptionList({
    required this.items,
    required this.selectedId,
    required this.onChanged,
  });

  final List<ReferenceItem> items;
  final String? selectedId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: ListView.separated(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.zero,
          itemCount: items.length,
          separatorBuilder: (_, _) =>
              const Divider(height: 1, color: AppColors.mutedSurface),
          itemBuilder: (context, index) {
            final item = items[index];
            final isSelected = item.id == selectedId;

            return InkWell(
              onTap: () => onChanged(item.id),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 48),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.input,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: AppTypography.onboardingReferenceOption
                              .copyWith(
                                color: isSelected
                                    ? AppColors.text
                                    : AppColors.bodyText,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      _LocationRadio(isSelected: isSelected),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

final class _LocationRadio extends StatelessWidget {
  const _LocationRadio({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? AppColors.primary : Colors.transparent,
        border: Border.all(
          color: isSelected ? AppColors.primary : const Color(0xFFA3A3A3),
          width: 1.5,
        ),
      ),
    );
  }
}

final class _LocationPickerBottomBar extends StatelessWidget {
  const _LocationPickerBottomBar({
    required this.isEnabled,
    required this.onSelect,
  });

  final bool isEnabled;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: FilledButton(
          onPressed: isEnabled ? onSelect : null,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.surfaceLight,
            disabledBackgroundColor: AppColors.border,
            disabledForegroundColor: AppColors.mutedText,
            textStyle: AppTypography.onboardingAction,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(l10n.profileEditSelect),
              const SizedBox(width: AppSpacing.sm),
              Assets.icons.icArrowRight.svg(
                width: 18,
                height: 18,
                colorFilter: ColorFilter.mode(
                  isEnabled ? AppColors.surfaceLight : AppColors.mutedText,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
