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

final class _CandidateDetailPageState extends State<CandidateDetailPage> {
  bool _isPlayingVoice = false;
  late bool _isSaved;

  @override
  void initState() {
    super.initState();
    _isSaved = widget.candidate?.isSaved ?? false;
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
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Image with Blur and Permission Button
                  _buildHeaderImage(
                    context,
                    imageUrl: imageUrl,
                    shouldBlur: shouldBlur,
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name + Age + Verified Badge
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                nameAge,
                                style: const TextStyle(
                                  fontSize: 20,
                                  height: 1.3,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.text,
                                ),
                              ),
                            ),
                            8.g,
                            _buildVerifiedBadge(),
                          ],
                        ),
                        6.g,

                        // Subtitle (Location, Height, Education)
                        Text(
                          subtitle,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: AppColors.mutedText,
                          ),
                        ),
                        18.g,

                        // Compatibility Card
                        _buildCompatibilityCard(),

                        // Voice Intro Section (Only if available)
                        if (hasVoiceIntro) ...[
                          18.g,
                          const Text(
                            'Ovozli tanishtiruv · 12 sek',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.mutedText,
                            ),
                          ),
                          8.g,
                          _buildVoiceIntroPlayer(),
                        ],

                        // Bio Section (Only if available)
                        if (hasBio) ...[
                          18.g,
                          Text(
                            bioText,
                            style: const TextStyle(
                              fontSize: 14,
                              height: 1.45,
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

            // Sticky Top Overlay Buttons (Back & Bookmark)
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              left: 18,
              right: 18,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCircularButton(
                    icon: Icons.chevron_left,
                    onTap: () => context.pop(),
                  ),
                  _buildCircularButton(
                    icon: _isSaved ? Icons.bookmark : Icons.bookmark_border,
                    iconColor: _isSaved ? AppColors.primary : AppColors.text,
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
              child: _buildBottomActionBar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderImage(
    BuildContext context, {
    required String? imageUrl,
    required bool shouldBlur,
  }) {
    final height = MediaQuery.of(context).size.width * 1.05;

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

    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (shouldBlur)
            ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
              child: Transform.scale(scale: 1.15, child: imageContent),
            )
          else
            imageContent,

          // Permission Pill Button
          if (shouldBlur)
            Positioned(
              left: 18,
              right: 18,
              bottom: 18,
              child: Center(
                child: Material(
                  color: const Color(0xFF111111).withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.lock_outline,
                            size: 15,
                            color: Colors.white,
                          ),
                          8.g,
                          const Text(
                            "Rasmni ko'rish uchun ruxsat so'rash",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCircularButton({
    required IconData icon,
    required VoidCallback onTap,
    Color iconColor = AppColors.text,
  }) {
    return Material(
      color: Colors.white.withValues(alpha: 0.92),
      shape: const CircleBorder(),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Center(
            child: Icon(icon, size: 22, color: iconColor),
          ),
        ),
      ),
    );
  }

  Widget _buildVerifiedBadge() {
    return Container(
      width: 22,
      height: 22,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Icon(
          Icons.check,
          size: 14,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildCompatibilityCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Umumiy moslik',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
              ),
              Text(
                '82%',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          14.g,
          _buildProgressRow(title: 'Din va qadriyatlar', percent: 88),
          12.g,
          _buildProgressRow(title: 'Moliya', percent: 81),
          12.g,
          _buildProgressRow(title: 'Qarindoshlar', percent: 79),
          12.g,
          _buildProgressRow(title: 'Xarakter', percent: 84),
          12.g,
          _buildProgressRow(title: 'Kelajak', percent: 78),
        ],
      ),
    );
  }

  Widget _buildProgressRow({required String title, required int percent}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.text,
              ),
            ),
            Text(
              '$percent%',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.mutedText,
              ),
            ),
          ],
        ),
        6.g,
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percent / 100.0,
            minHeight: 5,
            backgroundColor: const Color(0xFFF1F3F5),
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildVoiceIntroPlayer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() => _isPlayingVoice = !_isPlayingVoice);
            },
            child: Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  _isPlayingVoice ? Icons.pause : Icons.play_arrow,
                  size: 22,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          14.g,
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(26, (index) {
                const heights = [
                  10.0, 16.0, 22.0, 14.0, 26.0, 18.0, 12.0, 24.0,
                  28.0, 16.0, 20.0, 14.0, 22.0, 18.0, 12.0, 26.0,
                  18.0, 14.0, 22.0, 16.0, 24.0, 14.0, 20.0, 12.0,
                  18.0, 10.0,
                ];
                final barHeight = heights[index % heights.length];
                return Container(
                  width: 3,
                  height: barHeight,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }),
            ),
          ),
          10.g,
        ],
      ),
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        18,
        12,
        18,
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
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    8.g,
                    const Icon(
                      Icons.arrow_forward,
                      size: 18,
                      color: Colors.white,
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
                  size: 24,
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
