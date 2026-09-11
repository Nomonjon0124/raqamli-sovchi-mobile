import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/featured_service_card.dart';
import '../widgets/service_tiles.dart';
import '../widgets/services_hero.dart';
import '../widgets/services_how_it_works_card.dart';

final class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.card,
              AppSpacing.sm,
              AppSpacing.card,
              AppSpacing.xl,
            ),
            sliver: SliverList.list(
              children: [
                ServicesHero(
                  title: l10n.servicesHeroTitle,
                  subtitle: l10n.servicesHeroSubtitle,
                  stats: [
                    ServicesHeroStat(
                      value: l10n.servicesHeroSupportValue,
                      label: l10n.servicesHeroSupportLabel,
                    ),
                    ServicesHeroStat(
                      value: l10n.servicesHeroPsychologistsValue,
                      label: l10n.servicesHeroPsychologistsLabel,
                    ),
                    ServicesHeroStat(
                      value: l10n.servicesHeroPrivacyValue,
                      label: l10n.servicesHeroPrivacyLabel,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                _SectionTitle(l10n.servicesPopularSection),
                const SizedBox(height: AppSpacing.sm),
                FeaturedServiceCard(
                  icon: Assets.icons.icPsychology,
                  title: l10n.servicePsychologistTitle,
                  subtitle: l10n.servicePsychologistSubtitle,
                  rating: l10n.servicePsychologistRating,
                  description: l10n.servicePsychologistDescription,
                  tags: [
                    l10n.servicePsychologistDuration,
                    l10n.servicePsychologistFormat,
                    l10n.servicePsychologistExperts,
                  ],
                  price: l10n.servicePsychologistPrice,
                  actionLabel: l10n.serviceViewAction,
                  onTap: () => _showComingSoon(context),
                ),
                const SizedBox(height: AppSpacing.lg),
                _SectionTitle(l10n.servicesOtherSection),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ServiceGridTile(
                      icon: Assets.icons.icSrvMeeting,
                      iconBackground: AppColors.servicesMeetingSurface,
                      title: l10n.serviceMeetingTitle,
                      subtitle: l10n.serviceMeetingSubtitle,
                      onTap: () => _showComingSoon(context),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    ServiceGridTile(
                      icon: Assets.icons.icSrvVerify,
                      iconBackground: AppColors.servicesVerifySurface,
                      title: l10n.serviceVerificationTitle,
                      subtitle: l10n.serviceVerificationSubtitle,
                      onTap: () => _showComingSoon(context),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                ServiceListTile(
                  icon: Assets.icons.icSrvPremium2,
                  title: l10n.servicePremiumTitle,
                  subtitle: l10n.servicePremiumSubtitle,
                  onTap: () => _showComingSoon(context),
                ),
                const SizedBox(height: AppSpacing.md),
                ServiceListTile(
                  icon: Assets.icons.icSrvPremium2,
                  title: l10n.serviceBoostTitle,
                  subtitle: l10n.serviceBoostSubtitle,
                  onTap: () => _showComingSoon(context),
                ),
                const SizedBox(height: AppSpacing.lg),
                _SectionTitle(l10n.servicesHowSection),
                const SizedBox(height: AppSpacing.sm),
                ServicesHowItWorksCard(
                  steps: [
                    ServicesHowStep(
                      title: l10n.servicesHowStepOneTitle,
                      subtitle: l10n.servicesHowStepOneSubtitle,
                    ),
                    ServicesHowStep(
                      title: l10n.servicesHowStepTwoTitle,
                      subtitle: l10n.servicesHowStepTwoSubtitle,
                    ),
                    ServicesHowStep(
                      title: l10n.servicesHowStepThreeTitle,
                      subtitle: l10n.servicesHowStepThreeSubtitle,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.servicesInfoSurface,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.input),
                    child: Text(
                      l10n.servicesOptionalNote,
                      style: AppTypography.servicesNote,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).servicesActionComingSoon),
        ),
      );
  }
}

final class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: AppTypography.servicesSectionTitle);
  }
}
