// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Uzbek (`uz`).
class AppLocalizationsUz extends AppLocalizations {
  AppLocalizationsUz([String locale = 'uz']) : super(locale);

  @override
  String get faceCaptureTitle => 'Bir marta selfi olamiz';

  @override
  String get faceCaptureSubtitle =>
      'Asosiy suratingiz bilan solishtiramiz. Hech kimga ko‘rinmaydi va tekshiruvdan keyin o‘chiriladi.';

  @override
  String get selfieCameraLabel => 'selfi kamera';

  @override
  String get faceRuleOne => 'Yuzingizni doira ichiga joylashtiring.';

  @override
  String get faceRuleTwo => 'Yuzingiz yaxshi ko‘rinsin — shu yetarli.';

  @override
  String get faceRuleThree => 'Telefonni ko‘z darajasida ushlang.';

  @override
  String get takeSelfieLabel => 'Selfi olish';

  @override
  String get aboutMeTitle => 'O‘zingiz haqingizda';

  @override
  String get aboutMeSubtitle =>
      'Ixtiyoriy. Qisqacha yozing — nomzodlar shuni o‘qiydi.';

  @override
  String get aboutMeHint =>
      'O‘zingiz, kasbingiz va oilaviy qadriyatlaringiz haqida 2–3 gap...';

  @override
  String aboutMeCounter(int count) {
    return '$count / 300 belgi';
  }

  @override
  String get mainPhotoSelectionHint => 'Asosiy suratni tanlang';

  @override
  String get mainPhotoSubtitle =>
      'Profilingizda birinchi shu surat ko‘rinadi va selfi bilan solishtiriladi.';

  @override
  String get mainPhotoBadge => 'ASOSIY';

  @override
  String get faceRetryHint => 'Selfi mos kelmadi. Qayta urinib ko‘ring.';

  @override
  String get faceCameraError => 'Kamera ishga tushmadi.';

  @override
  String get onboardingSuccessTitle => 'Profillingiz tayyor!';

  @override
  String get onboardingSuccessSubtitle =>
      'Hammasi saqlandi. Endi sizga mos nomzodlarni ko‘rishingiz mumkin.';

  @override
  String get pledgeConfirmationTitle => 'Niyatingizni tasdiqlang';

  @override
  String get pledgeConfirmationSubtitle =>
      'Bu qadam majburiy. Tasdiqlagach profilingizda «Niyati jiddiy» belgisi paydo bo‘ladi.';

  @override
  String get pledgeConfirmationPointOne =>
      'Ma’lumotlarim to‘g‘ri va o‘zimga tegishli.';

  @override
  String get pledgeConfirmationPointTwo =>
      'Niyatim jiddiy — oila qurish uchun keldim.';

  @override
  String get pledgeConfirmationPointThree =>
      'Suhbatdoshga hurmat bilan munosabatda bo‘laman.';

  @override
  String get pledgeConfirmationButton => 'Qasamni tasdiqlash';

  @override
  String get privacyPolicyAgreementSuffix => ' bilan tanishing';

  @override
  String get aiTestBadge => 'AI MOSLIK TESTI';

  @override
  String get aiTestTitle => '30 ta savolga javob berasizmi?';

  @override
  String get aiTestDescription =>
      'Javoblaringiz asosida har bir nomzod bilan qanchalik mos kelishingizni hisoblaymiz. Taxminan 8 daqiqa.';

  @override
  String get aiTestPointOne => 'AI tahlili — 8 daqiqada tayyor';

  @override
  String get aiTestPointTwo => 'Mos juftlar avtomatik tanlanadi';

  @override
  String get aiTestPointThree => 'Javoblaringiz hech kimga ko‘rsatilmaydi';

  @override
  String get startAiTest => 'Ha, testni boshlayman';

  @override
  String get viewCandidatesLater => 'Keyinroq — avval nomzodlarni ko‘raman';

  @override
  String get appTitle => 'Raqamli Sovchi';

  @override
  String get loading => 'Yuklanmoqda...';

  @override
  String get splashSubtitle => 'Shoshilmasdan, oila bilan';

  @override
  String get loginTitle => 'Xush kelibsiz';

  @override
  String get loginHeadline => 'Shoshilmasdan,\noila bilan';

  @override
  String get loginSubtitle => 'Telefon raqamingiz bilan boshlaymiz';

  @override
  String get phoneLabel => 'Telefon raqam';

  @override
  String get phoneError => 'Telefon raqamni toʻgʻri kiriting.';

  @override
  String get continueLabel => 'Davom etish';

  @override
  String get orLabel => 'yoki';

  @override
  String get loginNote =>
      'Raqamingizni hech kim koʻrmaydi. Har bir profil qoʻlda tekshiriladi. Bu yerda faqat nikoh niyatidagilar qoladi.';

  @override
  String get otpTitle => 'Kodni kiriting';

  @override
  String otpSentTo(String phone) {
    return '$phone raqamiga 4 xonali kod yubordik';
  }

  @override
  String get otpResend => 'Kod kelmadimi? 00:48 dan keyin qayta yuboramiz';

  @override
  String get confirmLabel => 'Tasdiqlash';

  @override
  String get candidateTypeTitle => 'Kim sifatida qidiryapsiz?';

  @override
  String get candidateTypeSubtitle =>
      'Bu tanlov anketangiz qanday bo‘lishini belgilaydi. Jinsni qayta so‘ramaymiz.';

  @override
  String get groomCandidateTitle => 'Kuyov nomzodi';

  @override
  String get groomCandidateSubtitle => 'Erkakman, o‘zim uchun izlayapman';

  @override
  String get brideCandidateTitle => 'Kelin nomzodi';

  @override
  String get brideCandidateSubtitle => 'Ayolman, o‘zim uchun izlayapman';

  @override
  String get representativeCandidateTitle => 'Vakil';

  @override
  String get representativeCandidateSubtitle =>
      'Yaqinim nomidan ariza to‘ldiraman';

