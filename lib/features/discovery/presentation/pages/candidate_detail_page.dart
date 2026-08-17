import 'dart:math' as math;
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../core/extensions/gap_extension.dart';
import '../../../../gen/assets.gen.dart';
import '../../domain/entities/candidate.dart';

final class CandidateDetailPage extends StatefulWidget {
  const CandidateDetailPage({this.candidate, super.key});

  final Candidate? candidate;

  @override
  State<CandidateDetailPage> createState() => _CandidateDetailPageState();
}

final class _CandidateDetailPageState extends State<CandidateDetailPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _voiceController;
  bool _isPlayingVoice = false;
  late bool _isSaved;

  @override
  void initState() {
    super.initState();
    _isSaved = widget.candidate?.isSaved ?? false;
    _voiceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void dispose() {
    _voiceController.dispose();
    super.dispose();
  }

  void _toggleVoicePlayback() {
    setState(() {
      _isPlayingVoice = !_isPlayingVoice;
      if (_isPlayingVoice) {
        _voiceController.repeat();
      } else {
        _voiceController.stop();
        _voiceController.value = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final candidate = widget.candidate;

    // Name & Age
    final firstName = candidate?.firstName ?? 'Mohira';
    final lastName = candidate?.lastName ?? 'Ravshanova';
    final middleName = candidate?.middleName ?? 'Jaloldin qizi';
    final fullName = '$firstName $lastName $middleName'.trim();
    final age = candidate?.age ?? 23;
    final nameAge = '$fullName, $age';

    // Subtitle details
    final region = candidate?.regionName ?? 'Toshkent';
    final district = candidate?.districtName ?? 'Yunusobod';
    final locationText = '$region, $district';
    final heightText = '165 sm';
    final educationText = candidate?.educationLevelName ?? 'TATU, IT';
    final subtitle = '$locationText · $heightText · $educationText';

    // Voice & Bio visibility conditions
    final hasVoiceIntro = candidate == null ||
        (candidate.voiceIntro != null &&
            candidate.voiceIntro!.trim().isNotEmpty);
    final hasBio = candidate == null ||
        (candidate.bio != null && candidate.bio!.trim().isNotEmpty);
    final bioText = candidate?.bio ?? 'Iymonli, oilaparvar. Hijobda.';

    // Image & Blur
    final shouldBlur = candidate?.blurPhotos ?? true;
    String? imageUrl;
    if (candidate?.photosInfo != null && candidate!.photosInfo!.isNotEmpty) {
      final mainPhoto = candidate.photosInfo!.firstWhere(
        (p) => p.isMain,
        orElse: () => candidate.photosInfo!.first,
      );
      if (mainPhoto.image.isNotEmpty) {
        imageUrl = mainPhoto.image;
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Hero Image with Blur and Permission Button
                _buildHeroImage(
                  context,
                  imageUrl: imageUrl,
                  shouldBlur: shouldBlur,
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 20, 22, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name + Age + Verified Badge Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              nameAge,
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
                          const _VerifiedBadge(),
                        ],
                      ),
                      6.g,

                      // Subtitle
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 13,
                          height: 21 / 13,
                          fontWeight: FontWeight.w400,
                          color: AppColors.mutedText,
                        ),
                      ),
                      18.g,

                      // Animated Match Card
                      const _AnimatedMatchCard(
                        matchPercent: 82,
                        scores: [
                          _MatchCategory(
                            title: 'Din va qadriyatlar',
                            percent: 88,
                          ),
                          _MatchCategory(title: 'Moliya', percent: 81),
                          _MatchCategory(title: 'Qarindoshlar', percent: 79),
                          _MatchCategory(title: 'Xarakter', percent: 84),
                          _MatchCategory(title: 'Kelajak', percent: 78),
                        ],
                      ),

                      // Voice Intro Section (Conditionally rendered)
                      if (hasVoiceIntro) ...[
                        18.g,
                        const Text(
                          'Ovozli tanishtiruv · 12 sek',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 12,
                            height: 16 / 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF525252),
                          ),
                        ),
                        8.g,
                        _buildVoicePlayer(),
                      ],

                      // Bio Section (Conditionally rendered)
                      if (hasBio) ...[
                        18.g,
                        Text(
                          bioText,
                          style: const TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 13,
                            height: 21 / 13,
                            fontWeight: FontWeight.w400,
                            color: AppColors.bodyText,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Top Back & Bookmark Buttons
          Positioned(
            top: MediaQuery.of(context).padding.top + 18,
            left: 18,
            right: 18,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildHeroRoundButton(
                  icon: Assets.icons.icArrowLeft01Round.svg(
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      AppColors.text,
                      BlendMode.srcIn,
                    ),
                  ),
                  onTap: () => context.pop(),
                ),
                _buildHeroRoundButton(
                  icon: _isSaved
                      ? Assets.icons.icPreservedBtv.svg(
                          width: 20,
                          height: 20,
                          colorFilter: const ColorFilter.mode(
                            AppColors.primary,
                            BlendMode.srcIn,
                          ),
                        )
                      : Assets.icons.icPreservedBtv.svg(
                          width: 20,
                          height: 20,
                          colorFilter: const ColorFilter.mode(
                            AppColors.text,
                            BlendMode.srcIn,
                          ),
                        ),
                  onTap: () {
                    setState(() => _isSaved = !_isSaved);
                  },
                ),
              ],
            ),
          ),

          // Bottom Action Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomActionBar(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage(
    BuildContext context, {
    required String? imageUrl,
    required bool shouldBlur,
  }) {
    const heroHeight = 330.0;

    final Widget imageContent = imageUrl != null && imageUrl.isNotEmpty
        ? CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Assets.images.image1.image(
              fit: BoxFit.cover,
            ),
            errorWidget: (context, url, error) => Assets.images.image1.image(
              fit: BoxFit.cover,
            ),
          )
        : Assets.images.image1.image(fit: BoxFit.cover);

    return Container(
      height: heroHeight,
      width: double.infinity,
      color: AppColors.mutedSurface,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (shouldBlur)
            ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 9, sigmaY: 9),
              child: Transform.scale(scale: 1.15, child: imageContent),
            )
          else
            imageContent,

          // Lock CTA Pill
          if (shouldBlur)
            Positioned(
              left: 18,
              right: 18,
              bottom: 18,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.text,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Assets.icons.icGlyph.svg(
                        width: 15,
                        height: 15,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                      8.g,
                      const Text(
                        'Rasmni koʻrish uchun ruxsat soʻrash',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 12,
                          height: 16 / 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeroRoundButton({
    required Widget icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 36,
          height: 36,
          child: Center(child: icon),
        ),
      ),
    );
  }

  Widget _buildVoicePlayer() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _toggleVoicePlayback,
            child: Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  _isPlayingVoice ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          12.g,
          Expanded(
            child: _AnimatedAudioWaveform(
              controller: _voiceController,
              isPlaying: _isPlayingVoice,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        22,
        12,
        22,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 52,
              child: FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Sovchi taklifi yuborish',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 15,
                        height: 20 / 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    8.g,
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
          ),
          10.g,
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border),
            ),
            child: InkWell(
              onTap: () {},
              customBorder: const CircleBorder(),
              child: const Center(
                child: Icon(
                  Icons.more_horiz,
                  size: 20,
                  color: AppColors.text,
                ),
              ),
            ),
          ),
        ],
      ),
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
          colorFilter: const ColorFilter.mode(
            Colors.white,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}

