import 'package:equatable/equatable.dart';

final class GeoCoordinates extends Equatable {
  const GeoCoordinates({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;

  bool get isValid =>
      latitude >= -90 &&
      latitude <= 90 &&
      longitude >= -180 &&
      longitude <= 180;

  @override
  List<Object?> get props => [latitude, longitude];
}
