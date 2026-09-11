// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get faceCaptureTitle => 'Сделаем одно селфи';

  @override
  String get faceCaptureSubtitle =>
      'Мы сравним его с вашим основным фото. Никто его не увидит, и после проверки оно будет удалено.';

  @override
  String get selfieCameraLabel => 'камера селфи';

  @override
  String get faceRuleOne => 'Разместите лицо внутри круга.';

  @override
  String get faceRuleTwo => 'Убедитесь, что лицо хорошо видно.';

  @override
  String get faceRuleThree => 'Держите телефон на уровне глаз.';

  @override
  String get takeSelfieLabel => 'Сделать селфи';

  @override
  String get aboutMeTitle => 'О себе';

  @override
  String get aboutMeSubtitle =>
      'Необязательно. Напишите кратко — кандидаты это прочитают.';

  @override
  String get aboutMeHint =>
      'Напишите 2–3 предложения о себе, работе и семейных ценностях...';

  @override
  String aboutMeCounter(int count) {
    return '$count / 300 символов';
  }

  @override
  String get mainPhotoSelectionHint => 'Выберите главное фото';

  @override
  String get mainPhotoSubtitle =>
      'Это фото будет первым в профиле и будет сравниваться с селфи.';

  @override
  String get mainPhotoBadge => 'ГЛАВНОЕ';

  @override
  String get faceRetryHint => 'Селфи не совпало. Попробуйте ещё раз.';

  @override
  String get faceCameraError => 'Не удалось запустить камеру.';

  @override
  String get onboardingSuccessTitle => 'Ваша анкета готова!';

  @override
  String get onboardingSuccessSubtitle =>
      'Всё сохранено. Теперь вы можете посмотреть подходящих кандидатов.';

  @override
  String get pledgeConfirmationTitle => 'Подтвердите своё намерение';

  @override
  String get pledgeConfirmationSubtitle =>
      'Этот шаг обязателен. После подтверждения в профиле появится отметка «Серьёзные намерения».';

  @override
  String get pledgeConfirmationPointOne =>
      'Мои данные верны и принадлежат мне.';

  @override
  String get pledgeConfirmationPointTwo =>
      'Моё намерение серьёзное — я пришёл(ла), чтобы создать семью.';

  @override
  String get pledgeConfirmationPointThree =>
      'Я буду уважительно относиться к собеседникам.';

  @override
  String get pledgeConfirmationButton => 'Подтвердить обещание';

  @override
  String get privacyPolicyAgreementSuffix => ' для ознакомления';

  @override
  String get aiTestBadge => 'AI-ТЕСТ СОВМЕСТИМОСТИ';

  @override
  String get aiTestTitle => 'Ответите на 30 вопросов?';

  @override
  String get aiTestDescription =>
      'По вашим ответам мы рассчитаем совместимость с каждым кандидатом. Это займёт около 8 минут.';

  @override
  String get aiTestPointOne => 'AI-анализ готов за 8 минут';

  @override
  String get aiTestPointTwo => 'Подходящие пары выбираются автоматически';

  @override
  String get aiTestPointThree => 'Ваши ответы никто не увидит';

  @override
  String get startAiTest => 'Да, начать тест';

  @override
  String get viewCandidatesLater => 'Позже — сначала посмотреть кандидатов';

  @override
  String get appTitle => 'Цифровой сват';

  @override
  String get loading => 'Загрузка...';

  @override
  String get splashSubtitle => 'Без спешки, вместе с семьей';

  @override
  String get loginTitle => 'Добро пожаловать';

  @override
  String get loginHeadline => 'Без спешки,\nвместе с семьей';

  @override
  String get loginSubtitle => 'Начнем с вашего номера телефона';

  @override
  String get phoneLabel => 'Номер телефона';

  @override
  String get phoneError => 'Введите корректный номер телефона Узбекистана.';

  @override
  String get continueLabel => 'Продолжить';

  @override
  String get orLabel => 'или';

  @override
  String get loginNote =>
      'Ваш номер остается приватным. Каждый профиль проверяется вручную, поэтому здесь остаются только люди с серьезным намерением создать семью.';

  @override
  String get otpTitle => 'Введите код';

  @override
  String otpSentTo(String phone) {
    return 'Мы отправили 4-значный код на $phone';
  }

  @override
  String get otpResend => 'Код не пришел? Повторная отправка через 00:48';

  @override
  String get confirmLabel => 'Подтвердить';

  @override
  String get candidateTypeTitle => 'Кого вы ищете?';

  @override
  String get candidateTypeSubtitle =>
      'Этот выбор определит вашу анкету. Повторно о поле не спросим.';

  @override
  String get groomCandidateTitle => 'Кандидат-жених';

  @override
  String get groomCandidateSubtitle => 'Я мужчина, ищу для себя';

  @override
  String get brideCandidateTitle => 'Кандидатка-невеста';

  @override
  String get brideCandidateSubtitle => 'Я женщина, ищу для себя';

  @override
  String get representativeCandidateTitle => 'Представитель';

  @override
  String get representativeCandidateSubtitle =>
      'Заполняю анкету от имени близкого человека';

  @override
  String get pledgeTitle => 'Для доверия между нами';

  @override
  String get pledgePointOne =>
      'Я буду использовать это приложение только с намерением вступить в брак.';

  @override
  String get pledgePointTwo =>
      'Мои данные верны, а фотографии принадлежат мне.';

  @override
  String get pledgePointThree =>
      'В беседе я буду соблюдать уважение и согласен на контроль AI-модератора.';

  @override
  String get pledgeAgreement =>
      'Согласен. Показывать на моём профиле значок «Серьёзные намерения».';

  @override
  String get pledgeStart => 'Начать анкету';

  @override
  String onboardingProgress(Object current, Object total) {
    return 'Шаг $current из $total';
  }

  @override
  String get birthDateTitle => 'Ваш год рождения';

  @override
  String get birthDateHint =>
      'Пользователи младше 18 лет не могут зарегистрироваться.';

  @override
  String get birthDateSubtitle =>
      'Кандидаты увидят ваш возраст, но не точную дату рождения.';

  @override
  String get identityTitle => 'Ваше имя и фамилия';

  @override
  String get identitySubtitle =>
      'Напишите так, как указано в паспорте. Это имя увидят кандидаты.';

  @override
  String get firstNameLabel => 'Имя';

  @override
  String get lastNameLabel => 'Фамилия';

  @override
  String get patronymicLabel => 'Отчество (необязательно)';

  @override
  String get professionTitle => 'Ваша профессия?';

  @override
  String get professionOther => 'Другое';

  @override
  String get professionInputLabel => 'Напишите профессию';

  @override
  String get professionEmpty => 'Профессии не найдены.';

  @override
  String get representativeProfessionTitle => 'Профессия кандидата?';

  @override
  String get representativeProfessionInputLabel =>
      'Напишите профессию кандидата';

  @override
  String get educationTitle => 'Какое у вас образование?';

  @override
  String get heightTitle => 'Ваш рост';

  @override
  String get heightWeightTitle => 'Ваш рост и вес';

  @override
  String get heightLabel => 'Рост (см)';

  @override
  String get heightInputLabel => 'Ваш рост';

  @override
  String get heightUnit => 'см';

  @override
  String get weightLabel => 'Вес (кг)';

  @override
  String get weightInputLabel => 'Ваш вес';

  @override
  String get weightUnit => 'кг';

  @override
  String get decreaseHeightLabel => 'Уменьшить рост';

  @override
  String get increaseHeightLabel => 'Увеличить рост';

  @override
  String get decreaseWeightLabel => 'Уменьшить вес';

  @override
  String get increaseWeightLabel => 'Увеличить вес';

  @override
  String get locationTitle => 'Где вы живёте?';

  @override
  String get regionLabel => 'Регион';

  @override
  String get districtLabel => 'Район или город';

  @override
  String get regionSheetTitle => 'Выберите регион';

  @override
  String regionSheetCount(Object count) {
    return '$count регионов';
  }

  @override
  String get districtSheetTitle => 'Выберите район / город';

  @override
  String districtSheetSubtitle(Object count, Object region) {
    return '$region · $count районов';
  }

  @override
  String get locationSearchPlaceholder => 'Поиск по названию района';

  @override
  String get selectLabel => 'Выбрать';

  @override
  String get unselectedValue => 'Не выбрано';

  @override
  String get selectRegionFirstValue => 'Сначала выберите регион';

  @override
  String get healthStatusTitle => 'Состояние здоровья';

  @override
  String get healthStatusSubtitle =>
      'Эта информация используется только для расчёта совместимости.';

  @override
  String get healthHealthyLabel => 'Здоров';

  @override
  String get healthDisabilityLabel => 'Есть инвалидность';

  @override
  String get healthDisabilityHint =>
      'На следующем шаге можно кратко объяснить это';

  @override
  String get maritalStatusTitle => 'Ваше семейное положение';

  @override
  String get maritalStatusDivorcedHint =>
      'При выборе «Разведён(а)» количество детей обязательно.';

  @override
  String get maritalStatusFirstMarriageDetail => 'Ранее не состоял(а) в браке';

  @override
  String get maritalStatusDivorcedDetail => 'Будет запрошено количество детей';

  @override
  String get childrenCountLabel => 'Количество ваших детей';

  @override
  String get decreaseChildrenLabel => 'Уменьшить количество детей';

  @override
  String get increaseChildrenLabel => 'Увеличить количество детей';

  @override
  String get childrenNotLivingTitle => 'Дети не живут со мной';

  @override
  String get childrenNotLivingDetail =>
      'В профиле будет указано, что у вас есть дети, без подробностей';

  @override
  String get photoTitle => 'Добавьте фотографии';

  @override
  String get photoHint =>
      'До 5 фотографий. Их увидят только те, кому вы разрешите.';

  @override
  String get photoPrivacyHint =>
      'Нужна минимум 1 фотография. Лицо должно быть хорошо видно.';

  @override
  String get photoSlotAddLabel => 'фото';

  @override
  String photoSlotFilledLabel(int order) {
    return 'фото $order ✓';
  }

  @override
  String get addPhoto => 'Добавить фото';

  @override
  String get setMainPhoto => 'Сделать главным';

  @override
  String get removePhoto => 'Удалить';

  @override
  String get voiceTitle => 'Голосовое представление';

  @override
  String get voiceHint => 'Запишите до 30 секунд в формате AAC/M4A.';

  @override
  String get voiceShortHint =>
      '10–15 секунд достаточно. Голос говорит о человеке больше, чем фотография.';

  @override
  String get startRecording => 'Начать запись';

  @override
  String get stopRecording => 'Остановить запись';

  @override
  String get playRecording => 'Прослушать запись';

  @override
  String get voiceSubtitle =>
      'Необязательно. 10–15 секунд достаточно — голос расскажет о человеке больше.';

  @override
  String get startRecordingHint => 'Нажмите, чтобы начать запись';

  @override
  String get recordedVoiceHint =>
      'Прослушайте запись. Если не понравится, запишите заново или удалите — голос необязателен.';

  @override
  String get reRecordVoice => 'Записать заново';

  @override
  String get deleteVoice => 'Удалить';

  @override
  String get locationPermissionTitle => 'Ваше местоположение';

  @override
  String get locationPermissionSubtitle =>
      'Разрешение на геолокацию нужно, чтобы сначала показывать кандидатов поблизости. Точный адрес никому не виден.';

  @override
  String get enableLocation => 'Включить геолокацию';

  @override
  String get skipLabel => 'Пропустить';

  @override
  String get faceTitle => 'Подтвердите лицо';

  @override
  String get faceHint => 'Сделайте селфи прямо, с открытыми глазами.';

  @override
  String get verifyFace => 'Подтвердить лицо';

  @override
  String get finishOnboarding => 'Завершить и открыть профиль';

  @override
  String get representativeFlowMessage =>
      'Для представителя предусмотрена отдельная анкета; она будет доступна позже.';

  @override
  String get representativeIntroTitle => 'Вы вошли как представитель';

  @override
  String get representativeIntroSubtitle =>
      'Представитель — близкий родственник кандидата. Вы заполняете анкету и рассматриваете предложения от его имени.';

  @override
  String get representativeConsentRequiredTitle =>
      'Требуется согласие кандидата';

  @override
  String get representativeConsentRequiredBody =>
      'После заполнения анкеты кандидату отправляется SMS. До подтверждения профиль будет скрыт.';

  @override
  String get representativeIntroFootnote =>
      'Сначала мы спросим о вас, затем о кандидате.';

  @override
  String get startLabel => 'Начать';

  @override
  String get representativeSelfSection => 'ЧАСТЬ 1 · О ВАС';

  @override
  String get representativeSelfTitle => 'О вас';

  @override
  String get representativeSelfSubtitle =>
      'Кандидат увидит это имя в запросе согласия.';

  @override
  String get representativeRelationTitle => 'Кем вы приходитесь кандидату?';

  @override
  String get representativeCandidateSection => 'ЧАСТЬ 2 · О КАНДИДАТЕ';

  @override
  String get representativeCandidateTypeTitle => 'Кто кандидат?';

  @override
  String get representativeCandidateTypeSubtitle =>
      'Все следующие вопросы относятся к кандидату, а не к вам.';

  @override
  String get representativeBrideTitle => 'Невеста';

  @override
  String get representativeBrideSubtitle => 'Кандидат-женщина';

  @override
  String get representativeGroomTitle => 'Жених';

  @override
  String get representativeGroomSubtitle => 'Кандидат-мужчина';

  @override
  String get representativeCandidateIdentityTitle => 'Имя и фамилия кандидата';

  @override
  String get representativeCandidateIdentitySubtitle =>
      'Кандидат подтвердит эти данные и сможет исправить их позже.';

  @override
  String get representativeBirthDateTitle => 'Год рождения кандидата';

  @override
  String get representativeEducationTitle => 'Образование кандидата';

  @override
  String get representativeHeightWeightTitle => 'Рост и вес кандидата';

  @override
  String get representativeHeightInputLabel => 'Рост кандидата';

  @override
  String get representativeWeightInputLabel => 'Вес кандидата';

  @override
  String get representativeLocationTitle => 'Где живёт кандидат?';

  @override
  String get representativeHealthStatusTitle => 'Состояние здоровья кандидата';

  @override
  String get representativeMaritalStatusTitle => 'Семейное положение кандидата';

  @override
  String get representativeChildrenCountLabel => 'Количество детей кандидата';

  @override
  String get representativeChildrenNotLivingTitle =>
      'Дети не живут с кандидатом';

  @override
  String get representativePhotoTitle => 'Фотографии кандидата';

  @override
  String get representativePhotoHint =>
      'До 5 фотографий. Их увидят только люди, одобренные кандидатом.';

  @override
  String get representativeMainPhotoSubtitle =>
      'Эта фотография будет первой в профиле кандидата.';

  @override
  String get representativeAboutTitle => 'О кандидате';

  @override
  String get representativeAboutSubtitle =>
      'Необязательно. Пишите о кандидате, а не о себе.';

  @override
  String get representativeAboutHint =>
      'Напишите 2–3 предложения о работе, интересах и семейных ценностях кандидата...';

  @override
  String get representativeVoiceTitle => 'Голосовое представление кандидата';

  @override
  String get representativeVoiceSubtitle =>
      'Необязательно. Кандидат сможет перезаписать его позже.';

  @override
  String get representativeLocationPermissionTitle =>
      'Местоположение кандидата';

  @override
  String get representativeLocationPermissionSubtitle =>
      'Необязательно. Точный адрес никому не показывается.';

  @override
  String get representativeConsentSection => 'ЧАСТЬ 3 · СОГЛАСИЕ';

  @override
  String get representativeContactTitle => 'Телефон кандидата';

  @override
  String get representativeContactSubtitle =>
      'На этот контакт будет отправлен запрос согласия. До подтверждения анкета скрыта.';

  @override
  String get representativeContactLabel => 'Телефон / email';

  @override
  String get representativeContactPhoneTab => 'Номер телефона';

  @override
  String get representativeContactEmailTab => 'Email';

  @override
  String get representativeContactWarningTitle =>
      'Контакт должен принадлежать кандидату';

  @override
  String get representativeContactWarningBody =>
      'Если указать свой контакт, согласие будет недействительным, а профиль может быть заблокирован.';

  @override
  String get representativeSendConsent => 'Отправить запрос согласия';

  @override
  String get representativeCandidateNoApp =>
      'Кандидат не пользуется приложением';

  @override
  String get representativeConsentSentTitle => 'Запрос отправлен';

  @override
  String representativeConsentSentSubtitle(String firstName) {
    return 'Ожидаем подтверждения от $firstName. До этого анкета скрыта.';
  }

  @override
  String get representativeSmsSentTitle => 'Кандидату отправлено SMS';

  @override
  String representativeSmsSentBody(String representativeName) {
    return '$representativeName заполнил(а) анкету от вашего имени. Вы согласны?';
  }

  @override
  String get representativeConsentRevocation =>
      'Кандидат может отозвать согласие в любое время — анкета сразу будет скрыта.';

  @override
  String get understoodLabel => 'Понятно';

  @override
  String get resendRequestLabel => 'Отправить повторно';

  @override
  String get representativePledgeTitle => 'Подтвердите ответственность';

  @override
  String get representativePledgeSubtitle =>
      'Этот шаг обязателен: вы вводите данные от имени другого человека.';

  @override
  String get representativePledgePointOne =>
      'Данные кандидата верны и внесены с его согласия.';

  @override
  String get representativePledgePointTwo =>
      'Я не буду вмешиваться в личные разговоры кандидата.';

  @override
  String get representativePledgePointThree =>
      'Я буду рассматривать предложения в интересах кандидата.';

  @override
  String get representativeReadyTitle => 'Ваш профиль готов!';

  @override
  String get representativeReadySubtitle =>
      'Всё сохранено. Теперь можно смотреть подходящих кандидатов.';

  @override
  String get representativeSetCriteria => 'Настроить критерии поиска';

  @override
  String get laterLabel => 'Позже';

  @override
  String get candidateConsentEyebrow => 'НА ТЕЛЕФОНЕ КАНДИДАТА';

  @override
  String get candidateConsentTitle => 'От вашего имени заполнили анкету';

  @override
  String candidateConsentBody(String representativeName, String relation) {
    return '$representativeName ($relation) заполнил(а) анкету для вас. Без вашего согласия она скрыта.';
  }

  @override
  String get candidateConsentApproveTitle => 'Если вы согласитесь';

  @override
  String get candidateConsentApproveBody =>
      'Анкета станет активной и начнёт получать предложения. Позже её можно редактировать.';

  @override
  String get candidateConsentRejectHint =>
      'При отказе анкета будет удалена, а представитель получит уведомление.';

  @override
  String get agreeLabel => 'Согласен(на)';

  @override
  String get rejectLabel => 'Отказать';

  @override
  String get backLabel => 'Назад';

  @override
  String get temporaryOtpHint => 'Временный адаптер: используйте код 1234';

  @override
  String get pinCreateTitle => 'Создайте короткий код';

  @override
  String get pinUnlockTitle => 'Введите PIN-код';

  @override
  String get pinHintCreate =>
      'Чтобы аккаунт оставался только вашим. Этот код нужно будет вводить при каждом входе.';

  @override
  String get pinHintUnlock =>
      'Введите PIN-код, который вы создали для этого устройства.';

  @override
  String get unlockLabel => 'Открыть';

  @override
  String get signInAsDemo => 'Войти как демо-пользователь';

  @override
  String get homeTitle => 'Главная';

  @override
  String get homeMessage => 'Основа готова для следующей функции.';

  @override
  String get logout => 'Выйти';

  @override
  String get deleteAccount => 'Удалить аккаунт';

  @override
  String get deleteAccountTitle => 'Удалить ваш аккаунт?';

  @override
  String get deleteAccountMessage =>
      'Это действие навсегда удалит ваш аккаунт и связанные данные профиля. Отменить его нельзя.';

  @override
  String get deleteAccountCancel => 'Отмена';

  @override
  String get deleteAccountConfirm => 'Удалить';

  @override
  String get retry => 'Повторить';

  @override
  String get telegramWaiting =>
      'Подтвердите номер телефона в Telegram, затем вернитесь в приложение.';

  @override
  String get candidatesTabLabel => 'Кандидаты';

  @override
  String get messagesTabLabel => 'Сообщения';

  @override
  String get servicesTabLabel => 'Услуги';

  @override
  String get savedTabLabel => 'Сохранено';

  @override
  String get profileTabLabel => 'Профиль';

  @override
  String get candidatesPlaceholder => 'Пока страница кандидатов.';

  @override
  String get messagesPlaceholder => 'Пока страница сообщений.';

  @override
  String get servicesPlaceholder => 'Пока страница услуг.';

  @override
  String get savedPlaceholder => 'Пока страница сохраненного.';

  @override
  String get profilePlaceholder => 'Пока страница профиля.';

  @override
  String get notificationsActionLabel => 'Уведомления';

  @override
  String get notificationsEmpty => 'Уведомлений пока нет';

  @override
  String get notificationsMarkAllRead => 'Отметить все как прочитанные';

  @override
  String get candidatesFilterMatches => 'Подходящие';

  @override
  String get candidatesFilterRecommended => 'Рекомендации';

  @override
  String get candidatesFilterNearby => 'Рядом';

  @override
  String get privatePhotoLabel => 'Приватное фото';

  @override
  String get matchLockedLabel => 'совпадение закрыто';

  @override
  String get genericError => 'Что-то пошло не так.';

  @override
  String get savedEmptyState => 'Сохранённых профилей пока нет.';

  @override
  String get candidateDetailRequestPhotoPermission =>
      'Запросить доступ к фотографии';

  @override
  String get candidateDetailOptionsSubtitle => 'Что вы хотите сделать?';

  @override
  String get candidateDetailSaveSubtitle =>
      'Позже найдёте в разделе «Сохранённые»';

  @override
  String get candidateDetailSaveToSaved => 'Добавить в сохранённые';

  @override
  String get candidateDetailShare => 'Поделиться профилем';

  @override
  String get candidateDetailShareSubtitle =>
      'Отправьте представителю или семье';

  @override
  String get candidateDetailPhotoPermissionSubtitle =>
      'Запрос получит кандидат и его представитель';

  @override
  String get candidateDetailReport => 'Пожаловаться';

  @override
  String get candidateDetailReportSubtitle =>
      'Модератор рассмотрит жалобу в течение 24 часов';

  @override
  String get candidateDetailBlock => 'Заблокировать профиль';

  @override
  String get candidateDetailBlockSubtitle => 'Он больше не будет вас видеть';

  @override
  String get candidateDetailCompatibilityTitle => 'Общая совместимость';

  @override
  String candidateDetailVoiceIntro(String duration) {
    return 'Голосовое знакомство · $duration';
  }

  @override
  String get candidateDetailVoiceDuration => '12 сек';

  @override
  String get candidateDetailSendProposal => 'Отправить предложение сватовства';

  @override
  String get candidateDetailSave => 'Сохранить';

  @override
  String get candidateDetailUnsave => 'Удалить из сохранённых';

  @override
  String get candidateDetailNoPhoto => 'Нет фотографии профиля';

  @override
  String get candidateDetailLastActivity => 'Последняя активность: недавно';

  @override
  String get candidateDetailCompatibilityUnavailableTitle =>
      'Совместимость не рассчитана';

  @override
  String get candidateDetailCompatibilityUnavailableDescription =>
      'Кандидат ещё не заполнил опрос из 30 вопросов, поэтому процент совместимости не показывается. Информация ниже взята из анкеты кандидата.';

  @override
  String get candidateDetailBasicInformation => 'Основная информация';

  @override
  String get candidateDetailBirthYear => 'Год рождения';

  @override
  String candidateDetailBirthYearWithAge(int birthYear, int age) {
    return '$birthYear · $age лет';
  }

  @override
  String get candidateDetailCity => 'Город';

  @override
  String get candidateDetailMaritalStatus => 'Семейное положение';

  @override
  String get candidateDetailChildren => 'Дети';

  @override
  String get candidateDetailNoChildren => 'Нет';

  @override
  String get candidateDetailHasChildren => 'Есть';

  @override
  String candidateDetailChildrenCount(int count) {
    return '$count';
  }

  @override
  String get candidateDetailEducationAndWork => 'Образование и работа';

  @override
  String get candidateDetailEducation => 'Образование';

  @override
  String get candidateDetailProfession => 'Профессия';

  @override
  String get candidateDetailLifestyle => 'Образ жизни';

  @override
  String get candidateDetailHealthStatus => 'Состояние здоровья';

  @override
  String get candidateDetailIncompleteProfileTitle =>
      'Анкета заполнена не полностью';

  @override
  String get candidateDetailIncompleteProfileDescription =>
      'Кандидат ещё не заполнил часть информации. После отправки предложения сватовства ему придёт напоминание завершить анкету.';

  @override
  String get candidateDetailAbout => 'О кандидате';

  @override
  String get candidateRequestPending => 'В процессе...';

  @override
  String get candidateRequestRetry => 'Отправить запрос повторно';

  @override
  String candidateRequestRetryAt(Object date) {
    return 'Повторный запрос: $date';
  }

  @override
  String get candidateRequestChat => 'Начать разговор';

  @override
  String get candidateRequestForwarded => 'Направлено представителю';

  @override
  String get photoRequestTitle => 'Запрос на просмотр фото';

  @override
  String get photoRequestDescription =>
      'Запрос отправляется кандидату и его представителю. Решение остаётся за ними.';

  @override
  String get photoRequestMessageHint => 'Сообщение (необязательно)';

  @override
  String get photoRequestDurationLabel => 'Срок запроса';

  @override
  String get photoRequestDurationValue => '7 дней';

  @override
  String get photoRequestRejectLabel => 'При отказе';

  @override
  String get photoRequestRejectValue => 'повторно через 7 дней';

  @override
  String get photoRequestPrivacyNote =>
      'Открытое фото видно только вам, скриншоты блокируются.';

  @override
  String get photoRequestSubmit => 'Отправить запрос';

  @override
  String get candidateProposalSentTitle => 'Предложение отправлено';

  @override
  String candidateProposalSentDescription(Object name) {
    return '$name и его представитель рассмотрят ваше предложение. Мы сообщим, когда будет ответ.';
  }

  @override
  String get candidateProposalSentTimelineSent => 'Предложение отправлено';

  @override
  String candidateProposalSentTimelineReview(Object name) {
    return '$name рассмотрит его';
  }

  @override
  String get candidateProposalSentTimelineChat => 'После ответа откроется чат';

  @override
  String get candidateProposalSentQuotaLabel => 'Предложения на этой неделе';

  @override
  String get candidateProposalSentQuotaValue => '2 / 3';

  @override
  String candidateProposalSentNote(Object remaining) {
    return 'Не расстраивайтесь, если ответа не будет — это вопрос выбора. Осталось предложений: $remaining.';
  }

  @override
  String get candidateProposalSentReturn => 'Вернуться к кандидатам';

  @override
  String get candidatePhotoPermissionSentTitle =>
      'Запрос на просмотр фото отправлен';

  @override
  String candidatePhotoPermissionSentDescription(Object name) {
    return 'Запрос на просмотр фото отправлен $name и его представителю. Мы сообщим, когда будет ответ.';
  }

  @override
  String get candidatePhotoPermissionSentReturn => 'Вернуться к профилю';

  @override
  String candidateBlockDialogTitle(String candidateName) {
    return 'Заблокировать $candidateName?';
  }

  @override
  String get candidateBlockDialogSubtitle =>
      'Они не увидят вас, и вы не увидите их. Они не узнают о блокировке.';

  @override
  String get candidateBlockPointChatClosed =>
      'Чат закроется, переписка сохранится';

  @override
  String get candidateBlockPointRemovedSaved =>
      'Будет удален(а) из сохраненных';

  @override
  String get candidateBlockPointRepresentativeBlocked =>
      'Их представитель также не сможет связаться с вами';

  @override
  String get candidateBlockAction => 'Заблокировать';

  @override
  String get candidateBlockCancel => 'Отмена';

  @override
  String get candidateBlockedTitle => 'Профиль заблокирован';

  @override
  String candidateBlockedSubtitle(String candidateName) {
    return '$candidateName больше не увидит вас.';
  }

  @override
  String get candidateBlockedWhoLabel => 'Кто';

  @override
  String get candidateBlockedTimeLabel => 'Заблокирован';

  @override
  String get candidateBlockedStatusLabel => 'Статус';

  @override
  String get candidateBlockedStatusValue => 'Заблокирован';

  @override
  String get candidateBlockedSettingsHint =>
      'Пользователь не узнает о блокировке. Разблокировать можно в Настройки → Заблокированные профили.';

  @override
  String get candidateBlockedClose => 'Закрыть';

  @override
  String get candidateReportTitle => 'Что случилось?';

  @override
  String get candidateReportSubtitle =>
      'История переписки сохранена у нас для проверки.';

  @override
  String get candidateReportTargetProfile => 'Жалоба на этот профиль';

  @override
  String get candidateReportReasonSection => 'Причина';

  @override
  String get candidateReportReasonInappropriate =>
      'Непристойные слова или фото';

  @override
  String get candidateReportReasonFake =>
      'Ложная информация или фейковый профиль';

  @override
  String get candidateReportReasonNoMarriage => 'Нет намерения вступить в брак';

  @override
  String get candidateReportReasonScam => 'Финансовое мошенничество';

  @override
  String get candidateReportReasonAbusiveLanguage => 'Непристойные слова';

  @override
  String get candidateReportReasonFakeProfile => 'Фейковый профиль';

  @override
  String get candidateReportReasonFraud => 'Мошенничество';

  @override
  String get candidateReportReasonSpam => 'Спам и реклама';

  @override
  String get candidateReportReasonFalseInformation => 'Ложная информация';

  @override
  String get candidateReportReasonThreat => 'Оскорбление или угроза';

  @override
  String get candidateReportReasonNoSeriousIntent =>
      'Нет намерения вступить в брак';

  @override
  String get candidateReportReasonOther => 'Другая причина';

  @override
  String get candidateReportNoteLabel =>
      'Дополнительный комментарий (необязательно)';

  @override
  String get candidateReportNoteHint => 'Кратко опишите, что произошло...';

  @override
  String get candidateReportSubmitAction => 'Отправить жалобу';

  @override
  String get candidateReportSubmittedTitle => 'Жалоба отправлена';

  @override
  String get candidateReportSubmittedSubtitle =>
      'Мы сообщим вам о результатах.';

  @override
  String get candidateReportNumberLabel => 'Номер обращения';

  @override
  String get candidateReportSubmittedTimeLabel => 'Отправлено';

  @override
  String get candidateReportStatusLabel => 'Статус';

  @override
  String get candidateReportStatusUnderReview => 'На рассмотрении';

  @override
  String get candidateReportStepHistoryPreserved =>
      'История переписки сохранена как доказательство';

  @override
  String get candidateReportStepModeratorReview => 'Проверка модератором';

  @override
  String get candidateReportStepDecision => 'Решение и уведомление';

  @override
  String get candidateReportNotice =>
      'Этот пользователь не сможет связаться с вами. Чат временно закрыт.';

  @override
  String get surveyPromptTitle => 'Процент совпадения закрыт';

  @override
  String get surveyPromptMessage =>
      'Ответьте на 30 вопросов — AI проанализирует ваши ответы и автоматически рассчитает совместимость с каждым кандидатом.';

  @override
  String get surveyPromptButton => 'Начать анкету';

  @override
  String get mockCandidateMohira => 'Мохира Р., 23';

  @override
  String get mockCandidateZilola => 'Зилола К., 25';

  @override
  String get mockCandidateNilufar => 'Нилуфар А., 22';

  @override
  String get mockCandidateDilnoza => 'Дилноза С., 27';

  @override
  String get mockCityTashkent => 'Ташкент';

  @override
  String get mockCitySamarkand => 'Самарканд';

  @override
  String get mockCityFergana => 'Фергана';

  @override
  String get mockCityBukhara => 'Бухара';

  @override
  String get messagesSegmentChats => 'Чаты';

  @override
  String get messagesSegmentRequests => 'Запросы';

  @override
  String get chatRoomsEmpty => 'Открытых чатов пока нет';

  @override
  String get chatThreadOpen => 'Открыть чат';

  @override
  String get chatParticipantFallback => 'Собеседник';

  @override
  String get chatSafetyNotice =>
      'Чат контролируется искусственным интеллектом — неприличные слова и изображения не пройдут.';

  @override
  String get chatIcebreakerGoal => 'Какая самая большая цель в вашей жизни?';

  @override
  String get chatIcebreakerFamily =>
      'Какую семейную традицию вы хотели бы продолжить?';

  @override
  String get chatIcebreakerBook => 'Какая книга вдохновляет вас больше всего?';

  @override
  String get chatIcebreakerChange =>
      'Расскажите об одной вещи, которую вы хотели бы изменить в своей жизни.';

  @override
  String get chatWriteMessage => 'Напишите сообщение…';

  @override
  String get chatSendMessage => 'Отправить сообщение';

  @override
  String get chatReplyTo => 'Ответить';

  @override
  String get chatReplyCancel => 'Отменить ответ';

  @override
  String get chatTyping => 'печатает…';

  @override
  String get chatOpenTimeRemaining => 'Чат открыт на 72 часа';

  @override
  String get chatMoreActions => 'Дополнительные действия';

  @override
  String get mockMessageMohiraName => 'Мохира Р.';

  @override
  String get mockMessageZilolaName => 'Зилола К.';

  @override
  String get mockMessageNilufarName => 'Нилуфар А.';

  @override
  String get mockMessageDilnozaName => 'Дилноза С.';

  @override
  String get mockMessageMohiraPreview => 'Если будет время, познакомимся.';

  @override
  String get mockMessageZilolaPreview => 'Ваше приглашение просмотрено';

  @override
  String get mockMessageNilufarPreview => 'Срок чата истек';

  @override
  String get mockMessageDilnozaPreview => 'Ожидается ответ';

  @override
  String get messageTimeYesterday => 'Вчера';

  @override
  String get messageTimeMonday => 'Пн';

  @override
  String get messageTimeTuesday => 'Вт';

  @override
  String get savedFilterAll => 'Все';

  @override
  String get savedFilterInvited => 'Приглашение отправлено';

  @override
  String get savedFilterWaiting => 'Ожидается ответ';

  @override
  String savedLimitLabel(int savedCount, int limit) {
    return '$savedCount / $limit сохранено';
  }

  @override
  String get savedPremiumCta => 'Premium — безлимит';

  @override
  String savedUpsellTitle(int remaining) {
    return 'Осталось мест: $remaining';
  }

  @override
  String get savedUpsellMessage =>
      'В бесплатном плане можно сохранить до 10 профилей. В Premium ограничений нет.';

  @override
  String get questionnaireOptionalBadge => 'Необязательный шаг';

  @override
  String questionnaireIntroTitle(int count, int minutes) {
    return '$count вопросов — $minutes минут';
  }

  @override
  String get questionnaireIntroDescription =>
      'Мы проанализируем ответы и покажем процент совместимости с каждым кандидатом. Анкету можно заполнить позже.';

  @override
  String questionnaireQuestionCount(int count) {
    return '$count вопросов';
  }

  @override
  String get questionnaireWithoutTitle => 'Что будет без анкеты?';

  @override
  String get questionnaireWithoutBody =>
      'Профиль и список кандидатов останутся доступны, но AI не рассчитает совместимость, проценты и анализ по разделам.';

  @override
  String get questionnaireStart => 'Да, начать анкету';

  @override
  String get questionnaireLater => 'Заполнить позже';

  @override
  String get questionnaireEmpty => 'Вопросов пока нет.';

  @override
  String questionnaireProgress(int current, int total) {
    return '$current/$total';
  }

  @override
  String get questionnaireNext => 'Следующий вопрос';

  @override
  String get questionnaireSubmit => 'Отправить ответы';

  @override
  String get questionnaireAnalysisTitle => 'Анализируем ваши ответы';

  @override
  String get questionnaireAnalysisBody =>
      'AI формирует профиль ценностей, финансов и характера и подбирает подходящих кандидатов.';

  @override
  String get questionnaireResultTitle => 'Ваш профиль готов!';

  @override
  String get questionnaireResultSubtitle =>
      'Совместимость, рассчитанная AI, теперь доступна.';

  @override
  String get questionnaireHonestyPill => 'Искренность: высокая';

  @override
  String get questionnaireSeriousPill => 'Серьёзные намерения';

  @override
  String questionnaireMatchedCandidates(int count) {
    return '$count подходящих кандидатов';
  }

  @override
  String get questionnaireMatchedCandidatesSubtitle =>
      'Совместимость рассчитана AI';

  @override
  String get questionnaireNextStepsTitle => 'Что будет дальше?';

  @override
  String get questionnaireAiMatchCalculatedTitle =>
      'AI рассчитал совместимость';

  @override
  String get questionnaireAiMatchCalculatedBody =>
      'Кандидаты подобраны на основе ваших ответов.';

  @override
  String get questionnaireCandidatesVeiledTitle =>
      'Кандидаты остаются под пардой';

  @override
  String get questionnaireCandidatesVeiledBody =>
      'Фотографии откроются только после согласия обеих сторон.';

  @override
  String get questionnaireConsentOnlyTitle => 'Контакт только с согласия';

  @override
  String get questionnaireConsentOnlyBody =>
      'Общение начинается с участием представителя или семьи.';

  @override
  String get questionnaireHonestyTitle => 'Индекс искренности · высокий';

  @override
  String get questionnaireHonestyBody =>
      'Ответы на проверочные вопросы последовательны. Профиль отмечен как надёжный.';

  @override
  String get questionnaireSeriousBadge => 'Получен знак «Серьёзные намерения»';

  @override
  String get questionnaireShowCandidates => 'Посмотреть кандидатов';

  @override
  String get questionnaireTraitTraditional => 'традиционный';

  @override
  String get questionnaireTraitBalanced => 'сбалансированный';

  @override
  String get candidatesViewGrid => 'В виде сетки';

  @override
  String get candidatesViewMap => 'На карте';

  @override
  String get nearbyPermissionTitle => 'Кандидаты поблизости';

  @override
  String get nearbyPermissionDescription =>
      'Ваше местоположение используется как примерная зона, а не как точная точка.';

  @override
  String get nearbyPermissionOpenSettings => 'Открыть настройки';

  @override
  String get nearbyPermissionEnableService => 'Включить геолокацию';

  @override
  String get nearbyPermissionAllow => 'Разрешить доступ к геолокации';

  @override
  String get nearbyPermissionNotNow => 'Не сейчас';

  @override
  String get nearbyPermissionFootnote =>
      'Если выбрать «Не сейчас», Совпадения и Рекомендации продолжат работать как прежде.';

  @override
  String get nearbyPermissionRuleHidden =>
      'Ваш точный адрес никому не показывается';

  @override
  String get nearbyPermissionRuleZone =>
      'Другие видят вас в примерной зоне радиусом 2 км';

  @override
  String get nearbyPermissionRuleSettings =>
      'Это можно отключить в Настройках в любое время';

  @override
  String get nearbyUnknownZone => 'Ближайшая зона';

  @override
  String nearbyCandidateCount(int count) {
    return 'Кандидатов: $count';
  }

  @override
  String nearbyZoneDistance(String zone, String distance) {
    return '$zone · ~$distance км';
  }

  @override
  String get nearbyYou => 'Вы';

  @override
  String nearbyAroundCount(int count) {
    return 'Кандидатов рядом: $count';
  }

  @override
  String get nearbyShowAll => 'Все';

  @override
  String get nearbyCloseMap => 'Закрыть карту';

  @override
  String nearbyWithinRadius(int radius) {
    return 'В радиусе $radius км';
  }

  @override
  String get nearbyRecenter => 'Вернуться к моему местоположению';

  @override
  String get nearbySettingsTitle => 'Радиус и видимость';

  @override
  String get nearbySearchRadiusLabel => 'Радиус';

  @override
  String get nearbyRadiusRange => '1–25 км';

  @override
  String nearbyRadiusOption(int radius) {
    return '$radius км';
  }

  @override
  String get nearbyEntireRegion => 'Вся область';

  @override
  String get nearbyEntireRegionUnavailable =>
      'Поиск по всей области пока недоступен';

  @override
  String get nearbyRadiusHint =>
      'Чем больше радиус, тем ниже может быть процент совместимости.';

  @override
  String get nearbyVisibilityTitle => 'Показывать меня в списке рядом';

  @override
  String get nearbyVisibilitySubtitle =>
      'Если отключить, вы тоже никого не увидите';

  @override
  String get nearbyAudienceTitle => 'Кто может видеть меня рядом';

  @override
  String get nearbyAudienceAll => 'Все кандидаты';

  @override
  String get nearbyAudienceHighMatch => 'Только совместимость выше 70%';

  @override
  String get nearbyAudienceRecommended => 'рекомендуется';

  @override
  String get nearbyAudienceRepresented => 'Только кандидаты с представителем';

  @override
  String get nearbyPrivacyZoneNote =>
      'Центр зоны случайно смещается раз в день, поэтому вычислить ваш дом невозможно.';

  @override
  String get nearbySettingsSave => 'Сохранить';

  @override
  String nearbyEmptyTitle(int radius) {
    return 'В радиусе $radius км пока нет кандидатов';
  }

  @override
  String get nearbyEmptyDescription =>
      'Увеличьте радиус или немного смягчите критерии.';

  @override
  String nearbyExpandRadius(int radius) {
    return 'Увеличить радиус до $radius км';
  }

  @override
  String get nearbyChangeCriteria => 'Изменить критерии';

  @override
  String get nearbyNotifyTitle => 'Сообщать о появлении нового кандидата';

  @override
  String get nearbyNotifySubtitle => 'Не чаще одного раза в день';

  @override
  String get profileEdit => 'Редактировать профиль';

  @override
  String get profileSettings => 'Настройки профиля';

  @override
  String profileIdentifier(String code) {
    return 'Номер пользователя: $code';
  }

  @override
  String get profilePreview => 'Как видят другие';

  @override
  String get profileCopyIdentifier => 'Скопировать номер пользователя';

  @override
  String get profileCompleteTitle => 'Заполните профиль';

  @override
  String get profileCompleteSubtitle => 'Чтобы точнее подобрать пару';

  @override
  String get profileMyPhotos => 'МОИ ФОТОГРАФИИ';

  @override
  String get profileMainPhoto => 'ГЛАВНОЕ';

  @override
  String get profileAddPhoto => 'Добавить фотографию';

  @override
  String profilePhotoSemantics(int index) {
    return 'Фотография профиля $index';
  }

  @override
  String get profilePhotoSourceTitle => 'Новое фото';

  @override
  String get profilePhotoSourceSubtitle =>
      'После загрузки фотография пройдёт проверку лица.';

  @override
  String get profilePhotoCamera => 'Сделать снимок камерой';

  @override
  String get profilePhotoGallery => 'Выбрать из галереи';

  @override
  String get profilePhotoActionsTitle => 'Фото';

  @override
  String get profilePhotoSetMain => 'Сделать главным';

  @override
  String get profilePhotoReplace => 'Заменить';

  @override
  String get profilePhotoDelete => 'Удалить';

  @override
  String get profilePhotoCancel => 'Отмена';

  @override
  String get profilePhotoDeleteTitle => 'Удалить это фото?';

  @override
  String get profilePhotoDeleteSubtitle =>
      'Фото будет удалено из профиля. Вместо него можно загрузить новое.';

  @override
  String get profileAboutSection => 'О СЕБЕ';

  @override
  String get profileNotFilled => 'Пока не заполнено';

  @override
  String get profileAdd => 'Добавить';

  @override
  String get profileEditShort => 'Изменить';

  @override
  String get profilePhotoVerification => 'Проверка фотографии';

  @override
  String get profilePhotoVerificationSubtitle =>
      'Основная фотография сравнивается с селфи с камеры';

  @override
  String get profileServices => 'Услуги';

  @override
  String get profileServicesSubtitle =>
      'Психолог, семейная встреча, проверка и Premium';

  @override
  String get profileIdentifierCopied => 'Номер пользователя скопирован';

  @override
  String get profileActionComingSoon =>
      'Этот раздел будет подключён на следующем этапе профиля';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsBack => 'Назад';

  @override
  String get settingsAccountSection => 'Аккаунт';

  @override
  String get settingsEditProfile => 'Редактировать профиль';

  @override
  String get settingsPhotoPrivacy => 'Конфиденциальность фотографий';

  @override
  String get settingsPhotoPrivacyAll => 'Видно всем';

  @override
  String get settingsBlockedUsers => 'Заблокированные пользователи';

  @override
  String get settingsRecoveryQuestion => 'Вопрос восстановления аккаунта';

  @override
  String get settingsPrivacyChatSection => 'Конфиденциальность и чат';

  @override
  String get settingsPrivacyVeil => 'Конфиденциальность и режим парды';

  @override
  String get settingsChatLimits => 'Лимиты чата';

  @override
  String get settingsChatLimitValue => '72 часа';

  @override
  String get settingsParentLink => 'Подключить родителя';

  @override
  String get settingsNotificationAppearanceSection => 'Уведомления и вид';

  @override
  String get settingsNotifications => 'Уведомления';

  @override
  String get settingsNotificationsSubtitle =>
      'Сообщать о новых лайках, совпадениях и сообщениях';

  @override
  String get settingsNotificationTypes => 'Типы уведомлений';

  @override
  String get settingsDocumentsSection => 'Документы';

  @override
  String get settingsPrivacyPolicy => 'Политика конфиденциальности';

  @override
  String get settingsTerms => 'Условия использования';

  @override
  String get settingsHelpInfoSection => 'Помощь и информация';

  @override
  String get settingsServices => 'Услуги';

  @override
  String get settingsHelpCenter => 'Центр помощи';

  @override
  String get settingsShareApp => 'Поделиться приложением';

  @override
  String get settingsLogout => 'Выйти из аккаунта';

  @override
  String get settingsActionComingSoon =>
      'Эта настройка будет подключена на следующем этапе';

  @override
  String get privacyPolicyLoadingLabel =>
      'Политика конфиденциальности загружается';

  @override
  String get privacyPolicyLoadError =>
      'Не удалось загрузить политику конфиденциальности. Проверьте подключение к интернету и повторите попытку.';

  @override
  String get termsOfServiceLoadingLabel => 'Условия использования загружаются';

  @override
  String get termsOfServiceLoadError =>
      'Не удалось загрузить условия использования. Проверьте подключение к интернету и повторите попытку.';

  @override
  String failureMessage(String type) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'networkTimeout': 'Время подключения истекло.',
      'noInternet': 'Нет подключения к интернету.',
      'unauthorized': 'Сессия истекла.',
      'cancelled': '',
      'forbidden': 'Доступ запрещен.',
      'notFound': 'Данные не найдены.',
      'validation': 'Проверьте введенные данные.',
      'configuration': 'Вход через Google не настроен для этой сборки.',
      'unsupported': 'Этот способ входа пока недоступен.',
      'server': 'Произошла ошибка сервера.',
      'unknown': 'Что-то пошло не так.',
      'other': 'Что-то пошло не так.',
    });
    return '$_temp0';
  }

  @override
  String get profileEditTitle => 'Редактировать профиль';

  @override
  String get profileEditAvatarTitle => 'Фото профиля';

  @override
  String get profileEditChangePhoto => 'Изменить фото';

  @override
  String get profilePhotoManagementTitle => 'Главное фото';

  @override
  String get profilePhotoManagementSubtitle =>
      'Это фото будет первым в профиле и списке кандидатов. При проверке селфи оно используется для сравнения.';

  @override
  String get profilePhotoConfirm => 'Подтвердить';

  @override
  String get profileFaceVerificationDone => 'Продолжить';

  @override
  String get profileEditName => 'Имя';

  @override
  String get profileEditBirthYear => 'Год рождения';

  @override
  String get profileEditHeight => 'Рост';

  @override
  String get profileEditWeight => 'Вес';

  @override
  String get profileEditEducation => 'Образование';

  @override
  String get profileEditProfession => 'Профессия';

  @override
  String get profileEditRegion => 'Область';

  @override
  String get profileEditDistrict => 'Район';

  @override
  String get profileEditMaritalStatus => 'Семейное положение';

  @override
  String get profileEditAboutSection => 'О СЕБЕ';

  @override
  String get profileEditAboutPlaceholder =>
      'Напишите коротко о себе, своих ценностях и планах на будущее…';

  @override
  String get profileEditSave => 'Сохранить';

  @override
  String get profileEditCancel => 'Отмена';

  @override
  String get profileEditSuccess => 'Профиль успешно сохранен';

  @override
  String get profileEditFirstName => 'Имя';

  @override
  String get profileEditLastName => 'Фамилия';

  @override
  String get profileEditSelect => 'Выбрать';

  @override
  String get profileEditSelectOption => 'Выбрать';

  @override
  String get profileEditProfessionOther => 'Другое';

  @override
  String get profileEditProfessionInputLabel => 'Введите профессию';

  @override
  String get profileEditSearchPlaceholder => 'Поиск...';

  @override
  String get profileEditRegionSearchHint => 'Поиск области...';

  @override
  String get profileEditDistrictSearchHint => 'Поиск района...';

  @override
  String profileEditDistrictRegionCaption(String region) {
    return 'По $region';
  }

  @override
  String get profileEditNoOptions => 'Ничего не найдено';

  @override
  String profileEditCm(int cm) {
    return '$cm см';
  }

  @override
  String profileEditKg(int kg) {
    return '$kg кг';
  }

  @override
  String get profileEditSelectRegionFirst => 'Сначала выберите область';

  @override
  String get profileEditDiscardConfirmTitle => 'Отменить изменения?';

  @override
  String get profileEditDiscardConfirmMessage =>
      'Несохраненные данные будут потеряны.';

  @override
  String get profileEditDiscard => 'Отменить';

  @override
  String get profileEditKeepEditing => 'Остаться';

  @override
  String get profileEditUnsavedTitle => 'Изменения не сохранены';

  @override
  String get profileEditUnsavedMessage =>
      'Если выйти, внесенные изменения будут потеряны.';

  @override
  String get profileEditStayEditing => 'Остаться в редактировании';

  @override
  String get profileEditExit => 'Выйти';

  @override
  String get profileEditUpdatedTitle => 'Профиль обновлен';

  @override
  String get profileEditUpdatedMessage =>
      'Изменения сохранены. Кандидаты увидят ваш профиль в обновленном виде.';

  @override
  String get profileEditUpdatedOk => 'Хорошо';

  @override
  String get blockedUsersTitle => 'Заблокированные профили';

  @override
  String get blockedUsersSubtitle =>
      'Заблокированные профили не видят вас в поиске и не могут писать.';

  @override
  String get blockedUsersEmpty => 'Нет заблокированных профилей';

  @override
  String get blockedUsersEmptySubtitle =>
      'Все заблокированные вами профили будут отображаться здесь.';

  @override
  String get blockedUsersNote =>
      'Профиль, на который подана жалоба, автоматически блокируется после проверки модератором — в этом списке помечается «После жалобы».';

  @override
  String blockedAtDate(String date) {
    return 'Заблокирован(а) $date';
  }

  @override
  String get blockedAfterComplaint => 'Заблокирован(а) после жалобы';

  @override
  String get unblockButton => 'Разблокировать';

  @override
  String get unblockSuccess => 'Пользователь разблокирован';

  @override
  String get unblockConfirmTitle => 'Разблокировать профиль?';

  @override
  String get unblockConfirmMessage =>
      'Этот профиль снова сможет писать вам и просматривать ваш профиль.';

  @override
  String get cancel => 'Отмена';

  @override
  String get accountDeletionTitle => 'Удалить аккаунт';

  @override
  String get accountDeletionWarningTitle => 'Это действие нельзя отменить';

  @override
  String get accountDeletionWarningMessage =>
      'После удаления профиль невозможно восстановить.';

  @override
  String get accountDeletionItemsTitle => 'ЧТО БУДЕТ УДАЛЕНО';

  @override
  String get accountDeletionPhotos =>
      'Все фотографии и голосовое представление';

  @override
  String get accountDeletionQuestionnaire =>
      'Ответы анкеты и результаты совместимости';

  @override
  String get accountDeletionChats => 'Чаты и сохранённые профили';

  @override
  String get accountDeletionRepresentative => 'Связь с вашим представителем';

  @override
  String get accountDeletionReasonTitle => 'ПРИЧИНА (НЕОБЯЗАТЕЛЬНО)';

  @override
  String get accountDeletionReasonFoundMatch => 'Я нашёл(ла) пару';

  @override
  String get accountDeletionReasonNoTime => 'Сейчас нет времени';

  @override
  String get accountDeletionReasonPrivacy =>
      'Есть вопросы по конфиденциальности';

  @override
  String get accountDeletionConfirm => 'Удалить аккаунт';

  @override
  String get accountDeletionCancel => 'Отмена';
}
