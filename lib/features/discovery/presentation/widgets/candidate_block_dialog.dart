import 'package:flutter/material.dart';

import '../../../../app/di/service_locator.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/ui/widgets/app_toast.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../profile/application/use_cases/block_user.dart';

final class CandidateBlockDialog extends StatefulWidget {
  const CandidateBlockDialog({
    required this.candidateId,
    required this.candidateName,
    this.blockUserUseCase,
    super.key,
  });

  final String candidateId;
  final String candidateName;
  final BlockUserUseCase? blockUserUseCase;

  static Future<bool?> show(
    BuildContext context, {
    required String candidateId,
    required String candidateName,
    BlockUserUseCase? blockUserUseCase,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) => CandidateBlockDialog(
        candidateId: candidateId,
        candidateName: candidateName,
        blockUserUseCase: blockUserUseCase,
      ),
    );
  }

  @override
  State<CandidateBlockDialog> createState() => _CandidateBlockDialogState();
}

final class _CandidateBlockDialogState extends State<CandidateBlockDialog> {
  bool _isLoading = false;

  late final BlockUserUseCase _blockUser =
      widget.blockUserUseCase ?? serviceLocator<BlockUserUseCase>();

  Future<void> _handleBlock() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    final result = await _blockUser(blockedUserId: widget.candidateId);
    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() => _isLoading = false);
        final error = failure.message;
        AppToast.show(
          context,
          message: (error != null && error.isNotEmpty)
              ? error
              : AppLocalizations.of(context).genericError,
        );
      },
      (blockedUser) {
        Navigator.of(context).pop(true);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: AppColors.dangerSurface,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Assets.icons.settingsShield.svg(
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    AppColors.danger,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.candidateBlockDialogTitle(widget.candidateName),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                height: 26 / 20,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.candidateBlockDialogSubtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 13,
                fontWeight: FontWeight.w400,
                height: 18 / 13,
                color: AppColors.mutedText,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(AppRadius.xl),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.candidateBlockPointChatClosed,
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 13,
                      height: 18 / 13,
                      color: AppColors.bodyText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.candidateBlockPointRemovedSaved,
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 13,
                      height: 18 / 13,
                      color: AppColors.bodyText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.candidateBlockPointRepresentativeBlocked,
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 13,
                      height: 18 / 13,
                      color: AppColors.bodyText,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: _isLoading ? null : _handleBlock,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                backgroundColor: AppColors.danger,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      l10n.candidateBlockAction,
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: _isLoading
                  ? null
                  : () => Navigator.of(context).pop(false),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                foregroundColor: AppColors.text,
                side: const BorderSide(color: Color(0xFFE5E7EB)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
              child: Text(
                l10n.candidateBlockCancel,
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
