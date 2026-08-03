# Raqamli Sovchi Flutter arxitekturasi bo'yicha texnik topshiriq

Holat: boshlang'ich majburiy standart

Maqsad: ijtimoiy ilovani tez, xavfsiz, test qilinadigan, kengaytiriladigan va UI/UX sifati qat'iy nazorat qilinadigan Flutter mahsulot sifatida qurish.

## 1. Muhokama natijasidagi asosiy qarorlar

Ushbu hujjatdagi qarorlar loyiha katta ijtimoiy appga aylanishini hisobga olib tanlandi. Asosiy yo'nalish: generatorlarga ortiqcha bog'lanmaslik, kod o'qilishini yuqori saqlash, qatlamlarni buzmaslik va chat/media/security talablarini boshidan arxitekturaga joylash.

Qabul qilingan stack:

- Architecture: Clean Architecture + Feature-first modular structure.
- Presentation controller: BLoC/Cubit.
- State management: `flutter_bloc`.
- Dependency injection: `get_it` bilan manual registration.
- Navigation: `go_router`.
- Network: `dio`.
- Error flow: custom `Either<Failure, T>` yoki `Result<T>` pattern.
- Models/entities: oddiy immutable Dart class + `Equatable`.
- Serialization: boshida manual `fromJson/toJson`; API juda kattalashsa `json_serializable` qayta ko'rib chiqiladi.
- Secure storage: `flutter_secure_storage`.
- Environment config: `--dart-define-from-file` yoki `.env` faqat no-secret config uchun.
- Screenshot protection: app-wide native protection yoki `screen_protector`; chat/profile/media ekranlarida majburiy.
- Realtime chat: `web_socket_channel` abstraction ortida.
- Push notification: `firebase_messaging` FCM token lifecycle bilan.
- Audio/video chat media: `record`, `just_audio`, `camera`, `video_player`.
- Image/media optimization: `cached_network_image`, `flutter_image_compress`.
- Testing: `bloc_test`, `mocktail`, widget/golden/integration testlar.

Muhim ogohlantirish:

- Mobile app ichiga qo'yilgan har qanday `baseURL`, Firebase config yoki public key dekompilyatsiya qilinishi mumkin. Ular "secret" emas. Secret tokenlar faqat runtime authdan keladi va secure storage ichida saqlanadi.
- Screenshot bloklash Android/iOS darajasida himoya beradi, lekin tashqi kamera bilan yozib olishni to'xtata olmaydi. Shuning uchun privacy UX, watermark, report/moderation va server-side access control ham kerak.

## 2. Siz bergan fikrlar bo'yicha xulosa

### 2.1 BLoC tanlovi

Qaror: BLoC bu loyiha uchun Riverpoddan ko'ra mosroq bo'lishi mumkin.

Sabab:

- Ijtimoiy appda oqimlar eventga boy bo'ladi: login, profile completion, swipe, match, chat send, reconnect, upload, retry, notification open.
- `event -> bloc -> state` oqimi katta jamoada o'qilishi oson.
- Har bir feature uchun alohida `event`, `state`, `bloc` fayllari kod tartibini kuchaytiradi.
- `bloc_test` bilan state transitionlarni aniq test qilish oson.

Cheklov:

- Oddiy ekranda ortiqcha event/state yozish boilerplate yaratadi.

Standart:

- Murakkab oqimlar uchun `Bloc<Event, State>`.
- Juda oddiy view state uchun `Cubit<State>`.
- Text field focus, tab animation, local toggle kabi mayda UI holatlar uchun lokal `StatefulWidget` yoki `ValueNotifier` ruxsat etiladi.

### 2.2 DI kutubxonasi

Qaror: `get_it` ishlatiladi, lekin `injectable` hozircha majburiy emas.

Sabab:

- Siz generatorlardan imkon qadar qochmoqchisiz.
- `get_it` manual registration bilan aniq, sodda va testda override qilish oson.
- `injectable` katta loyiha uchun foydali, lekin u ham generatorga tayanadi. Hozircha kerak emas.

Qayta ko'rib chiqish sharti:

- Agar registration fayllari juda kattalashib, dependency graphni qo'lda yuritish qimmatlashsa, `injectable` qayta baholanadi.

### 2.3 Controller va widgetlarni ajratish

Qaror: presentation controller sifatida `Bloc/Cubit` ishlatiladi. Widgetlar alohida fayllarga bo'linishi qat'iy qoida bo'ladi.

Qoidalar:

- Page faylida faqat screen layout orchestration bo'ladi.
- 40-60 qatordan oshadigan yoki qayta ishlatiladigan UI qismi alohida widget faylga chiqadi.
- Private `_SomeWidget` classlarni page ichida ko'paytirish taqiqlanadi, faqat juda kichik bir martalik UI uchun ruxsat.
- Feature widgetlar `features/<feature>/presentation/widgets/` ichida.
- Global reusable widgetlar `core/ui/widgets/` ichida.