  @override
  String get pledgeTitle => 'Bir-birimizga ishonch uchun';

  @override
  String get pledgePointOne => 'Bu ilovadan faqat nikoh niyatida foydalanaman.';

  @override
  String get pledgePointTwo => 'Ma’lumotlarim to‘g‘ri, suratlar o‘zimniki.';

  @override
  String get pledgePointThree =>
      'Suhbatda odob saqlayman. AI moderator nazoratiga roziman.';

  @override
  String get pledgeAgreement =>
      'Roziman. Profilimda «Niyati jiddiy» belgisi ko‘rinsin.';

  @override
  String get pledgeStart => 'Anketani boshlash';

  @override
  String onboardingProgress(Object current, Object total) {
    return '$total bosqichdan $current-bosqich';
  }

  @override
  String get birthDateTitle => 'Tug‘ilgan yilingiz';

  @override
  String get birthDateHint =>
      '18 yoshdan kichik foydalanuvchilar ro‘yxatdan o‘ta olmaydi.';

  @override
  String get birthDateSubtitle =>
      'Yoshingiz nomzodlarga ko‘rinadi, aniq sana emas.';

  @override
  String get identityTitle => 'Ismingiz va familiyangiz';

  @override
  String get identitySubtitle =>
      'Pasportdagidek yozing — nomzodlar shu ismni ko‘radi.';

  @override
  String get firstNameLabel => 'Ismingiz';

  @override
  String get lastNameLabel => 'Familiyangiz';

  @override
  String get patronymicLabel => 'Otasining ismi (ixtiyoriy)';

  @override
  String get professionTitle => 'Kasbingiz?';

  @override
  String get professionOther => 'Boshqa';

  @override
  String get professionInputLabel => 'Kasbingizni yozing';

  @override
  String get professionEmpty => 'Kasblar topilmadi.';

  @override
  String get representativeProfessionTitle => 'Nomzodning kasbi?';

  @override
  String get representativeProfessionInputLabel => 'Nomzodning kasbini yozing';

  @override
  String get educationTitle => 'Ma’lumotingiz qanday?';

  @override
  String get heightTitle => 'Bo‘yingiz';

  @override
  String get heightWeightTitle => 'Bo‘yingiz va vazningiz';

  @override
  String get heightLabel => 'Bo‘yi (sm)';

  @override
  String get heightInputLabel => 'Bo‘yingiz';

  @override
  String get heightUnit => 'sm';

  @override
  String get weightLabel => 'Vazni (kg)';

  @override
  String get weightInputLabel => 'Vazningiz';

  @override
  String get weightUnit => 'kg';

  @override
  String get decreaseHeightLabel => 'Bo‘yni kamaytirish';

  @override
  String get increaseHeightLabel => 'Bo‘yni oshirish';

  @override
  String get decreaseWeightLabel => 'Vaznni kamaytirish';

  @override
  String get increaseWeightLabel => 'Vaznni oshirish';

  @override
  String get locationTitle => 'Qayerda yashaysiz?';

  @override
  String get regionLabel => 'Viloyat';

  @override
  String get districtLabel => 'Tuman yoki shahar';

  @override
  String get regionSheetTitle => 'Viloyatni tanlang';

  @override
  String regionSheetCount(Object count) {
    return '$count ta hudud';
  }

  @override
  String get districtSheetTitle => 'Tuman / shaharni tanlang';

  @override
  String districtSheetSubtitle(Object count, Object region) {
    return '$region · $count ta tuman';
  }

  @override
  String get locationSearchPlaceholder => 'Tuman nomi bo‘yicha qidirish';

  @override
  String get selectLabel => 'Tanlash';

  @override
  String get unselectedValue => 'Tanlanmagan';

  @override
  String get selectRegionFirstValue => 'Avval viloyatni tanlang';

  @override
  String get healthStatusTitle => 'Sog‘liqlik darajangiz';

  @override
  String get healthStatusSubtitle =>
      'Bu ma’lumot faqat moslikni hisoblashda ishlatiladi.';

  @override
  String get healthHealthyLabel => 'Sog‘lom';

  @override
  String get healthDisabilityLabel => 'Nogironligi bor';

  @override
  String get healthDisabilityHint =>
      'Keyingi qadamda qisqacha izohlashingiz mumkin';

  @override
  String get maritalStatusTitle => 'Oilaviy holatingiz';

  @override
  String get maritalStatusDivorcedHint =>
      '«Ajrashgan» tanlanganda farzandlar soni majburiy bo‘ladi.';

  @override
  String get maritalStatusFirstMarriageDetail => 'Avval turmush qurmagan';

  @override
  String get maritalStatusDivorcedDetail => 'Farzandlar soni so‘raladi';

  @override
  String get childrenCountLabel => 'Farzandlaringiz soni';

  @override
  String get decreaseChildrenLabel => 'Farzandlar sonini kamaytirish';

  @override
  String get increaseChildrenLabel => 'Farzandlar sonini oshirish';

  @override
  String get childrenNotLivingTitle => 'Farzandlar men bilan yashamaydi';

  @override
  String get childrenNotLivingDetail =>
      'Profilda «farzandi bor» deb ko‘rsatiladi, tafsilot yozilmaydi';

  @override
  String get photoTitle => 'Suratlaringizni qo‘shing';

  @override
  String get photoHint =>
      '5 tagacha surat. Ularni faqat siz ruxsat bergan odam ko‘radi.';

  @override
  String get photoPrivacyHint =>
      'Kamida 1 ta surat kerak. Yuz aniq ko‘rinishi shart.';

  @override
  String get photoSlotAddLabel => 'surat';

  @override
  String photoSlotFilledLabel(int order) {
    return 'surat $order ✓';
  }

  @override
  String get addPhoto => 'Surat qo‘shish';

  @override
  String get setMainPhoto => 'Asosiy qilish';

  @override
  String get removePhoto => 'O‘chirish';

  @override
  String get voiceTitle => 'Ovozli tanishtiruv';

