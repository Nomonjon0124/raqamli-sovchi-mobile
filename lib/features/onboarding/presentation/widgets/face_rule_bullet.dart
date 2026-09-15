import 'package:flutter/material.dart';

final class FaceRuleBullet extends StatelessWidget {
  const FaceRuleBullet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}
