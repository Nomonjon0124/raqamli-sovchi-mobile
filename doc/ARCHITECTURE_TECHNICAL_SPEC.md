# Raqamli Sovchi Flutter arxitekturasi bo'yicha texnik topshiriq

Holat: boshlang'ich majburiy standart

Maqsad: ijtimoiy ilovani tez, xavfsiz, test qilinadigan, kengaytiriladigan va UI/UX sifati qat'iy nazorat qilinadigan Flutter mahsulot sifatida qurish.

## 1. Asosiy qaror

Loyiha quyidagi modelda quriladi:

- Architecture: Clean Architecture + MVVM + Feature-first modular structure.
- State management: Riverpod `Notifier` / `AsyncNotifier` asosida.
- Domain modelling: immutable model, sealed state, typed errors.
- Navigation: `go_router` bilan typed route yondashuvi.
- Network: `dio` asosida API client, interceptor, retry, timeout, cancellation.
- Serialization: `freezed` + `json_serializable`.
- Local cache: kichik key-value uchun `shared_preferences`, token/secret uchun `flutter_secure_storage`, murakkab offline ma'lumot uchun `drift` yoki `isar`.
- Media: image/video upload, compression, cache va CDN strategiyasi alohida qatlamda.
- Analytics/monitoring: privacy-first event tracking, crash reporting, performance tracing.
- Testing: unit, widget, golden, integration va contract testlar.

Bu arxitektura ijtimoiy app uchun tanlanadi, chunki profil, match, feed, chat, notification, moderation, media va payment kabi modullar tez ko'payadi. Har bir feature mustaqil rivojlanishi, test qilinishi va keyinchalik alohida paketga ajratilishi mumkin bo'lishi kerak.

## 2. Arxitektura prinsiplari

### 2.1 Clean Architecture

Kod tashqi texnologiyalardan ichki biznes qoidalarga qarab oqmasligi kerak. Bog'liqlik yo'nalishi doim ichkariga qaraydi:

```text
presentation -> application -> domain <- data
```

Qoidalar:

- `domain` Flutter, Riverpod, Dio, Firebase, Supabase yoki UI paketlarini bilmaydi.
- `data` tashqi API, local database, storage va platform pluginlarni biladi, lekin UI ni bilmaydi.
- `presentation` faqat ekranga chiqarish, user interaction va view state bilan ishlaydi.
- `application` use case, command, orchestration va transaction chegaralarini boshqaradi.
- API response hech qachon to'g'ridan-to'g'ri UI ga chiqmaydi.
- Widget ichida API chaqirish, parsing, caching, permission logic yoki biznes qaror bo'lmaydi.

### 2.2 SOLID talablari

- Single Responsibility: har bir class bitta sabab bilan o'zgaradi.
- Open/Closed: yangi provider, backend yoki feature qo'shish mavjud domain contractni buzmasligi kerak.
- Liskov Substitution: repository interface implementatsiyalari bir xil xatti-harakat kafolatini beradi.
- Interface Segregation: katta `UserRepository` o'rniga maqsadli contractlar ishlatiladi, masalan `ProfileRepository`, `MatchRepository`, `BlockRepository`.
- Dependency Inversion: ViewModel/Notifier abstractionga bog'lanadi, konkret API clientga emas.

### 2.3 Qo'shimcha majburiy prinsiplari

- DDD-lite: bounded contextlar aniq bo'ladi: `auth`, `profile`, `discovery`, `match`, `chat`, `feed`, `notifications`, `moderation`, `settings`.
- CQRS-lite: murakkab oqimlarda read model va write command ajratiladi.
- Result pattern: exceptionlar qatlamlar orasida xom holatda yurmaydi, `Result<T, Failure>` yoki sealed failure ishlatiladi.
- Immutable state: View state mutate qilinmaydi, yangi state nusxasi emit qilinadi.
- Idempotency: chat send, like, match action, upload retry kabi amallar idempotency key bilan himoyalanadi.
- Offline-first selective: chat draft, profile cache, feed page cache va media cache offline holatni hisobga oladi.
- Privacy by design: shaxsiy ma'lumot, location, photo metadata va moderation signallari minimal saqlanadi.

## 3. Tavsiya etilgan papka tuzilmasi

Feature-first tuzilma ishlatiladi. Shared yadro `core` ichida, har bir biznes modul `features` ichida bo'ladi.

