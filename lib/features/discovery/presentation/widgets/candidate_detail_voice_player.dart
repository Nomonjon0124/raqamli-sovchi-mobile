import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../core/extensions/gap_extension.dart';

final class CandidateDetailVoicePlayer extends StatefulWidget {
  const CandidateDetailVoicePlayer({
    this.durationLabel = '12 sek',
    this.voiceUrl,
    super.key,
  });

  final String durationLabel;
  final String? voiceUrl;

  @override
  State<CandidateDetailVoicePlayer> createState() =>
      _CandidateDetailVoicePlayerState();
}

final class _CandidateDetailVoicePlayerState
    extends State<CandidateDetailVoicePlayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayback() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _controller.repeat();
      } else {
        _controller.stop();
        _controller.value = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ovozli tanishtiruv · ${widget.durationLabel}',
          style: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 12,
            height: 16 / 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF525252),
          ),
        ),
        8.g,
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: _togglePlayback,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      _isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              12.g,
              Expanded(
                child: _AnimatedAudioWaveform(
                  controller: _controller,
                  isPlaying: _isPlaying,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

final class _AnimatedAudioWaveform extends StatelessWidget {
  const _AnimatedAudioWaveform({
    required this.controller,
    required this.isPlaying,
  });

  static const _figmaBars = <double>[
    22.0,
    18.2,
    8.7,
    14.1,
    21.1,
    21.0,
    13.8,
    9.0,
    18.4,
    22.0,
    18.1,
    8.5,
    14.3,
    21.2,
    20.9,
    13.6,
    9.2,
    18.6,
    22.0,
    17.9,
    8.2,
    14.5,
    21.2,
    20.8,
  ];

  final AnimationController controller;
  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(_figmaBars.length, (index) {
              final height = _barHeight(index);
              final progress = isPlaying
                  ? (controller.value * (_figmaBars.length + 4)).floor()
                  : _figmaBars.length;
              final color = isPlaying && index >= progress
                  ? const Color(0xFFA3A3A3)
                  : AppColors.primary;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                width: 3,
                height: height,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }),
          );
        },
      ),
    );
  }

  double _barHeight(int index) {
    if (!isPlaying) return _figmaBars[index].clamp(6.0, 24.0);
    final wave = math.sin((controller.value * math.pi * 2) + index * 0.55);
    final scale = 0.8 + (wave + 1) * 0.2;
    return (_figmaBars[index] * scale).clamp(6.0, 24.0);
  }
}