### 2.4 Custom widgetlar

Qaror: design system darajasida custom widgetlar majburiy, lekin "hamma narsani bitta widgetga tiqish" taqiqlanadi.

To'g'ri yondashuv:

- `AppTextField`, `AppButton`, `AppAvatar`, `AppImage`, `AppEmptyState`, `AppErrorView`, `AppBottomSheet`.
- Variantlar enum yoki named constructor orqali beriladi.
- Har bir widget common holatlarni qo'llaydi: loading, disabled, error, prefix/suffix, helper text.

Noto'g'ri yondashuv:

- 30 ta parametrli bitta universal widget.
- Featurega xos biznes logicni common widgetga joylash.
- Har bir dizayn farqi uchun yangi widget yaratish.

### 2.5 Extensionlar

Qaror: extensionlar kerak, lekin qat'iy tartib bilan.

Qoidalar:

- Extension faqat pure formatting yoki convenience bo'lsa ishlatiladi.
- Extension ichida API, storage, context-heavy navigation, permission yoki biznes logic bo'lmaydi.
- Pul, sana, telefon, karta maskasi, duration, file size, string trimming kabi narsalar uchun mos.
- Extensionlar `core/extensions/` ichida turadi.

### 2.6 Enum classlar

Qaror: Dart enhanced enumlardan faol foydalanamiz.

Qayerda ishlatiladi:

- Message status: `sending`, `sent`, `delivered`, `read`, `failed`.
- Upload status: `idle`, `compressing`, `uploading`, `uploaded`, `failed`.
- Permission status mapping.
- Button variant, text field variant, media type.

Cheklov:

- Murakkab UI state faqat enum bilan yopilmaydi. Masalan `loading/data/error` yetarli bo'lmagan joyda immutable state class ishlatiladi.

### 2.7 Dio va Either/Result

Qaror: `dio` asosiy HTTP client bo'ladi. Har bir repository natijani `Either<Failure, T>` yoki `Result<T>` shaklida qaytaradi.

Sabab:

- Success/failure oqimi typed bo'ladi.
- UI `try/catch` bilan to'lib ketmaydi.
- Error mapping markazlashadi.

Qoidalar:

- `try/catch` faqat data source/repository chegarasida bo'ladi.
- BLoC ichida xom `DioException` ushlanmaydi.
- API error code `Failure` ga map qilinadi.
- Timeout, token refresh, unauthorized redirect va retry policy markaziy boshqariladi.

### 2.8 Freezed o'rniga Equatable

Qaror: boshlang'ich standart `Equatable` + oddiy immutable class.

Sabab:

- Generatorlardan qochish ish jarayonini yengillashtiradi.
- Model/entityni qo'lda yozish kodni aniqroq qiladi.
- `Equatable` value equality uchun yetarli.

Cheklov:

- `copyWith`, `fromJson`, `toJson` qo'lda yoziladi.
- API model ko'payganda manual serialization xatolari oshishi mumkin. Shunda faqat DTO qatlamida `json_serializable` qayta ko'rib chiqiladi.

### 2.9 Screenshot, WebSocket, FCM, environment

Qaror:

- Screenshot app bo'ylab bloklanadi.
- Chat realtime uchun WebSocket abstraction bo'ladi.
- Notification FCM bilan qilinadi.
- Tokenlar secure storagega yoziladi.
- `baseURL` environment configda bo'ladi, lekin secret deb qaralmaydi.

### 2.10 Audio va yumaloq video

Qaror:

- Chat attachment architecture boshidan voice note va circular video uchun tayyorlanadi.
- Audio recording, playback, upload queue, retry va preview state alohida state machine bo'ladi.
- Circular video UI maskasi presentationda, file/video handling esa media service ichida bo'ladi.

## 3. Arxitektura prinsiplari

### 3.1 Clean Architecture

Bog'liqlik yo'nalishi:

```text
presentation -> application -> domain <- data
```

Qoidalar:

- `domain` Flutter, BLoC, Dio, Firebase, WebSocket yoki UI paketlarini bilmaydi.
- `data` tashqi API, local database, storage va platform pluginlarni biladi, lekin UI ni bilmaydi.
- `presentation` faqat ekranga chiqarish, user interaction va view state bilan ishlaydi.
- `application` use case, command, orchestration va transaction chegaralarini boshqaradi.
- API response to'g'ridan-to'g'ri UI ga chiqmaydi.
- Widget ichida API chaqirish, parsing, caching, permission logic yoki biznes qaror bo'lmaydi.