final class _MatchCategory {
  const _MatchCategory({required this.title, required this.percent});

  final String title;
  final int percent;
}

final class _AnimatedMatchCard extends StatelessWidget {
  const _AnimatedMatchCard({
    required this.matchPercent,
    required this.scores,
  });

  final int matchPercent;
  final List<_MatchCategory> scores;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Umumiy moslik',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 13,
                  height: 18 / 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
              Text(
                '$matchPercent%',
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 24,
                  height: 30 / 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          14.g,
          for (var i = 0; i < scores.length; i++) ...[
            _AnimatedMatchBar(category: scores[i]),
            if (i < scores.length - 1) 14.g,
          ],
        ],
      ),
    );
  }
}

final class _AnimatedMatchBar extends StatelessWidget {
  const _AnimatedMatchBar({required this.category});

  final _MatchCategory category;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              category.title,
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 12,
                height: 19 / 12,
                fontWeight: FontWeight.w400,
                color: AppColors.text,
              ),
            ),
            Text(
              '${category.percent}%',
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 12,
                height: 19 / 12,
                fontWeight: FontWeight.w400,
                color: AppColors.mutedText,
              ),
            ),
          ],
        ),
        5.g,
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: category.percent / 100.0),
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) => ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 5,
              color: AppColors.primary,
              backgroundColor: AppColors.mutedSurface,
            ),
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
