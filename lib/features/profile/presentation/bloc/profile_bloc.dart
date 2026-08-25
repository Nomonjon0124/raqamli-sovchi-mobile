import 'package:flutter_bloc/flutter_bloc.dart';

import '../../application/use_cases/get_my_profile.dart';
import 'profile_event.dart';
import 'profile_state.dart';

final class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({required GetMyProfileUseCase getMyProfile})
    : _getMyProfile = getMyProfile,
      super(const ProfileState()) {
    on<ProfileLoadRequested>(_onLoadRequested);
    on<ProfileRefreshRequested>(_onRefreshRequested);
  }

  final GetMyProfileUseCase _getMyProfile;

  Future<void> _onLoadRequested(
    ProfileLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ProfileStatus.loading,
        isRefreshing: false,
        clearFailure: true,
      ),
    );
    await _load(emit);
  }

  Future<void> _onRefreshRequested(
    ProfileRefreshRequested event,
    Emitter<ProfileState> emit,
  ) async {
    if (state.isRefreshing) return;
    emit(state.copyWith(isRefreshing: true, clearFailure: true));
    await _load(emit);
  }

  Future<void> _load(Emitter<ProfileState> emit) async {
    final result = await _getMyProfile();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: state.profile == null
              ? ProfileStatus.failure
              : ProfileStatus.success,
          failure: failure,
          isRefreshing: false,
        ),
      ),
      (profile) =>
          emit(ProfileState(status: ProfileStatus.success, profile: profile)),
    );
  }
}
