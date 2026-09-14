import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:raqamli_sovchi/app/theme/app_status_colors.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../discovery/domain/entities/candidate.dart';
import '../../domain/entities/chat_request_profile.dart';

final class ChatRequestProfileView extends StatelessWidget {
  const ChatRequestProfileView({
    required this.request,
    required this.candidate,
    required this.onAccept,
    required this.onReject,
    required this.onBack,
    required this.isActionLoading,
    super.key,
  });

  final ChatRequestProfile request;
  final Candidate? candidate;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback onBack;
  final bool isActionLoading;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final name = _name(l10n);
    final locationProfession = _locationProfession(context);
    final score = _overallScore;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.section,
            AppSpacing.input,
            AppSpacing.section,
            AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(title: l10n.chatRequestProfileTitle, onBack: onBack),
              const SizedBox(height: AppSpacing.section),
              _Hero(
                name: name,
                locationProfession: locationProfession,
                score: score,
                imageUrl: _imageUrl,
                isPhotoHidden: candidate?.blurPhotos == true,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                l10n.chatRequestCompatibilityLabel,
                style: AppTypography.chatRequestSectionLabel,
              ),
              const SizedBox(height: AppSpacing.sm),
              _Breakdown(
                candidate: candidate,
                unavailableLabel: l10n.chatRequestCompatibilityUnavailable,
              ),
              const SizedBox(height: AppSpacing.lg),
              _RepresentativeCard(
                label: l10n.chatRequestViaRepresentative,
                note: l10n.chatRequestRepresentativeNote,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(
          AppSpacing.section,
          AppSpacing.sm,
          AppSpacing.section,
          AppSpacing.sm,
        ),
        child: Row(
          children: [
            Expanded(
              child: _ActionButton(
                label: l10n.chatRequestAccept,
                icon: Assets.icons.icVerifyCheck,
                backgroundColor: context.statusColors.successContainer,
                foregroundColor: context.statusColors.onSuccessContainer,
                onPressed: isActionLoading ? null : onAccept,
              ),
            ),
            const SizedBox(width: AppSpacing.inline),
            Expanded(
              child: _ActionButton(
                label: l10n.chatRequestReject,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest,
                foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
                onPressed: isActionLoading ? null : onReject,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _name(AppLocalizations l10n) {
    final candidateName = candidate == null
        ? ''
        : [candidate!.firstName, candidate!.lastName ?? '']
              .map((value) => value.trim())
              .where((value) => value.isNotEmpty)
              .join(' ');
    final requestName = request.fromProfileName?.trim() ?? '';
    return candidateName.isNotEmpty
        ? candidateName
        : requestName.isNotEmpty
        ? requestName
        : l10n.chatRequestCandidateFallback;
  }

  String _locationProfession(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final location = candidate == null
        ? ''
        : [candidate!.regionName, candidate!.districtName]
              .whereType<String>()
              .map((value) => value.trim())
              .where((value) => value.isNotEmpty)
              .join(', ');
    final profession = candidate?.professionName?.trim() ?? '';
    if (location.isEmpty && profession.isEmpty) {
      return l10n.chatRequestProfileUnavailable;
    }
    if (location.isEmpty) return profession;
    if (profession.isEmpty) return location;
    return l10n.chatRequestLocationProfession(location, profession);
  }

  int? get _overallScore {
    final value = candidate?.compatibilityScore?.overallScore;
    if (value == null) return null;
    return value.round().clamp(0, 100);
  }

  String? get _imageUrl {
    final candidatePhoto = candidate?.photosInfo
        ?.where((photo) => photo.isMain)
        .map((photo) => photo.image.trim())
        .firstWhere((image) => image.isNotEmpty, orElse: () => '');
    final fallback = candidate?.photosInfo
        ?.map((photo) => photo.image.trim())
        .firstWhere((image) => image.isNotEmpty, orElse: () => '');
    final requestImage = request.fromProfileImageUrl?.trim();
    for (final value in [candidatePhoto, fallback, requestImage]) {
      if (value != null && value.isNotEmpty) return value;
    }
    return null;
  }
}

final class _Header extends StatelessWidget {
  const _Header({required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      _RoundIconButton(onPressed: onBack),
      Expanded(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: AppTypography.chatRequestProfileTitle,
        ),
      ),
      const SizedBox(width: 36),
    ],
  );
}

final class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Material(
    color: Theme.of(context).colorScheme.surfaceContainerHighest,
    shape: const CircleBorder(),
    child: InkWell(
      onTap: onPressed,
      customBorder: const CircleBorder(),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Assets.icons.icArrowLeft01Round.svg(
          width: 20,
          height: 20,
          colorFilter: ColorFilter.mode(
            Theme.of(context).colorScheme.onSurface,
            BlendMode.srcIn,
          ),
        ),
      ),
    ),
  );
}

final class _Hero extends StatelessWidget {
  const _Hero({
    required this.name,
    required this.locationProfession,
    required this.score,
    required this.imageUrl,
    required this.isPhotoHidden,
  });

  final String name;
  final String locationProfession;
  final int? score;
  final String? imageUrl;
  final bool isPhotoHidden;

  @override
  Widget build(BuildContext context) => _Card(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _ProfilePhoto(imageUrl: imageUrl, isPhotoHidden: isPhotoHidden),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.chatRequestProfileName,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    locationProfession,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.chatRequestCardBody,
                  ),
                ],
              ),
            ),
            if (score != null) ...[
              const SizedBox(width: AppSpacing.sm),
              Column(
                children: [
                  Text('$score%', style: AppTypography.chatRequestProfileScore),
                  Text(
                    AppLocalizations.of(
                      context,
                    ).chatRequestCompatibilityShortLabel,
                    style: AppTypography.chatRequestCardBody,
                  ),
                ],
              ),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.compact,
          runSpacing: AppSpacing.compact,
          children: [
            _Badge(
              icon: Assets.icons.icPersons,
              label: AppLocalizations.of(context).chatRequestViaRepresentative,
            ),
            _Badge(
              icon: Assets.icons.icVerifyCheck,
              label: AppLocalizations.of(context).chatRequestPhotoVerified,
              isSuccess: true,
            ),
            _Badge(
              label: AppLocalizations.of(context).chatRequestSeriousIntent,
              isSuccess: true,
            ),
          ],
        ),
      ],
    ),
  );
}