  @override
  String get voiceHint => 'AAC/M4A formatda 30 soniyagacha yozing.';

  @override
  String get voiceShortHint =>
      '10–15 soniya yetarli. Ovoz odam haqida suratdan ko‘ra ko‘proq narsani aytadi.';

  @override
  String get startRecording => 'Yozishni boshlash';

  @override
  String get stopRecording => 'Yozishni to‘xtatish';

  @override
  String get playRecording => 'Yozuvni eshitish';

  @override
  String get voiceSubtitle =>
      'Ixtiyoriy. 10–15 soniya yetarli — ovoz odam haqida ko‘proq narsani aytadi.';

  @override
  String get startRecordingHint => 'Yozishni boshlash uchun bosing';

  @override
  String get recordedVoiceHint =>
      'Eshitib ko‘ring. Yoqmasa qayta yozing yoki o‘chiring — ovoz ixtiyoriy.';

  @override
  String get reRecordVoice => 'Qayta yozish';

  @override
  String get deleteVoice => 'O‘chirish';

  @override
  String get locationPermissionTitle => 'Joylashuvingiz';

  @override
  String get locationPermissionSubtitle =>
      'Yaqin hududdagi nomzodlarni birinchi ko‘rsatish uchun joylashuv ruxsati kerak. Aniq manzil hech kimga ko‘rinmaydi.';

  @override
  String get enableLocation => 'Joylashuvni yoqish';

  @override
  String get skipLabel => 'O‘tkazib yuborish';

  @override
  String get faceTitle => 'Yuzingizni tasdiqlang';

  @override
  String get faceHint =>
      'Yuzingiz to‘g‘ri qaragan va ko‘zlaringiz ochiq holda selfie oling.';

  @override
  String get verifyFace => 'Yuzni tasdiqlash';

  @override
  String get finishOnboarding => 'Yakunlash va profilni ochish';

  @override
  String get representativeFlowMessage =>
      'Vakil oqimi alohida anketa bo‘lib, keyinroq ochiladi.';

  @override
  String get representativeIntroTitle => 'Siz vakil sifatida kirdingiz';

  @override
  String get representativeIntroSubtitle =>
      'Vakil — nomzodning yaqin qarindoshi: amma, xola, amaki yoki tog‘a. Siz uning nomidan anketa to‘ldirasiz va kelgan takliflarni ko‘rib chiqasiz.';

  @override
  String get representativeConsentRequiredTitle => 'Nomzodning roziligi shart';

  @override
  String get representativeConsentRequiredBody =>
      'Anketa to‘ldirilgach nomzodga SMS yuboriladi. U tasdiqlamaguncha profil hech kimga ko‘rinmaydi.';

  @override
  String get representativeIntroFootnote =>
      'Keyingi qadamlarda avval o‘zingiz haqingizda, so‘ng nomzod haqida ma’lumot so‘raymiz.';

  @override
  String get startLabel => 'Boshlash';

  @override
  String get representativeSelfSection => '1-QISM · SIZ HAQINGIZDA';

  @override
  String get representativeSelfTitle => 'O‘zingiz haqingizda';

  @override
  String get representativeSelfSubtitle =>
      'Nomzod rozilik so‘rovida shu ismni ko‘radi.';

  @override
  String get representativeRelationTitle => 'Nomzodga kimsiz?';

  @override
  String get representativeCandidateSection => '2-QISM · NOMZOD HAQIDA';

  @override
  String get representativeCandidateTypeTitle => 'Nomzod kim?';

  @override
  String get representativeCandidateTypeSubtitle =>
      'Shundan keyingi barcha savollar nomzod haqida bo‘ladi — o‘zingiz haqingizda emas.';

  @override
  String get representativeBrideTitle => 'Kelin';

  @override
  String get representativeBrideSubtitle => 'Ayol nomzod';

  @override
  String get representativeGroomTitle => 'Kuyov';

  @override
  String get representativeGroomSubtitle => 'Erkak nomzod';

  @override
  String get representativeCandidateIdentityTitle =>
      'Nomzodning ismi va familiyasi';

  @override
  String get representativeCandidateIdentitySubtitle =>
      'Bu ma’lumotlarni nomzodning o‘zi tasdiqlaydi. Xato bo‘lsa, keyin tuzatish mumkin.';

  @override
  String get representativeBirthDateTitle => 'Nomzod tug‘ilgan yili';

  @override
  String get representativeEducationTitle => 'Nomzodning ma’lumoti';

  @override
  String get representativeHeightWeightTitle => 'Nomzodning bo‘yi va vazni';

  @override
  String get representativeHeightInputLabel => 'Nomzodning bo‘yi';

  @override
  String get representativeWeightInputLabel => 'Nomzodning vazni';

  @override
  String get representativeLocationTitle => 'Nomzod qayerda yashaydi?';

  @override
  String get representativeHealthStatusTitle =>
      'Nomzodning sog‘liqlik darajasi';

  @override
  String get representativeMaritalStatusTitle => 'Nomzodning oilaviy holati';

  @override
  String get representativeChildrenCountLabel => 'Nomzodning farzandlari soni';

  @override
  String get representativeChildrenNotLivingTitle =>
      'Farzandlar nomzod bilan yashamaydi';

  @override
  String get representativePhotoTitle => 'Nomzodning suratlari';

  @override
  String get representativePhotoHint =>
      '5 tagacha surat. Ularni faqat nomzod ruxsat bergan odam ko‘radi.';

  @override
  String get representativeMainPhotoSubtitle =>
      'Nomzod profilida birinchi shu surat ko‘rinadi.';

  @override
  String get representativeAboutTitle => 'Nomzod haqida';

  @override
  String get representativeAboutSubtitle =>
      'Ixtiyoriy. Savollar nomzod haqida — o‘zingiz haqingizda emas.';

  @override
  String get representativeAboutHint =>
      'Nomzodning kasbi, qiziqishlari va oilaviy qadriyatlari haqida 2–3 gap...';

  @override
  String get representativeVoiceTitle => 'Nomzodning ovozli izohi';

