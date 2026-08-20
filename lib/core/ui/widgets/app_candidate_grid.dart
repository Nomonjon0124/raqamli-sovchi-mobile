import 'package:flutter/material.dart';

import 'app_candidate_card.dart';

final class AppCandidateGrid extends StatelessWidget {
  const AppCandidateGrid({
    required this.candidates,
    required this.privatePhotoLabel,
    this.onCandidateTap,
    super.key,
  });

  final List<AppCandidateCardData> candidates;
  final String privatePhotoLabel;
  final ValueChanged<int>? onCandidateTap;

  @override
  Widget build(BuildContext context) {
    return SliverGrid.builder(
      itemCount: candidates.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 18,
        childAspectRatio: 165 / 274,
      ),
      itemBuilder: (context, index) => AppCandidateCard(
        candidate: candidates[index],
        privatePhotoLabel: privatePhotoLabel,
        onTap: onCandidateTap != null ? () => onCandidateTap!(index) : null,
      ),
    );
  }
}
