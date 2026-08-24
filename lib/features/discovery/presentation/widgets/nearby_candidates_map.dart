import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/geo_coordinates.dart';
import '../../domain/entities/nearby_candidate_cluster.dart';
import 'current_location_marker.dart';
import 'nearby_candidates_sheet.dart';
import 'privacy_zone_marker.dart';

final class NearbyCandidatesMap extends StatefulWidget {
  const NearbyCandidatesMap({
    required this.currentLocation,
    required this.clusters,
    required this.items,
    required this.radiusKm,
    required this.onRadiusPressed,
    required this.onCandidateTap,
    super.key,
  });

  final GeoCoordinates currentLocation;
  final List<NearbyCandidateCluster> clusters;
  final List<NearbyCandidateMapItem> items;
  final double radiusKm;
  final VoidCallback onRadiusPressed;
  final ValueChanged<String> onCandidateTap;

  @override
  State<NearbyCandidatesMap> createState() => _NearbyCandidatesMapState();
}

final class _NearbyCandidatesMapState extends State<NearbyCandidatesMap> {
  final MapController _mapController = MapController();
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  LatLng get _currentPoint =>
      LatLng(widget.currentLocation.latitude, widget.currentLocation.longitude);

  @override
  void didUpdateWidget(covariant NearbyCandidatesMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentLocation != widget.currentLocation) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _mapController.move(_currentPoint, 13.5);
      });
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    _sheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentPoint,
              initialZoom: 13.5,
              minZoom: 8,
              maxZoom: 18,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'app.raqamlisovchi.uz',
                maxNativeZoom: 19,
              ),
              MarkerLayer(markers: _buildMarkers()),
            ],
          ),
          AnimatedBuilder(
            animation: _sheetController,
            builder: (context, child) {
              final sheetSize = _sheetController.isAttached
                  ? _sheetController.size
                  : 0.34;
              return Positioned(
                right: AppSpacing.xs,
                bottom: constraints.maxHeight * sheetSize + AppSpacing.xs,
                child: child!,
              );
            },
            child: _OpenStreetMapAttribution(
              label: l10n.openStreetMapAttribution,
            ),
          ),
          Positioned(
            top: AppSpacing.lg,
            left: AppSpacing.lg,
            child: _MapChip(
              icon: SvgPicture.asset(
                'assets/icons/ic_radar.svg',
                width: 15,
                height: 15,
                colorFilter: const ColorFilter.mode(
                  AppColors.primary,
                  BlendMode.srcIn,
                ),
              ),
              label: l10n.nearbyWithinRadius(widget.radiusKm.round()),
              onPressed: widget.onRadiusPressed,
            ),
          ),
          Positioned(
            top: AppSpacing.lg,
            right: AppSpacing.lg,
            child: _MapCircleButton(
              semanticLabel: l10n.nearbyRecenter,
              onPressed: () => _mapController.move(_currentPoint, 13.5),
            ),
          ),
          NearbyCandidatesSheet(
            controller: _sheetController,
            items: widget.items,
            onCandidateTap: widget.onCandidateTap,
            onShowAll: _showAllCandidates,
          ),
        ],
      ),
    );
  }

  List<Marker> _buildMarkers() {
    return [
      for (final cluster in widget.clusters)
        Marker(
          key: ValueKey(cluster.id),
          point: LatLng(cluster.center.latitude, cluster.center.longitude),
          width: _clusterDiameter(cluster.count) + 36,
          height: _clusterDiameter(cluster.count) + 36,
          child: PrivacyZoneMarker(
            cluster: cluster,
            diameter: _clusterDiameter(cluster.count),
          ),
        ),
      Marker(
        key: const ValueKey('current-location'),
        point: _currentPoint,
        width: 64,
        height: 82,
        alignment: Marker.computePixelAlignment(
          width: 64,
          height: 82,
          left: 32,
          top: 32,
        ),
        child: const CurrentLocationMarker(),
      ),
    ];
  }

  double _clusterDiameter(int count) {
    return 86 + math.min(count * 12, 58).toDouble();
  }

  void _showAllCandidates() {
    _sheetController.animateTo(
      0.76,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }
}

final class _OpenStreetMapAttribution extends StatelessWidget {
  const _OpenStreetMapAttribution({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceLight.withValues(alpha: 0.86),
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        onTap: () => unawaited(
          launchUrl(
            Uri.https('www.openstreetmap.org', '/copyright'),
            mode: LaunchMode.externalApplication,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.compact,
            vertical: AppSpacing.xs,
          ),
          child: Text(
            label,
            style: AppTypography.onboardingFieldLabel.copyWith(
              letterSpacing: 0,
              color: AppColors.mapLabelText,
            ),
          ),
        ),
      ),
    );
  }
}

final class _MapChip extends StatelessWidget {
  const _MapChip({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final Widget icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceLight,
      borderRadius: BorderRadius.circular(AppRadius.full),
      elevation: 3,
      shadowColor: AppColors.chipShadow,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.dense,
            AppSpacing.input,
            AppSpacing.dense,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon,
              const SizedBox(width: AppSpacing.compact),
              Text(
                label,
                style: AppTypography.caption.copyWith(color: AppColors.text),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _MapCircleButton extends StatelessWidget {
  const _MapCircleButton({
    required this.semanticLabel,
    required this.onPressed,
  });

  final String semanticLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceLight,
      shape: const CircleBorder(),
      elevation: 3,
      shadowColor: AppColors.elevatedShadow,
      child: IconButton(
        onPressed: onPressed,
        tooltip: semanticLabel,
        iconSize: 18,
        constraints: const BoxConstraints.tightFor(width: 44, height: 44),
        icon: const _TargetIcon(),
      ),
    );
  }
}

final class _TargetIcon extends StatelessWidget {
  const _TargetIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 18,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0.5,
            top: 0.5,
            child: SvgPicture.asset(
              'assets/icons/ic_map_target_ring.svg',
              width: 17,
              height: 17,
            ),
          ),
          Positioned(
            left: 4.25,
            top: 4.25,
            child: SvgPicture.asset(
              'assets/icons/ic_map_target_center.svg',
              width: 9.5,
              height: 9.5,
            ),
          ),
          Positioned(
            left: 8.5,
            top: 0.5,
            child: SvgPicture.asset(
              'assets/icons/ic_map_target_corner.svg',
              width: 9.5,
              height: 9.5,
            ),
          ),
        ],
      ),
    );
  }
}