  @override
  String get representativeVoiceSubtitle =>
      'Ixtiyoriy. Nomzod keyin o‘zi qayta yozishi mumkin.';

  @override
  String get representativeLocationPermissionTitle => 'Nomzodning joylashuvi';

  @override
  String get representativeLocationPermissionSubtitle =>
      'Ixtiyoriy. Aniq manzil hech kimga ko‘rinmaydi.';

  @override
  String get representativeConsentSection => '3-QISM · ROZILIK';

  @override
  String get representativeContactTitle => 'Nomzodning telefon raqami';

  @override
  String get representativeContactSubtitle =>
      'Shu raqamga rozilik so‘rovi yuboriladi. Nomzod tasdiqlamaguncha anketa hech kimga ko‘rinmaydi.';

  @override
  String get representativeContactLabel => 'Telefon raqami / email';

  @override
  String get representativeContactWarningTitle =>
      'Raqam nomzodniki bo‘lishi shart';

  @override
  String get representativeContactWarningBody =>
      'O‘z raqamingizni kiritsangiz, rozilik haqiqiy hisoblanmaydi va profil bloklanadi.';

  @override
  String get representativeSendConsent => 'Rozilik so‘rovini yuborish';

  @override
  String get representativeCandidateNoApp => 'Nomzod ilovadan foydalanmaydi';

  @override
  String get representativeConsentSentTitle => 'So‘rov yuborildi';

  @override
  String representativeConsentSentSubtitle(String firstName) {
    return '$firstName tasdiqlashi kutilmoqda. Tasdiqlangunga qadar anketa yashirin.';
  }

  @override
  String get representativeSmsSentTitle => 'Nomzodga SMS ketdi';

  @override
  String representativeSmsSentBody(String representativeName) {
    return '$representativeName sizning nomingizdan anketa to‘ldirdi. Rozimisiz?';
  }

  @override
  String get representativeConsentRevocation =>
      'Nomzod rozilikni istalgan vaqtda qaytarib olishi mumkin — shunda anketa darhol yashiriladi.';

  @override
  String get understoodLabel => 'Tushunarli';

  @override
  String get resendRequestLabel => 'So‘rovni qayta yuborish';

  @override
  String get representativePledgeTitle => 'Mas’uliyatni tasdiqlang';

  @override
  String get representativePledgeSubtitle =>
      'Bu qadam majburiy. Siz boshqa odam nomidan ma’lumot kiritayapsiz.';

  @override
  String get representativePledgePointOne =>
      'Nomzod haqidagi ma’lumotlar to‘g‘ri va uning roziligi bilan kiritildi.';

  @override
  String get representativePledgePointTwo =>
      'Nomzodning shaxsiy suhbatlariga aralashmayman.';

  @override
  String get representativePledgePointThree =>
      'Taklif va so‘rovlarni nomzod manfaatida ko‘rib chiqaman.';

  @override
  String get representativeReadyTitle => 'Profillingiz tayyor!';

  @override
  String get representativeReadySubtitle =>
      'Hammasi saqlandi. Endi sizga mos nomzodlarni ko‘rishingiz mumkin.';

  @override
  String get representativeSetCriteria => 'Qidiruv mezonlarini sozlash';

  @override
  String get laterLabel => 'Keyinroq';

  @override
  String get candidateConsentEyebrow => 'NOMZOD TELEFONIDA';

  @override
  String get candidateConsentTitle => 'Sizning nomingizdan anketa to‘ldirildi';

  @override
  String candidateConsentBody(String representativeName, String relation) {
    return '$representativeName ($relation) siz uchun anketa to‘ldirdi. Roziligingizsiz u hech kimga ko‘rinmaydi.';
  }

  @override
  String get candidateConsentApproveTitle => 'Rozilik bersangiz';

  @override
  String get candidateConsentApproveBody =>
      'Anketa faollashadi, takliflar kela boshlaydi. Keyin o‘zingiz tahrirlashingiz mumkin.';

  @override
  String get candidateConsentRejectHint =>
      'Rad etsangiz anketa o‘chiriladi va vakilga xabar beriladi.';

  @override
  String get agreeLabel => 'Roziman';

  @override
  String get rejectLabel => 'Rad etaman';

  @override
  String get backLabel => 'Orqaga';

  @override
  String get temporaryOtpHint =>
      'Vaqtinchalik adapter: 1234 kodidan foydalaning';

  @override
  String get pinCreateTitle => 'Qisqa kod oʻylab toping';

  @override
  String get pinUnlockTitle => 'PIN-kodni kiriting';

  @override
  String get pinHintCreate =>
      'Hisobingiz faqat sizniki boʻlib qolishi uchun. Har safar kirishda shu kodni terasiz.';

  @override
  String get pinHintUnlock =>
      'Bu qurilma uchun yaratgan PIN-kodingizni kiriting.';

  @override
  String get unlockLabel => 'Ochish';

  @override
  String get signInAsDemo => 'Demo sifatida kirish';

  @override
  String get homeTitle => 'Bosh sahifa';

  @override
  String get homeMessage => 'Foundation keyingi feature uchun tayyor.';

  @override
  String get logout => 'Chiqish';

  @override
  String get deleteAccount => 'Hisobni oʻchirish';

  @override
  String get deleteAccountTitle => 'Hisobingiz oʻchirilsinmi?';

  @override
  String get deleteAccountMessage =>
      'Bu amal hisobingiz va unga bogʻliq profil maʼlumotlarini oʻchiradi. Amalni ortga qaytarib boʻlmaydi.';

  @override
  String get deleteAccountCancel => 'Bekor qilish';

  @override
  String get deleteAccountConfirm => 'Oʻchirish';

  @override
  String get retry => 'Qayta urinish';

  @override
  String get telegramWaiting =>
      'Telegramda telefon raqamingizni tasdiqlang, keyin ilovaga qayting.';

  @override
  String get candidatesTabLabel => 'Nomzodlar';

