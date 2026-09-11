import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../../core/config/app_config.dart';
import '../../core/network/api_client.dart';
import '../../core/notifications/notification_event_bus.dart';
import '../../core/platform/external_url_launcher.dart';
import '../../core/security/auth_session_manager.dart';
import '../../core/security/background_lock_gate.dart';
import '../../core/security/biometric_auth_service.dart';
import '../../core/security/notification_device_store.dart';
import '../../core/security/screenshot_guard.dart';
import '../../core/security/secure_storage.dart';
import '../../core/security/token_store.dart';
import '../../features/auth/application/use_cases/authenticate_biometric.dart';
import '../../features/auth/application/use_cases/check_biometric_availability.dart';
import '../../features/auth/application/use_cases/clear_auth_session.dart';
import '../../features/auth/application/use_cases/clear_pending_auth_session.dart';
import '../../features/auth/application/use_cases/clear_pin.dart';
import '../../features/auth/application/use_cases/commit_pending_auth_session.dart';
import '../../features/auth/application/use_cases/create_pin.dart';
import '../../features/auth/application/use_cases/create_telegram_auth_session.dart';
import '../../features/auth/application/use_cases/delete_account.dart';
import '../../features/auth/application/use_cases/get_telegram_auth_session_status.dart';
import '../../features/auth/application/use_cases/has_pin.dart';
import '../../features/auth/application/use_cases/obtain_token.dart';
import '../../features/auth/application/use_cases/read_profile_onboarding_completion.dart';
import '../../features/auth/application/use_cases/request_phone_otp.dart';
import '../../features/auth/application/use_cases/restore_session.dart';
import '../../features/auth/application/use_cases/sign_in_with_google.dart';
import '../../features/auth/application/use_cases/sign_out.dart';
import '../../features/auth/application/use_cases/verify_phone_otp.dart';
import '../../features/auth/application/use_cases/verify_pin.dart';
import '../../features/auth/data/data_sources/auth_data_source.dart';
import '../../features/auth/data/data_sources/google_auth_data_source.dart';
import '../../features/auth/data/data_sources/google_oauth_provider.dart';
import '../../features/auth/data/data_sources/secure_pin_data_source.dart';
import '../../features/auth/data/data_sources/telegram_auth_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/data/repositories/pin_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/repositories/google_oauth_provider.dart';
import '../../features/auth/domain/repositories/pin_repository.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/chat/application/use_cases/chat_use_cases.dart';
import '../../features/chat/data/data_sources/chat_data_source.dart';
import '../../features/chat/data/repositories/chat_repository_impl.dart';
import '../../features/chat/data/services/chat_web_socket_service.dart';
import '../../features/chat/domain/repositories/chat_repository.dart';
import '../../features/chat/presentation/bloc/chat_conversation_bloc.dart';
import '../../features/chat/presentation/bloc/chat_list_bloc.dart';
import '../../features/discovery/application/use_cases/check_location_access.dart';
import '../../features/discovery/application/use_cases/cluster_nearby_candidates.dart';
import '../../features/discovery/application/use_cases/get_candidate.dart';
import '../../features/discovery/application/use_cases/get_candidates.dart';
import '../../features/discovery/application/use_cases/get_saved_candidates.dart';
import '../../features/discovery/application/use_cases/open_location_settings.dart';
import '../../features/discovery/application/use_cases/request_current_location.dart';
import '../../features/discovery/application/use_cases/save_candidate.dart';
import '../../features/discovery/application/use_cases/unsave_candidate.dart';
import '../../features/discovery/application/use_cases/update_profile_location.dart';
import '../../features/discovery/data/data_sources/discovery_data_source.dart';
import '../../features/discovery/data/data_sources/location_data_source.dart';
import '../../features/discovery/data/repositories/discovery_repository_impl.dart';
import '../../features/discovery/data/repositories/location_repository_impl.dart';
import '../../features/discovery/domain/repositories/discovery_repository.dart';
import '../../features/discovery/domain/repositories/location_repository.dart';
import '../../features/discovery/presentation/bloc/candidate_detail_bloc.dart';
import '../../features/discovery/presentation/bloc/discovery_bloc.dart';
import '../../features/match/application/use_cases/create_match_request.dart';
import '../../features/match/application/use_cases/create_photo_request.dart';
import '../../features/match/application/use_cases/get_match_request_for_candidate.dart';
import '../../features/match/application/use_cases/get_match_requests.dart';
import '../../features/match/data/data_sources/match_request_data_source.dart';
import '../../features/match/data/data_sources/photo_request_data_source.dart';
import '../../features/match/data/repositories/match_request_repository_impl.dart';
import '../../features/match/data/repositories/photo_request_repository_impl.dart';
import '../../features/match/domain/repositories/match_request_repository.dart';
import '../../features/match/domain/repositories/photo_request_repository.dart';
import '../../features/moderation/application/use_cases/create_complaint.dart';
import '../../features/moderation/data/data_sources/complaint_data_source.dart';
import '../../features/moderation/data/repositories/complaint_repository_impl.dart';
import '../../features/moderation/domain/repositories/complaint_repository.dart';
import '../../features/notifications/application/use_cases/notification_use_cases.dart';
import '../../features/notifications/data/data_sources/notification_data_source.dart';
import '../../features/notifications/data/repositories/notification_repository_impl.dart';
import '../../features/notifications/data/services/notification_lifecycle_service.dart';
import '../../features/notifications/domain/repositories/notification_repository.dart';
import '../../features/notifications/presentation/bloc/notification_bloc.dart';
import '../../features/onboarding/application/services/onboarding_location_service.dart';
import '../../features/onboarding/application/services/onboarding_media_service.dart';
import '../../features/onboarding/data/data_sources/onboarding_data_source.dart';
import '../../features/onboarding/data/data_sources/onboarding_draft_data_source.dart';
import '../../features/onboarding/data/repositories/onboarding_draft_repository_impl.dart';
import '../../features/onboarding/data/repositories/onboarding_repository_impl.dart';
import '../../features/onboarding/data/services/onboarding_location_service_impl.dart';
import '../../features/onboarding/data/services/onboarding_media_service_impl.dart';
import '../../features/onboarding/domain/repositories/onboarding_draft_repository.dart';
import '../../features/onboarding/domain/repositories/onboarding_repository.dart';
import '../../features/onboarding/presentation/bloc/profile_onboarding_bloc.dart';
import '../../features/profile/application/services/profile_photo_picker.dart';
import '../../features/profile/application/use_cases/block_user.dart';
import '../../features/profile/application/use_cases/delete_profile_photo.dart';
import '../../features/profile/application/use_cases/get_blocked_users.dart';
import '../../features/profile/application/use_cases/get_my_profile.dart';
import '../../features/profile/application/use_cases/set_main_profile_photo.dart';
import '../../features/profile/application/use_cases/unblock_user.dart';
import '../../features/profile/application/use_cases/update_profile.dart';
import '../../features/profile/application/use_cases/upload_profile_photo.dart';
import '../../features/profile/data/data_sources/blocked_user_data_source.dart';
import '../../features/profile/data/data_sources/profile_data_source.dart';
import '../../features/profile/data/repositories/blocked_user_repository_impl.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/data/services/profile_photo_picker_impl.dart';
import '../../features/profile/domain/repositories/blocked_user_repository.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/presentation/bloc/blocked_users/blocked_users_cubit.dart';
import '../../features/profile/presentation/bloc/edit_profile/edit_profile_bloc.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../features/profile/presentation/bloc/profile_face_verification/profile_face_verification_bloc.dart';
import '../../features/profile/presentation/bloc/profile_photo_management/profile_photo_management_bloc.dart';
import '../../features/questionnaire/application/use_cases/load_questionnaire.dart';
import '../../features/questionnaire/application/use_cases/submit_questionnaire.dart';
import '../../features/questionnaire/data/data_sources/questionnaire_data_source.dart';
import '../../features/questionnaire/data/repositories/questionnaire_repository_impl.dart';
import '../../features/questionnaire/domain/repositories/questionnaire_repository.dart';
import '../../features/questionnaire/presentation/bloc/questionnaire_bloc.dart';
import '../../features/saved/presentation/bloc/saved_bloc.dart';
import '../../features/settings/presentation/cubit/settings_cubit.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> configureDependencies() async {
  if (serviceLocator.isRegistered<AuthBloc>()) return;

  serviceLocator
    ..registerLazySingleton<SecureStorage>(
      () => const FlutterSecureStorageAdapter(FlutterSecureStorage()),
    )
    ..registerLazySingleton<TokenStore>(
      () => SecureTokenStore(serviceLocator()),
    )
    ..registerLazySingleton<NotificationDeviceStore>(
      () => SecureNotificationDeviceStore(serviceLocator()),
    )
    ..registerLazySingleton<NotificationEventBus>(NotificationEventBus.new)
    ..registerLazySingleton<AuthSessionManager>(
      () => DefaultAuthSessionManager(serviceLocator(), serviceLocator()),
    )
    ..registerLazySingleton<BackgroundLockGate>(BackgroundLockGate.new)
    ..registerLazySingleton<ScreenshotGuard>(SecureScreenshotGuard.new)
    ..registerLazySingleton<ExternalUrlLauncher>(UrlLauncherService.new)
    ..registerLazySingleton<BiometricAuthService>(LocalBiometricAuthService.new)
    ..registerLazySingleton<Dio>(
      () => Dio(
        BaseOptions(
          baseUrl: AppConfig.baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 30),
        ),
      ),
    )
    ..registerLazySingleton<ApiClient>(
      () => DioApiClient(
        authSessionManager: serviceLocator(),
        client: serviceLocator(),
      ),
    )
    ..registerLazySingleton<AuthDataSource>(
      () => AppConfig.useTemporaryAuthAdapter
          ? TemporaryAuthDataSource(serviceLocator())
          : RemoteAuthDataSource(
              client: serviceLocator(),
              tokenStore: serviceLocator(),
            ),
    )
    ..registerLazySingleton<TelegramAuthDataSource>(
      () => RemoteTelegramAuthDataSource(
        client: serviceLocator(),
        urlLauncher: serviceLocator(),
      ),
    )
    ..registerLazySingleton<GoogleOAuthProvider>(GoogleSignInOAuthProvider.new)
    ..registerLazySingleton<GoogleAuthDataSource>(
      () => RemoteGoogleAuthDataSource(client: serviceLocator()),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
        telegram: serviceLocator(),
        google: serviceLocator(),
      ),
    )
    ..registerLazySingleton<OnboardingDataSource>(
      () => RemoteOnboardingDataSource(serviceLocator()),
    )
    ..registerLazySingleton<OnboardingRepository>(
      () => OnboardingRepositoryImpl(serviceLocator()),
    )
    ..registerLazySingleton<OnboardingDraftDataSource>(
      () => SecureOnboardingDraftDataSource(serviceLocator()),
    )
    ..registerLazySingleton<OnboardingDraftRepository>(
      () => OnboardingDraftRepositoryImpl(serviceLocator()),
    )
    ..registerLazySingleton<QuestionnaireDataSource>(
      () => RemoteQuestionnaireDataSource(serviceLocator()),
    )
    ..registerLazySingleton<QuestionnaireRepository>(
      () => QuestionnaireRepositoryImpl(serviceLocator()),
    )
    ..registerLazySingleton<DiscoveryDataSource>(
      () => RemoteDiscoveryDataSource(serviceLocator()),
    )
    ..registerLazySingleton<DiscoveryRepository>(
      () => DiscoveryRepositoryImpl(serviceLocator()),
    )
    ..registerLazySingleton<LocationDataSource>(DeviceLocationDataSource.new)
    ..registerLazySingleton<LocationRepository>(
      () => LocationRepositoryImpl(serviceLocator()),
    )
    ..registerLazySingleton<ProfileDataSource>(
      () => RemoteProfileDataSource(serviceLocator()),
    )
    ..registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(serviceLocator()),
    )
    ..registerLazySingleton<BlockedUserDataSource>(
      () => RemoteBlockedUserDataSource(serviceLocator()),
    )
    ..registerLazySingleton<BlockedUserRepository>(
      () => BlockedUserRepositoryImpl(serviceLocator()),
    )
    ..registerLazySingleton<MatchRequestDataSource>(
      () => RemoteMatchRequestDataSource(serviceLocator()),
    )
    ..registerLazySingleton<MatchRequestRepository>(
      () => MatchRequestRepositoryImpl(serviceLocator()),
    )
    ..registerLazySingleton<ChatDataSource>(
      () => RemoteChatDataSource(serviceLocator()),
    )
    ..registerLazySingleton<ChatWebSocketService>(
      () => ChatWebSocketService(serviceLocator()),
    )
    ..registerLazySingleton<ChatRepository>(
      () => ChatRepositoryImpl(serviceLocator(), serviceLocator()),
    )
    ..registerLazySingleton<PhotoRequestDataSource>(
      () => RemotePhotoRequestDataSource(serviceLocator()),
    )
    ..registerLazySingleton<PhotoRequestRepository>(
      () => PhotoRequestRepositoryImpl(serviceLocator()),
    )
    ..registerLazySingleton<ComplaintDataSource>(
      () => RemoteComplaintDataSource(serviceLocator()),
    )
    ..registerLazySingleton<ComplaintRepository>(
      () => ComplaintRepositoryImpl(serviceLocator()),
    )
    ..registerLazySingleton<NotificationDataSource>(
      () => RemoteNotificationDataSource(serviceLocator()),
    )
    ..registerLazySingleton<NotificationRepository>(
      () => NotificationRepositoryImpl(serviceLocator()),
    )
    ..registerFactory<GetCandidatesUseCase>(
      () => GetCandidatesUseCase(serviceLocator()),
    )
    ..registerFactory<CheckLocationAccessUseCase>(
      () => CheckLocationAccessUseCase(serviceLocator()),
    )
    ..registerFactory<RequestCurrentLocationUseCase>(
      () => RequestCurrentLocationUseCase(serviceLocator()),
    )
    ..registerFactory<OpenLocationSettingsUseCase>(
      () => OpenLocationSettingsUseCase(serviceLocator()),
    )
    ..registerFactory<UpdateProfileLocationUseCase>(
      () => UpdateProfileLocationUseCase(serviceLocator()),
    )
    ..registerFactory<ClusterNearbyCandidatesUseCase>(
      ClusterNearbyCandidatesUseCase.new,
    )
    ..registerFactory<GetMyProfileUseCase>(
      () => GetMyProfileUseCase(serviceLocator()),
    )
    ..registerFactory<UpdateProfileUseCase>(
      () => UpdateProfileUseCase(serviceLocator()),
    )
    ..registerFactory<UploadProfilePhotoUseCase>(
      () => UploadProfilePhotoUseCase(serviceLocator()),
    )
    ..registerFactory<SetMainProfilePhotoUseCase>(
      () => SetMainProfilePhotoUseCase(serviceLocator()),
    )
    ..registerFactory<DeleteProfilePhotoUseCase>(
      () => DeleteProfilePhotoUseCase(serviceLocator()),
    )
    ..registerFactory<ProfilePhotoPicker>(
      () => DeviceProfilePhotoPicker(backgroundLockGate: serviceLocator()),
    )
    ..registerFactory<GetCandidateUseCase>(
      () => GetCandidateUseCase(serviceLocator()),
    )
    ..registerFactory<GetSavedCandidatesUseCase>(
      () => GetSavedCandidatesUseCase(serviceLocator()),
    )
    ..registerFactory<SaveCandidateUseCase>(
      () => SaveCandidateUseCase(serviceLocator()),
    )
    ..registerFactory<UnsaveCandidateUseCase>(
      () => UnsaveCandidateUseCase(serviceLocator()),
    )
    ..registerFactory<GetMatchRequestsUseCase>(
      () => GetMatchRequestsUseCase(serviceLocator()),
    )
    ..registerFactory<LoadChatRoomsUseCase>(
      () => LoadChatRoomsUseCase(serviceLocator()),
    )
    ..registerFactory<LoadChatMessagesUseCase>(
      () => LoadChatMessagesUseCase(serviceLocator()),
    )
    ..registerFactory<SendChatMessageUseCase>(
      () => SendChatMessageUseCase(serviceLocator()),
    )
    ..registerFactory<MarkChatRoomReadUseCase>(
      () => MarkChatRoomReadUseCase(serviceLocator()),
    )
    ..registerFactory<LoadChatRoomPresenceUseCase>(
      () => LoadChatRoomPresenceUseCase(serviceLocator()),
    )
    ..registerFactory<LoadChatRoomsPresenceUseCase>(
      () => LoadChatRoomsPresenceUseCase(serviceLocator()),
    )
    ..registerFactory<ConnectChatRoomUseCase>(
      () => ConnectChatRoomUseCase(serviceLocator()),
    )
    ..registerFactory<DisconnectChatRoomUseCase>(
      () => DisconnectChatRoomUseCase(serviceLocator()),
    )
    ..registerFactory<SendChatTypingUseCase>(
      () => SendChatTypingUseCase(serviceLocator()),
    )
    ..registerFactory<GetMatchRequestForCandidateUseCase>(
      () => GetMatchRequestForCandidateUseCase(serviceLocator()),
    )
    ..registerFactory<CreateMatchRequestUseCase>(
      () => CreateMatchRequestUseCase(serviceLocator()),
    )
    ..registerFactory<CreatePhotoRequestUseCase>(
      () => CreatePhotoRequestUseCase(serviceLocator()),
    )
    ..registerFactory<BlockUserUseCase>(
      () => BlockUserUseCase(serviceLocator()),
    )
    ..registerFactory<GetBlockedUsersUseCase>(
      () => GetBlockedUsersUseCase(serviceLocator()),
    )
    ..registerFactory<UnblockUserUseCase>(
      () => UnblockUserUseCase(serviceLocator()),
    )
    ..registerFactory<CreateComplaintUseCase>(
      () => CreateComplaintUseCase(serviceLocator()),
    )
    ..registerFactory<LoadNotificationsUseCase>(
      () => LoadNotificationsUseCase(serviceLocator()),
    )
    ..registerFactory<LoadUnreadNotificationCountUseCase>(
      () => LoadUnreadNotificationCountUseCase(serviceLocator()),
    )
    ..registerFactory<MarkNotificationReadUseCase>(
      () => MarkNotificationReadUseCase(serviceLocator()),
    )
    ..registerFactory<MarkAllNotificationsReadUseCase>(
      () => MarkAllNotificationsReadUseCase(serviceLocator()),
    )
    ..registerFactory<RegisterNotificationDeviceUseCase>(
      () => RegisterNotificationDeviceUseCase(serviceLocator()),
    )
    ..registerFactory<UnregisterNotificationDeviceUseCase>(
      () => UnregisterNotificationDeviceUseCase(serviceLocator()),
    )
    ..registerFactory<CreateNotificationTicketUseCase>(
      () => CreateNotificationTicketUseCase(serviceLocator()),
    )
    ..registerLazySingleton<NotificationLifecycleService>(
      () => NotificationLifecycleService(
        deviceStore: serviceLocator(),
        registerDevice: serviceLocator(),
        unregisterDevice: serviceLocator(),
        createTicket: serviceLocator(),
        eventBus: serviceLocator(),
      ),
    )
    ..registerFactory<NotificationsBloc>(
      () => NotificationsBloc(
        loadNotifications: serviceLocator(),
        loadUnreadCount: serviceLocator(),
        markRead: serviceLocator(),
        markAllRead: serviceLocator(),
        eventBus: serviceLocator(),
      ),
    )
    ..registerFactory<ChatListBloc>(
      () => ChatListBloc(
        loadChatRooms: serviceLocator(),
        loadRoomsPresence: serviceLocator(),
        getMyProfile: serviceLocator(),
        getMatchRequests: serviceLocator(),
        eventBus: serviceLocator(),
      ),
    )
    ..registerFactory<ChatConversationBloc>(
      () => ChatConversationBloc(
        loadMessages: serviceLocator(),
        sendMessage: serviceLocator(),
        markRoomRead: serviceLocator(),
        loadPresence: serviceLocator(),
        connectChatRoom: serviceLocator(),
        disconnectChatRoom: serviceLocator(),
        sendTyping: serviceLocator(),
        repository: serviceLocator(),
        eventBus: serviceLocator(),
      ),
    )
    ..registerFactory<DiscoveryBloc>(
      () => DiscoveryBloc(
        getCandidates: serviceLocator(),
        getMyProfile: serviceLocator(),
        checkLocationAccess: serviceLocator(),
        requestCurrentLocation: serviceLocator(),
        openLocationSettings: serviceLocator(),
        updateProfileLocation: serviceLocator(),
        clusterNearbyCandidates: serviceLocator(),
      ),
    )
    ..registerFactory<CandidateDetailBloc>(
      () => CandidateDetailBloc(
        getCandidate: serviceLocator(),
        getMyProfile: serviceLocator(),
        getMatchRequest: serviceLocator(),
        createMatchRequest: serviceLocator(),
        saveCandidate: serviceLocator(),
        unsaveCandidate: serviceLocator(),
      ),
    )
    ..registerFactory<SavedBloc>(
      () => SavedBloc(
        getSavedCandidates: serviceLocator(),
        getMyProfile: serviceLocator(),
        getMatchRequests: serviceLocator(),
      ),
    )
    ..registerFactory<ProfileBloc>(
      () => ProfileBloc(
        getMyProfile: serviceLocator(),
        uploadPhoto: serviceLocator(),
        setMainPhoto: serviceLocator(),
        deletePhoto: serviceLocator(),
        photoPicker: serviceLocator(),
      ),
    )
    ..registerFactory<EditProfileBloc>(
      () => EditProfileBloc(
        updateProfile: serviceLocator(),
        uploadPhoto: serviceLocator(),
        onboardingRepository: serviceLocator(),
      ),
    )
    ..registerFactory<ProfilePhotoManagementBloc>(
      () => ProfilePhotoManagementBloc(
        getMyProfile: serviceLocator(),
        uploadPhoto: serviceLocator(),
        setMainPhoto: serviceLocator(),
        deletePhoto: serviceLocator(),
        photoPicker: serviceLocator(),
      ),
    )
    ..registerFactory<ProfileFaceVerificationBloc>(
      () => ProfileFaceVerificationBloc(
        onboardingRepository: serviceLocator(),
        mediaService: serviceLocator(),
      ),
    )
    ..registerFactory<BlockedUsersCubit>(
      () => BlockedUsersCubit(
        getBlockedUsers: serviceLocator(),
        unblockUser: serviceLocator(),
      ),
    )
    ..registerFactory<SettingsCubit>(SettingsCubit.new)
    ..registerFactory<OnboardingMediaService>(
      () => DeviceOnboardingMediaService(backgroundLockGate: serviceLocator()),
    )
    ..registerLazySingleton<OnboardingLocationService>(
      DeviceOnboardingLocationService.new,
    )
    ..registerLazySingleton<PinDataSource>(
      () => SecurePinDataSource(serviceLocator()),
    )
    ..registerLazySingleton<PinRepository>(
      () => PinRepositoryImpl(serviceLocator()),
    )
    ..registerFactory<RestoreSessionUseCase>(
      () => RestoreSessionUseCase(serviceLocator()),
    )
    ..registerFactory<RequestPhoneOtpUseCase>(
      () => RequestPhoneOtpUseCase(serviceLocator()),
    )
    ..registerFactory<ObtainTokenUseCase>(
      () => ObtainTokenUseCase(serviceLocator()),
    )
    ..registerFactory<VerifyPhoneOtpUseCase>(
      () => VerifyPhoneOtpUseCase(serviceLocator()),
    )
    ..registerFactory<SignInWithGoogleUseCase>(
      () => SignInWithGoogleUseCase(serviceLocator(), serviceLocator()),
    )
    ..registerFactory<CreateTelegramAuthSessionUseCase>(
      () => CreateTelegramAuthSessionUseCase(serviceLocator()),
    )
    ..registerFactory<GetTelegramAuthSessionStatusUseCase>(
      () => GetTelegramAuthSessionStatusUseCase(serviceLocator()),
    )
    ..registerFactory<CheckBiometricAvailabilityUseCase>(
      () => CheckBiometricAvailabilityUseCase(serviceLocator()),
    )
    ..registerFactory<AuthenticateBiometricUseCase>(
      () => AuthenticateBiometricUseCase(serviceLocator(), serviceLocator()),
    )
    ..registerFactory<HasPinUseCase>(() => HasPinUseCase(serviceLocator()))
    ..registerFactory<CreatePinUseCase>(
      () => CreatePinUseCase(serviceLocator()),
    )
    ..registerFactory<VerifyPinUseCase>(
      () => VerifyPinUseCase(serviceLocator()),
    )
    ..registerFactory<ClearPinUseCase>(() => ClearPinUseCase(serviceLocator()))
    ..registerFactory<CommitPendingAuthSessionUseCase>(
      () => CommitPendingAuthSessionUseCase(serviceLocator()),
    )
    ..registerFactory<ReadProfileOnboardingCompletionUseCase>(
      () => ReadProfileOnboardingCompletionUseCase(serviceLocator()),
    )
    ..registerFactory<ClearAuthSessionUseCase>(
      () => ClearAuthSessionUseCase(serviceLocator()),
    )
    ..registerFactory<ClearPendingAuthSessionUseCase>(
      () => ClearPendingAuthSessionUseCase(serviceLocator()),
    )
    ..registerFactory<SignOutUseCase>(() => SignOutUseCase(serviceLocator()))
    ..registerFactory<DeleteAccountUseCase>(
      () => DeleteAccountUseCase(serviceLocator()),
    )
    ..registerFactory<LoadQuestionnaireUseCase>(
      () => LoadQuestionnaireUseCase(serviceLocator()),
    )
    ..registerFactory<SubmitQuestionnaireUseCase>(
      () => SubmitQuestionnaireUseCase(serviceLocator()),
    )
    ..registerFactory<QuestionnaireBloc>(
      () => QuestionnaireBloc(
        loadQuestionnaire: serviceLocator(),
        submitQuestionnaire: serviceLocator(),
      ),
    )
    ..registerFactory<ProfileOnboardingBloc>(
      () => ProfileOnboardingBloc(
        onboardingRepository: serviceLocator(),
        draftRepository: serviceLocator(),
        mediaService: serviceLocator(),
        locationService: serviceLocator(),
        commitPendingAuthSession: serviceLocator(),
      ),
    )
    ..registerFactory<AuthBloc>(
      () => AuthBloc(
        restoreSession: serviceLocator(),
        requestPhoneOtp: serviceLocator(),
        verifyPhoneOtp: serviceLocator(),
        signInWithGoogle: serviceLocator(),
        createTelegramAuthSession: serviceLocator(),
        getTelegramAuthSessionStatus: serviceLocator(),
        checkBiometricAvailability: serviceLocator(),
        authenticateBiometric: serviceLocator(),
        hasPin: serviceLocator(),
        createPin: serviceLocator(),
        verifyPin: serviceLocator(),
        clearPin: serviceLocator(),
        commitPendingAuthSession: serviceLocator(),
        readProfileOnboardingCompletion: serviceLocator(),
        signOut: serviceLocator(),
        deleteAccount: serviceLocator(),
        clearAuthSession: serviceLocator(),
        clearPendingAuthSession: serviceLocator(),
      ),
    );
}

Future<void> resetDependencies() => serviceLocator.reset();