### 3.2 SOLID talablari

- Single Responsibility: har bir class bitta sabab bilan o'zgaradi.
- Open/Closed: yangi backend yoki feature mavjud contractni buzmasligi kerak.
- Liskov Substitution: repository implementationlari bir xil xatti-harakat kafolatini beradi.
- Interface Segregation: katta repositorylar o'rniga maqsadli contractlar ishlatiladi.
- Dependency Inversion: BLoC use case/repository abstractionga bog'lanadi, konkret API clientga emas.

### 3.3 Qo'shimcha majburiy prinsiplar

- DDD-lite: bounded contextlar aniq: `auth`, `profile`, `discovery`, `match`, `chat`, `feed`, `notifications`, `moderation`, `settings`.
- CQRS-lite: murakkab oqimlarda read query va write command ajratiladi.
- Result pattern: exceptionlar qatlamlar orasida xom holatda yurmaydi.
- Immutable state: state mutate qilinmaydi, yangi state emit qilinadi.
- Idempotency: chat send, like, match action, upload retry kabi amallar idempotency key bilan himoyalanadi.
- Offline-first selective: chat draft, profile cache, feed page cache va media cache offline holatni hisobga oladi.
- Privacy by design: shaxsiy ma'lumot, location, photo metadata va moderation signallari minimal saqlanadi.

## 4. Tavsiya etilgan papka tuzilmasi

```text
lib/
  app/
    app.dart
    bootstrap.dart
    router/
      app_router.dart
      route_names.dart
    di/
      service_locator.dart
      service_locator.config.dart
    theme/
      app_theme.dart
      app_colors.dart
      app_typography.dart
      app_spacing.dart
      app_radius.dart
  core/
    config/
      app_config.dart
      build_flavor.dart
    errors/
      failure.dart
      either.dart
      exception_mapper.dart
    extensions/
      date_time_extensions.dart
      string_extensions.dart
      num_extensions.dart
      phone_extensions.dart
      money_extensions.dart
    network/
      api_client.dart
      auth_interceptor.dart
      retry_policy.dart
      network_info.dart
    realtime/
      realtime_connection.dart
      websocket_realtime_connection.dart
      reconnect_policy.dart
    security/
      screenshot_guard.dart
      token_store.dart
      privacy_guard.dart
    storage/
      secure_storage.dart
      cache_store.dart
    media/
      audio_recorder_service.dart
      audio_player_service.dart
      camera_service.dart
      media_upload_service.dart
      media_compression_service.dart
    notifications/
      push_notification_service.dart
      notification_router.dart
    analytics/
      analytics_service.dart
      analytics_event.dart
    permissions/
      permission_service.dart
    ui/
      widgets/
        app_button.dart
        app_text_field.dart
        app_avatar.dart
        app_error_view.dart
        app_empty_state.dart
        app_cached_image.dart
      layout/
      accessibility/
    utils/
      clock.dart
      debouncer.dart
      pagination.dart
      id_generator.dart
  features/
    auth/
      domain/
        entities/
        repositories/
        failures/
      application/
        use_cases/
      data/
        models/
        data_sources/
        repositories/
      presentation/
        bloc/
          auth_bloc.dart
          auth_event.dart
          auth_state.dart
        pages/
        widgets/
    profile/
    discovery/
    match/
    chat/
    feed/
    notifications/
    moderation/
    settings/
  l10n/
  main.dart
```

Test tuzilmasi:

```text
test/
  core/
  features/
    chat/
      domain/
      application/
      data/
      presentation/
integration_test/
goldens/
```

## 5. BLoC/Cubit standarti

### 5.1 Fayl tuzilmasi

Har bir murakkab featureda alohida fayllar bo'ladi:

```text
presentation/
  bloc/
    profile_bloc.dart
    profile_event.dart
    profile_state.dart
  pages/
    profile_page.dart
  widgets/
    profile_header.dart
    profile_photo_grid.dart
    profile_completion_bar.dart
```

### 5.2 Event naming

Eventlar user action yoki lifecycle actionni bildiradi:

```dart
sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

final class ChatStarted extends ChatEvent {
  const ChatStarted(this.conversationId);

  final String conversationId;

  @override
  List<Object?> get props => [conversationId];
}

final class ChatMessageSubmitted extends ChatEvent {
  const ChatMessageSubmitted(this.text);

  final String text;

  @override
  List<Object?> get props => [text];
}
```

### 5.3 State naming

Oddiy holatda bitta immutable state class:

```dart
enum ViewStatus { initial, loading, success, empty, failure }

final class ProfileState extends Equatable {
  const ProfileState({
    this.status = ViewStatus.initial,
    this.profile,
    this.errorMessage,
  });

  final ViewStatus status;
  final UserProfile? profile;
  final String? errorMessage;

  ProfileState copyWith({
    ViewStatus? status,
    UserProfile? profile,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, profile, errorMessage];
}
```