  @override
  String get messagesTabLabel => 'Xabarlar';

  @override
  String get servicesTabLabel => 'Xizmatlar';

  @override
  String get savedTabLabel => 'Saqlangan';

  @override
  String get profileTabLabel => 'Profil';

  @override
  String get candidatesPlaceholder => 'Hozircha nomzodlar sahifasi.';

  @override
  String get messagesPlaceholder => 'Hozircha xabarlar sahifasi.';

  @override
  String get servicesPlaceholder => 'Hozircha xizmatlar sahifasi.';

  @override
  String get savedPlaceholder => 'Hozircha saqlanganlar sahifasi.';

  @override
  String get profilePlaceholder => 'Hozircha profil sahifasi.';

  @override
  String get notificationsActionLabel => 'Bildirishnomalar';

  @override
  String get notificationsEmpty => 'Hozircha bildirishnomalar yo‘q';

  @override
  String get notificationsMarkAllRead => 'Barchasini o‘qilgan deb belgilash';

  @override
  String get candidatesFilterMatches => 'Moslar';

  @override
  String get candidatesFilterRecommended => 'Tavsiyalar';

  @override
  String get candidatesFilterNearby => 'Yaqinlar';

  @override
  String get privatePhotoLabel => 'Maxfiy rasm';

  @override
  String get matchLockedLabel => 'moslik yopiq';

  @override
  String get genericError => 'Nimadir xato ketdi.';

  @override
  String get savedEmptyState => 'Hozircha saqlangan profil yo‘q.';

  @override
  String get candidateDetailRequestPhotoPermission =>
      'Rasmni ko‘rish uchun ruxsat so‘rash';

  @override
  String get candidateDetailOptionsSubtitle => 'Nima qilmoqchisiz?';

  @override
  String get candidateDetailSaveSubtitle =>
      'Keyin «Saqlangan» bo‘limidan topasiz';

  @override
  String get candidateDetailSaveToSaved => 'Saqlanganlarga qo‘shish';

  @override
  String get candidateDetailShare => 'Profilni ulashish';

  @override
  String get candidateDetailShareSubtitle =>
      'Vakilingizga yoki oilangizga yuboring';

  @override
  String get candidateDetailPhotoPermissionSubtitle =>
      'So‘rov nomzodga va uning vakiliga boradi';

  @override
  String get candidateDetailReport => 'Shikoyat qilish';

  @override
  String get candidateDetailReportSubtitle =>
      'Moderator 24 soat ichida ko‘radi';

  @override
  String get candidateDetailBlock => 'Profilni bloklash';

  @override
  String get candidateDetailBlockSubtitle => 'U sizni boshqa ko‘rmaydi';

  @override
  String get candidateDetailCompatibilityTitle => 'Umumiy moslik';

  @override
  String candidateDetailVoiceIntro(String duration) {
    return 'Ovozli tanishtiruv · $duration';
  }

  @override
  String get candidateDetailVoiceDuration => '12 sek';

  @override
  String get candidateDetailSendProposal => 'Sovchi taklifi yuborish';

  @override
  String get candidateDetailSave => 'Saqlash';

  @override
  String get candidateDetailUnsave => 'Saqlanganlardan olib tashlash';

  @override
  String get candidateDetailNoPhoto => 'Profil rasmi yo‘q';

  @override
  String get candidateDetailLastActivity => 'Oxirgi faollik: yaqinda';

  @override
  String get candidateDetailCompatibilityUnavailableTitle =>
      'Moslik hisoblanmagan';

  @override
  String get candidateDetailCompatibilityUnavailableDescription =>
      'Nomzod 30 savollik so‘rovnomani hali to‘ldirmagan — shu sababli moslik foizi ko‘rsatilmaydi. Quyidagi ma’lumotlar nomzod anketasidan olingan.';

  @override
  String get candidateDetailBasicInformation => 'Asosiy ma’lumotlar';

  @override
  String get candidateDetailBirthYear => 'Tug‘ilgan yili';

  @override
  String candidateDetailBirthYearWithAge(int birthYear, int age) {
    return '$birthYear · $age yosh';
  }

  @override
  String get candidateDetailCity => 'Shahar';

  @override
  String get candidateDetailMaritalStatus => 'Oilaviy holati';

  @override
  String get candidateDetailChildren => 'Farzandlari';

  @override
  String get candidateDetailNoChildren => 'Yo‘q';

  @override
  String get candidateDetailHasChildren => 'Bor';

  @override
  String candidateDetailChildrenCount(int count) {
    return '$count ta';
  }

  @override
  String get candidateDetailEducationAndWork => 'Ta’lim va ish';

  @override
  String get candidateDetailEducation => 'Ma’lumoti';

  @override
  String get candidateDetailAdditionalInformation => 'Qo‘shimcha ma’lumotlar';

  @override
  String get candidateDetailHealthStatus => 'Sog‘lig‘i';

  @override
  String get candidateDetailIncompleteProfileTitle => 'Anketa to‘liq emas';

  @override
  String get candidateDetailIncompleteProfileDescription =>
      'Nomzod ayrim ma’lumotlarni hali to‘ldirmagan. Sovchi taklifi yuborilganda unga anketani to‘ldirish eslatmasi boradi.';

  @override
  String get candidateDetailAbout => 'Nomzod haqida';

  @override
  String get candidateRequestPending => 'Jarayonda...';

  @override
  String get candidateRequestRetry => 'Qayta so‘rov yuborish';

  @override
  String candidateRequestRetryAt(Object date) {
    return 'Qayta so‘rov yuborish: $date';
  }

  @override
  String get candidateRequestChat => 'Suhbatlashish';

  @override
  String get candidateRequestForwarded => 'Vakilga yo‘naltirildi';

  @override
  String get photoRequestTitle => 'Rasm ko‘rish so‘rovi';

  @override
  String get photoRequestDescription =>
      'So‘rov nomzodga va uning vakiliga yuboriladi. Qaror faqat ularga tegishli.';

