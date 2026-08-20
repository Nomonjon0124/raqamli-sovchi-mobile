import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
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
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 22,
                  height: 27 / 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  color: AppColors.text,
                ),
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
          style: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 13,
            height: 21 / 13,
            fontWeight: FontWeight.w400,
            color: AppColors.mutedText,
          ),
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