Murakkab holatda sealed state class ishlatiladi:

```dart
sealed class UploadState extends Equatable {
  const UploadState();
}

final class UploadCompressing extends UploadState {
  const UploadCompressing(this.progress);

  final double progress;

  @override
  List<Object?> get props => [progress];
}

final class UploadFailed extends UploadState {
  const UploadFailed(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
```

### 5.4 BLoC qoidalari

- BLoC ichida UI widget import qilinmaydi.
- BLoC faqat use case chaqiradi.
- BLoC ichida `DioException`, `FirebaseException` kabi tashqi exception ushlanmaydi.
- BLoC constructor orqali dependency oladi.
- BLoC state emit qilishdan oldin business resultni aniq map qiladi.
- BLoC event handler ichida uzun parsing yoki file compression qilinmaydi; service/use casega chiqariladi.

## 6. Dependency injection standarti

`get_it` bitta markaziy service locator sifatida ishlatiladi.

```dart
final sl = GetIt.instance;

Future<void> configureDependencies() async {
  sl.registerLazySingleton<ApiClient>(() => DioApiClient(sl()));
  sl.registerLazySingleton<TokenStore>(() => SecureTokenStore(sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl(), sl()));
  sl.registerFactory(() => AuthBloc(signInUseCase: sl(), logoutUseCase: sl()));
}
```

Qoidalar:

- `registerFactory` BLoC/Cubit uchun ishlatiladi.
- `registerLazySingleton` service, repository va data source uchun ishlatiladi.
- `registerSingletonAsync` faqat async init talab qiladigan service uchun ishlatiladi.
- Service locator faqat composition rootda va page-level BLoC yaratishda chaqiriladi.
- Domain/application qatlamlari `GetIt` ni bilmaydi.
- Testlarda dependency override qilinadi, global state testdan keyin reset qilinadi.

## 7. Domain, model va entity standarti

### 7.1 Entity

```dart
final class UserProfile extends Equatable {
  const UserProfile({
    required this.id,
    required this.displayName,
    required this.age,
    required this.photoUrls,
  });

  final String id;
  final String displayName;
  final int age;
  final List<String> photoUrls;

  @override
  List<Object?> get props => [id, displayName, age, photoUrls];
}
```

### 7.2 Data model

DTO/data model API schema bilan ishlaydi:

```dart
final class UserProfileModel extends Equatable {
  const UserProfileModel({
    required this.id,
    required this.name,
    required this.age,
    required this.photos,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as String,
      name: json['name'] as String,
      age: json['age'] as int,
      photos: List<String>.from(json['photos'] as List<dynamic>),
    );
  }

  final String id;
  final String name;
  final int age;
  final List<String> photos;

  UserProfile toEntity() {
    return UserProfile(
      id: id,
      displayName: name,
      age: age,
      photoUrls: photos,
    );
  }

  @override
  List<Object?> get props => [id, name, age, photos];
}
```

Qoidalar:

- Entity va DTO bir class bo'lmaydi, agar backend schema juda oddiy bo'lsa ham.
- `fromJson` ichida validation minimal bo'ladi, biznes validation domain/value objectga chiqadi.
- API field nomlari domain nomlarini ifloslantirmaydi.
- `copyWith` kerak bo'lgan state/modelda qo'lda yoziladi.

## 8. Either/Result va error handling

Minimal custom Either:

```dart
sealed class Either<L, R> {
  const Either();

  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight);
}

final class Left<L, R> extends Either<L, R> {
  const Left(this.value);

  final L value;

  @override
  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight) {
    return onLeft(value);
  }
}

final class Right<L, R> extends Either<L, R> {
  const Right(this.value);

  final R value;

  @override
  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight) {
    return onRight(value);
  }
}
```

Repository contract:

```dart
abstract interface class ProfileRepository {
  Future<Either<Failure, UserProfile>> getMyProfile();
}
```

Dio mapping:

```dart
Failure mapDioException(DioException error) {
  return switch (error.type) {
    DioExceptionType.connectionTimeout => const Failure.networkTimeout(),
    DioExceptionType.receiveTimeout => const Failure.networkTimeout(),
    DioExceptionType.badResponse => Failure.server(
        statusCode: error.response?.statusCode,
        message: 'Server xatosi',
      ),
    _ => const Failure.unknown(),
  };
}
```

Qoidalar:

- UI qatlamiga exception chiqmaydi.
- Failure user message va technical reasonni alohida saqlaydi.
- Retry faqat idempotent requestlarda.
- Unauthorized global auth flowga uzatiladi.

