import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../../../discovery/application/use_cases/get_saved_candidates.dart';
import '../../../discovery/domain/entities/candidate.dart';
import '../../../match/application/use_cases/get_match_requests.dart';
import '../../../match/domain/entities/match_request.dart';
import '../../../profile/application/use_cases/get_my_profile.dart';
import 'saved_event.dart';
import 'saved_state.dart';

final class SavedBloc extends Bloc<SavedEvent, SavedState> {
  SavedBloc({
    required GetSavedCandidatesUseCase getSavedCandidates,
    required GetMyProfileUseCase getMyProfile,
    required GetMatchRequestsUseCase getMatchRequests,
  }) : _getSavedCandidates = getSavedCandidates,
       _getMyProfile = getMyProfile,
       _getMatchRequests = getMatchRequests,
       super(const SavedState()) {
    on<SavedLoadRequested>(_onLoad);
    on<SavedFilterChanged>(_onFilterChanged);
  }

  final GetSavedCandidatesUseCase _getSavedCandidates;
  final GetMyProfileUseCase _getMyProfile;
  final GetMatchRequestsUseCase _getMatchRequests;

  List<Candidate>? _savedCandidatesCache;
  String? _myProfileIdCache;
  final Map<MatchRequestStatus, List<MatchRequest>> _matchRequestsCache = {};
  Future<Either<Failure, List<Candidate>>>? _savedCandidatesRequest;
  Future<Either<Failure, String>>? _myProfileIdRequest;
  final Map<MatchRequestStatus, Future<Either<Failure, List<MatchRequest>>>>
  _matchRequestsInFlight = {};
  int _loadGeneration = 0;

  Future<void> _onLoad(
    SavedLoadRequested event,
    Emitter<SavedState> emit,
  ) async {
    if (event.forceRefresh) _clearCache();

    final filter = state.filter;
    final generation = ++_loadGeneration;
    emit(state.copyWith(status: SavedStatus.loading, errorMessage: ''));
    final result = await _loadCandidates(filter);

    if (generation != _loadGeneration || filter != state.filter) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SavedStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (candidates) => emit(
        state.copyWith(
          status: candidates.isEmpty ? SavedStatus.empty : SavedStatus.success,
          candidates: candidates,
          errorMessage: '',
        ),
      ),
    );
  }

  Future<Either<Failure, List<Candidate>>> _loadCandidates(
    SavedRequestFilter filter,
  ) async {
    final savedResult = await _loadSavedCandidates();
    if (filter == SavedRequestFilter.all) return savedResult;
    if (filter != SavedRequestFilter.invited) {
      return const Right<Failure, List<Candidate>>([]);
    }

    return savedResult.fold(Left.new, (candidates) async {
      final profileIdResult = await _loadMyProfileId();
      return profileIdResult.fold(Left.new, (profileId) async {
        final requestsResult = await _loadMatchRequests(
          fromProfile: profileId,
          status: MatchRequestStatus.pending,
        );
        return requestsResult.fold(
          Left.new,
          (requests) => Right(
            candidates
                .where(
                  (candidate) => requests.any(
                    (request) => request.toProfileId == candidate.id,
                  ),
                )
                .toList(),
          ),
        );
      });
    });
  }

  Future<void> _onFilterChanged(
    SavedFilterChanged event,
    Emitter<SavedState> emit,
  ) async {
    if (event.filter == SavedRequestFilter.waiting) return;
    if (event.filter == state.filter && state.status != SavedStatus.initial) {
      return;
    }
    ++_loadGeneration;
    emit(state.copyWith(filter: event.filter));
    add(const SavedLoadRequested());
  }

  Future<Either<Failure, List<Candidate>>> _loadSavedCandidates() async {
    final cached = _savedCandidatesCache;
    if (cached != null) return Right(cached);

    final inFlight = _savedCandidatesRequest;
    if (inFlight != null) return inFlight;

    final request = _getSavedCandidates();
    _savedCandidatesRequest = request;
    try {
      final result = await request;
      result.fold(
        (_) {},
        (candidates) => _savedCandidatesCache = List.unmodifiable(candidates),
      );
      return result;
    } finally {
      if (identical(_savedCandidatesRequest, request)) {
        _savedCandidatesRequest = null;
      }
    }
  }

  Future<Either<Failure, String>> _loadMyProfileId() async {
    final cached = _myProfileIdCache;
    if (cached != null) return Right(cached);

    final inFlight = _myProfileIdRequest;
    if (inFlight != null) return inFlight;

    final request = _getMyProfile();
    final mappedRequest = request.then(
      (result) => result.fold<Either<Failure, String>>(
        (failure) => Left<Failure, String>(failure),
        (profile) {
          _myProfileIdCache = profile.id;
          return Right<Failure, String>(profile.id);
        },
      ),
    );
    _myProfileIdRequest = mappedRequest;
    try {
      return await mappedRequest;
    } finally {
      if (identical(_myProfileIdRequest, mappedRequest)) {
        _myProfileIdRequest = null;
      }
    }
  }

  Future<Either<Failure, List<MatchRequest>>> _loadMatchRequests({
    required String fromProfile,
    required MatchRequestStatus status,
  }) async {
    final cached = _matchRequestsCache[status];
    if (cached != null) return Right(cached);

    final inFlight = _matchRequestsInFlight[status];
    if (inFlight != null) return inFlight;

    final request = _getMatchRequests(fromProfile: fromProfile, status: status);
    _matchRequestsInFlight[status] = request;
    try {
      final result = await request;
      result.fold(
        (_) {},
        (requests) => _matchRequestsCache[status] = List.unmodifiable(requests),
      );
      return result;
    } finally {
      if (identical(_matchRequestsInFlight[status], request)) {
        final _ = _matchRequestsInFlight.remove(status);
      }
    }
  }

  void _clearCache() {
    _savedCandidatesCache = null;
    _myProfileIdCache = null;
    _matchRequestsCache.clear();
    _savedCandidatesRequest = null;
    _myProfileIdRequest = null;
    _matchRequestsInFlight.clear();
  }
}