  @override
  String get photoRequestMessageHint => 'Xabar (ixtiyoriy)';

  @override
  String get photoRequestDurationLabel => 'So‘rov muddati';

  @override
  String get photoRequestDurationValue => '7 kun';

  @override
  String get photoRequestRejectLabel => 'Rad etilsa';

  @override
  String get photoRequestRejectValue => 'qayta so‘rash 7 kundan keyin';

  @override
  String get photoRequestPrivacyNote =>
      'Rasm ochilsa, u faqat sizga ko‘rinadi va skrinshot bloklanadi.';

  @override
  String get photoRequestSubmit => 'So‘rov yuborish';

  @override
  String get candidateProposalSentTitle => 'Taklif yuborildi';

  @override
  String candidateProposalSentDescription(Object name) {
    return '$name va uning vakili sizning taklifingizni ko‘radi. Javob kelganda xabar beramiz.';
  }

  @override
  String get candidateProposalSentTimelineSent => 'Taklif yuborildi';

  @override
  String candidateProposalSentTimelineReview(Object name) {
    return '$name ko‘rib chiqadi';
  }

  @override
  String get candidateProposalSentTimelineChat =>
      'Javob kelsa — suhbat ochiladi';

  @override
  String get candidateProposalSentQuotaLabel => 'Bu haftalik takliflar';

  @override
  String get candidateProposalSentQuotaValue => '2 / 3';

  @override
  String candidateProposalSentNote(Object remaining) {
    return 'Javob kelmasa ham xafa bo‘lmang — bu tanlov masalasi. Yana $remaining ta taklif qoldi.';
  }

  @override
  String get candidateProposalSentReturn => 'Nomzodlarga qaytish';

  @override
  String get candidatePhotoPermissionSentTitle =>
      'Rasm ko‘rish uchun ruxsat so‘raldi';

  @override
  String candidatePhotoPermissionSentDescription(Object name) {
    return '$name va uning vakiliga rasmni ko‘rish uchun so‘rov yuborildi. Javob kelganda xabar beramiz.';
  }

  @override
  String get candidatePhotoPermissionSentReturn => 'Profilga qaytish';

  @override
  String get surveyPromptTitle => 'Moslik foizi yopiq';

  @override
  String get surveyPromptMessage =>
      '30 ta savolga javob bering — AI javoblaringizni tahlil qilib, har bir nomzod bilan moslik foizingizni avtomatik hisoblaydi.';

  @override
  String get surveyPromptButton => 'Soʻrovnomani boshlash';

  @override
  String get mockCandidateMohira => 'Mohira R., 23';

  @override
  String get mockCandidateZilola => 'Zilola K., 25';

  @override
  String get mockCandidateNilufar => 'Nilufar A., 22';

  @override
  String get mockCandidateDilnoza => 'Dilnoza S., 27';

  @override
  String get mockCityTashkent => 'Toshkent';

  @override
  String get mockCitySamarkand => 'Samarqand';

  @override
  String get mockCityFergana => 'Fargʻona';

  @override
  String get mockCityBukhara => 'Buxoro';

  @override
  String get messagesSegmentChats => 'Suhbatlar';

  @override
  String get messagesSegmentRequests => 'Soʻrovlar';

  @override
  String get mockMessageMohiraName => 'Mohira R.';

  @override
  String get mockMessageZilolaName => 'Zilola K.';

  @override
  String get mockMessageNilufarName => 'Nilufar A.';

  @override
  String get mockMessageDilnozaName => 'Dilnoza S.';

  @override
  String get mockMessageMohiraPreview => 'Vaqtingiz boʻlsa tanishsak.';

  @override
  String get mockMessageZilolaPreview => 'Taklifingiz koʻrildi';

  @override
  String get mockMessageNilufarPreview => 'Chat muddati tugadi';

  @override
  String get mockMessageDilnozaPreview => 'Hozircha javob kutilmoqda';

  @override
  String get messageTimeYesterday => 'Kecha';

  @override
  String get messageTimeMonday => 'Dush';

  @override
  String get messageTimeTuesday => 'Sesh';

  @override
  String get savedFilterAll => 'Hammasi';

  @override
  String get savedFilterInvited => 'Taklif yuborilgan';

  @override
  String get savedFilterWaiting => 'Javob kutilmoqda';

  @override
  String savedLimitLabel(int savedCount, int limit) {
    return '$savedCount / $limit saqlangan';
  }

  @override
  String get savedPremiumCta => 'Premium — cheksiz';

  @override
  String savedUpsellTitle(int remaining) {
    return 'Yana $remaining ta joy qoldi';
  }

  @override
  String get savedUpsellMessage =>
      'Bepul rejada 10 tagacha profil saqlanadi. Premium bilan cheklov yoʻq.';

  @override
  String get questionnaireOptionalBadge => 'Ixtiyoriy qadam';

  @override
  String questionnaireIntroTitle(int count, int minutes) {
    return '$count ta savol — $minutes daqiqa';
  }

  @override
  String get questionnaireIntroDescription =>
      'Javoblaringizni tahlil qilib, har bir nomzod bilan moslik foizingizni ko‘rsatamiz. Xohlamasangiz, keyinroq ham topshirasiz.';

  @override
  String questionnaireQuestionCount(int count) {
    return '$count savol';
  }

  @override
  String get questionnaireWithoutTitle => 'So‘rovnomasiz nima bo‘ladi?';

  @override
  String get questionnaireWithoutBody =>
      'Profilingiz ishlaydi va nomzodlarni ko‘rasiz, lekin AI moslikni hisoblamaydi — foiz va bo‘limlar kesimidagi tahlil yopiq qoladi.';

  @override
  String get questionnaireStart => 'Ha, so‘rovnomani boshlayman';

  @override
  String get questionnaireLater => 'Keyinroq to‘ldiraman';

  @override
  String get questionnaireEmpty => 'Hozircha savollar mavjud emas.';

  @override
  String questionnaireProgress(int current, int total) {
    return '$current/$total';
  }