## 9. API connection standarti

`dio` quyidagilar uchun tanlandi:

- Interceptor.
- Timeout.
- Cancel token.
- Upload/download progress.
- Multipart.
- Centralized error handling.

Api client:

```dart
final class DioApiClient implements ApiClient {
  DioApiClient(TokenStore tokenStore)
      : _dio = Dio(
          BaseOptions(
            baseUrl: AppConfig.baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            sendTimeout: const Duration(seconds: 30),
          ),
        ) {
    _dio.interceptors.add(AuthInterceptor(tokenStore));
  }

  final Dio _dio;
}
```

Qoidalar:

- Har bir request typed method orqali yuradi.
- Endpoint stringlari data source ichida markazlashadi.
- Token header interceptor orqali qo'shiladi.
- Token refresh parallel requestlarda bitta refresh operationga birlashtiriladi.
- Request/response log release buildda o'chiriladi.
- PII loglanmaydi.

## 10. Environment va secret siyosati

Qaror:

- `baseURL`, app flavor, feature flag endpoint kabi no-secret configlar environment orqali beriladi.
- Access token, refresh token, FCM token runtime qiymat bo'lib secure storage va backend sync orqali boshqariladi.
- API secret, service account key, admin key, private signing key mobile app ichida bo'lmaydi.

Tavsiya:

- CI/CD uchun `--dart-define-from-file=config/dev.json`.
- Local developer uchun `.env` ishlatilsa, `.gitignore`ga qo'shiladi.
- Envied obfuscation foydali bo'lishi mumkin, lekin code generation talab qiladi va haqiqiy security emas.

Misol:

```json
{
  "BASE_URL": "https://api.raqamlisovchi.uz",
  "WS_URL": "wss://api.raqamlisovchi.uz/realtime",
  "FLAVOR": "prod"
}
```

```dart
abstract final class AppConfig {
  static const baseUrl = String.fromEnvironment('BASE_URL');
  static const wsUrl = String.fromEnvironment('WS_URL');
  static const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
}
```

## 11. Security va privacy

Majburiy qoidalar:

- Screenshot olish app bo'ylab bloklanadi.
- App switcher preview blur/blank qilinadi.
- Token, refresh token, session secret faqat secure storage.
- FCM token secure storageda vaqtincha saqlanishi mumkin, lekin backendda user-device mapping bilan boshqariladi.
- Token rotation va logoutda device token unlink qilinadi.
- PII logga yozilmaydi.
- Debug log release buildga chiqmaydi.
- Deep link validation majburiy.
- File upload MIME, size, extension va duration validationdan o'tadi.
- Media EXIF/location metadata uploaddan oldin tozalanadi.
- Chat media access backend authorization bilan himoyalanadi.

Screenshot guard:

```dart
abstract interface class ScreenshotGuard {
  Future<void> enableProtection();
  Future<void> disableProtectionForDebugOnly();
}
```

Qoidalar:

- Protection `bootstrap` paytida yoqiladi.
- Debug buildda ham default yoqilgan bo'ladi, faqat kerakli testda vaqtincha o'chiriladi.
- Android uchun `FLAG_SECURE`, iOS uchun secure overlay / screen capture protection yechimi ishlatiladi.

## 12. Realtime chat arxitekturasi

Transport abstraction:

```dart
abstract interface class RealtimeConnection {
  Stream<RealtimeEvent> get events;
  Future<void> connect({required String accessToken});
  Future<void> send(RealtimeCommand command);
  Future<void> disconnect();
}
```

Qoidalar:

- WebSocket implementation `data` yoki `core/realtime` ichida qoladi.
- Chat BLoC WebSocket package import qilmaydi.
- Reconnect exponential backoff bilan.
- Heartbeat/ping-pong majburiy.
- Auth token expire bo'lsa reconnect oldidan token refresh qilinadi.
- Message send idempotency key bilan yuradi.
- Local optimistic message server ack bilan reconcile qilinadi.
- Offline queue va failed retry state bo'ladi.

Message status enum:

```dart
enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed;

  bool get canRetry => this == MessageStatus.failed;
  bool get isTerminal => this == MessageStatus.read || this == MessageStatus.failed;
}
```

## 13. Chat media: audio, circular video, attachment

### 13.1 Voice note

Kutubxonalar:

- Recording: `record`.
- Playback: `just_audio`.
- Permission: `permission_handler`.
- Upload: `dio` multipart.

Qoidalar:

- Audio yozishdan oldin microphone permission aniq so'raladi.
- Recording state: `idle`, `recording`, `paused`, `preview`, `uploading`, `failed`.
- Maksimal duration backend contract bilan belgilanadi.
- Audio fayl hajmi uploaddan oldin tekshiriladi.
- Waveform UI kerak bo'lsa keyingi bosqichda alohida package baholanadi.