```text
lib/
  app/
    app.dart
    bootstrap.dart
    router/
      app_router.dart
      route_names.dart
    di/
      providers.dart
    theme/
      app_theme.dart
      app_colors.dart
      app_typography.dart
      app_spacing.dart
  core/
    config/
      environment.dart
      build_flavor.dart
    errors/
      failure.dart
      result.dart
      exception_mapper.dart
    network/
      api_client.dart
      auth_interceptor.dart
      retry_policy.dart
      network_info.dart
    storage/
      secure_storage.dart
      cache_store.dart
    analytics/
      analytics_service.dart
      analytics_event.dart
    permissions/
      permission_service.dart
    ui/
      widgets/
      layout/
      accessibility/
    utils/
      clock.dart
      debouncer.dart
      pagination.dart
  features/
    auth/
      domain/
        entities/
        repositories/
        failures/
      application/
        use_cases/
      data/
        dto/
        data_sources/
        repositories/
      presentation/
        controllers/
        pages/
        widgets/
        state/
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

Test tuzilmasi ham shu tartibni takrorlaydi:

```text
test/
  core/
  features/
    auth/
      domain/
      application/
      data/
      presentation/
integration_test/
goldens/
```

## 4. Feature qatlamlari

### 4.1 Domain

Domain ichida biznes tili saqlanadi:

- entities: `UserProfile`, `Match`, `Conversation`, `Message`, `FeedPost`.
- value objects: `UserId`, `ConversationId`, `AgeRange`, `GeoPoint`, `PhotoId`.
- repository contractlar: `ProfileRepository`, `MatchRepository`, `ChatRepository`.
- failure turlari: `AuthFailure`, `ProfileFailure`, `ChatFailure`.

Qoidalar:

- Domain model immutable bo'ladi.
- Domain classlar UI ranglari, route nomlari, json keylari yoki endpointlarni bilmaydi.
- Domain validation model ichida yoki value object ichida bo'ladi.
- Date/time uchun to'g'ridan-to'g'ri `DateTime.now()` ishlatilmaydi, `Clock` abstraction ishlatiladi.

### 4.2 Application

Use case va flow orchestration shu qatlamda bo'ladi.

Misollar:

- `SignInWithPhoneUseCase`
- `CompleteProfileUseCase`
- `SwipeProfileUseCase`
- `CreateMatchUseCase`
- `SendMessageUseCase`
- `ReportUserUseCase`
- `LoadFeedPageUseCase`

Qoidalar:

- Use case bitta public methodga ega bo'ladi: `call`.
- Use case repository contractga bog'lanadi.
- Bir nechta repository qatnashadigan transaction shu yerda boshqariladi.
- Retry, validation va failure mapping aniq yoziladi.

### 4.3 Data

Data qatlamida tashqi dunyo bilan aloqa bor:

- Remote data source: REST, GraphQL, Firebase, Supabase yoki websocket.
- Local data source: cache, SQLite/Drift, secure storage.
- DTO: API schema uchun model.
- Mapper: DTO <-> Domain.
- Repository implementation: data sourcelarni birlashtiradi.

Qoidalar:

- DTO va domain model alohida bo'ladi.
- Mapperlar test qilinadi.
- Repository cache policy ni boshqaradi.
- Timeout har bir request uchun majburiy.
- Network retry faqat idempotent requestlarga qo'llanadi.
- Token refresh bitta markaziy interceptor orqali qilinadi.

### 4.4 Presentation

Presentation qatlamida UI va state bor:

- page/screen: route darajasidagi widget.
- widget: reusable visual component.
- controller/notifier: UI state va command.
- state: immutable view state.

Qoidalar:

- `setState` faqat juda lokal UI holatlarida: animation toggle, tab index, text field focus.
- API chaqirish widget ichida bo'lmaydi.
- Controller state `loading`, `data`, `empty`, `error`, `refreshing`, `paginationLoading` holatlarini ajratadi.
- Har bir error userga mos, qisqa va actionable ko'rinishda chiqadi.
- Har bir async action double tapdan himoyalanadi.

## 5. State management standarti

Riverpod tanlanadi, chunki dependency injection, async state, test override va DevTools inspection uchun qulay.

Qoidalar:

- Global mutable singleton ishlatilmaydi.
- Provider nomlari feature bilan boshlanadi: `profileControllerProvider`, `chatRepositoryProvider`.
- UI `ref.watch` bilan faqat kerakli state slice ni kuzatadi.
- Katta ekranlar mayda widgetlarga bo'linadi, har bir widget faqat o'ziga kerakli state ni oladi.
- `AsyncValue` oddiy load/data/error uchun ishlatiladi.
- Murakkab view state uchun `freezed` sealed class yoki immutable state class ishlatiladi.
- Provider override testlarda majburiy ishlatiladi.

## 6. Ijtimoiy app modullari bo'yicha arxitektura

### 6.1 Auth

- Phone/email/social login alohida strategy sifatida yoziladi.
- Token secure storage ichida saqlanadi.
- Session restore app bootstrap paytida bajariladi.
- Auth state router redirect bilan bog'lanadi.
- Logout local cache tozalash siyosatini aniq bajaradi.

### 6.2 Profile

- Public profile va private account settings alohida model bo'ladi.
- Photo upload queue bilan ishlaydi.
- Profile completeness domain service orqali hisoblanadi.
- Sensitive fields alohida permission va visibility policy bilan boshqariladi.

### 6.3 Discovery / Matching

- Swipe, like, skip, super-like kabi actionlar idempotent bo'ladi.
- Card prefetch ishlatiladi.
- Business rule backendda authoritative, frontend faqat UX uchun optimistik update qiladi.
- Undo, rate limit va abuse prevention signal uchun eventlar ajratiladi.

### 6.4 Chat

- Real-time transport alohida interface ortida bo'ladi.
- Message optimistic send bilan ko'rsatiladi, keyin server ack bilan reconcile qilinadi.
- Message status: `sending`, `sent`, `delivered`, `read`, `failed`.
- Pagination cursor-based bo'ladi.
- Draft local saqlanadi.
- Attachment upload message senddan alohida state machine sifatida yuradi.

### 6.5 Feed

- Infinite scroll cursor-based pagination bilan ishlaydi.
- Pull-to-refresh eski sahifalarni buzmasligi kerak.
- Media cache va placeholderlar majburiy.
- Like/comment count optimistik update qilinadi, lekin backend result bilan reconcile qilinadi.

### 6.6 Moderation

- Report, block, hide, mute birinchi release arxitekturasida bo'lishi kerak.
- Block qilingan user chat, discovery va feedda ko'rinmasligi shart.
- Moderation actionlar audit event sifatida yoziladi.
- User-generated content uchun image/text moderation backend contract orqali qo'llanadi.

### 6.7 Notifications

- Push permission onboardingdan ajratiladi.
- Notification routing typed deep link orqali bo'ladi.
- Foreground, background va cold start holatlari test qilinadi.
- Notification preferences local UI state emas, backend preference model bo'ladi.

## 7. Performance talablari

### 7.1 Budjetlar

- Cold start: release buildda imkon qadar 2.5 sekunddan past.
- Screen transition: 16 ms frame budgetga yaqin, jank minimal.
- Feed scroll: 60 FPS target, og'ir qurilmalarda profiling majburiy.
- API timeout: default 10-15 sekund, upload uchun alohida.
- Image memory: original rasmni to'g'ridan-to'g'ri listda render qilish taqiqlanadi.
- Build method: heavy computation, sorting, filtering yoki parsing bajarilmaydi.

### 7.2 Flutter performance qoidalari

- `const` constructorlar maksimal ishlatiladi.
- Listlar uchun `ListView.builder`, `SliverList`, `CustomScrollView` ishlatiladi.
- Katta feed itemlarda `RepaintBoundary` qo'llanadi.
- Image uchun thumbnail, resize, cacheWidth/cacheHeight siyosati bo'ladi.
- Scroll listenerlar throttle/debounce bilan himoyalanadi.
- Animatsiyalar transform/opacity kabi arzon propertylarga tayanadi.
- Expensive operation isolate yoki backendga ko'chiriladi.
- DevTools Performance bilan release/profile rejimda tekshiruv qilinadi.

### 7.3 Rebuild nazorati

- Har bir page yirik `watch` qilmasligi kerak.
- Selector yoki provider slice ishlatiladi.
- Widget tree ichida yirik anonymous builderlar ko'paytirilmaydi.
- UI state kichik, serializable va diff-friendly bo'ladi.

## 8. UI/UX standarti

### 8.1 Design system

App ichida yagona design system bo'ladi:

- Color tokens: primary, secondary, surface, error, success, warning, outline.
- Typography tokens: display, headline, title, body, label.
- Spacing scale: 4, 8, 12, 16, 24, 32.
- Radius: umumiy card radius 8 px atrofida, faqat avatar/media uchun alohida.
- Elevation/shadow minimal va maqsadli.
- Dark mode birinchi arxitektura bosqichidan hisobga olinadi.

Qoidalar:

- Hardcoded rang va font size feature ichida yozilmaydi.
- Button, input, chip, avatar, empty state, error state, media tile reusable component bo'ladi.
- UI matnlari l10n orqali yuradi.
- Har bir screen loading, empty, error, offline va permission denied holatlariga ega bo'ladi.

### 8.2 UX oqimlari

- Onboarding qisqa, bosqichma-bosqich va progress ko'rsatkichli bo'ladi.
- Profile yaratishda autosave yoki draft strategy bo'ladi.
- Chatda send failure qayta yuborish imkoniga ega bo'ladi.
- Discoveryda action feedback darhol chiqadi.
- Har bir destructive action confirm yoki undo bilan himoyalanadi.
- Errorlar texnik exception emas, user tushunadigan matn bo'ladi.

### 8.3 Accessibility

- Dynamic text scaling buzilmasligi kerak.
- Minimum tap target 44x44.
- Contrast WCAG AA darajasiga yaqin bo'lishi kerak.
- Semantics label icon-only buttonlarda majburiy.
- Form fieldlar error text va helper text bilan aniq ishlaydi.
- Screen reader uchun muhim state o'zgarishlari e'lon qilinadi.

## 9. Xavfsizlik va privacy

Majburiy qoidalar:

- Token, refresh token, session secret faqat secure storage.
- PII logga yozilmaydi.
- Debug log release buildga chiqmaydi.
- Screenshot/privacy himoyasi kerak bo'lgan ekranlar aniqlanadi.
- API requestlarda certificate pinning imkoniyati baholanadi.
- Deep link validation majburiy.
- File upload MIME, size va extension validationdan o'tadi.
- Location ishlatilsa, aniqlik darajasi minimal kerakli miqdorda bo'ladi.
- Account delete va data export flow arxitekturada joy qoldiradi.

## 10. Backend integratsiya shartlari

Backend tanlovi alohida qaror bo'lishi mumkin: Firebase, Supabase yoki custom backend. Flutter tarafida backend vendor lock-in kamaytiriladi.

Qoidalar:

- Repository contractlar backenddan mustaqil bo'ladi.
- API schema OpenAPI/GraphQL contract bilan hujjatlanadi.
- Real-time chat transport interface ortida bo'ladi.
- Push notification payload typed bo'ladi.
- Backend error code frontend failurega markaziy mapping qilinadi.
- Feature flag va remote config orqali xavfli featurelar bosqichma-bosqich yoqiladi.

## 11. Observability

Appda quyidagilar bo'lishi kerak:

- Crash reporting.
- Non-fatal error reporting.
- API latency metric.
- Screen load metric.
- Feed scroll performance signal.
- Login/signup funnel.
- Profile completion funnel.
- Match/chat conversion eventlari.

Privacy qoidasi:

- Analytics event PII saqlamaydi.
- Event schema versionlanadi.
- Consent talab qilinadigan regionlar uchun tracking toggle bo'ladi.

## 12. Test strategiyasi

### 12.1 Unit test

Majburiy:

- Use case.
- Repository cache va failure mapping.
- DTO mapper.
- Value object validation.
- Controller/Notifier state transition.

### 12.2 Widget test

Majburiy:

- Loading, data, empty, error holatlari.
- Form validation.
- Permission denied UI.
- Offline banner.
- Chat message statuslari.

### 12.3 Golden test

Majburiy ekranlar:

- Auth.
- Profile card.
- Discovery card.
- Chat list.
- Chat room.
- Feed item.
- Error/empty states.

### 12.4 Integration test

Majburiy oqimlar:

- Login/session restore.
- Profile completion.
- Swipe -> match -> chat.
- Message send failure retry.
- Block/report user.
- Push notification deep link.

## 13. CI/CD va sifat eshiklari

Har bir PR quyidagilardan o'tishi shart:

- `flutter analyze`
- `dart format --set-exit-if-changed .`
- Unit/widget testlar.
- Golden testlar, agar UI o'zgargan bo'lsa.
- Dependency audit.
- Build smoke test: Android va iOS kamida bitta flavor.

Merge bloklanadi, agar:

- Analyzer error bor.
- Testlar yiqilgan.
- Domain qatlami Flutter yoki data paketga bog'langan.
- UI text l10n dan tashqarida yozilgan.
- Secret yoki PII logga tushgan.
- Performance-sensitive listda eager render ishlatilgan.

## 14. Coding standard

- Public API aniq nomlanadi.
- Abbreviationlar cheklanadi.
- Har bir feature README yoki qisqa architecture note bilan yuradi.
- `dynamic` faqat majburiy holatda va izoh bilan ishlatiladi.
- `late` ehtiyotkor ishlatiladi, nullable yoki constructor injection afzal.
- Exception yutib yuborilmaydi.
- Magic numberlar token/constantga chiqariladi.
- Generated filelar qo'lda tahrir qilinmaydi.

## 15. Dependency siyosati

Yangi paket qo'shishdan oldin savollar:

- Paket oxirgi 12 oyda faol yangilanganmi?
- Flutter/Dart joriy SDK bilan mosmi?
- Paket biznes corega vendor lock-in olib keladimi?
- Test qilish va mock qilish osonmi?
- Bundle size yoki startupga ta'siri bormi?
- Native permission talab qiladimi?

Tavsiya etilgan boshlang'ich paketlar:

```yaml
dependencies:
  flutter_riverpod:
  riverpod_annotation:
  go_router:
  dio:
  freezed_annotation:
  json_annotation:
  flutter_secure_storage:
  shared_preferences:
  cached_network_image:
  intl:
  connectivity_plus:
  permission_handler:

dev_dependencies:
  build_runner:
  riverpod_generator:
  riverpod_lint:
  custom_lint:
  freezed:
  json_serializable:
  mocktail:
  golden_toolkit:
```

Keyin zaruratga qarab:

- `drift`: relational offline cache kerak bo'lsa.
- `isar`: local object store kerak bo'lsa.
- `firebase_messaging`: push notification uchun.
- `firebase_crashlytics` yoki alternativ crash reporting.
- `sentry_flutter`: crash/performance monitoring uchun.
- `image_picker`, `photo_manager`, `video_player`: media featurelar uchun.

## 16. Boshlang'ich implementation roadmap

1. `analysis_options.yaml` ni kuchaytirish: strict lint, riverpod lint, custom lint.
2. `lib/app`, `lib/core`, `lib/features` tuzilmasini yaratish.
3. App bootstrap, flavor va environment config qo'shish.
4. Riverpod DI rootini yaratish.
5. Router va auth redirect skeletini yaratish.
6. Design tokenlar va base theme yaratish.
7. `Result`, `Failure`, `Clock`, `NetworkInfo`, `Logger` kabi core abstractionlarni qo'shish.
8. Auth feature skeletonini yozish.
9. Profile feature skeletonini yozish.
10. Test scaffold va CI buyruqlarini tayyorlash.

## 17. Feature yaratish checklisti

Har bir yangi feature quyidagi tartibda qo'shiladi:

- Domain entity/value object yozildi.
- Repository contract yozildi.
- Use case yozildi.
- DTO va mapper yozildi.
- Remote/local data source yozildi.
- Repository implementation yozildi.
- Providerlar ro'yxatdan o'tdi.
- Controller/Notifier yozildi.
- Page/widgetlar design system bilan yozildi.
- Loading/empty/error/offline state bor.
- Unit/widget testlar bor.
- Analytics eventlar privacy qoidalariga mos.
- Accessibility tekshirildi.
- Performance xavfi bo'lsa profile qilindi.

## 18. Definition of Done

Feature tugagan deb hisoblanadi, agar:

- Kod arxitektura qatlamlarini buzmaydi.
- Analyzer va format toza.
- Testlar o'tgan.
- Error, empty, loading, offline holatlar ishlaydi.
- UI design tokenga mos.
- Dynamic text scaling va kichik ekran tekshirilgan.
- Analytics va crash reporting xatari baholangan.
- Security/privacy ta'siri ko'rib chiqilgan.
- API contract yoki mock contract yangilangan.

## 19. Manbalar

- Flutter rasmiy app architecture guide: https://docs.flutter.dev/app-architecture/guide
- Flutter rasmiy architecture case study: https://docs.flutter.dev/app-architecture/case-study
- Riverpod rasmiy dokumentatsiyasi: https://riverpod.dev/
- Riverpod code generation haqida: https://riverpod.dev/docs/concepts/about_code_generation
- Dart rasmiy dokumentatsiyasi: https://dart.dev/

## 20. Muhim yakuniy qoida

Bu loyiha ijtimoiy app bo'lgani uchun arxitektura faqat kod tartibi emas. U user ishonchi, privacy, moderation, performance va UI sifatini himoya qiladigan mahsulot standartidir. Tez yozilgan, lekin qatlamlarni buzadigan kod keyinchalik qimmatga tushadi. Shu sababli har bir feature avval contract, state, failure, UX holatlari va test mezonlari bilan boshlanadi.
