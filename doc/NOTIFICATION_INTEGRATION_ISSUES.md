# Notification integratsiyasi bo'yicha muammolar

Holat: 2026-08-21

Ushbu hujjat mobile va backend tomonda notification ishlashiga ta'sir qilayotgan muammolarni ajratib beradi. Maqsad: backend va mobile jamoasi bir xil contract bo'yicha kelishib, FCM push, WebSocket realtime, notification center, unread badge va tap routing flowlarini yakunlash.

## Qisqa xulosa

Hozirgi eng asosiy blocker backend tomonda: push yuborish taski runtime xato bilan yiqiladi. Shu sababli backend notification yaratgan bo'lsa ham FCM push foydalanuvchiga yetib bormaydi.

Mobile tomonda Firebase/FCM lifecycle boshlangan, lekin iOS native sozlamalari, logout/device unlink tartibi, WebSocket reconnect, notification tap routing va deduplication tugallanmagan. Backend delivery tuzatilgandan keyin ham bu kamchiliklar notification experience'ni noto'g'ri ishlatadi.

## Backend tomondagi muammolar

### P0: FCM push yuborish taski runtime xato bilan yiqiladi

Fayl: `C:/Users/ummug/StudioProjects/raqamli_sovchi_backend/apps/accounts/notifications/tasks.py`

Dalil:

- `send_push_notification_task()` signature faqat `user_id`, `title`, `message`, `extra_data` qabul qiladi.
- Shu function ichida `p.notification_id` va `p.extra_data` ishlatilgan.
- `p` bu scope ichida mavjud emas.

Tegishli joy:

- `tasks.py:90-95` push taskga `p.user_id`, `p.title`, `p.message`, `p.extra_data` uzatilgan.
- `tasks.py:132-138` `send_push_notification_task()` parametrlari.
- `tasks.py:149-152` mavjud bo'lmagan `p` ishlatilgan.

Ta'siri:

- Celery task `NameError` bilan yiqiladi.
- FCM push yuborilmaydi.
- Mobile token register to'g'ri bo'lsa ham foydalanuvchi push olmaydi.

Tuzatish:

- Push taskga `notification_id` va `notification_type` aniq uzatish kerak.
- Yoki butun `NotificationPayload` dictini `send_push_notification_task()`ga berish kerak.
- `fcm_data` quyidagi contractga mos bo'lishi kerak:

```json
{
  "notification_id": "<notification uuid>",
  "notification_type": "<type>",
  "payload": "{\"...\": \"...\"}",
  "schema_version": "1"
}
```

### P0: Device unregister va invalid-token cleanup soft delete bilan noto'g'ri ishlayapti

Fayllar:

- `C:/Users/ummug/StudioProjects/raqamli_sovchi_backend/apps/core/base/models.py`
- `C:/Users/ummug/StudioProjects/raqamli_sovchi_backend/apps/accounts/notifications/views.py`
- `C:/Users/ummug/StudioProjects/raqamli_sovchi_backend/apps/accounts/notifications/tasks.py`

Dalil:

- `BaseQuerySet.delete()` real delete qilmaydi, faqat `is_active=False` qiladi.
- Unregister endpoint ham `.delete()` chaqiryapti.
- Push sender `UserDevice.objects.filter(user_id=user_id)` ishlatyapti, lekin `.active()` yoki `is_active=True` filter yo'q.
- Invalid FCM token cleanup ham `.delete()` bilan soft delete qiladi.
- Register `update_or_create()` ichida `is_active=True` qayta tiklanmayapti.

Tegishli joy:

- `base/models.py:15-16` soft delete.
- `views.py:154-157` unregister.
- `tasks.py:139-143` active filter yo'q.
- `tasks.py:183-185` invalid token cleanup.
- `views.py:116-123` register defaults ichida `is_active=True` yo'q.

Ta'siri:

- Logout bo'lgan device push listdan tushmasligi mumkin.
- Invalid tokenlar keyingi yuborishda yana tanlanishi mumkin.
- Account delete qilingandan keyin eski device tokenlarga push ketishi privacy risk.

Tuzatish:

- Push sender faqat active device'larni tanlasin: `UserDevice.objects.active().filter(user_id=user_id)`.
- Unregister uchun aniq qaror kerak: hard delete qilinadimi yoki soft delete. Soft delete bo'lsa sender hamma joyda `is_active=True` filter ishlatishi shart.
- Register vaqtida mavjud inactive record qayta ishlatilsa `is_active=True` qilib tiklansin.
- Account delete/logout flowida user device'lari idempotent tozalansin.

### P1: Backend notification payload contract to'liq barqaror emas

Fayl: `C:/Users/ummug/StudioProjects/raqamli_sovchi_backend/apps/accounts/notifications/signals.py`

Dalil:

- `message_data` ichida `"id"` ikki marta yozilgan.
- `notification_type` alohida field sifatida yo'q, hozir `extra_data.type`dan olinishi kutilgan.
- FCM va WebSocket bir xil typed payload contractiga majburiy bog'lanmagan.

Tegishli joy:

- `signals.py:12-19`
- `tasks.py:112-118`
- `tasks.py:149-154`

Ta'siri:

- Mobile taraf routing uchun kerakli `notification_type`, `notification_id`, `payload` doim kafolatlanmaydi.
- FCM va WebSocket eventlarini bitta notification ID orqali dedup qilish qiyinlashadi.

Tuzatish:

- Backendda notification event serializer yoki helper yaratish kerak.
- FCM va WebSocket bir xil asosiy maydonlarni yuborsin:

```json
{
  "notification_id": "<uuid>",
  "notification_type": "match_request_created",
  "title": "...",
  "message": "...",
  "payload": {
    "sender_profile_id": "...",
    "chat_room_id": null
  },
  "schema_version": "1",
  "created_at": "..."
}
```

### P1: Backend loglarda PII chiqishi mumkin

Fayl: `C:/Users/ummug/StudioProjects/raqamli_sovchi_backend/apps/accounts/notifications/tasks.py`

Dalil:

- Invalid payload logida raw payload yozilyapti.
- Invalid token cleanup logida `user_id` yozilyapti.
- Task return stringlarida `user_id` bor.

Tegishli joy:

- `tasks.py:63`
- `tasks.py:97`
- `tasks.py:147`
- `tasks.py:185`

Ta'siri:

- Notification title/message, user ID yoki extra_data logga tushishi mumkin.
- Bu privacy policy va mobile arxitektura talablariga zid.

Tuzatish:

- Raw payload, user ID, FCM token, notification matni log qilinmasin.
- Loglarda faqat aggregate count, task id yoki sanitized error code qolsin.

### P1: OpenAPI schema endpoint contract bilan to'liq mos emas

Fayllar:

- `C:/Users/ummug/StudioProjects/raqamli_sovchi_backend/apps/accounts/notifications/views.py`
- `C:/Users/ummug/StudioProjects/raqamli_sovchi_backend/apps/accounts/notifications/serializers.py`

Muammo:

- Register contract source bo'yicha `fcm_token`, `device_type`, `device_id`, lekin Swagger eskirgan schema ko'rsatishi mumkin.
- `DELETE /devices/current/` body schema typed serializer bilan hujjatlashtirilmagan.
- WebSocket ticket response schema ham typed emas.

Tuzatish:

- Register, unregister va ticket endpointlari uchun request/response serializerlarni OpenAPI'ga aniq bog'lash.
- Mobile jamoasi Swaggerga qarab ishlay olishi uchun schema source bilan bir xil bo'lishi kerak.

### P1: Backend testlar yetarli emas

Fayl:

- `C:/Users/ummug/StudioProjects/raqamli_sovchi_backend/apps/accounts/notifications/tests.py`

Muammo:

