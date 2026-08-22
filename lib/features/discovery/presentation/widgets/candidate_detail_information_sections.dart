import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/extensions/gap_extension.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/candidate.dart';

final class CandidateDetailInformationSections extends StatelessWidget {
  const CandidateDetailInformationSections({
    required this.candidate,
    super.key,
  });

  final Candidate candidate;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final sections = <_CandidateInformationSectionData>[
      _CandidateInformationSectionData(
        title: l10n.candidateDetailBasicInformation,
        entries: [
          _CandidateInformationEntry(
            label: l10n.candidateDetailBirthYear,
            value: _birthYearValue(l10n),
          ),
          _CandidateInformationEntry(
            label: l10n.candidateDetailCity,
            value: _locationValue,
          ),
          _CandidateInformationEntry(
            label: l10n.heightLabel,
            value: candidate.height == null
                ? null
                : '${candidate.height} ${l10n.heightUnit}',
          ),
          _CandidateInformationEntry(
            label: l10n.weightLabel,
            value: _weightValue(l10n),
          ),
          _CandidateInformationEntry(
            label: l10n.candidateDetailMaritalStatus,
            value: candidate.martialStatusName,
          ),
          _CandidateInformationEntry(
            label: l10n.candidateDetailChildren,
            value: _childrenValue(l10n),
          ),
        ],
      ),
      _CandidateInformationSectionData(
        title: l10n.candidateDetailEducationAndWork,
        entries: [
          _CandidateInformationEntry(
            label: l10n.candidateDetailEducation,
            value: candidate.educationLevelName,
          ),
        ],
      ),
      _CandidateInformationSectionData(
        title: l10n.candidateDetailAdditionalInformation,
        entries: [
          _CandidateInformationEntry(
            label: l10n.candidateDetailHealthStatus,
            value: candidate.healthStatusName,
          ),
        ],
      ),
    ].where((section) => section.visibleEntries.isNotEmpty).toList();

    return Column(
      children: [
        for (var index = 0; index < sections.length; index++) ...[
          _CandidateInformationSection(section: sections[index]),
          if (index < sections.length - 1) 20.g,
        ],
      ],
    );
  }

  String? _birthYearValue(AppLocalizations l10n) {
    final birthYear = candidate.birthYear;
    if (birthYear == null) return null;
    final age = candidate.age;
    return age == null
        ? birthYear.toString()
        : l10n.candidateDetailBirthYearWithAge(birthYear, age);
  }

  String? get _locationValue {
    final values = [
      candidate.regionName,
      candidate.districtName,
    ].whereType<String>().where((value) => value.trim().isNotEmpty).toList();
    return values.isEmpty ? null : values.join(', ');
  }

  String? _weightValue(AppLocalizations l10n) {
    final weight = candidate.weight;
    if (weight == null) return null;
    final formatted = weight == weight.roundToDouble()
        ? weight.toInt().toString()
        : weight.toString();
    return '$formatted ${l10n.weightUnit}';
  }

  String? _childrenValue(AppLocalizations l10n) {
    if (candidate.hasChildren == false) return l10n.candidateDetailNoChildren;
    final count = candidate.childrenCount;
    if (count != null) return l10n.candidateDetailChildrenCount(count);
    return candidate.hasChildren == true
        ? l10n.candidateDetailHasChildren
        : null;
  }
}

final class _CandidateInformationSection extends StatelessWidget {
  const _CandidateInformationSection({required this.section});

  final _CandidateInformationSectionData section;

  @override
  Widget build(BuildContext context) {
    final entries = section.visibleEntries;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            section.title,
            style: AppTypography.candidateDetailSectionTitle,
          ),
        ),
        8.g,
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.subtleSurface,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              for (var index = 0; index < entries.length; index++) ...[
                _CandidateInformationRow(entry: entries[index]),
                if (index < entries.length - 1)
                  const Divider(height: 1, color: AppColors.border),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

final class _CandidateInformationRow extends StatelessWidget {
  const _CandidateInformationRow({required this.entry});

  final _CandidateInformationEntry entry;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            entry.label,
            style: AppTypography.candidateDetailInfoLabel,
          ),
        ),
        12.g,
        Flexible(
          child: Text(
            entry.value!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: AppTypography.candidateDetailInfoValue,
          ),
        ),
      ],
    ),
  );
}

final class _CandidateInformationSectionData {
  const _CandidateInformationSectionData({
    required this.title,
    required this.entries,
  });

  final String title;
  final List<_CandidateInformationEntry> entries;

  List<_CandidateInformationEntry> get visibleEntries =>
      entries.where((entry) => entry.value?.trim().isNotEmpty == true).toList();
}

final class _CandidateInformationEntry {
  const _CandidateInformationEntry({required this.label, required this.value});

  final String label;
  final String? value;
}