  @override
  String get questionnaireNext => 'Keyingi savol';

  @override
  String get questionnaireSubmit => 'Javoblarni yuborish';

  @override
  String get questionnaireAnalysisTitle => 'Javoblaringiz tahlil qilinmoqda';

  @override
  String get questionnaireAnalysisBody =>
      'AI qadriyatlar, moliya va xarakter profilingizni tuzib, mos nomzodlarni tanlaydi.';

  @override
  String get questionnaireResultTitle => 'Sizning profilingiz tayyor!';

  @override
  String get questionnaireResultSubtitle =>
      'Sun’iy intellekt aniqlagan moslik endi ochiq.';

  @override
  String get questionnaireHonestyPill => 'Samimiylik: yuqori';

  @override
  String get questionnaireSeriousPill => 'Niyati jiddiy';

  @override
  String questionnaireMatchedCandidates(int count) {
    return '$count ta mos nomzod';
  }

  @override
  String get questionnaireMatchedCandidatesSubtitle =>
      'Moslik AI tomonidan hisoblandi';

  @override
  String get questionnaireNextStepsTitle => 'Endi nima bo‘ladi?';

  @override
  String get questionnaireAiMatchCalculatedTitle => 'AI moslik hisoblandi';

  @override
  String get questionnaireAiMatchCalculatedBody =>
      'Javoblaringiz asosida nomzodlar tanlandi.';

  @override
  String get questionnaireCandidatesVeiledTitle => 'Nomzodlar parda ostida';

  @override
  String get questionnaireCandidatesVeiledBody =>
      'Suratlar ikkala tomon roziligidan keyin ochiladi.';

  @override
  String get questionnaireConsentOnlyTitle => 'Aloqa faqat rozilik bilan';

  @override
  String get questionnaireConsentOnlyBody =>
      'Suhbat vakil yoki oila ishtirokida boshlanadi.';

  @override
  String get questionnaireHonestyTitle => 'Samimiylik indeksi · yuqori';

  @override
  String get questionnaireHonestyBody =>
      'Tuzoq savollarga javoblaringiz izchil. Profil ishonchli deb belgilandi.';

  @override
  String get questionnaireSeriousBadge => '“Niyati jiddiy” belgisi berildi';

  @override
  String get questionnaireShowCandidates => 'Mos nomzodlarni ko‘rish';

  @override
  String get questionnaireTraitTraditional => 'an’anaviy';

  @override
  String get questionnaireTraitBalanced => 'balansli';

  @override
  String get candidatesViewGrid => 'Katak ko‘rinishi';

  @override
  String get candidatesViewMap => 'Xarita ko‘rinishi';

  @override
  String get nearbyPermissionTitle => 'Yaqin atrofdagi nomzodlar';

  @override
  String get nearbyPermissionDescription =>
      'Joylashuvingiz aniq nuqta sifatida emas, taxminiy zona sifatida ishlatiladi.';

  @override
  String get nearbyPermissionOpenSettings => 'Sozlamalarni ochish';

  @override
  String get nearbyPermissionEnableService => 'Joylashuvni yoqish';

  @override
  String get nearbyPermissionAllow => 'Joylashuvga ruxsat berish';

  @override
  String get nearbyPermissionNotNow => 'Hozir emas';

  @override
  String get nearbyPermissionFootnote =>
      '«Hozir emas» ni tanlasangiz, Moslar va Tavsiyalar avvalgidek ishlaydi.';

  @override
  String get nearbyPermissionRuleHidden =>
      'Aniq manzilingiz hech kimga ko‘rsatilmaydi';

  @override
  String get nearbyPermissionRuleZone =>
      'Boshqalar sizni ~2 km li zona ichida ko‘radi';

  @override
  String get nearbyPermissionRuleSettings =>
      'Istalgan vaqtda Sozlamalardan o‘chirasiz';

  @override
  String get nearbyUnknownZone => 'Yaqin zona';

  @override
  String nearbyCandidateCount(int count) {
    return '$count ta nomzod';
  }

  @override
  String nearbyZoneDistance(String zone, String distance) {
    return '$zone · ~$distance km';
  }

  @override
  String get nearbyYou => 'Siz';

  @override
  String nearbyAroundCount(int count) {
    return 'Atrofingizda $count ta nomzod';
  }

  @override
  String get nearbyShowAll => 'Barchasi';

  @override
  String get openStreetMapAttribution => '© OpenStreetMap ishtirokchilari';

  @override
  String nearbyWithinRadius(int radius) {
    return '$radius km ichida';
  }

  @override
  String get nearbyRecenter => 'Joylashuvimga qaytish';

  @override
  String get nearbySettingsTitle => 'Radius va ko‘rinish';

  @override
  String get nearbySearchRadiusLabel => 'Qidiruv radiusi';

  @override
  String nearbyRadiusOption(int radius) {
    return '$radius km';
  }

  @override
  String get nearbyEntireRegion => 'Butun viloyat';

  @override
  String get nearbyEntireRegionUnavailable =>
      'Butun viloyat bo‘yicha qidiruv hozircha mavjud emas';

  @override
  String get nearbyRadiusHint =>
      'Radius qanchalik katta bo‘lsa, moslik foizi shunchalik pasayadi.';

  @override
  String get nearbyVisibilityTitle => 'Meni Yaqinlar ro‘yxatida ko‘rsatish';

  @override
  String get nearbyVisibilitySubtitle =>
      'O‘chirsangiz, siz ham hech kimni ko‘rmaysiz';

  @override
  String get nearbyAudienceTitle => 'Kim meni Yaqinlarda ko‘ra oladi';

  @override
  String get nearbyAudienceAll => 'Hamma nomzodlar';

  @override
  String get nearbyAudienceHighMatch => 'Faqat moslik 70% dan yuqori';

  @override
  String get nearbyAudienceRecommended => 'tavsiya etiladi';

  @override
  String get nearbyAudienceRepresented => 'Faqat vakili bor nomzodlar';