### 13.2 Circular video

Kutubxonalar:

- Capture: `camera`.
- Playback: `video_player`.
- Compression/thumbnail: backend yoki alohida media pipeline; mobil tomonda faqat zarur minimal compression.

Qoidalar:

- Circular video presentation maskasi bilan yumaloq ko'rsatiladi.
- Fayl aslida oddiy video formatda saqlanadi.
- Maksimal duration, file size va resolution cheklanadi.
- Upload retry va cancel bo'lishi kerak.
- Camera/microphone permission birgalikda boshqariladi.

### 13.3 Attachment state machine

```dart
enum AttachmentStatus {
  picking,
  validating,
  compressing,
  uploading,
  uploaded,
  failed,
  cancelled;
}
```

Qoidalar:

- Attachment upload message senddan alohida yuradi.
- Message faqat uploaded media id bilan serverga yuboriladi yoki pending attachment sifatida belgilanadi.
- Upload progress UI da ko'rinadi.
- Failed attachment qayta yuborilishi mumkin.

## 14. UI/UX va widget standarti

### 14.1 Fayl ajratish qoidasi

- Har bir page alohida fayl.
- Har bir qayta ishlatiladigan widget alohida fayl.
- Bir page faylida screen + 5-6 ta widget class yozish taqiqlanadi.
- Widget nomi feature ma'nosini bildiradi: `ChatComposer`, `VoiceRecordButton`, `ProfilePhotoGrid`.
- Global widget nomi `App` prefix bilan boshlanadi: `AppTextField`, `AppButton`.

### 14.2 Custom widget misoli

```dart
enum AppTextFieldType { text, phone, password, money, card }

final class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.type,
    this.labelText,
    this.errorText,
    this.enabled = true,
  });

  final TextEditingController controller;
  final AppTextFieldType type;
  final String? labelText;
  final String? errorText;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: switch (type) {
        AppTextFieldType.phone => TextInputType.phone,
        AppTextFieldType.money => TextInputType.number,
        AppTextFieldType.card => TextInputType.number,
        AppTextFieldType.password => TextInputType.visiblePassword,
        AppTextFieldType.text => TextInputType.text,
      },
      obscureText: type == AppTextFieldType.password,
      decoration: InputDecoration(
        labelText: labelText,
        errorText: errorText,
      ),
    );
  }
}
```

Qoidalar:

- Custom widgetlar design token ishlatadi.
- Feature-specific variant common widgetga tiqilmaydi.
- Juda ko'p parametr paydo bo'lsa widgetni kichikroq variantlarga ajratish kerak.

## 15. Extension standarti

Misol:

```dart
extension PhoneFormatX on String {
  String get uzPhoneFormatted {
    final digits = replaceAll(RegExp(r'\D'), '');
    if (digits.length != 12 || !digits.startsWith('998')) {
      return this;
    }
    return '+${digits.substring(0, 3)} '
        '${digits.substring(3, 5)} '
        '${digits.substring(5, 8)} '
        '${digits.substring(8, 10)} '
        '${digits.substring(10, 12)}';
  }
}
```

Qoidalar:

- Extension nomlari `X` suffix bilan tugaydi: `DateTimeFormatX`, `MoneyFormatX`.
- Extensionlar biznes qaror qilmaydi.
- Lokalizatsiya kerak bo'lsa `BuildContext` extension emas, formatter service afzal.

## 16. Enum standarti

Enhanced enum misoli:

```dart
enum UserVisibility {
  public('public'),
  matchesOnly('matches_only'),
  hidden('hidden');

  const UserVisibility(this.apiValue);

  final String apiValue;

  static UserVisibility fromApi(String value) {
    return UserVisibility.values.firstWhere(
      (item) => item.apiValue == value,
      orElse: () => UserVisibility.hidden,
    );
  }
}
```

Qoidalar:

- API stringlar enum ichida markazlashadi.
- Enum UI text qaytarmaydi; UI text l10n orqali olinadi.
- Enum biznes statuslar uchun ishlatiladi, katta state tree uchun emas.

## 17. Ijtimoiy app modullari

### 17.1 Auth

- Phone/email/social login strategy pattern bilan.
- Token secure storage.
- Session restore bootstrapda.
- Auth state router redirect bilan.
- Logout local cache va FCM device unlink qiladi.

### 17.2 Profile

- Public profile va private settings alohida model.
- Photo upload queue.
- Profile completeness domain service.
- Sensitive fields visibility policy bilan.

### 17.3 Discovery / Matching

- Swipe, like, skip idempotent.
- Card prefetch.
- Optimistic update va server reconcile.
- Rate limit va abuse signal.

