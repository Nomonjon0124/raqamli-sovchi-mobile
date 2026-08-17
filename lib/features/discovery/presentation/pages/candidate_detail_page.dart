import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/extensions/gap_extension.dart';
import '../../../../gen/assets.gen.dart';
import '../../domain/entities/candidate.dart';
import '../widgets/candidate_detail_bottom_bar.dart';
import '../widgets/candidate_detail_header.dart';
import '../widgets/candidate_detail_hero_image.dart';
import '../widgets/candidate_detail_match_card.dart';
import '../widgets/candidate_detail_voice_player.dart';

final class CandidateDetailPage extends StatefulWidget {
  const CandidateDetailPage({this.candidate, super.key});

  final Candidate? candidate;

  @override
  State<CandidateDetailPage> createState() => _CandidateDetailPageState();
}

final class _CandidateDetailPageState extends State<CandidateDetailPage> {
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

    // Subtitle
    final region = candidate?.regionName ?? 'Toshkent';
    final district = candidate?.districtName ?? 'Yunusobod';
    final locationText = '$region, $district';
    final heightText = '165 sm';
    final educationText = candidate?.educationLevelName ?? 'TATU, IT';
    final subtitle = '$locationText · $heightText · $educationText';

    // Visibility conditions
    final hasVoiceIntro = candidate == null ||
        (candidate.voiceIntro != null &&
            candidate.voiceIntro!.trim().isNotEmpty);
    final hasBio = candidate == null ||
        (candidate.bio != null && candidate.bio!.trim().isNotEmpty);
    final bioText = candidate?.bio ?? 'Iymonli, oilaparvar. Hijobda.';

    // Main Image & Blur
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
                // Hero Image with Blur & Lock CTA
                CandidateDetailHeroImage(
                  imageUrl: imageUrl,
                  shouldBlur: shouldBlur,
                  onRequestPermission: () {},
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 20, 22, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name, Age, Badge, Subtitle
                      CandidateDetailHeader(
                        nameAge: nameAge,
                        subtitle: subtitle,
                      ),
                      18.g,

                      // Animated Compatibility Match Card
                      const CandidateDetailMatchCard(
                        matchPercent: 82,
                        scores: [
                          MatchCategory(
                            title: 'Din va qadriyatlar',
                            percent: 88,
                          ),
                          MatchCategory(title: 'Moliya', percent: 81),
                          MatchCategory(title: 'Qarindoshlar', percent: 79),
                          MatchCategory(title: 'Xarakter', percent: 84),
                          MatchCategory(title: 'Kelajak', percent: 78),
                        ],
                      ),

                      // Voice Intro Player (Conditionally rendered)
                      if (hasVoiceIntro) ...[
                        18.g,
                        CandidateDetailVoicePlayer(
                          voiceUrl: candidate?.voiceIntro,
                        ),
                      ],

                      // Bio Text (Conditionally rendered)
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

          // Floating Top Back & Bookmark Buttons
          Positioned(
            top: MediaQuery.of(context).padding.top + 18,
            left: 18,
            right: 18,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCircularButton(
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
                _buildCircularButton(
                  icon: Assets.icons.icPreservedBtv.svg(
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      _isSaved ? AppColors.primary : AppColors.text,
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
            child: CandidateDetailBottomBar(
              onSendProposal: () {},
              onMoreOptions: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularButton({
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
}