- Notification delivery uchun real testlar yo'q.

Kerakli testlar:

- Device register upsert.
- Register inactive device'ni active qiladi.
- Unregister faqat authenticated user's current device'ini o'chiradi yoki inactive qiladi.
- Push sender faqat active devices'larni tanlaydi.
- Invalid token cleanup keyingi sendda qayta tanlanmaydi.
- FCM payloadda `notification_id`, `notification_type`, `payload`, `schema_version` bor.
- WebSocket ticket muddati tugaganda ishlamaydi.

## Mobile tomondagi muammolar

### P1: Logout/device unlink noto'g'ri tartibda bajariladi

Fayllar:

- `C:/Users/ummug/StudioProjects/raqamli_sovchi/lib/features/auth/presentation/bloc/auth_bloc.dart`
- `C:/Users/ummug/StudioProjects/raqamli_sovchi/lib/app/app.dart`
- `C:/Users/ummug/StudioProjects/raqamli_sovchi/lib/features/notifications/data/services/notification_lifecycle_service.dart`

Dalil:

- Auth BLoC logoutda avval sessionni tozalaydi.
- App unauthenticated state'ni ko'rgandan keyin `NotificationLifecycleService.deactivate()` chaqiradi.
- `deactivate()` ichida backendga unregister DELETE ketadi, lekin auth token allaqachon tozalangan bo'lishi mumkin.

Tegishli joy:

- `auth_bloc.dart:447-461`
- `app.dart:63-67`
- `notification_lifecycle_service.dart:103-106`

Ta'siri:

- `DELETE /api/v1/accounts/notifications/devices/current/` 401 qaytarishi mumkin.
- Local token/device state tozalanadi, lekin backenddagi device record qoladi.
- Keyinchalik logout bo'lgan device push olishi mumkin.

Tuzatish:

- Notification unregister auth token o'chirilishidan oldin bajarilsin.
- Logout/account delete orchestration ichida `notificationLifecycle.deactivate()` yoki dedicated use case avval chaqirilsin.
- Network xatosi bo'lsa ham local Firebase token invalid qilinishi mumkin, lekin backend cleanup retry strategiyasi aniq bo'lishi kerak.

### P1: iOS push notification native sozlamalari tugallanmagan

Fayllar:

- `C:/Users/ummug/StudioProjects/raqamli_sovchi/ios/Runner`

Dalil:

- `GoogleService-Info.plist` topilmadi.
- `Runner.entitlements` ichida `aps-environment` topilmadi.
- `Info.plist`da `UIBackgroundModes` uchun `remote-notification` topilmadi.

Ta'siri:

- iOS real device'da FCM push kelmaydi yoki background/terminated handling ishlamaydi.

Tuzatish:

- `flutterfire configure --project=raqamli-sovchi-988e7 --platforms=android,ios` orqali iOS config yangilansin.
- `GoogleService-Info.plist` Runner targetga qo'shilsin.
- Xcode'da Push Notifications capability yoqilsin.
- Background Modes -> Remote notifications yoqilsin.
- Firebase Console'ga APNs `.p8` key, key ID va team ID yuklansin.

### P1: iOS permission prompt app bootstrap/initialization vaqtida chiqishi mumkin

Fayl:

- `C:/Users/ummug/StudioProjects/raqamli_sovchi/lib/features/notifications/data/services/notification_lifecycle_service.dart`

Dalil:

- `DarwinInitializationSettings()` default request permission qiymatlari bilan ishlatilgan.
- Service `bootstrap.dart`da app start paytida initialize qilinadi.

Tegishli joy:

- `notification_lifecycle_service.dart:49-56`
- `bootstrap.dart:22`

Ta'siri:

- User login/home'ga kirmasdan oldin native notification permission prompt ko'rishi mumkin.
- Bu product plandagi "authenticated home'ga kirgandan keyin tushuntiruvchi prompt" talabiga zid.

Tuzatish:

- `DarwinInitializationSettings(requestAlertPermission: false, requestBadgePermission: false, requestSoundPermission: false)` ishlatish.
- Permission request faqat authenticated userga tushuntiruvchi UI promptdan keyin chaqirilsin.

### P1: Notification tap routing implementatsiyasi yo'q

Fayllar:

- `C:/Users/ummug/StudioProjects/raqamli_sovchi/lib/features/notifications/data/services/notification_lifecycle_service.dart`
- `C:/Users/ummug/StudioProjects/raqamli_sovchi/lib/features/notifications/presentation/bloc/notification_bloc.dart`
- `C:/Users/ummug/StudioProjects/raqamli_sovchi/lib/app/router/app_router.dart`

Dalil:

- `_handleOpened()` faqat event busga event qo'shadi.
- BLoC eventni route qilish o'rniga listni qayta yuklaydi.
- Local notification `show()` chaqirig'ida payload berilmagan.
- `flutter_local_notifications.initialize()` ichida tap callback ulanmagan.

Tegishli joy:

- `notification_lifecycle_service.dart:155-168`
- `notification_lifecycle_service.dart:171-174`
- `notification_bloc.dart:25-30`

Ta'siri:

- Push bosilganda app kerakli sahifaga o'tmaydi.
- `match_request_created`, `match_request_accepted`, `new_chat_message` kabi typed route mapping ishlamaydi.

Tuzatish:

- `NotificationRouter` yoki shunga o'xshash core service qo'shish.
- FCM `onMessageOpenedApp`, `getInitialMessage` va local notification tap callback bitta parser/router orqali ishlasin.
- Mapping:
  - `match_request_created` -> yuboruvchi profil detaili.
  - `match_request_accepted` -> Messages tab.
  - `new_chat_message` -> Messages tab, chat detail keyin bo'lmasa fallback.
  - `match_request_forwarded`, `match_request_rejected`, unknown payload -> notification center.

### P1: WebSocket normal holatda ulanmasligi yoki uzilganda tiklanmasligi mumkin

Fayllar:

- `C:/Users/ummug/StudioProjects/raqamli_sovchi/lib/core/config/app_config.dart`
- `C:/Users/ummug/StudioProjects/raqamli_sovchi/lib/features/notifications/data/services/notification_lifecycle_service.dart`

Dalil:

- `AppConfig.wsUrl` default bo'sh.
- `_connectSocket()` `wsUrl` bo'sh bo'lsa silent return qiladi.
- Socket streamda `onDone`, `onError`, reconnect/backoff va ticket refresh yo'q.

Tegishli joy:

- `app_config.dart:19`
- `notification_lifecycle_service.dart:126-148`

Ta'siri:

- Notification center va unread badge realtime yangilanmaydi.
- WebSocket uzilib qolsa qayta ulanmaydi.

Tuzatish:

- Dev/staging/prod configlarda `WS_URL` berilishi shart.
- Ticket olish, 60 sekund expiry, reconnect/backoff va socket close handling yozilishi kerak.
- Backend ticket endpoint xatosida UI offline/degraded holatga o'tsin.

### P1: Activation error handling to'liq emas

Fayl:

- `C:/Users/ummug/StudioProjects/raqamli_sovchi/lib/features/notifications/data/services/notification_lifecycle_service.dart`

Dalil:

- `_active = true` token sync va socket connectdan oldin qo'yiladi.
- Agar token olish/register/socket xato bersa, service active holatda qolishi mumkin.
- Keyingi `activate()` chaqiruvi `if (_active) return` sabab qayta urinmaydi.

Tegishli joy:

- `notification_lifecycle_service.dart:77-93`

Ta'siri:

- Birinchi activation failure'dan keyin notification register qayta tiklanmasligi mumkin.

Tuzatish:

- Activation flow try/catch/finally bilan boshqarilsin.
- Register yoki socket failure bo'lsa `_active` holati va retry imkoniyati aniq bo'lsin.
- iOS uchun APNs token tayyor bo'lishini kutish kerak bo'lishi mumkin.

### P2: FCM va WebSocket deduplication yo'q

Fayllar:

- `C:/Users/ummug/StudioProjects/raqamli_sovchi/lib/core/notifications/notification_event_bus.dart`
- `C:/Users/ummug/StudioProjects/raqamli_sovchi/lib/features/notifications/presentation/bloc/notification_bloc.dart`

Muammo:

- FCM va WebSocket bir xil notificationni olib kelganda bitta `notification_id` bo'yicha dedup qilinmaydi.
- Har eventda list to'liq reload qilinadi.

Ta'siri:

- Duplicate UI reload, badge noto'g'ri ko'rsatishi yoki notification list blink qilishi mumkin.

Tuzatish:

- Event cache/dedup layer qo'shish.
- `notification_id` majburiy bo'lsin.
- Badge uchun bitta shared source of truth ishlatilsin.

### P2: Notification center feature incomplete

Fayllar:

- `C:/Users/ummug/StudioProjects/raqamli_sovchi/lib/features/notifications/presentation/pages/notifications_page.dart`
- `C:/Users/ummug/StudioProjects/raqamli_sovchi/lib/features/notifications/presentation/bloc/notification_bloc.dart`

Muammolar:

- Pagination yo'q yoki birinchi page bilan cheklangan.
- Offline/permission-denied state yo'q.
- Read/mark-all failure userga aniq ko'rsatilmaydi.
- Read item tap behavior route bilan bog'lanmagan.

Tuzatish:

- Cursor/page pagination.
- Loading, empty, error, offline, permission denied states.
- Mark read/mark all read optimistic yoki server-confirmed behavior.
- Notification item tap -> mark read -> route.

### P2: Android notification setup to'liq polish qilinmagan

Fayllar:

- `C:/Users/ummug/StudioProjects/raqamli_sovchi/android/app/src/main/AndroidManifest.xml`
- `C:/Users/ummug/StudioProjects/raqamli_sovchi/lib/features/notifications/data/services/notification_lifecycle_service.dart`

Muammolar:

- Local notification icon `@mipmap/ic_launcher`, dedicated monochrome notification icon emas.
- Backend FCM AndroidConfig high priority/channel ID/icon bilan yubormayapti.
- Channel name/description hardcoded, l10n va product naming bilan yakuniy tekshiruv kerak.

Tuzatish:

- Dedicated monochrome drawable notification icon qo'shish.
- Android default channel metadata va backend AndroidConfig mos bo'lishi kerak.
- Android 13+ uchun `POST_NOTIFICATIONS` permission flow real device'da tekshirilsin.

## Ikkala tomon birgalikda to'g'rilashi kerak bo'lgan ishlar

### 1. Notification payload contractni yakunlash

Backend va mobile quyidagi minimal contractga kelishishi kerak:

```json
{
  "notification_id": "uuid",
  "notification_type": "match_request_created",
  "title": "string",
  "message": "string",
  "payload": {
    "sender_profile_id": "uuid",
    "chat_room_id": "uuid yoki null",
    "match_request_id": "uuid yoki null"
  },
  "schema_version": "1",
  "created_at": "iso datetime"
}
```

Qoidalar:

- `notification_id` FCM va WebSocketda bir xil bo'lishi shart.
- `notification_type` enum/string contract sifatida hujjatlashtirilsin.
- `payload` noto'g'ri bo'lsa mobile notification center fallback qilishi kerak.
- Backend unknown type yubormasligi kerak, lekin mobile unknown type'ni xavfsiz handle qiladi.

### 2. Routing contractni kelishish

Mobile routing uchun backend quyidagi type va payloadlarni kafolatlashi kerak:

| notification_type | Kerakli payload | Mobile route |
| --- | --- | --- |
| `match_request_created` | `sender_profile_id` yoki `match_request_id` | Profile detail yoki notification center fallback |
| `match_request_accepted` | `match_request_id`, optional `chat_room_id` | Messages tab |
| `new_chat_message` | `chat_room_id` | Messages tab, chat detail keyin qo'shiladi |
| `match_request_forwarded` | `match_request_id` | Notification center |
| `match_request_rejected` | `match_request_id` | Notification center |

### 3. Device lifecycle contractni yakunlash

Endpointlar:

- `POST /api/v1/accounts/notifications/devices/register/`
- `DELETE /api/v1/accounts/notifications/devices/current/`

Register body:

```json
{
  "fcm_token": "<FCM token>",
  "device_type": "android",
  "device_id": "<install uuid>"
}
```

Unregister body:

```json
{
  "device_id": "<install uuid>"
}
```

Kelishuv:

- `device_id` mobile secure storageda saqlanadi.
- Register idempotent upsert bo'ladi.
- Token refresh bo'lsa backend record update qilinadi.
- Logout/account delete vaqtida unregister auth token o'chishidan oldin chaqiriladi.
- Backend unregister ownership-safe bo'lishi kerak: user faqat o'z device'ini unlink qiladi.

### 4. WebSocket ticket contractni yakunlash

Endpoint:

- `POST /api/v1/accounts/notifications/tickets/`

Response:

```json
{
  "ticket": "<short lived ticket>",
  "expires_in": 60
}
```

Socket:

```text
WS_URL/ws/notifications/?ticket=<ticket>
```

Kelishuv:

- Ticket faqat authenticated user uchun.
- Ticket muddati 60 soniya.
- Mobile reconnect paytida yangi ticket oladi.
- Backend expired/used/invalid ticketni rad etadi.

### 5. Permission va platform setupni birga test qilish

Tekshiruvlar:

- Android real device: permission grant, deny, foreground push, background tap, terminated tap.
- iPhone real device: APNs config, permission grant/deny, foreground push, background tap, terminated tap.
- Logoutdan keyin shu device push olmaydi.
- Token refreshdan keyin eski token emas, yangi token ishlaydi.

### 6. Test va quality gate

Backend:

- Notification task unit tests.
- Device register/unregister tests.
- Payload serializer tests.
- Ticket expiry tests.
- Invalid token cleanup tests.

Mobile:

- Payload parser tests.
- Notification router tests.
- Register/unregister use case tests.
- Token store tests.
- NotificationBloc tests.
- WebSocket reconnect/dedup tests.
- Bell badge va notification center widget tests.

## Tavsiya qilingan ish tartibi

1. Backend P0 delivery bugni tuzatish.
2. Backend active device lifecycle va cleanupni tuzatish.
3. Backend payload serializer va OpenAPI schemalarni yakunlash.
4. Mobile logout/unregister orderni tuzatish.
5. Mobile permission flow va iOS native setupni yakunlash.
6. Mobile tap routing va local notification callbackni yozish.
7. WebSocket reconnect, ticket refresh va deduplication qo'shish.
8. Notification center pagination/state/read behaviorni yakunlash.
9. Android/iOS real device smoke test o'tkazish.
10. Backend va mobile critical testlarni qo'shish.

## Backendchidan feedback kerak bo'lgan savollar

1. `notification_type` alohida model field bo'ladimi yoki `extra_data.type` ichida qoladimi?
2. `UserDevice` unregister hard delete bo'ladimi yoki soft delete? Soft delete bo'lsa active filter barcha senderlarda majburiy bo'lishi kerak.
3. Account delete qilinganda user device'lari qayerda cleanup qilinadi?
4. WebSocket ticket endpoint prod/stagingda tayyormi va `WS_URL` aniq qiymati qanday?
5. FCM payloadda `payload` stringified JSON bo'ladimi yoki data ichida flat keylar bo'ladimi?
6. iOS APNs key Firebase Console'ga yuklanganmi?