### 17.4 Chat

- WebSocket abstraction.
- Message status lifecycle.
- Cursor-based pagination.
- Draft local storage.
- Voice note va circular video.
- Screenshot protection majburiy.

### 17.5 Feed

- Cursor-based pagination.
- Pull-to-refresh mavjud listni buzmasligi kerak.
- Media cache va placeholder.
- Optimistic like/comment count.

### 17.6 Moderation

- Report, block, hide, mute birinchi release arxitekturasida.
- Block qilingan user chat/discovery/feedda ko'rinmaydi.
- Moderation action audit event.
- User-generated content backend moderation contract orqali.

### 17.7 Notifications

- FCM token lifecycle.
- Token refresh backend sync.
- Foreground/background/cold start handling.
- Notification deep link typed routega map qilinadi.
- Permission onboardingdan ajratiladi.

## 18. Performance talablari

Budjetlar:

- Cold start: release buildda imkon qadar 2.5 sekunddan past.
- Screen transition: 16 ms frame budgetga yaqin.
- Feed/chat scroll: 60 FPS target.
- API timeout: default 10-15 sekund.
- Upload timeout alohida.
- Image memory: original rasm listda render qilinmaydi.

Flutter qoidalari:

- `const` constructor maksimal.
- Listlar uchun `ListView.builder`, `SliverList`, `CustomScrollView`.
- Katta feed/chat itemlarda `RepaintBoundary`.
- Image `cacheWidth/cacheHeight`, thumbnail va cache bilan.
- Scroll listener throttle/debounce.
- Build methodda parsing/sorting/filtering yo'q.
- Audio/video compression UI threadni bloklamaydi.

Rebuild nazorati:

- Page butun statega keraksiz rebuild qilinmaydi.
- `BlocSelector` yoki kichik `BlocBuilder` ishlatiladi.
- Chat list itemlar stable key bilan.

## 19. Design system

App ichida yagona design system bo'ladi:

- Color tokens.
- Typography tokens.
- Spacing scale: 4, 8, 12, 16, 24, 32.
- Radius tokenlar.
- Button/input/avatar/media tile componentlar.
- Dark mode boshidan.

Qoidalar:

- Hardcoded rang va font size feature ichida yozilmaydi.
- UI matnlari l10n orqali.
- Har bir screen loading, empty, error, offline, permission denied holatiga ega.
- Minimum tap target 44x44.
- Dynamic text scaling buzilmaydi.
- Icon-only buttonlarda semantics label majburiy.

## 20. Testing strategiyasi

Unit:

- Use case.
- Repository failure mapping.
- DTO mapper.
- Value object validation.
- BLoC/Cubit state transition.
- Reconnect policy.
- Token store.

Widget:

- Loading/data/empty/error/offline.
- Form validation.
- Chat composer.
- Voice record button states.
- Circular video preview.
- Screenshot guard enabled state smoke test.

Integration:

- Login/session restore.
- Profile completion.
- Swipe -> match -> chat.
- Message send failure retry.
- Voice note send.
- Circular video send.
- Block/report user.
- Push notification deep link.

Test packages:

- `bloc_test`
- `mocktail`
- `flutter_test`
- Golden test uchun `golden_toolkit` keyin baholanadi.

## 21. CI/CD va sifat eshiklari

Har bir PR:

- `flutter analyze`
- `dart format --set-exit-if-changed .`
- Unit/widget testlar.
- BLoC testlar.
- UI o'zgarsa golden testlar.
- Android build smoke test.
- iOS build smoke test, macOS runner mavjud bo'lsa.

Merge bloklanadi:

- Analyzer error bor.
- Testlar yiqilgan.
- Domain qatlami Flutter/BLoC/Dio/Firebasega bog'langan.
- UI text l10n dan tashqarida.
- Secret yoki PII logga tushgan.
- Performance-sensitive list eager render ishlatgan.
- Screenshot guard sensitive ekranlarda yoqilmagan.

## 22. Dependency siyosati

Yangi paket qo'shishdan oldin:

- Paket faol maintenance qilinadimi?
- Pub points/like/download yetarlimi?
- Verified publisher bormi?
- Native permission talab qiladimi?
- Test/mock qilish osonmi?
- Bundle size/startupga ta'siri bormi?
- Generator talab qiladimi?

Boshlang'ich paketlar:

```yaml
dependencies:
  flutter_bloc:
  equatable:
  get_it:
  go_router:
  dio:
  flutter_secure_storage:
  shared_preferences:
  cached_network_image:
  intl:
  connectivity_plus:
  permission_handler:
  firebase_core:
  firebase_messaging:
  web_socket_channel:
  screen_protector:
  record:
  just_audio:
  camera:
  video_player:
  flutter_image_compress:
  path_provider:
  uuid:

dev_dependencies:
  bloc_test:
  mocktail:
  flutter_lints:
```

