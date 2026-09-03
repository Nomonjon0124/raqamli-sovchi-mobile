import 'package:equatable/equatable.dart';

import 'match_request.dart';

final class PhotoRequest extends Equatable {
  const PhotoRequest({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.note,
    this.fromProfileId,
    this.toProfileId,
    this.fromProfileName,
    this.toProfileName,
  });

  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final MatchRequestStatus? status;
  final String? note;
  final String? fromProfileId;
  final String? toProfileId;
  final String? fromProfileName;
  final String? toProfileName;

  @override
  List<Object?> get props => [
    id,
    createdAt,
    updatedAt,
    status,
    note,
    fromProfileId,
    toProfileId,
    fromProfileName,
    toProfileName,
  ];
}
