import 'package:equatable/equatable.dart';

import '../../../match/domain/entities/photo_request.dart';

final class CandidatePhotoRequestState extends Equatable {
  const CandidatePhotoRequestState({
    this.isSubmitting = false,
    this.request,
    this.errorMessage,
  });

  final bool isSubmitting;
  final PhotoRequest? request;
  final String? errorMessage;

  CandidatePhotoRequestState copyWith({
    bool? isSubmitting,
    PhotoRequest? request,
    String? errorMessage,
    bool clearError = false,
  }) => CandidatePhotoRequestState(
    isSubmitting: isSubmitting ?? this.isSubmitting,
    request: request ?? this.request,
    errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
  );

  @override
  List<Object?> get props => [isSubmitting, request, errorMessage];
}