Keyingi bosqichda qayta ko'rib chiqiladigan paketlar:

- `json_serializable`: API DTO juda ko'payganda.
- `injectable`: DI registration haddan tashqari kattalashganda.
- `drift` yoki `isar`: offline cache murakkablashganda.
- `sentry_flutter` yoki `firebase_crashlytics`: crash/performance monitoring uchun.
- Waveform package: voice note UI uchun alohida baholanadi.

## 23. Boshlang'ich implementation roadmap

1. `analysis_options.yaml` ni kuchaytirish.
2. `pubspec.yaml`ga boshlang'ich paketlarni qo'shish.
3. `lib/app`, `lib/core`, `lib/features` tuzilmasini yaratish.
4. `get_it` service locator yaratish.
5. App bootstrap va screenshot guardni ulash.
6. App config va flavor mexanizmini qo'shish.
7. Dio api client, token store, interceptor yozish.
8. `Either`, `Failure`, `Clock`, `IdGenerator` qo'shish.
9. Router va auth redirect skeletini yaratish.
10. Design tokenlar va global widgets yaratish.
11. Auth feature skeleton + BLoC.
12. Profile feature skeleton + BLoC.
13. Chat realtime skeleton + attachment state machine.
14. Test scaffold va CI buyruqlarini tayyorlash.

## 24. Feature yaratish checklisti

Har bir yangi feature:

- Domain entity/value object yozildi.
- Repository contract yozildi.
- Use case yozildi.
- DTO/model va mapper yozildi.
- Remote/local data source yozildi.
- Repository implementation yozildi.
- DI registration qo'shildi.
- BLoC/Cubit, event, state alohida fayllarda.
- Page va widgetlar alohida fayllarda.
- Loading/empty/error/offline/permission state bor.
- Unit/BLoC/widget testlar bor.
- Analytics event privacy qoidalariga mos.
- Accessibility tekshirildi.
- Performance xavfi bo'lsa profile qilindi.
- Sensitive ekran bo'lsa screenshot guard tekshirildi.

## 25. Definition of Done

Feature tugagan deb hisoblanadi, agar:

- Kod qatlamlarni buzmaydi.
- Analyzer va format toza.
- Testlar o'tgan.
- Error, empty, loading, offline holatlar ishlaydi.
- UI design tokenga mos.
- Dynamic text scaling va kichik ekran tekshirilgan.
- Analytics/crash/security ta'siri baholangan.
- API contract yoki mock contract yangilangan.
- Screenshot/privacy talablar bajarilgan.

## 26. Manbalar

- Flutter rasmiy app architecture guide: https://docs.flutter.dev/app-architecture/guide
- Flutter navigation guide: https://docs.flutter.dev/ui/navigation
- Bloc rasmiy dokumentatsiyasi: https://bloclibrary.dev/
- `flutter_bloc`: https://pub.dev/packages/flutter_bloc
- `bloc_test`: https://pub.dev/packages/bloc_test
- `get_it`: https://pub.dev/packages/get_it
- `dio`: https://pub.dev/packages/dio
- `equatable`: https://pub.dev/packages/equatable
- `go_router`: https://pub.dev/packages/go_router
- `flutter_secure_storage`: https://pub.dev/packages/flutter_secure_storage
- `firebase_messaging`: https://pub.dev/packages/firebase_messaging
- Firebase Cloud Messaging Flutter guide: https://firebase.google.com/docs/cloud-messaging/flutter/get-started
- `web_socket_channel`: https://pub.dev/packages/web_socket_channel
- Flutter WebSocket cookbook: https://docs.flutter.dev/cookbook/networking/web-sockets
- `record`: https://pub.dev/packages/record
- Flutter audio recording cookbook: https://docs.flutter.dev/cookbook/audio/record
- `camera`: https://pub.dev/packages/camera
- `video_player`: https://pub.dev/packages/video_player
- `screen_protector`: https://pub.dev/packages/screen_protector
- `permission_handler`: https://pub.dev/packages/permission_handler

## 27. Yakuniy qoida

Bu loyiha ijtimoiy app bo'lgani uchun arxitektura faqat kod tartibi emas. U user ishonchi, privacy, moderation, performance va UI sifatini himoya qiladigan mahsulot standartidir. BLoC, get_it, Equatable va Dio tanlovi loyiha kodini o'qiladigan, test qilinadigan va generatorlarga kamroq bog'langan holatda saqlaydi. Har bir feature avval contract, state, failure, UX holatlari va test mezonlari bilan boshlanadi.