final class _ProfilePhoto extends StatelessWidget {
  const _ProfilePhoto({required this.imageUrl, required this.isPhotoHidden});

  final String? imageUrl;
  final bool isPhotoHidden;

  @override
  Widget build(BuildContext context) {
    final showImage = !isPhotoHidden && imageUrl?.isNotEmpty == true;
    return CircleAvatar(
      radius: 36,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      foregroundImage: showImage ? CachedNetworkImageProvider(imageUrl!) : null,
      child: showImage
          ? null
          : Assets.icons.icSquareLock.svg(
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onSurfaceVariant,
                BlendMode.srcIn,
              ),
            ),
    );
  }
}

final class _Badge extends StatelessWidget {
  const _Badge({required this.label, this.icon, this.isSuccess = false});

  final String label;
  final SvgGenImage? icon;
  final bool isSuccess;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: isSuccess
          ? context.statusColors.successContainer
          : context.statusColors.infoContainer,
      borderRadius: BorderRadius.circular(AppRadius.full),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.compact,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            icon!.svg(
              width: 12,
              height: 12,
              colorFilter: ColorFilter.mode(
                isSuccess
                    ? context.statusColors.onSuccessContainer
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
          ],
          Text(
            label,
            style: AppTypography.chatRequestBadge.copyWith(
              color: isSuccess
                  ? context.statusColors.onSuccessContainer
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    ),
  );
}

final class _Breakdown extends StatelessWidget {
  const _Breakdown({required this.candidate, required this.unavailableLabel});

  final Candidate? candidate;
  final String unavailableLabel;

  @override
  Widget build(BuildContext context) {
    final sections = candidate?.compatibilityScore?.sections ?? const [];
    return _Card(
      child: sections.isEmpty
          ? Text(unavailableLabel, style: AppTypography.chatRequestSectionBody)
          : Column(
              children: [
                for (var index = 0; index < sections.length; index++) ...[
                  _BreakdownRow(section: sections[index]),
                  if (index < sections.length - 1)
                    const SizedBox(height: AppSpacing.md),
                ],
              ],
            ),
    );
  }
}

final class _BreakdownRow extends StatelessWidget {
  const _BreakdownRow({required this.section});

  final CompatibilitySection section;

  @override
  Widget build(BuildContext context) {
    final percent = section.score.round().clamp(0, 100);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                section.sectionName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.chatRequestSectionBody,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              '$percent%',
              style: AppTypography.chatRequestBadge.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.full),
          child: SizedBox(
            height: AppSpacing.compact,
            child: LinearProgressIndicator(
              value: percent / 100,
              backgroundColor: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

final class _RepresentativeCard extends StatelessWidget {
  const _RepresentativeCard({required this.label, required this.note});

  final String label;
  final String note;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: context.statusColors.infoContainer,
      borderRadius: BorderRadius.circular(AppRadius.lg),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.input,
        vertical: AppSpacing.inline,
      ),
      child: Row(
        children: [
          Assets.icons.icPersons.svg(
            width: 18,
            height: 18,
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.onSurfaceVariant,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTypography.chatRequestCardTitle),
                const SizedBox(height: AppSpacing.xxs),
                Text(note, style: AppTypography.chatRequestCardBody),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

final class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      border: Border.all(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.input),
      child: child,
    ),
  );
}

final class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final SvgGenImage? icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => Material(
    color: backgroundColor,
    shape: const StadiumBorder(),
    child: InkWell(
      onTap: onPressed,
      customBorder: const StadiumBorder(),
      child: SizedBox(
        height: AppSpacing.chatActionHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              icon!.svg(
                width: 12,
                height: 12,
                colorFilter: ColorFilter.mode(foregroundColor, BlendMode.srcIn),
              ),
              const SizedBox(width: AppSpacing.xs),
            ],
            Text(
              label,
              style: AppTypography.chatRequestAction.copyWith(
                color: foregroundColor,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
