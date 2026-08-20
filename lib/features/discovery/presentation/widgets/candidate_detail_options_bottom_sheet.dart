import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../l10n/app_localizations.dart';

final class CandidateDetailOptionsBottomSheet extends StatelessWidget {
  const CandidateDetailOptionsBottomSheet({
    required this.candidateName,
    required this.onSave,
    required this.onShare,
    required this.onRequestPhotoPermission,
    required this.onReport,
    required this.onBlock,
    required this.onCancel,
    super.key,
  });

  final String candidateName;
  final VoidCallback onSave;
  final VoidCallback onShare;
  final VoidCallback onRequestPhotoPermission;
  final VoidCallback onReport;
  final VoidCallback onBlock;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      top: false,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      candidateName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 15,
                        height: 20 / 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      l10n.candidateDetailOptionsSubtitle,
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 11,
                        height: 17 / 11,
                        color: AppColors.mutedText,
                      ),
                    ),
                  ],
                ),
              ),
              _OptionsGroup(
                rows: [
                  _OptionRowData(
                    icon: Assets.icons.icSaved,
                    title: l10n.candidateDetailSaveToSaved,
                    subtitle: l10n.candidateDetailSaveSubtitle,
                    onTap: onSave,
                  ),
                  _OptionRowData(
                    icon: Assets.icons.icShare,
                    title: l10n.candidateDetailShare,
                    subtitle: l10n.candidateDetailShareSubtitle,
                    onTap: onShare,
                  ),
                  _OptionRowData(
                    icon: Assets.icons.icInfo,
                    title: l10n.candidateDetailRequestPhotoPermission,
                    subtitle: l10n.candidateDetailPhotoPermissionSubtitle,
                    onTap: onRequestPhotoPermission,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _OptionsGroup(
                danger: true,
                rows: [
                  _OptionRowData(
                    icon: Assets.icons.icSecurity,
                    title: l10n.candidateDetailReport,
                    subtitle: l10n.candidateDetailReportSubtitle,
                    onTap: onReport,
                  ),
                  _OptionRowData(
                    icon: Assets.icons.icSecurity,
                    title: l10n.candidateDetailBlock,
                    subtitle: l10n.candidateDetailBlockSubtitle,
                    onTap: onBlock,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Material(
                color: AppColors.mutedSurface,
                borderRadius: BorderRadius.circular(AppRadius.xl),
                child: InkWell(
                  onTap: onCancel,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      l10n.deleteAccountCancel,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 14,
                        height: 19 / 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _OptionsGroup extends StatelessWidget {
  const _OptionsGroup({required this.rows, this.danger = false});

  final List<_OptionRowData> rows;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.subtleSurface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var index = 0; index < rows.length; index++) ...[
              _OptionRow(data: rows[index], danger: danger),
              if (index != rows.length - 1)
                const Divider(height: 1, color: AppColors.border),
            ],
          ],
        ),
      ),
    );
  }
}

final class _OptionRow extends StatelessWidget {
  const _OptionRow({required this.data, required this.danger});

  final _OptionRowData data;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: data.onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.mutedSurface,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: data.icon.svg(width: 18, height: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 14,
                        height: 19 / 14,
                        fontWeight: FontWeight.w500,
                        color: danger ? AppColors.dangerText : AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      data.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 11,
                        height: 17 / 11,
                        color: AppColors.mutedText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _OptionRowData {
  const _OptionRowData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final SvgGenImage icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
}