  @override
  String get nearbyPrivacyZoneNote =>
      'Zona markazi kuniga bir marta tasodifiy siljiydi — shuning uchun sizning uyingizni hisoblab bo‘lmaydi.';

  @override
  String get nearbySettingsSave => 'Saqlash';

  @override
  String nearbyEmptyTitle(int radius) {
    return '$radius km ichida hozircha nomzod yo‘q';
  }

  @override
  String get nearbyEmptyDescription =>
      'Radiusni kengaytiring yoki mezonlarni biroz yumshating.';

  @override
  String nearbyExpandRadius(int radius) {
    return 'Radiusni $radius km ga kengaytirish';
  }

  @override
  String get nearbyChangeCriteria => 'Mezonlarni o‘zgartirish';

  @override
  String get nearbyNotifyTitle => 'Yangi nomzod paydo bo‘lsa xabar bering';

  @override
  String get nearbyNotifySubtitle => 'Kuniga bir marta, ko‘pi bilan';

  @override
  String get profileEdit => 'Profilni tahrirlash';

  @override
  String get profileSettings => 'Profil sozlamalari';

  @override
  String profileIdentifier(String code) {
    return 'Foydalanuvchi raqami: $code';
  }

  @override
  String get profilePreview => 'Boshqalar ko‘rinishi';

  @override
  String get profileCopyIdentifier => 'Foydalanuvchi raqamini nusxalash';

  @override
  String get profileCompleteTitle => 'Profilingizni to‘ldiring';

  @override
  String get profileCompleteSubtitle => 'Aniqroq juftlik topish uchun';

  @override
  String get profileMyPhotos => 'SURATLARIM';

  @override
  String get profileMainPhoto => 'ASOSIY';

  @override
  String get profileAddPhoto => 'Surat qo‘shish';

  @override
  String profilePhotoSemantics(int index) {
    return 'Profil surati $index';
  }

  @override
  String get profileAboutSection => 'O‘ZINGIZ HAQINGIZDA';

  @override
  String get profileNotFilled => 'Hali to‘ldirilmagan';

  @override
  String get profileAdd => 'Qo‘shish';

  @override
  String get profileEditShort => 'Tahrirlash';

  @override
  String get profilePhotoVerification => 'Rasm tekshiruvi';

  @override
  String get profilePhotoVerificationSubtitle =>
      'Asosiy suratingiz kamera orqali selfi bilan solishtiriladi';

  @override
  String get profileServices => 'Xizmatlar';

  @override
  String get profileServicesSubtitle =>
      'Psixolog, oilaviy uchrashuv, tekshiruv va Premium';

  @override
  String get profileIdentifierCopied => 'Foydalanuvchi raqami nusxalandi';

  @override
  String get profileActionComingSoon =>
      'Bu bo‘lim keyingi profil bosqichida ulanadi';

  @override
  String get settingsTitle => 'Sozlamalar';

  @override
  String get settingsBack => 'Orqaga';

  @override
  String get settingsAccountSection => 'Hisob';

  @override
  String get settingsEditProfile => 'Profilni tahrirlash';

  @override
  String get settingsPhotoPrivacy => 'Rasm maxfiyligi';

  @override
  String get settingsPhotoPrivacyAll => 'Hammaga ochiq';

  @override
  String get settingsBlockedUsers => 'Bloklangan foydalanuvchilar';

  @override
  String get settingsRecoveryQuestion => 'Hisobni tiklash savoli';

  @override
  String get settingsPrivacyChatSection => 'Maxfiylik va suhbat';

  @override
  String get settingsPrivacyVeil => 'Maxfiylik va parda tartibi';

  @override
  String get settingsChatLimits => 'Suhbat limitlari';

  @override
  String get settingsChatLimitValue => '72 soat';

  @override
  String get settingsParentLink => 'Ota-ona ulash';

  @override
  String get settingsNotificationAppearanceSection =>
      'Bildirishnoma va ko‘rinish';

  @override
  String get settingsNotifications => 'Bildirishnomalar';

  @override
  String get settingsNotificationsSubtitle =>
      'Yangi like, moslik va xabarlar haqida xabar beriladi';

  @override
  String get settingsNotificationTypes => 'Bildirishnoma turlari';

  @override
  String get settingsDocumentsSection => 'Hujjatlar';

  @override
  String get settingsPrivacyPolicy => 'Maxfiylik siyosati';

  @override
  String get settingsTerms => 'Foydalanish shartlari';

  @override
  String get settingsHelpInfoSection => 'Yordam va ma’lumot';

  @override
  String get settingsServices => 'Xizmatlar';

  @override
  String get settingsHelpCenter => 'Yordam markazi';

  @override
  String get settingsShareApp => 'Ilovani ulashish';

  @override
  String get settingsLogout => 'Hisobdan chiqish';

  @override
  String get settingsActionComingSoon => 'Bu sozlama keyingi bosqichda ulanadi';

  @override
  String get privacyPolicyLoadingLabel => 'Maxfiylik siyosati yuklanmoqda';

  @override
  String get privacyPolicyLoadError =>
      'Maxfiylik siyosatini yuklab bo‘lmadi. Internet aloqasini tekshirib, qayta urinib ko‘ring.';

  @override
  String failureMessage(String type) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'networkTimeout': 'Ulanish vaqti tugadi.',
      'noInternet': 'Internet aloqasi yoʻq.',
      'unauthorized': 'Sessiya tugagan.',
      'cancelled': '',
      'forbidden': 'Kirish rad etildi.',
      'notFound': 'Maʼlumot topilmadi.',
      'validation': 'Kiritilgan maʼlumotni tekshiring.',
      'configuration': 'Google orqali kirish ushbu build uchun sozlanmagan.',
      'unsupported': 'Bu kirish usuli hali mavjud emas.',
      'server': 'Serverda xatolik yuz berdi.',
      'unknown': 'Nimadir xato ketdi.',
      'other': 'Nimadir xato ketdi.',
    });
    return '$_temp0';
  }
}
