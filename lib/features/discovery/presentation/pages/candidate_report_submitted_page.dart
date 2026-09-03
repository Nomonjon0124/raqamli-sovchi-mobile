import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../l10n/app_localizations.dart';

final class CandidateReportSubmittedPage extends StatelessWidget {
  const CandidateReportSubmittedPage({
    required this.candidateName,
    this.reportNumber = 'SH-24815',
    this.submittedAt,
    this.onClose,
    super.key,
  });

  final String candidateName;
  final String reportNumber;
  final DateTime? submittedAt;
  final VoidCallback? onClose;

  String _formatDateTime(DateTime date) {
    final local = date.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final year = local.year.toString();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$day.$month.$year $hour:$minute';
  }

  void _close(BuildContext context) {
    if (onClose != null) {
      onClose!();
      return;
    }
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop(true);
    } else {
      context.go(RouteNames.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final formattedDate = _formatDateTime(submittedAt ?? DateTime.now());

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(22, 12, 22, 12),
        child: FilledButton(
          onPressed: () => _close(context),
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.candidateBlockedClose,
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 15,
                  height: 20 / 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Assets.icons.icArrowRight.svg(
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () => _close(context),
                icon: Assets.icons.icArrowLeft01Round.svg(
                  width: 20,
                  height: 20,
                ),
                tooltip: l10n.backLabel,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 8, 22, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Assets.icons.icReportDialogue.svg(width: 68, height: 68),
                    const SizedBox(height: 16),
                    Text(
                      l10n.candidateReportSubmittedTitle,
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 24,
                        height: 30 / 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.candidateReportSubmittedSubtitle,
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 14,
                        height: 20 / 14,
                        color: AppColors.mutedText,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Details table
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                      ),
                      child: Column(
                        children: [
                          _RowItem(
                            label: l10n.candidateReportNumberLabel,
                            value: '#$reportNumber',
                          ),
                          const SizedBox(height: 12),
                          _RowItem(
                            label: l10n.candidateReportSubmittedTimeLabel,
                            value: formattedDate,
                          ),
                          const SizedBox(height: 12),
                          _RowItem(
                            label: l10n.candidateReportStatusLabel,
                            value: l10n.candidateReportStatusUnderReview,
                            valueColor: AppColors.warningText,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Status milestones
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _StepItem(
                            text: l10n.candidateReportStepHistoryPreserved,
                            isActive: true,
                          ),
                          const SizedBox(height: 14),
                          _StepItem(
                            text: l10n.candidateReportStepModeratorReview,
                            isActive: false,
                          ),
                          const SizedBox(height: 14),
                          _StepItem(
                            text: l10n.candidateReportStepDecision,
                            isActive: false,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Notice card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                      ),
                      child: Text(
                        l10n.candidateReportNotice,
                        style: const TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 12,
                          height: 18 / 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _RowItem extends StatelessWidget {
  const _RowItem({required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 13,
            color: AppColors.mutedText,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppColors.text,
          ),
        ),
      ],
    );
  }
}

final class _StepItem extends StatelessWidget {
  const _StepItem({required this.text, required this.isActive});

  final String text;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF00966D) : const Color(0xFFD1D5DB),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 13,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              height: 18 / 13,
              color: isActive ? AppColors.text : AppColors.mutedText,
            ),
          ),
        ),
      ],
    );
  }
}
