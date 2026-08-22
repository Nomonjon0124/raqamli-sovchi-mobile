import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/extensions/gap_extension.dart';
import '../../../../gen/assets.gen.dart';

final class CandidateDetailHeader extends StatelessWidget {
  const CandidateDetailHeader({
    required this.nameAge,
    required this.subtitle,
    this.isVerified = false,
    super.key,
  });

  final String nameAge;
  final String subtitle;
  final bool isVerified;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                nameAge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.candidateDetailName,
              ),
            ),
            8.g,
            if (isVerified) const _VerifiedBadge(),
          ],
        ),
        6.g,
        Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.candidateDetailBody,
        ),
      ],
    );
  }
}

final class _VerifiedBadge extends StatelessWidget {
  const _VerifiedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Assets.icons.icVerifyCheck.svg(
          width: 13,
          height: 13,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
      ),
    );
  }
}
