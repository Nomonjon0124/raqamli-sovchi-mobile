import 'package:equatable/equatable.dart';

enum MatchRequestStatus {
  pending,
  forwardedToRepresentative,
  accepted,
  rejected;

  static MatchRequestStatus? fromApiName(String? value) {
    return switch (value) {
      'pending' => MatchRequestStatus.pending,
      'forwarded_to_representative' =>
        MatchRequestStatus.forwardedToRepresentative,
      'accepted' => MatchRequestStatus.accepted,
      'rejected' => MatchRequestStatus.rejected,
      _ => null,
    };
  }

  String get apiName => switch (this) {
    MatchRequestStatus.pending => 'pending',
    MatchRequestStatus.forwardedToRepresentative =>
      'forwarded_to_representative',
    MatchRequestStatus.accepted => 'accepted',
    MatchRequestStatus.rejected => 'rejected',
  };
}

enum MatchRequestVisibilityScope {
  onlyThisUser,
  forwardToRepresentative;

  String get apiName => switch (this) {
    MatchRequestVisibilityScope.onlyThisUser => 'only_this_user',
    MatchRequestVisibilityScope.forwardToRepresentative =>
      'forward_to_representative',
  };
}

final class MatchRequest extends Equatable {
  const MatchRequest({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.visibilityScope,
    required this.note,
    required this.fromProfileId,
    required this.toProfileId,
    this.fromProfileName,
    this.toProfileName,
    this.fromProfileImageUrl,
    this.toProfileImageUrl,
  });

  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final MatchRequestStatus? status;
  final MatchRequestVisibilityScope? visibilityScope;
  final String? note;
  final String? fromProfileId;
  final String? toProfileId;
  final String? fromProfileName;
  final String? toProfileName;
  final String? fromProfileImageUrl;
  final String? toProfileImageUrl;

  DateTime get retryAvailableAt => updatedAt.add(const Duration(days: 7));

  bool canRetryAt(DateTime now) => !now.isBefore(retryAvailableAt);

  @override
  List<Object?> get props => [
    id,
    createdAt,
    updatedAt,
    status,
    visibilityScope,
    note,
    fromProfileId,
    toProfileId,
    fromProfileName,
    toProfileName,
    fromProfileImageUrl,
    toProfileImageUrl,
  ];
}
