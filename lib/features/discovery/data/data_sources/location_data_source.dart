import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' as permissions;

import '../../domain/entities/geo_coordinates.dart';
import '../../domain/entities/location_access_status.dart';

abstract interface class LocationDataSource {
  Future<LocationAccessStatus> checkAccess();

  Future<GeoCoordinates> requestCurrentLocation();

  Future<bool> openSettings(LocationAccessStatus status);
}

final class DeviceLocationDataSource implements LocationDataSource {
  @override
  Future<LocationAccessStatus> checkAccess() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return LocationAccessStatus.serviceDisabled;
      }
      return _mapPermission(await permissions.Permission.location.status);
    } on MissingPluginException {
      return LocationAccessStatus.unknown;
    } on PlatformException {
      return LocationAccessStatus.unknown;
    }
  }

  @override
  Future<GeoCoordinates> requestCurrentLocation() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        throw const DeviceLocationServiceDisabledException();
      }

      final currentPermission = await permissions.Permission.location.status;
      final permission =
          currentPermission.isGranted || currentPermission.isLimited
          ? currentPermission
          : await permissions.Permission.location.request();

      if (permission.isPermanentlyDenied || permission.isRestricted) {
        throw const DeviceLocationPermanentlyDeniedException();
      }
      if (!permission.isGranted && !permission.isLimited) {
        throw const DeviceLocationDeniedException();
      }
      if (!currentPermission.isGranted && !currentPermission.isLimited) {
        await Future<void>.delayed(const Duration(milliseconds: 250));
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      );
      return GeoCoordinates(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } on DeviceLocationException {
      rethrow;
    } on LocationServiceDisabledException {
      throw const DeviceLocationServiceDisabledException();
    } on PermissionDeniedException {
      throw const DeviceLocationDeniedException();
    } on MissingPluginException {
      throw const DeviceLocationUnavailableException();
    } on PlatformException {
      throw const DeviceLocationUnavailableException();
    }
  }

  @override
  Future<bool> openSettings(LocationAccessStatus status) {
    if (status == LocationAccessStatus.serviceDisabled) {
      return Geolocator.openLocationSettings();
    }
    return permissions.openAppSettings();
  }

  LocationAccessStatus _mapPermission(permissions.PermissionStatus permission) {
    if (permission.isGranted || permission.isLimited) {
      return LocationAccessStatus.granted;
    }
    if (permission.isPermanentlyDenied || permission.isRestricted) {
      return LocationAccessStatus.permanentlyDenied;
    }
    return LocationAccessStatus.denied;
  }
}

sealed class DeviceLocationException implements Exception {
  const DeviceLocationException();
}

final class DeviceLocationDeniedException extends DeviceLocationException {
  const DeviceLocationDeniedException();
}

final class DeviceLocationPermanentlyDeniedException
    extends DeviceLocationException {
  const DeviceLocationPermanentlyDeniedException();
}

final class DeviceLocationServiceDisabledException
    extends DeviceLocationException {
  const DeviceLocationServiceDisabledException();
}

final class DeviceLocationUnavailableException extends DeviceLocationException {
  const DeviceLocationUnavailableException();
}
