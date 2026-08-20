import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../core/extensions/gap_extension.dart';
import '../../../../l10n/app_localizations.dart';

final class CandidateDetailVoicePlayer extends StatefulWidget {
  const CandidateDetailVoicePlayer({this.voiceUrl, super.key});

  final String? voiceUrl;

  @override
  State<CandidateDetailVoicePlayer> createState() =>
      _CandidateDetailVoicePlayerState();
}

final class _CandidateDetailVoicePlayerState
    extends State<CandidateDetailVoicePlayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final AudioPlayer _player;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  StreamSubscription<Duration?>? _durationSubscription;
  bool _isPlaying = false;
  Duration? _duration;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _player = AudioPlayer();
    _playerStateSubscription = _player.playerStateStream.listen((state) {
      if (!mounted) return;
      setState(() => _isPlaying = state.playing);
      if (state.processingState == ProcessingState.completed) {
        _controller.stop();
        _controller.value = 0;
      }
    });
    _durationSubscription = _player.durationStream.listen((duration) {
      if (mounted) setState(() => _duration = duration);
    });
    _loadAudio();
  }

  Future<void> _loadAudio() async {
    final url = widget.voiceUrl;
    if (url == null || url.trim().isEmpty) return;
    try {
      await _player.setUrl(url);
    } catch (_) {
      // The server may return an unavailable optional voice file.
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    final playerStateSubscription = _playerStateSubscription;
    if (playerStateSubscription != null) {
      unawaited(playerStateSubscription.cancel());
    }
    final durationSubscription = _durationSubscription;
    if (durationSubscription != null) {
      unawaited(durationSubscription.cancel());
    }
    unawaited(_player.dispose());
    super.dispose();
  }

  Future<void> _togglePlayback() async {
    if (widget.voiceUrl == null || widget.voiceUrl!.trim().isEmpty) return;
    if (_isPlaying) {
      await _player.pause();
      _controller.stop();
    } else {
      await _player.play();
      _controller.repeat();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final duration = _duration == null
        ? l10n.candidateDetailVoiceDuration
        : '${_duration!.inSeconds ~/ 60}:${(_duration!.inSeconds % 60).toString().padLeft(2, '0')}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.candidateDetailVoiceIntro(duration),
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

  static const _bars = <double>[
    22,
    18.2,
    8.7,
    14.1,
    21.1,
    21,
    13.8,
    9,
    18.4,
    22,
    18.1,
    8.5,
    14.3,
    21.2,
    20.9,
    13.6,
    9.2,
    18.6,
    22,
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
        builder: (context, _) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(_bars.length, (index) {
            final wave = math.sin(controller.value * math.pi * 2 + index * .55);
            final scale = isPlaying ? .8 + (wave + 1) * .2 : 1.0;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              width: 3,
              height: (_bars[index] * scale).clamp(6.0, 24.0),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        ),
      ),
    );
  }
}
