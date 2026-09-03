import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../l10n/app_localizations.dart';

final class CandidateBlockedPage extends StatelessWidget {
  const CandidateBlockedPage({
    required this.candidateName,
    this.blockedAt,
    this.onClose,
    super.key,
  });

  final String candidateName;
  final DateTime? blockedAt;
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
      Navigator.of(context).pop();
    } else {
      context.go(RouteNames.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final formattedDate = _formatDateTime(blockedAt ?? DateTime.now());

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
                    Assets.icons.icBlockedFace.svg(width: 80, height: 80),
                    const SizedBox(height: 16),
                    Text(
                      l10n.candidateBlockedTitle,
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
                      l10n.candidateBlockedSubtitle(candidateName),
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 14,
                        height: 20 / 14,
                        color: AppColors.mutedText,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _CandidateInfoCard(
                      whoLabel: l10n.candidateBlockedWhoLabel,
                      whoValue: candidateName,
                      timeLabel: l10n.candidateBlockedTimeLabel,
                      timeValue: formattedDate,
                      statusLabel: l10n.candidateBlockedStatusLabel,
                      statusValue: l10n.candidateBlockedStatusValue,
                    ),
                    const SizedBox(height: 16),
                    _ConsequencesCard(
                      pointChat: l10n.candidateBlockPointChatClosed,
                      pointSaved: l10n.candidateBlockPointRemovedSaved,
                      pointRepresentative:
                          l10n.candidateBlockPointRepresentativeBlocked,
                    ),
                    const SizedBox(height: 16),
                    _NoticeCard(text: l10n.candidateBlockedSettingsHint),
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

final class _CandidateInfoCard extends StatelessWidget {
  const _CandidateInfoCard({
    required this.whoLabel,
    required this.whoValue,
    required this.timeLabel,
    required this.timeValue,
    required this.statusLabel,
    required this.statusValue,
  });

  final String whoLabel;
  final String whoValue;
  final String timeLabel;
  final String timeValue;
  final String statusLabel;
  final String statusValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        children: [
          _RowItem(label: whoLabel, value: whoValue),
          const SizedBox(height: 12),
          _RowItem(label: timeLabel, value: timeValue),
          const SizedBox(height: 12),
          _RowItem(
            label: statusLabel,
            value: statusValue,
            valueColor: AppColors.dangerText,
          ),
        ],
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

final class _ConsequencesCard extends StatelessWidget {
  const _ConsequencesCard({
    required this.pointChat,
    required this.pointSaved,
    required this.pointRepresentative,
  });

  final String pointChat;
  final String pointSaved;
  final String pointRepresentative;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BulletPoint(text: pointChat),
          const SizedBox(height: 12),
          _BulletPoint(text: pointSaved),
          const SizedBox(height: 12),
          _BulletPoint(text: pointRepresentative),
        ],
      ),
    );
  }
}

final class _BulletPoint extends StatelessWidget {
  const _BulletPoint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Color(0xFF00966D),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              height: 18 / 13,
              color: AppColors.text,
            ),
          ),
        ),
      ],
    );
  }
}

final class _NoticeCard extends StatelessWidget {
  const _NoticeCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Manrope',
          fontSize: 12,
          height: 18 / 12,
          color: Color(0xFF6B7280),
        ),
      ),
    );
  }
}
