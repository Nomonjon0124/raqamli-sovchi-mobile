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
  String get representativeContactPhoneTab => 'Telefon raqam';

  @override
  String get representativeContactEmailTab => 'Email manzil';

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
  String get pinConfirmTitle => 'PIN-kodni qayta kiriting';

  @override
  String get pinMismatch =>
      'Kiritilgan PIN-kodlar bir xil emas. Qaytadan urinib ko‘ring.';

  @override
  String get pinUnlockTitle => 'PIN-kodni kiriting';

  @override
  String get pinHintCreate =>
      'Hisobingiz faqat sizniki boʻlib qolishi uchun. Har safar kirishda shu kodni terasiz.';

  @override
  String get pinHintConfirm =>
      'Yaratgan PIN-kodingizni yana bir marta kiriting.';

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
  String get servicesHeroTitle => 'Tanishuv yo‘lida\nyolg‘iz emassiz';

  @override
  String get servicesHeroSubtitle =>
      'Psixolog, oilaviy uchrashuv va profil tekshiruvi — hammasi bir joyda.';

  @override
  String get servicesHeroSupportValue => '24/7';

  @override
  String get servicesHeroSupportLabel => 'yordam';

  @override
  String get servicesHeroPsychologistsValue => '12';

  @override
  String get servicesHeroPsychologistsLabel => 'psixolog';

  @override
  String get servicesHeroPrivacyValue => 'Maxfiy';

  @override
  String get servicesHeroPrivacyLabel => 'suhbat';

  @override
  String get servicesPopularSection => 'Eng ko‘p tanlanadi';

  @override
  String get servicePsychologistTitle => 'Oilaviy psixolog';

  @override
  String get servicePsychologistSubtitle => 'Nikohdan oldin suhbat';

  @override
  String get servicePsychologistRating => '4.9';

  @override
  String get servicePsychologistDescription =>
      'Kelishmovchilik sabablarini oldindan ko‘rasiz. Suhbat to‘liq maxfiy — hech kim bilmaydi.';

  @override
  String get servicePsychologistDuration => '50 daqiqa';

  @override
  String get servicePsychologistFormat => 'Oflayn yoki uyda';

  @override
  String get servicePsychologistExperts => '12 mutaxassis';

  @override
  String get servicePsychologistPrice => 'bitta sessiy';

  @override
  String get serviceViewAction => 'Ko‘rish';

  @override
  String get servicesOtherSection => 'Boshqa xizmatlar';

  @override
  String get serviceMeetingTitle => 'Oilaviy uchrashuv';

  @override
  String get serviceMeetingSubtitle => 'Faqat vakillar taklif qiladi';

  @override
  String get serviceVerificationTitle => 'Profil tekshiruvi';

  @override
  String get serviceVerificationSubtitle => 'Selfi orqali tasdiqlash';

  @override
  String get servicePremiumTitle => 'Sovchi Premium';

  @override
  String get servicePremiumSubtitle =>
      'Ko‘proq taklif va to‘liq moslik tahlili';

  @override
  String get serviceBoostTitle => 'Yuqoriga ko‘tarish';

  @override
  String get serviceBoostSubtitle =>
      'Profilingiz 24 soat davomida ro‘yxat boshida ko‘rinadi.';

  @override
  String get servicesHowSection => 'Qanday ishlaydi';

  @override
  String get servicesHowStepOneTitle => 'Xizmatni tanlaysiz';

  @override
  String get servicesHowStepOneSubtitle =>
      'Har biri haqida to‘liq ma’lumot bor';

  @override
  String get servicesHowStepTwoTitle => 'Vaqt va shaklni belgilaysiz';

  @override
  String get servicesHowStepTwoSubtitle => 'Oflayn yoki uyingizda';

  @override
  String get servicesHowStepThreeTitle => 'To‘laysiz va uchrashasiz';

  @override
  String get servicesHowStepThreeSubtitle => 'Bekor qilsangiz pul qaytadi';

  @override
  String get servicesOptionalNote =>
      'Hech bir xizmat majburiy emas — ularsiz ham ilovadan to‘liq foydalanasiz.';

  @override
  String get servicesActionComingSoon => 'Bu xizmat keyingi bosqichda ulanadi';

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
  String get candidatesFilterNearby => 'Atrofdagilar';

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
  String get candidateDetailProfession => 'Kasb';

  @override
  String get candidateDetailLifestyle => 'Turmush tarzi';

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
  String candidateBlockDialogTitle(String candidateName) {
    return '$candidateName ni bloklaysizmi?';
  }

  @override
  String get candidateBlockDialogSubtitle =>
      'U sizni ko‘rmaydi, siz ham uni ko‘rmaysiz. Bloklaganingizni o‘zi bilmaydi.';

  @override
  String get candidateBlockPointChatClosed =>
      'Suhbat yopiladi, yozishmalar saqlanadi';

  @override
  String get candidateBlockPointRemovedSaved =>
      'Saqlanganlar ro‘yxatidan olib tashlanadi';

  @override
  String get candidateBlockPointRepresentativeBlocked =>
      'Uning vakili ham siz bilan bog‘lana olmaydi';

  @override
  String get candidateBlockAction => 'Bloklash';

  @override
  String get candidateBlockCancel => 'Bekor qilish';

  @override
  String get candidateBlockedTitle => 'Profil bloklandi';

  @override
  String candidateBlockedSubtitle(String candidateName) {
    return '$candidateName endi sizni ko‘rmaydi.';
  }

  @override
  String get candidateBlockedWhoLabel => 'Kim';

  @override
  String get candidateBlockedTimeLabel => 'Bloklandi';

  @override
  String get candidateBlockedStatusLabel => 'Holat';

  @override
  String get candidateBlockedStatusValue => 'Bloklangan';

  @override
  String get candidateBlockedSettingsHint =>
      'U bloklaganingizni bilmaydi. Blokni Sozlamalar → Bloklangan profillar bo‘limidan olib tashlaysiz.';

  @override
  String get candidateBlockedClose => 'Yopish';

  @override
  String get candidateReportTitle => 'Nima bo‘ldi?';

  @override
  String get candidateReportSubtitle =>
      'Suhbat tarixi bizda saqlanadi, tekshirishga yordam beradi.';

  @override
  String get candidateReportTargetProfile => 'Shikoyat shu profil ustidan';

  @override
  String get candidateReportReasonSection => 'Sabab';

  @override
  String get candidateReportReasonInappropriate => 'Odobsiz so‘z yoki rasm';

  @override
  String get candidateReportReasonFake => 'Yolg‘on ma’lumot yoki soxta profil';

  @override
  String get candidateReportReasonNoMarriage => 'Nikoh niyati yo‘q';

  @override
  String get candidateReportReasonScam => 'Moliyaviy firibgarlik';

  @override
  String get candidateReportReasonAbusiveLanguage => 'Odobsiz so‘z';

  @override
  String get candidateReportReasonFakeProfile => 'Soxta profil';

  @override
  String get candidateReportReasonFraud => 'Firibgarlik';

  @override
  String get candidateReportReasonSpam => 'Spam va reklama';

  @override
  String get candidateReportReasonFalseInformation => 'Noto‘g‘ri ma’lumot';

  @override
  String get candidateReportReasonThreat => 'Haqorat va tahdid';

  @override
  String get candidateReportReasonNoSeriousIntent => 'Nikoh niyati yo‘q';

  @override
  String get candidateReportReasonOther => 'Boshqa sabab';

  @override
  String get candidateReportNoteLabel => 'Qo‘shimcha izoh (ixtiyoriy)';

  @override
  String get candidateReportNoteHint => 'Nima bo‘lganini qisqacha yozing...';

  @override
  String get candidateReportSubmitAction => 'Shikoyatni yuborish';

  @override
  String get candidateReportSubmittedTitle => 'Shikoyat yuborildi';

  @override
  String get candidateReportSubmittedSubtitle => 'Natija haqida xabar beramiz.';

  @override
  String get candidateReportNumberLabel => 'Ariza raqami';

  @override
  String get candidateReportSubmittedTimeLabel => 'Yuborildi';

  @override
  String get candidateReportStatusLabel => 'Holat';

  @override
  String get candidateReportStatusUnderReview => 'Ko‘rib chiqilmoqda';

  @override
  String get candidateReportStepHistoryPreserved =>
      'Suhbat tarixi dalil sifatida saqlandi';

  @override
  String get candidateReportStepModeratorReview => 'Moderator tekshiruvi';

  @override
  String get candidateReportStepDecision => 'Qaror va xabarnoma';

  @override
  String get candidateReportNotice =>
      'Bu foydalanuvchi siz bilan bog‘lana olmaydi. Suhbat vaqtincha yopildi.';

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
  String get chatRequestsEmpty => 'Hozircha kelgan soʻrovlar yoʻq';

  @override
  String chatRequestCardTitle(String name) {
    return 'Soʻrov / $name';
  }

  @override
  String get chatRequestPendingHint =>
      'Qabul qilmaguningizcha nomzod sizga yoza olmaydi.';

  @override
  String get chatRequestProfileTitle => 'Nomzod profili';

  @override
  String get chatRequestCompatibilityLabel => 'MOSLIK BOʻLIMLAR KESIMIDA';

  @override
  String get chatRequestCompatibilityShortLabel => 'moslik';

  @override
  String get chatRequestCompatibilityUnavailable =>
      'Moslik foizi hali hisoblanmagan.';

  @override
  String get chatRequestAccept => 'Qabul qilish';

  @override
  String get chatRequestReject => 'Rad etish';

  @override
  String get chatRequestViaRepresentative => 'Vakil orqali';

  @override
  String get chatRequestPhotoVerified => 'Rasm tekshiruvi oʻtgan';

  @override
  String get chatRequestSeriousIntent => 'Niyati jiddiy';

  @override
  String chatRequestRepresentativeLabel(String name) {
    return 'Vakili: $name';
  }

  @override
  String get chatRequestRepresentativeNote => 'Murojaat vakil orqali kelgan';

  @override
  String get chatRequestProfileUnavailable =>
      'Profil maʼlumotlari vaqtincha mavjud emas.';

  @override
  String chatRequestLocationProfession(String location, String profession) {
    return '$location, $profession';
  }

  @override
  String get chatRequestCandidateFallback => 'Nomzod';

  @override
  String get chatRequestSectionFaith => 'Din va qadriyatlar';

  @override
  String get chatRequestSectionFinance => 'Moliya va boshqaruv';

  @override
  String get chatRequestSectionFamily => 'Qarindoshlar';

  @override
  String get chatRequestSectionCharacter => 'Xarakter';

  @override
  String get chatRequestSectionPlans => 'Kelajak rejalari';

  @override
  String get chatRequestAccepted => 'Soʻrov qabul qilindi';

  @override
  String get chatRequestRejected => 'Soʻrov rad etildi';

  @override
  String get chatRoomsEmpty => 'Hozircha ochiq suhbatlar yoʻq';

  @override
  String get chatThreadOpen => 'Suhbatni ochish';

  @override
  String get chatParticipantFallback => 'Suhbatdosh';

  @override
  String get chatSafetyNotice =>
      'Suhbatni Sunʼiy intellekt kuzatib turadi — odobsiz soʻz va rasm oʻtmaydi.';

  @override
  String get chatIcebreakerGoal => 'Hayotingizdagi eng katta maqsadingiz nima?';

  @override
  String get chatIcebreakerFamily =>
      'Oilada qanday anʼanani davom ettirishni xohlaysiz?';

  @override
  String get chatIcebreakerBook => 'Sizni qaysi kitob eng koʻp ilhomlantiradi?';

  @override
  String get chatIcebreakerChange =>
      'Oʻz hayotingizda oʻzgartirmoqchi boʻlgan bir narsani ayting.';

  @override
  String get chatWriteMessage => 'Xabar yozing…';

  @override
  String get chatSendMessage => 'Xabarni yuborish';

  @override
  String get chatReplyTo => 'Javob berish';

  @override
  String get chatReplyCancel => 'Javobni bekor qilish';

  @override
  String get chatTyping => 'yozyapti…';

  @override
  String get chatOpenTimeRemaining => 'Chat 72 soat ochiq';

  @override
  String get chatMoreActions => 'Qoʻshimcha amallar';

  @override
  String get chatMoreSheetTitle => 'Ilovani ulashish';

  @override
  String get chatMoreSheetSubtitle =>
      'Doʻstlaringizni Sovchiʼga taklif qiling — taklif kodi bilan.';

  @override
  String get chatReportAction => 'Shikoyat qilish';

  @override
  String get chatDeleteAction => 'Chatni oʻchirish';

  @override
  String chatDeleteTitle(String name) {
    return '$name ni suhbatni oʻchirmoqchimisiz?';
  }

  @override
  String get chatDeleteSubtitle =>
      'Agar suhbatni oʻchirsangiz nomzod maʼlumotlari ham berkitiladi!';

  @override
  String get chatDeleteCancel => 'Bekor qilish';

  @override
  String get chatDeleteConfirm => 'Oʻchirish';

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
  String get nearbyCloseMap => 'Xaritani yopish';

  @override
  String nearbyWithinRadius(int radius) {
    return '$radius km ichida';
  }

  @override
  String get nearbyRecenter => 'Joylashuvimga qaytish';

  @override
  String get nearbySettingsTitle => 'Radius va ko‘rinish';

  @override
  String get nearbySearchRadiusLabel => 'Radius';

  @override
  String get nearbyRadiusRange => '1–25 km';

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
  String get nearbyVisibilityTitle => 'Meni Atrofdagilar ro‘yxatida ko‘rsatish';

  @override
  String get nearbyVisibilitySubtitle =>
      'O‘chirsangiz, siz ham hech kimni ko‘rmaysiz';

  @override
  String get nearbyAudienceTitle => 'Kim meni Atrofdagilarda ko‘ra oladi';

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
  String get profilePhotoSourceTitle => 'Yangi surat';

  @override
  String get profilePhotoSourceSubtitle =>
      'Yuklangandan soʻng surat yuz tekshiruvidan oʻtadi.';

  @override
  String get profilePhotoCamera => 'Kameradan olish';

  @override
  String get profilePhotoGallery => 'Galereyadan tanlash';

  @override
  String get profilePhotoActionsTitle => 'Surat';

  @override
  String get profilePhotoSetMain => 'Asosiy qilib belgilash';

  @override
  String get profilePhotoReplace => 'Almashtirish';

  @override
  String get profilePhotoDelete => 'Oʻchirish';

  @override
  String get profilePhotoCancel => 'Bekor qilish';

  @override
  String get profilePhotoDeleteTitle => 'Suratni oʻchirasizmi?';

  @override
  String get profilePhotoDeleteSubtitle =>
      'Surat profilingizdan olib tashlanadi. Oʻrniga yangisini yuklashingiz mumkin.';

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
  String get settingsLanguage => 'Til';

  @override
  String get settingsTheme => 'Mavzu';

  @override
  String get settingsLanguageSheetTitle => 'Til';

  @override
  String get settingsThemeSheetTitle => 'Mavzu';

  @override
  String get settingsLanguageUzbekLatin => 'O‘zbek';

  @override
  String get settingsLanguageUzbekCyrillic => 'Ўзбек';

  @override
  String get settingsLanguageRussian => 'Русский';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsThemeSystem => 'Avtomatik';

  @override
  String get settingsThemeLight => 'Yorug‘';

  @override
  String get settingsThemeDark => 'Qorong‘i';

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
  String get termsOfServiceLoadingLabel => 'Foydalanish shartlari yuklanmoqda';

  @override
  String get termsOfServiceLoadError =>
      'Foydalanish shartlarini yuklab bo‘lmadi. Internet aloqasini tekshirib, qayta urinib ko‘ring.';

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

  @override
  String get profileEditTitle => 'Profilni tahrirlash';

  @override
  String get profileEditAvatarTitle => 'Profil surati';

  @override
  String get profileEditChangePhoto => 'Suratni oʻzgartirish';

  @override
  String get profilePhotoManagementTitle => 'Asosiy surat';

  @override
  String get profilePhotoManagementSubtitle =>
      'Profilingizda va nomzodlar roʻyxatida birinchi shu surat ko‘rinadi. Selfi tekshiruvi ham shu surat bilan solishtiriladi.';

  @override
  String get profilePhotoConfirm => 'Tasdiqlash';

  @override
  String get profileFaceVerificationDone => 'Davom etish';

  @override
  String get profileEditName => 'Ism';

  @override
  String get profileEditBirthYear => 'Tugʻilgan yil';

  @override
  String get profileEditHeight => 'Boʻy';

  @override
  String get profileEditWeight => 'Vazn';

  @override
  String get profileEditEducation => 'Maʼlumoti';

  @override
  String get profileEditProfession => 'Kasbi';

  @override
  String get profileEditRegion => 'Viloyat';

  @override
  String get profileEditDistrict => 'Tuman';

  @override
  String get profileEditMaritalStatus => 'Oilaviy holati';

  @override
  String get profileEditAboutSection => 'OʻZINGIZ HAQINGIZDA';

  @override
  String get profileEditAboutPlaceholder =>
      'Oʻzingiz, qadriyatlaringiz va kelajak rejalaringiz haqida qisqa yozing…';

  @override
  String get profileEditSave => 'Saqlash';

  @override
  String get profileEditCancel => 'Bekor qilish';

  @override
  String get profileEditSuccess => 'Profil muvaffaqiyatli saqlandi';

  @override
  String get profileEditFirstName => 'Ism';

  @override
  String get profileEditLastName => 'Familiya';

  @override
  String get profileEditSelect => 'Tanlash';

  @override
  String get profileEditSelectOption => 'Tanlang';

  @override
  String get profileEditProfessionOther => 'Boshqa';

  @override
  String get profileEditProfessionInputLabel => 'Kasbingizni yozing';

  @override
  String get profileEditSearchPlaceholder => 'Qidirish...';

  @override
  String get profileEditRegionSearchHint => 'Viloyat qidirish...';

  @override
  String get profileEditDistrictSearchHint => 'Tuman qidirish...';

  @override
  String profileEditDistrictRegionCaption(String region) {
    return '$region boʻyicha';
  }

  @override
  String get profileEditNoOptions => 'Maʼlumot topilmadi';

  @override
  String profileEditCm(int cm) {
    return '$cm sm';
  }

  @override
  String profileEditKg(int kg) {
    return '$kg kg';
  }

  @override
  String get profileEditSelectRegionFirst => 'Oldin viloyatni tanlang';

  @override
  String get profileEditDiscardConfirmTitle =>
      'Oʻzgarishlarni bekor qilasizmi?';

  @override
  String get profileEditDiscardConfirmMessage =>
      'Saqlanmagan maʼlumotlar yoʻqoladi.';

  @override
  String get profileEditDiscard => 'Bekor qilish';

  @override
  String get profileEditKeepEditing => 'Qolish';

  @override
  String get profileEditUnsavedTitle => 'Oʻzgarishlar saqlanmadi';

  @override
  String get profileEditUnsavedMessage =>
      'Chiqsangiz, kiritilgan oʻzgarishlar yoʻqoladi.';

  @override
  String get profileEditStayEditing => 'Tahrirlashda qolish';

  @override
  String get profileEditExit => 'Chiqish';

  @override
  String get profileEditUpdatedTitle => 'Profil yangilandi';

  @override
  String get profileEditUpdatedMessage =>
      'Oʻzgarishlar saqlandi. Profilingiz nomzodlarga yangilangan koʻrinishda koʻrsatiladi.';

  @override
  String get profileEditUpdatedOk => 'Yaxshi';

  @override
  String get blockedUsersTitle => 'Bloklangan profillar';

  @override
  String get blockedUsersSubtitle =>
      'Bloklangan profillar sizni qidiruvda ko‘rmaydi va yozolmaydi.';

  @override
  String get blockedUsersEmpty => 'Bloklangan profillar yo‘q';

  @override
  String get blockedUsersEmptySubtitle =>
      'Siz bloklagan barcha profillar shu yerda ko‘rinadi.';

  @override
  String get blockedUsersNote =>
      'Shikoyat qilingan profil moderator ko‘rigidan keyin avtomatik bloklanadi — bu ro‘yxatda «Shikoyatdan keyin» deb belgilanadi.';

  @override
  String blockedAtDate(String date) {
    return 'Bloklangan $date';
  }

  @override
  String get blockedAfterComplaint => 'Shikoyatdan keyin bloklangan';

  @override
  String get unblockButton => 'Blokdan chiqarish';

  @override
  String get unblockSuccess => 'Foydalanuvchi blokdan chiqarildi';

  @override
  String get unblockConfirmTitle => 'Blokdan chiqarilsinmi?';

  @override
  String get unblockConfirmMessage =>
      'Ushbu profil yana sizga xabar yoza oladi va profilingizni ko‘ra oladi.';

  @override
  String get cancel => 'Bekor qilish';

  @override
  String get accountDeletionTitle => 'Hisobni oʻchirish';

  @override
  String get accountDeletionWarningTitle => 'Bu amal qaytarilmaydi';

  @override
  String get accountDeletionWarningMessage =>
      'Hisob oʻchirilgach profilingizni tiklash imkoni boʻlmaydi.';

  @override
  String get accountDeletionItemsTitle => 'NIMALAR OʻCHIRILADI';

  @override
  String get accountDeletionPhotos => 'Barcha suratlar va ovozli tanishtiruv';

  @override
  String get accountDeletionQuestionnaire =>
      'Soʻrovnoma javoblari va moslik natijalari';

  @override
  String get accountDeletionChats => 'Suhbatlar va saqlangan profillar';

  @override
  String get accountDeletionRepresentative => 'Ulangan vakil bilan bogʻlanish';

  @override
  String get accountDeletionReasonTitle => 'SABAB (IXTIYORIY)';

  @override
  String get accountDeletionReasonFoundMatch => 'Juftlik topdim';

  @override
  String get accountDeletionReasonNoTime => 'Hozircha vaqtim yoʻq';

  @override
  String get accountDeletionReasonPrivacy => 'Maxfiylik xavotiri';

  @override
  String get accountDeletionConfirm => 'Hisobni oʻchirish';

  @override
  String get accountDeletionCancel => 'Bekor qilish';
}

/// The translations for Uzbek, using the Cyrillic script (`uz_Cyrl`).
class AppLocalizationsUzCyrl extends AppLocalizationsUz {
  AppLocalizationsUzCyrl() : super('uz_Cyrl');

  @override
  String get faceCaptureTitle => 'Бир марта селфи оламиз';

  @override
  String get faceCaptureSubtitle =>
      'Асосий суратингиз билан солиштирамиз. Ҳеч кимга кўринмайди ва текширувдан кейин ўчирилади.';

  @override
  String get selfieCameraLabel => 'селфи камера';

  @override
  String get faceRuleOne => 'Юзингизни доира ичига жойлаштиринг.';

  @override
  String get faceRuleTwo => 'Юзингиз яхши кўринсин — шу йетарли.';

  @override
  String get faceRuleThree => 'Телефонни кўз даражасида ушланг.';

  @override
  String get takeSelfieLabel => 'Селфи олиш';

  @override
  String get aboutMeTitle => 'Ўзингиз ҳақингизда';

  @override
  String get aboutMeSubtitle =>
      'Ихтиёрий. Қисқача ёзинг — номзодлар шуни ўқийди.';

  @override
  String get aboutMeHint =>
      'Ўзингиз, касбингиз ва оилавий қадриятларингиз ҳақида 2–3 гап...';

  @override
  String aboutMeCounter(int count) {
    return '$count / 300 belgi';
  }

  @override
  String get mainPhotoSelectionHint => 'Асосий суратни танланг';

  @override
  String get mainPhotoSubtitle =>
      'Профилингизда биринчи шу сурат кўринади ва селфи билан солиштирилади.';

  @override
  String get mainPhotoBadge => 'АСОСИЙ';

  @override
  String get faceRetryHint => 'Селфи мос келмади. Қайта уриниб кўринг.';

  @override
  String get faceCameraError => 'Камера ишга тушмади.';

  @override
  String get onboardingSuccessTitle => 'Профиллингиз тайёр!';

  @override
  String get onboardingSuccessSubtitle =>
      'Ҳаммаси сақланди. Енди сизга мос номзодларни кўришингиз мумкин.';

  @override
  String get pledgeConfirmationTitle => 'Ниятингизни тасдиқланг';

  @override
  String get pledgeConfirmationSubtitle =>
      'Бу қадам мажбурий. Тасдиқлагач профилингизда «Нияти жиддий» белгиси пайдо бўлади.';

  @override
  String get pledgeConfirmationPointOne =>
      'Малумотларим тўғри ва ўзимга тегишли.';

  @override
  String get pledgeConfirmationPointTwo =>
      'Ниятим жиддий — оила қуриш учун келдим.';

  @override
  String get pledgeConfirmationPointThree =>
      'Суҳбатдошга ҳурмат билан муносабатда бўламан.';

  @override
  String get pledgeConfirmationButton => 'Қасамни тасдиқлаш';

  @override
  String get privacyPolicyAgreementSuffix => ' билан танишинг';

  @override
  String get aiTestBadge => 'АИ МОСЛИК ТЕСТИ';

  @override
  String get aiTestTitle => '30 та саволга жавоб берасизми?';

  @override
  String get aiTestDescription =>
      'Жавобларингиз асосида ҳар бир номзод билан қанчалик мос келишингизни ҳисоблаймиз. Тахминан 8 дақиқа.';

  @override
  String get aiTestPointOne => 'АИ таҳлили — 8 дақиқада тайёр';

  @override
  String get aiTestPointTwo => 'Мос жуфтлар автоматик танланади';

  @override
  String get aiTestPointThree => 'Жавобларингиз ҳеч кимга кўрсатилмайди';

  @override
  String get startAiTest => 'Ҳа, тестни бошлайман';

  @override
  String get viewCandidatesLater => 'Кейинроқ — аввал номзодларни кўраман';

  @override
  String get appTitle => 'Рақамли Совчи';

  @override
  String get loading => 'Юкланмоқда...';

  @override
  String get splashSubtitle => 'Шошилмасдан, оила билан';

  @override
  String get loginTitle => 'Хуш келибсиз';

  @override
  String get loginHeadline => 'Шошилмасдан,\nоила билан';

  @override
  String get loginSubtitle => 'Телефон рақамингиз билан бошлаймиз';

  @override
  String get phoneLabel => 'Телефон рақам';

  @override
  String get phoneError => 'Телефон рақамни тўғри киритинг.';

  @override
  String get continueLabel => 'Давом етиш';

  @override
  String get orLabel => 'ёки';

  @override
  String get loginNote =>
      'Рақамингизни ҳеч ким кўрмайди. Ҳар бир профил қўлда текширилади. Бу йерда фақат никоҳ ниятидагилар қолади.';

  @override
  String get otpTitle => 'Кодни киритинг';

  @override
  String otpSentTo(String phone) {
    return '$phone raqamiga 4 xonali kod yubordik';
  }

  @override
  String get otpResend => 'Код келмадими? 00:48 дан кейин қайта юборамиз';

  @override
  String get confirmLabel => 'Тасдиқлаш';

  @override
  String get candidateTypeTitle => 'Ким сифатида қидиряпсиз?';

  @override
  String get candidateTypeSubtitle =>
      'Бу танлов анкетангиз қандай бўлишини белгилайди. Жинсни қайта сўрамаймиз.';

  @override
  String get groomCandidateTitle => 'Куёв номзоди';

  @override
  String get groomCandidateSubtitle => 'Еркакман, ўзим учун излаяпман';

  @override
  String get brideCandidateTitle => 'Келин номзоди';

  @override
  String get brideCandidateSubtitle => 'Аёлман, ўзим учун излаяпман';

  @override
  String get representativeCandidateTitle => 'Вакил';

  @override
  String get representativeCandidateSubtitle =>
      'Яқиним номидан ариза тўлдираман';

  @override
  String get pledgeTitle => 'Бир-биримизга ишонч учун';

  @override
  String get pledgePointOne => 'Бу иловадан фақат никоҳ ниятида фойдаланаман.';

  @override
  String get pledgePointTwo => 'Малумотларим тўғри, суратлар ўзимники.';

  @override
  String get pledgePointThree =>
      'Суҳбатда одоб сақлайман. АИ модератор назоратига розиман.';

  @override
  String get pledgeAgreement =>
      'Розиман. Профилимда «Нияти жиддий» белгиси кўринсин.';

  @override
  String get pledgeStart => 'Анкетани бошлаш';

  @override
  String onboardingProgress(Object current, Object total) {
    return '$total bosqichdan $current-bosqich';
  }

  @override
  String get birthDateTitle => 'Туғилган йилингиз';

  @override
  String get birthDateHint =>
      '18 ёшдан кичик фойдаланувчилар рўйхатдан ўта олмайди.';

  @override
  String get birthDateSubtitle =>
      'Ёшингиз номзодларга кўринади, аниқ сана емас.';

  @override
  String get identityTitle => 'Исмингиз ва фамилиянгиз';

  @override
  String get identitySubtitle =>
      'Паспортдагидек ёзинг — номзодлар шу исмни кўради.';

  @override
  String get firstNameLabel => 'Исмингиз';

  @override
  String get lastNameLabel => 'Фамилиянгиз';

  @override
  String get patronymicLabel => 'Отасининг исми (ихтиёрий)';

  @override
  String get professionTitle => 'Касбингиз?';

  @override
  String get professionOther => 'Бошқа';

  @override
  String get professionInputLabel => 'Касбингизни ёзинг';

  @override
  String get professionEmpty => 'Касблар топилмади.';

  @override
  String get representativeProfessionTitle => 'Номзоднинг касби?';

  @override
  String get representativeProfessionInputLabel => 'Номзоднинг касбини ёзинг';

  @override
  String get educationTitle => 'Малумотингиз қандай?';

  @override
  String get heightTitle => 'Бўйингиз';

  @override
  String get heightWeightTitle => 'Бўйингиз ва вазнингиз';

  @override
  String get heightLabel => 'Бўйи (см)';

  @override
  String get heightInputLabel => 'Бўйингиз';

  @override
  String get heightUnit => 'см';

  @override
  String get weightLabel => 'Вазни (кг)';

  @override
  String get weightInputLabel => 'Вазнингиз';

  @override
  String get weightUnit => 'кг';

  @override
  String get decreaseHeightLabel => 'Бўйни камайтириш';

  @override
  String get increaseHeightLabel => 'Бўйни ошириш';

  @override
  String get decreaseWeightLabel => 'Вазнни камайтириш';

  @override
  String get increaseWeightLabel => 'Вазнни ошириш';

  @override
  String get locationTitle => 'Қайерда яшайсиз?';

  @override
  String get regionLabel => 'Вилоят';

  @override
  String get districtLabel => 'Туман ёки шаҳар';

  @override
  String get regionSheetTitle => 'Вилоятни танланг';

  @override
  String regionSheetCount(Object count) {
    return '$count ta hudud';
  }

  @override
  String get districtSheetTitle => 'Туман / шаҳарни танланг';

  @override
  String districtSheetSubtitle(Object count, Object region) {
    return '$region · $count ta tuman';
  }

  @override
  String get locationSearchPlaceholder => 'Туман номи бўйича қидириш';

  @override
  String get selectLabel => 'Танлаш';

  @override
  String get unselectedValue => 'Танланмаган';

  @override
  String get selectRegionFirstValue => 'Аввал вилоятни танланг';

  @override
  String get healthStatusTitle => 'Соғлиқлик даражангиз';

  @override
  String get healthStatusSubtitle =>
      'Бу малумот фақат мосликни ҳисоблашда ишлатилади.';

  @override
  String get healthHealthyLabel => 'Соғлом';

  @override
  String get healthDisabilityLabel => 'Ногиронлиги бор';

  @override
  String get healthDisabilityHint =>
      'Кейинги қадамда қисқача изоҳлашингиз мумкин';

  @override
  String get maritalStatusTitle => 'Оилавий ҳолатингиз';

  @override
  String get maritalStatusDivorcedHint =>
      '«Ажрашган» танланганда фарзандлар сони мажбурий бўлади.';

  @override
  String get maritalStatusFirstMarriageDetail => 'Аввал турмуш қурмаган';

  @override
  String get maritalStatusDivorcedDetail => 'Фарзандлар сони сўралади';

  @override
  String get childrenCountLabel => 'Фарзандларингиз сони';

  @override
  String get decreaseChildrenLabel => 'Фарзандлар сонини камайтириш';

  @override
  String get increaseChildrenLabel => 'Фарзандлар сонини ошириш';

  @override
  String get childrenNotLivingTitle => 'Фарзандлар мен билан яшамайди';

  @override
  String get childrenNotLivingDetail =>
      'Профилда «фарзанди бор» деб кўрсатилади, тафсилот ёзилмайди';

  @override
  String get photoTitle => 'Суратларингизни қўшинг';

  @override
  String get photoHint =>
      '5 тагача сурат. Уларни фақат сиз рухсат берган одам кўради.';

  @override
  String get photoPrivacyHint =>
      'Камида 1 та сурат керак. Юз аниқ кўриниши шарт.';

  @override
  String get photoSlotAddLabel => 'сурат';

  @override
  String photoSlotFilledLabel(int order) {
    return 'surat $order ✓';
  }

  @override
  String get addPhoto => 'Сурат қўшиш';

  @override
  String get setMainPhoto => 'Асосий қилиш';

  @override
  String get removePhoto => 'Ўчириш';

  @override
  String get voiceTitle => 'Овозли таништирув';

  @override
  String get voiceHint => 'ААС/М4А форматда 30 сониягача ёзинг.';

  @override
  String get voiceShortHint =>
      '10–15 сония йетарли. Овоз одам ҳақида суратдан кўра кўпроқ нарсани айтади.';

  @override
  String get startRecording => 'Ёзишни бошлаш';

  @override
  String get stopRecording => 'Ёзишни тўхтатиш';

  @override
  String get playRecording => 'Ёзувни ешитиш';

  @override
  String get voiceSubtitle =>
      'Ихтиёрий. 10–15 сония йетарли — овоз одам ҳақида кўпроқ нарсани айтади.';

  @override
  String get startRecordingHint => 'Ёзишни бошлаш учун босинг';

  @override
  String get recordedVoiceHint =>
      'Ешитиб кўринг. Ёқмаса қайта ёзинг ёки ўчиринг — овоз ихтиёрий.';

  @override
  String get reRecordVoice => 'Қайта ёзиш';

  @override
  String get deleteVoice => 'Ўчириш';

  @override
  String get locationPermissionTitle => 'Жойлашувингиз';

  @override
  String get locationPermissionSubtitle =>
      'Яқин ҳудуддаги номзодларни биринчи кўрсатиш учун жойлашув рухсати керак. Аниқ манзил ҳеч кимга кўринмайди.';

  @override
  String get enableLocation => 'Жойлашувни ёқиш';

  @override
  String get skipLabel => 'Ўтказиб юбориш';

  @override
  String get faceTitle => 'Юзингизни тасдиқланг';

  @override
  String get faceHint =>
      'Юзингиз тўғри қараган ва кўзларингиз очиқ ҳолда селфие олинг.';

  @override
  String get verifyFace => 'Юзни тасдиқлаш';

  @override
  String get finishOnboarding => 'Якунлаш ва профилни очиш';

  @override
  String get representativeFlowMessage =>
      'Вакил оқими алоҳида анкета бўлиб, кейинроқ очилади.';

  @override
  String get representativeIntroTitle => 'Сиз вакил сифатида кирдингиз';

  @override
  String get representativeIntroSubtitle =>
      'Вакил — номзоднинг яқин қариндоши: амма, хола, амаки ёки тоға. Сиз унинг номидан анкета тўлдирасиз ва келган таклифларни кўриб чиқасиз.';

  @override
  String get representativeConsentRequiredTitle => 'Номзоднинг розилиги шарт';

  @override
  String get representativeConsentRequiredBody =>
      'Анкета тўлдирилгач номзодга СМС юборилади. У тасдиқламагунча профил ҳеч кимга кўринмайди.';

  @override
  String get representativeIntroFootnote =>
      'Кейинги қадамларда аввал ўзингиз ҳақингизда, сўнг номзод ҳақида малумот сўраймиз.';

  @override
  String get startLabel => 'Бошлаш';

  @override
  String get representativeSelfSection => '1-ҚИСМ · СИЗ ҲАҚИНГИЗДА';

  @override
  String get representativeSelfTitle => 'Ўзингиз ҳақингизда';

  @override
  String get representativeSelfSubtitle =>
      'Номзод розилик сўровида шу исмни кўради.';

  @override
  String get representativeRelationTitle => 'Номзодга кимсиз?';

  @override
  String get representativeCandidateSection => '2-ҚИСМ · НОМЗОД ҲАҚИДА';

  @override
  String get representativeCandidateTypeTitle => 'Номзод ким?';

  @override
  String get representativeCandidateTypeSubtitle =>
      'Шундан кейинги барча саволлар номзод ҳақида бўлади — ўзингиз ҳақингизда емас.';

  @override
  String get representativeBrideTitle => 'Келин';

  @override
  String get representativeBrideSubtitle => 'Аёл номзод';

  @override
  String get representativeGroomTitle => 'Куёв';

  @override
  String get representativeGroomSubtitle => 'Еркак номзод';

  @override
  String get representativeCandidateIdentityTitle =>
      'Номзоднинг исми ва фамилияси';

  @override
  String get representativeCandidateIdentitySubtitle =>
      'Бу малумотларни номзоднинг ўзи тасдиқлайди. Хато бўлса, кейин тузатиш мумкин.';

  @override
  String get representativeBirthDateTitle => 'Номзод туғилган йили';

  @override
  String get representativeEducationTitle => 'Номзоднинг малумоти';

  @override
  String get representativeHeightWeightTitle => 'Номзоднинг бўйи ва вазни';

  @override
  String get representativeHeightInputLabel => 'Номзоднинг бўйи';

  @override
  String get representativeWeightInputLabel => 'Номзоднинг вазни';

  @override
  String get representativeLocationTitle => 'Номзод қайерда яшайди?';

  @override
  String get representativeHealthStatusTitle => 'Номзоднинг соғлиқлик даражаси';

  @override
  String get representativeMaritalStatusTitle => 'Номзоднинг оилавий ҳолати';

  @override
  String get representativeChildrenCountLabel => 'Номзоднинг фарзандлари сони';

  @override
  String get representativeChildrenNotLivingTitle =>
      'Фарзандлар номзод билан яшамайди';

  @override
  String get representativePhotoTitle => 'Номзоднинг суратлари';

  @override
  String get representativePhotoHint =>
      '5 тагача сурат. Уларни фақат номзод рухсат берган одам кўради.';

  @override
  String get representativeMainPhotoSubtitle =>
      'Номзод профилида биринчи шу сурат кўринади.';

  @override
  String get representativeAboutTitle => 'Номзод ҳақида';

  @override
  String get representativeAboutSubtitle =>
      'Ихтиёрий. Саволлар номзод ҳақида — ўзингиз ҳақингизда емас.';

  @override
  String get representativeAboutHint =>
      'Номзоднинг касби, қизиқишлари ва оилавий қадриятлари ҳақида 2–3 гап...';

  @override
  String get representativeVoiceTitle => 'Номзоднинг овозли изоҳи';

  @override
  String get representativeVoiceSubtitle =>
      'Ихтиёрий. Номзод кейин ўзи қайта ёзиши мумкин.';

  @override
  String get representativeLocationPermissionTitle => 'Номзоднинг жойлашуви';

  @override
  String get representativeLocationPermissionSubtitle =>
      'Ихтиёрий. Аниқ манзил ҳеч кимга кўринмайди.';

  @override
  String get representativeConsentSection => '3-ҚИСМ · РОЗИЛИК';

  @override
  String get representativeContactTitle => 'Номзоднинг телефон рақами';

  @override
  String get representativeContactSubtitle =>
      'Шу рақамга розилик сўрови юборилади. Номзод тасдиқламагунча анкета ҳеч кимга кўринмайди.';

  @override
  String get representativeContactLabel => 'Телефон рақами / емаил';

  @override
  String get representativeContactPhoneTab => 'Телефон рақам';

  @override
  String get representativeContactEmailTab => 'Емаил манзил';

  @override
  String get representativeContactWarningTitle =>
      'Рақам номзодники бўлиши шарт';

  @override
  String get representativeContactWarningBody =>
      'Ўз рақамингизни киритсангиз, розилик ҳақиқий ҳисобланмайди ва профил блокланади.';

  @override
  String get representativeSendConsent => 'Розилик сўровини юбориш';

  @override
  String get representativeCandidateNoApp => 'Номзод иловадан фойдаланмайди';

  @override
  String get representativeConsentSentTitle => 'Сўров юборилди';

  @override
  String representativeConsentSentSubtitle(String firstName) {
    return '$firstName tasdiqlashi kutilmoqda. Tasdiqlangunga qadar anketa yashirin.';
  }

  @override
  String get representativeSmsSentTitle => 'Номзодга СМС кетди';

  @override
  String representativeSmsSentBody(String representativeName) {
    return '$representativeName sizning nomingizdan anketa to‘ldirdi. Rozimisiz?';
  }

  @override
  String get representativeConsentRevocation =>
      'Номзод розиликни исталган вақтда қайтариб олиши мумкин — шунда анкета дарҳол яширилади.';

  @override
  String get understoodLabel => 'Тушунарли';

  @override
  String get resendRequestLabel => 'Сўровни қайта юбориш';

  @override
  String get representativePledgeTitle => 'Масулиятни тасдиқланг';

  @override
  String get representativePledgeSubtitle =>
      'Бу қадам мажбурий. Сиз бошқа одам номидан малумот киритаяпсиз.';

  @override
  String get representativePledgePointOne =>
      'Номзод ҳақидаги малумотлар тўғри ва унинг розилиги билан киритилди.';

  @override
  String get representativePledgePointTwo =>
      'Номзоднинг шахсий суҳбатларига аралашмайман.';

  @override
  String get representativePledgePointThree =>
      'Таклиф ва сўровларни номзод манфаатида кўриб чиқаман.';

  @override
  String get representativeReadyTitle => 'Профиллингиз тайёр!';

  @override
  String get representativeReadySubtitle =>
      'Ҳаммаси сақланди. Енди сизга мос номзодларни кўришингиз мумкин.';

  @override
  String get representativeSetCriteria => 'Қидирув мезонларини созлаш';

  @override
  String get laterLabel => 'Кейинроқ';

  @override
  String get candidateConsentEyebrow => 'НОМЗОД ТЕЛЕФОНИДА';

  @override
  String get candidateConsentTitle => 'Сизнинг номингиздан анкета тўлдирилди';

  @override
  String candidateConsentBody(String representativeName, String relation) {
    return '$representativeName ($relation) siz uchun anketa to‘ldirdi. Roziligingizsiz u hech kimga ko‘rinmaydi.';
  }

  @override
  String get candidateConsentApproveTitle => 'Розилик берсангиз';

  @override
  String get candidateConsentApproveBody =>
      'Анкета фаоллашади, таклифлар кела бошлайди. Кейин ўзингиз таҳрирлашингиз мумкин.';

  @override
  String get candidateConsentRejectHint =>
      'Рад етсангиз анкета ўчирилади ва вакилга хабар берилади.';

  @override
  String get agreeLabel => 'Розиман';

  @override
  String get rejectLabel => 'Рад етаман';

  @override
  String get backLabel => 'Орқага';

  @override
  String get temporaryOtpHint =>
      'Вақтинчалик адаптер: 1234 кодидан фойдаланинг';

  @override
  String get pinCreateTitle => 'Қисқа код ўйлаб топинг';

  @override
  String get pinConfirmTitle => 'ПИН-кодни қайта киритинг';

  @override
  String get pinMismatch =>
      'Киритилган ПИН-кодлар бир хил емас. Қайтадан уриниб кўринг.';

  @override
  String get pinUnlockTitle => 'ПИН-кодни киритинг';

  @override
  String get pinHintCreate =>
      'Ҳисобингиз фақат сизники бўлиб қолиши учун. Ҳар сафар киришда шу кодни терасиз.';

  @override
  String get pinHintConfirm => 'Яратган ПИН-кодингизни яна бир марта киритинг.';

  @override
  String get pinHintUnlock =>
      'Бу қурилма учун яратган ПИН-кодингизни киритинг.';

  @override
  String get unlockLabel => 'Очиш';

  @override
  String get signInAsDemo => 'Демо сифатида кириш';

  @override
  String get homeTitle => 'Бош саҳифа';

  @override
  String get homeMessage => 'Фоундатион кейинги феатуре учун тайёр.';

  @override
  String get logout => 'Чиқиш';

  @override
  String get deleteAccount => 'Ҳисобни ўчириш';

  @override
  String get deleteAccountTitle => 'Ҳисобингиз ўчирилсинми?';

  @override
  String get deleteAccountMessage =>
      'Бу амал ҳисобингиз ва унга боғлиқ профил малумотларини ўчиради. Амални ортга қайтариб бўлмайди.';

  @override
  String get deleteAccountCancel => 'Бекор қилиш';

  @override
  String get deleteAccountConfirm => 'Ўчириш';

  @override
  String get retry => 'Қайта уриниш';

  @override
  String get telegramWaiting =>
      'Телеграмда телефон рақамингизни тасдиқланг, кейин иловага қайтинг.';

  @override
  String get candidatesTabLabel => 'Номзодлар';

  @override
  String get messagesTabLabel => 'Хабарлар';

  @override
  String get servicesTabLabel => 'Хизматлар';

  @override
  String get savedTabLabel => 'Сақланган';

  @override
  String get profileTabLabel => 'Профил';

  @override
  String get candidatesPlaceholder => 'Ҳозирча номзодлар саҳифаси.';

  @override
  String get messagesPlaceholder => 'Ҳозирча хабарлар саҳифаси.';

  @override
  String get servicesPlaceholder => 'Ҳозирча хизматлар саҳифаси.';

  @override
  String get servicesHeroTitle => 'Танишув йўлида\nёлғиз емассиз';

  @override
  String get servicesHeroSubtitle =>
      'Психолог, оилавий учрашув ва профил текшируви — ҳаммаси бир жойда.';

  @override
  String get servicesHeroSupportValue => '24/7';

  @override
  String get servicesHeroSupportLabel => 'ёрдам';

  @override
  String get servicesHeroPsychologistsValue => '12';

  @override
  String get servicesHeroPsychologistsLabel => 'психолог';

  @override
  String get servicesHeroPrivacyValue => 'Махфий';

  @override
  String get servicesHeroPrivacyLabel => 'суҳбат';

  @override
  String get servicesPopularSection => 'Енг кўп танланади';

  @override
  String get servicePsychologistTitle => 'Оилавий психолог';

  @override
  String get servicePsychologistSubtitle => 'Никоҳдан олдин суҳбат';

  @override
  String get servicePsychologistRating => '4.9';

  @override
  String get servicePsychologistDescription =>
      'Келишмовчилик сабабларини олдиндан кўрасиз. Суҳбат тўлиқ махфий — ҳеч ким билмайди.';

  @override
  String get servicePsychologistDuration => '50 дақиқа';

  @override
  String get servicePsychologistFormat => 'Офлайн ёки уйда';

  @override
  String get servicePsychologistExperts => '12 мутахассис';

  @override
  String get servicePsychologistPrice => 'битта сессий';

  @override
  String get serviceViewAction => 'Кўриш';

  @override
  String get servicesOtherSection => 'Бошқа хизматлар';

  @override
  String get serviceMeetingTitle => 'Оилавий учрашув';

  @override
  String get serviceMeetingSubtitle => 'Фақат вакиллар таклиф қилади';

  @override
  String get serviceVerificationTitle => 'Профил текшируви';

  @override
  String get serviceVerificationSubtitle => 'Селфи орқали тасдиқлаш';

  @override
  String get servicePremiumTitle => 'Совчи Премиум';

  @override
  String get servicePremiumSubtitle => 'Кўпроқ таклиф ва тўлиқ мослик таҳлили';

  @override
  String get serviceBoostTitle => 'Юқорига кўтариш';

  @override
  String get serviceBoostSubtitle =>
      'Профилингиз 24 соат давомида рўйхат бошида кўринади.';

  @override
  String get servicesHowSection => 'Қандай ишлайди';

  @override
  String get servicesHowStepOneTitle => 'Хизматни танлайсиз';

  @override
  String get servicesHowStepOneSubtitle => 'Ҳар бири ҳақида тўлиқ малумот бор';

  @override
  String get servicesHowStepTwoTitle => 'Вақт ва шаклни белгилайсиз';

  @override
  String get servicesHowStepTwoSubtitle => 'Офлайн ёки уйингизда';

  @override
  String get servicesHowStepThreeTitle => 'Тўлайсиз ва учрашасиз';

  @override
  String get servicesHowStepThreeSubtitle => 'Бекор қилсангиз пул қайтади';

  @override
  String get servicesOptionalNote =>
      'Ҳеч бир хизмат мажбурий емас — уларсиз ҳам иловадан тўлиқ фойдаланасиз.';

  @override
  String get servicesActionComingSoon => 'Бу хизмат кейинги босқичда уланади';

  @override
  String get savedPlaceholder => 'Ҳозирча сақланганлар саҳифаси.';

  @override
  String get profilePlaceholder => 'Ҳозирча профил саҳифаси.';

  @override
  String get notificationsActionLabel => 'Билдиришномалар';

  @override
  String get notificationsEmpty => 'Ҳозирча билдиришномалар йўқ';

  @override
  String get notificationsMarkAllRead => 'Барчасини ўқилган деб белгилаш';

  @override
  String get candidatesFilterMatches => 'Мослар';

  @override
  String get candidatesFilterRecommended => 'Тавсиялар';

  @override
  String get candidatesFilterNearby => 'Атрофдагилар';

  @override
  String get privatePhotoLabel => 'Махфий расм';

  @override
  String get matchLockedLabel => 'мослик ёпиқ';

  @override
  String get genericError => 'Нимадир хато кетди.';

  @override
  String get savedEmptyState => 'Ҳозирча сақланган профил йўқ.';

  @override
  String get candidateDetailRequestPhotoPermission =>
      'Расмни кўриш учун рухсат сўраш';

  @override
  String get candidateDetailOptionsSubtitle => 'Нима қилмоқчисиз?';

  @override
  String get candidateDetailSaveSubtitle =>
      'Кейин «Сақланган» бўлимидан топасиз';

  @override
  String get candidateDetailSaveToSaved => 'Сақланганларга қўшиш';

  @override
  String get candidateDetailShare => 'Профилни улашиш';

  @override
  String get candidateDetailShareSubtitle =>
      'Вакилингизга ёки оилангизга юборинг';

  @override
  String get candidateDetailPhotoPermissionSubtitle =>
      'Сўров номзодга ва унинг вакилига боради';

  @override
  String get candidateDetailReport => 'Шикоят қилиш';

  @override
  String get candidateDetailReportSubtitle => 'Модератор 24 соат ичида кўради';

  @override
  String get candidateDetailBlock => 'Профилни блоклаш';

  @override
  String get candidateDetailBlockSubtitle => 'У сизни бошқа кўрмайди';

  @override
  String get candidateDetailCompatibilityTitle => 'Умумий мослик';

  @override
  String candidateDetailVoiceIntro(String duration) {
    return 'Ovozli tanishtiruv · $duration';
  }

  @override
  String get candidateDetailVoiceDuration => '12 сек';

  @override
  String get candidateDetailSendProposal => 'Совчи таклифи юбориш';

  @override
  String get candidateDetailSave => 'Сақлаш';

  @override
  String get candidateDetailUnsave => 'Сақланганлардан олиб ташлаш';

  @override
  String get candidateDetailNoPhoto => 'Профил расми йўқ';

  @override
  String get candidateDetailLastActivity => 'Охирги фаоллик: яқинда';

  @override
  String get candidateDetailCompatibilityUnavailableTitle =>
      'Мослик ҳисобланмаган';

  @override
  String get candidateDetailCompatibilityUnavailableDescription =>
      'Номзод 30 саволлик сўровномани ҳали тўлдирмаган — шу сабабли мослик фоизи кўрсатилмайди. Қуйидаги малумотлар номзод анкетасидан олинган.';

  @override
  String get candidateDetailBasicInformation => 'Асосий малумотлар';

  @override
  String get candidateDetailBirthYear => 'Туғилган йили';

  @override
  String candidateDetailBirthYearWithAge(int birthYear, int age) {
    return '$birthYear · $age yosh';
  }

  @override
  String get candidateDetailCity => 'Шаҳар';

  @override
  String get candidateDetailMaritalStatus => 'Оилавий ҳолати';

  @override
  String get candidateDetailChildren => 'Фарзандлари';

  @override
  String get candidateDetailNoChildren => 'Йўқ';

  @override
  String get candidateDetailHasChildren => 'Бор';

  @override
  String candidateDetailChildrenCount(int count) {
    return '$count ta';
  }

  @override
  String get candidateDetailEducationAndWork => 'Талим ва иш';

  @override
  String get candidateDetailEducation => 'Малумоти';

  @override
  String get candidateDetailProfession => 'Касб';

  @override
  String get candidateDetailLifestyle => 'Турмуш тарзи';

  @override
  String get candidateDetailHealthStatus => 'Соғлиғи';

  @override
  String get candidateDetailIncompleteProfileTitle => 'Анкета тўлиқ емас';

  @override
  String get candidateDetailIncompleteProfileDescription =>
      'Номзод айрим малумотларни ҳали тўлдирмаган. Совчи таклифи юборилганда унга анкетани тўлдириш еслатмаси боради.';

  @override
  String get candidateDetailAbout => 'Номзод ҳақида';

  @override
  String get candidateRequestPending => 'Жараёнда...';

  @override
  String get candidateRequestRetry => 'Қайта сўров юбориш';

  @override
  String candidateRequestRetryAt(Object date) {
    return 'Qayta so‘rov yuborish: $date';
  }

  @override
  String get candidateRequestChat => 'Суҳбатлашиш';

  @override
  String get candidateRequestForwarded => 'Вакилга йўналтирилди';

  @override
  String get photoRequestTitle => 'Расм кўриш сўрови';

  @override
  String get photoRequestDescription =>
      'Сўров номзодга ва унинг вакилига юборилади. Қарор фақат уларга тегишли.';

  @override
  String get photoRequestMessageHint => 'Хабар (ихтиёрий)';

  @override
  String get photoRequestDurationLabel => 'Сўров муддати';

  @override
  String get photoRequestDurationValue => '7 кун';

  @override
  String get photoRequestRejectLabel => 'Рад етилса';

  @override
  String get photoRequestRejectValue => 'қайта сўраш 7 кундан кейин';

  @override
  String get photoRequestPrivacyNote =>
      'Расм очилса, у фақат сизга кўринади ва скриншот блокланади.';

  @override
  String get photoRequestSubmit => 'Сўров юбориш';

  @override
  String get candidateProposalSentTitle => 'Таклиф юборилди';

  @override
  String candidateProposalSentDescription(Object name) {
    return '$name va uning vakili sizning taklifingizni ko‘radi. Javob kelganda xabar beramiz.';
  }

  @override
  String get candidateProposalSentTimelineSent => 'Таклиф юборилди';

  @override
  String candidateProposalSentTimelineReview(Object name) {
    return '$name ko‘rib chiqadi';
  }

  @override
  String get candidateProposalSentTimelineChat =>
      'Жавоб келса — суҳбат очилади';

  @override
  String get candidateProposalSentQuotaLabel => 'Бу ҳафталик таклифлар';

  @override
  String get candidateProposalSentQuotaValue => '2 / 3';

  @override
  String candidateProposalSentNote(Object remaining) {
    return 'Javob kelmasa ham xafa bo‘lmang — bu tanlov masalasi. Yana $remaining ta taklif qoldi.';
  }

  @override
  String get candidateProposalSentReturn => 'Номзодларга қайтиш';

  @override
  String get candidatePhotoPermissionSentTitle =>
      'Расм кўриш учун рухсат сўралди';

  @override
  String candidatePhotoPermissionSentDescription(Object name) {
    return '$name va uning vakiliga rasmni ko‘rish uchun so‘rov yuborildi. Javob kelganda xabar beramiz.';
  }

  @override
  String get candidatePhotoPermissionSentReturn => 'Профилга қайтиш';

  @override
  String candidateBlockDialogTitle(String candidateName) {
    return '$candidateName ni bloklaysizmi?';
  }

  @override
  String get candidateBlockDialogSubtitle =>
      'У сизни кўрмайди, сиз ҳам уни кўрмайсиз. Блоклаганингизни ўзи билмайди.';

  @override
  String get candidateBlockPointChatClosed =>
      'Суҳбат ёпилади, ёзишмалар сақланади';

  @override
  String get candidateBlockPointRemovedSaved =>
      'Сақланганлар рўйхатидан олиб ташланади';

  @override
  String get candidateBlockPointRepresentativeBlocked =>
      'Унинг вакили ҳам сиз билан боғлана олмайди';

  @override
  String get candidateBlockAction => 'Блоклаш';

  @override
  String get candidateBlockCancel => 'Бекор қилиш';

  @override
  String get candidateBlockedTitle => 'Профил блокланди';

  @override
  String candidateBlockedSubtitle(String candidateName) {
    return '$candidateName endi sizni ko‘rmaydi.';
  }

  @override
  String get candidateBlockedWhoLabel => 'Ким';

  @override
  String get candidateBlockedTimeLabel => 'Блокланди';

  @override
  String get candidateBlockedStatusLabel => 'Ҳолат';

  @override
  String get candidateBlockedStatusValue => 'Блокланган';

  @override
  String get candidateBlockedSettingsHint =>
      'У блоклаганингизни билмайди. Блокни Созламалар → Блокланган профиллар бўлимидан олиб ташлайсиз.';

  @override
  String get candidateBlockedClose => 'Ёпиш';

  @override
  String get candidateReportTitle => 'Нима бўлди?';

  @override
  String get candidateReportSubtitle =>
      'Суҳбат тарихи бизда сақланади, текширишга ёрдам беради.';

  @override
  String get candidateReportTargetProfile => 'Шикоят шу профил устидан';

  @override
  String get candidateReportReasonSection => 'Сабаб';

  @override
  String get candidateReportReasonInappropriate => 'Одобсиз сўз ёки расм';

  @override
  String get candidateReportReasonFake => 'Ёлғон малумот ёки сохта профил';

  @override
  String get candidateReportReasonNoMarriage => 'Никоҳ нияти йўқ';

  @override
  String get candidateReportReasonScam => 'Молиявий фирибгарлик';

  @override
  String get candidateReportReasonAbusiveLanguage => 'Одобсиз сўз';

  @override
  String get candidateReportReasonFakeProfile => 'Сохта профил';

  @override
  String get candidateReportReasonFraud => 'Фирибгарлик';

  @override
  String get candidateReportReasonSpam => 'Спам ва реклама';

  @override
  String get candidateReportReasonFalseInformation => 'Нотўғри малумот';

  @override
  String get candidateReportReasonThreat => 'Ҳақорат ва таҳдид';

  @override
  String get candidateReportReasonNoSeriousIntent => 'Никоҳ нияти йўқ';

  @override
  String get candidateReportReasonOther => 'Бошқа сабаб';

  @override
  String get candidateReportNoteLabel => 'Қўшимча изоҳ (ихтиёрий)';

  @override
  String get candidateReportNoteHint => 'Нима бўлганини қисқача ёзинг...';

  @override
  String get candidateReportSubmitAction => 'Шикоятни юбориш';

  @override
  String get candidateReportSubmittedTitle => 'Шикоят юборилди';

  @override
  String get candidateReportSubmittedSubtitle => 'Натижа ҳақида хабар берамиз.';

  @override
  String get candidateReportNumberLabel => 'Ариза рақами';

  @override
  String get candidateReportSubmittedTimeLabel => 'Юборилди';

  @override
  String get candidateReportStatusLabel => 'Ҳолат';

  @override
  String get candidateReportStatusUnderReview => 'Кўриб чиқилмоқда';

  @override
  String get candidateReportStepHistoryPreserved =>
      'Суҳбат тарихи далил сифатида сақланди';

  @override
  String get candidateReportStepModeratorReview => 'Модератор текшируви';

  @override
  String get candidateReportStepDecision => 'Қарор ва хабарнома';

  @override
  String get candidateReportNotice =>
      'Бу фойдаланувчи сиз билан боғлана олмайди. Суҳбат вақтинча ёпилди.';

  @override
  String get surveyPromptTitle => 'Мослик фоизи ёпиқ';

  @override
  String get surveyPromptMessage =>
      '30 та саволга жавоб беринг — АИ жавобларингизни таҳлил қилиб, ҳар бир номзод билан мослик фоизингизни автоматик ҳисоблайди.';

  @override
  String get surveyPromptButton => 'Сўровномани бошлаш';

  @override
  String get mockCandidateMohira => 'Моҳира Р., 23';

  @override
  String get mockCandidateZilola => 'Зилола К., 25';

  @override
  String get mockCandidateNilufar => 'Нилуфар А., 22';

  @override
  String get mockCandidateDilnoza => 'Дилноза С., 27';

  @override
  String get mockCityTashkent => 'Тошкент';

  @override
  String get mockCitySamarkand => 'Самарқанд';

  @override
  String get mockCityFergana => 'Фарғона';

  @override
  String get mockCityBukhara => 'Бухоро';

  @override
  String get messagesSegmentChats => 'Суҳбатлар';

  @override
  String get messagesSegmentRequests => 'Сўровлар';

  @override
  String get chatRequestsEmpty => 'Ҳозирча келган сўровлар йўқ';

  @override
  String chatRequestCardTitle(String name) {
    return 'Soʻrov / $name';
  }

  @override
  String get chatRequestPendingHint =>
      'Қабул қилмагунингизча номзод сизга ёза олмайди.';

  @override
  String get chatRequestProfileTitle => 'Номзод профили';

  @override
  String get chatRequestCompatibilityLabel => 'МОСЛИК БЎЛИМЛАР КЕСИМИДА';

  @override
  String get chatRequestCompatibilityShortLabel => 'мослик';

  @override
  String get chatRequestCompatibilityUnavailable =>
      'Мослик фоизи ҳали ҳисобланмаган.';

  @override
  String get chatRequestAccept => 'Қабул қилиш';

  @override
  String get chatRequestReject => 'Рад етиш';

  @override
  String get chatRequestViaRepresentative => 'Вакил орқали';

  @override
  String get chatRequestPhotoVerified => 'Расм текшируви ўтган';

  @override
  String get chatRequestSeriousIntent => 'Нияти жиддий';

  @override
  String chatRequestRepresentativeLabel(String name) {
    return 'Vakili: $name';
  }

  @override
  String get chatRequestRepresentativeNote => 'Мурожаат вакил орқали келган';

  @override
  String get chatRequestProfileUnavailable =>
      'Профил малумотлари вақтинча мавжуд емас.';

  @override
  String chatRequestLocationProfession(String location, String profession) {
    return '$location, $profession';
  }

  @override
  String get chatRequestCandidateFallback => 'Номзод';

  @override
  String get chatRequestSectionFaith => 'Дин ва қадриятлар';

  @override
  String get chatRequestSectionFinance => 'Молия ва бошқарув';

  @override
  String get chatRequestSectionFamily => 'Қариндошлар';

  @override
  String get chatRequestSectionCharacter => 'Характер';

  @override
  String get chatRequestSectionPlans => 'Келажак режалари';

  @override
  String get chatRequestAccepted => 'Сўров қабул қилинди';

  @override
  String get chatRequestRejected => 'Сўров рад етилди';

  @override
  String get chatRoomsEmpty => 'Ҳозирча очиқ суҳбатлар йўқ';

  @override
  String get chatThreadOpen => 'Суҳбатни очиш';

  @override
  String get chatParticipantFallback => 'Суҳбатдош';

  @override
  String get chatSafetyNotice =>
      'Суҳбатни Суний интеллект кузатиб туради — одобсиз сўз ва расм ўтмайди.';

  @override
  String get chatIcebreakerGoal => 'Ҳаётингиздаги енг катта мақсадингиз нима?';

  @override
  String get chatIcebreakerFamily =>
      'Оилада қандай ананани давом еттиришни хоҳлайсиз?';

  @override
  String get chatIcebreakerBook => 'Сизни қайси китоб енг кўп илҳомлантиради?';

  @override
  String get chatIcebreakerChange =>
      'Ўз ҳаётингизда ўзгартирмоқчи бўлган бир нарсани айтинг.';

  @override
  String get chatWriteMessage => 'Хабар ёзинг…';

  @override
  String get chatSendMessage => 'Хабарни юбориш';

  @override
  String get chatReplyTo => 'Жавоб бериш';

  @override
  String get chatReplyCancel => 'Жавобни бекор қилиш';

  @override
  String get chatTyping => 'ёзяпти…';

  @override
  String get chatOpenTimeRemaining => 'Чат 72 соат очиқ';

  @override
  String get chatMoreActions => 'Қўшимча амаллар';

  @override
  String get chatMoreSheetTitle => 'Иловани улашиш';

  @override
  String get chatMoreSheetSubtitle =>
      'Дўстларингизни Совчига таклиф қилинг — таклиф коди билан.';

  @override
  String get chatReportAction => 'Шикоят қилиш';

  @override
  String get chatDeleteAction => 'Чатни ўчириш';

  @override
  String chatDeleteTitle(String name) {
    return '$name ni suhbatni oʻchirmoqchimisiz?';
  }

  @override
  String get chatDeleteSubtitle =>
      'Агар суҳбатни ўчирсангиз номзод малумотлари ҳам беркитилади!';

  @override
  String get chatDeleteCancel => 'Бекор қилиш';

  @override
  String get chatDeleteConfirm => 'Ўчириш';

  @override
  String get mockMessageMohiraName => 'Моҳира Р.';

  @override
  String get mockMessageZilolaName => 'Зилола К.';

  @override
  String get mockMessageNilufarName => 'Нилуфар А.';

  @override
  String get mockMessageDilnozaName => 'Дилноза С.';

  @override
  String get mockMessageMohiraPreview => 'Вақтингиз бўлса танишсак.';

  @override
  String get mockMessageZilolaPreview => 'Таклифингиз кўрилди';

  @override
  String get mockMessageNilufarPreview => 'Чат муддати тугади';

  @override
  String get mockMessageDilnozaPreview => 'Ҳозирча жавоб кутилмоқда';

  @override
  String get messageTimeYesterday => 'Кеча';

  @override
  String get messageTimeMonday => 'Душ';

  @override
  String get messageTimeTuesday => 'Сеш';

  @override
  String get savedFilterAll => 'Ҳаммаси';

  @override
  String get savedFilterInvited => 'Таклиф юборилган';

  @override
  String get savedFilterWaiting => 'Жавоб кутилмоқда';

  @override
  String savedLimitLabel(int savedCount, int limit) {
    return '$savedCount / $limit saqlangan';
  }

  @override
  String get savedPremiumCta => 'Премиум — чексиз';

  @override
  String savedUpsellTitle(int remaining) {
    return 'Yana $remaining ta joy qoldi';
  }

  @override
  String get savedUpsellMessage =>
      'Бепул режада 10 тагача профил сақланади. Премиум билан чеклов йўқ.';

  @override
  String get questionnaireOptionalBadge => 'Ихтиёрий қадам';

  @override
  String questionnaireIntroTitle(int count, int minutes) {
    return '$count ta savol — $minutes daqiqa';
  }

  @override
  String get questionnaireIntroDescription =>
      'Жавобларингизни таҳлил қилиб, ҳар бир номзод билан мослик фоизингизни кўрсатамиз. Хоҳламасангиз, кейинроқ ҳам топширасиз.';

  @override
  String questionnaireQuestionCount(int count) {
    return '$count savol';
  }

  @override
  String get questionnaireWithoutTitle => 'Сўровномасиз нима бўлади?';

  @override
  String get questionnaireWithoutBody =>
      'Профилингиз ишлайди ва номзодларни кўрасиз, лекин АИ мосликни ҳисобламайди — фоиз ва бўлимлар кесимидаги таҳлил ёпиқ қолади.';

  @override
  String get questionnaireStart => 'Ҳа, сўровномани бошлайман';

  @override
  String get questionnaireLater => 'Кейинроқ тўлдираман';

  @override
  String get questionnaireEmpty => 'Ҳозирча саволлар мавжуд емас.';

  @override
  String questionnaireProgress(int current, int total) {
    return '$current/$total';
  }

  @override
  String get questionnaireNext => 'Кейинги савол';

  @override
  String get questionnaireSubmit => 'Жавобларни юбориш';

  @override
  String get questionnaireAnalysisTitle => 'Жавобларингиз таҳлил қилинмоқда';

  @override
  String get questionnaireAnalysisBody =>
      'АИ қадриятлар, молия ва характер профилингизни тузиб, мос номзодларни танлайди.';

  @override
  String get questionnaireResultTitle => 'Сизнинг профилингиз тайёр!';

  @override
  String get questionnaireResultSubtitle =>
      'Суний интеллект аниқлаган мослик енди очиқ.';

  @override
  String get questionnaireHonestyPill => 'Самимийлик: юқори';

  @override
  String get questionnaireSeriousPill => 'Нияти жиддий';

  @override
  String questionnaireMatchedCandidates(int count) {
    return '$count ta mos nomzod';
  }

  @override
  String get questionnaireMatchedCandidatesSubtitle =>
      'Мослик АИ томонидан ҳисобланди';

  @override
  String get questionnaireNextStepsTitle => 'Енди нима бўлади?';

  @override
  String get questionnaireAiMatchCalculatedTitle => 'АИ мослик ҳисобланди';

  @override
  String get questionnaireAiMatchCalculatedBody =>
      'Жавобларингиз асосида номзодлар танланди.';

  @override
  String get questionnaireCandidatesVeiledTitle => 'Номзодлар парда остида';

  @override
  String get questionnaireCandidatesVeiledBody =>
      'Суратлар иккала томон розилигидан кейин очилади.';

  @override
  String get questionnaireConsentOnlyTitle => 'Алоқа фақат розилик билан';

  @override
  String get questionnaireConsentOnlyBody =>
      'Суҳбат вакил ёки оила иштирокида бошланади.';

  @override
  String get questionnaireHonestyTitle => 'Самимийлик индекси · юқори';

  @override
  String get questionnaireHonestyBody =>
      'Тузоқ саволларга жавобларингиз изчил. Профил ишончли деб белгиланди.';

  @override
  String get questionnaireSeriousBadge => '“Нияти жиддий” белгиси берилди';

  @override
  String get questionnaireShowCandidates => 'Мос номзодларни кўриш';

  @override
  String get questionnaireTraitTraditional => 'ананавий';

  @override
  String get questionnaireTraitBalanced => 'балансли';

  @override
  String get candidatesViewGrid => 'Катак кўриниши';

  @override
  String get candidatesViewMap => 'Харита кўриниши';

  @override
  String get nearbyPermissionTitle => 'Яқин атрофдаги номзодлар';

  @override
  String get nearbyPermissionDescription =>
      'Жойлашувингиз аниқ нуқта сифатида емас, тахминий зона сифатида ишлатилади.';

  @override
  String get nearbyPermissionOpenSettings => 'Созламаларни очиш';

  @override
  String get nearbyPermissionEnableService => 'Жойлашувни ёқиш';

  @override
  String get nearbyPermissionAllow => 'Жойлашувга рухсат бериш';

  @override
  String get nearbyPermissionNotNow => 'Ҳозир емас';

  @override
  String get nearbyPermissionFootnote =>
      '«Ҳозир емас» ни танласангиз, Мослар ва Тавсиялар аввалгидек ишлайди.';

  @override
  String get nearbyPermissionRuleHidden =>
      'Аниқ манзилингиз ҳеч кимга кўрсатилмайди';

  @override
  String get nearbyPermissionRuleZone =>
      'Бошқалар сизни ~2 км ли зона ичида кўради';

  @override
  String get nearbyPermissionRuleSettings =>
      'Исталган вақтда Созламалардан ўчирасиз';

  @override
  String get nearbyUnknownZone => 'Яқин зона';

  @override
  String nearbyCandidateCount(int count) {
    return '$count ta nomzod';
  }

  @override
  String nearbyZoneDistance(String zone, String distance) {
    return '$zone · ~$distance km';
  }

  @override
  String get nearbyYou => 'Сиз';

  @override
  String nearbyAroundCount(int count) {
    return 'Atrofingizda $count ta nomzod';
  }

  @override
  String get nearbyShowAll => 'Барчаси';

  @override
  String get nearbyCloseMap => 'Харитани ёпиш';

  @override
  String nearbyWithinRadius(int radius) {
    return '$radius km ichida';
  }

  @override
  String get nearbyRecenter => 'Жойлашувимга қайтиш';

  @override
  String get nearbySettingsTitle => 'Радиус ва кўриниш';

  @override
  String get nearbySearchRadiusLabel => 'Радиус';

  @override
  String get nearbyRadiusRange => '1–25 км';

  @override
  String nearbyRadiusOption(int radius) {
    return '$radius km';
  }

  @override
  String get nearbyEntireRegion => 'Бутун вилоят';

  @override
  String get nearbyEntireRegionUnavailable =>
      'Бутун вилоят бўйича қидирув ҳозирча мавжуд емас';

  @override
  String get nearbyRadiusHint =>
      'Радиус қанчалик катта бўлса, мослик фоизи шунчалик пасаяди.';

  @override
  String get nearbyVisibilityTitle => 'Мени Атрофдагилар рўйхатида кўрсатиш';

  @override
  String get nearbyVisibilitySubtitle =>
      'Ўчирсангиз, сиз ҳам ҳеч кимни кўрмайсиз';

  @override
  String get nearbyAudienceTitle => 'Ким мени Атрофдагиларда кўра олади';

  @override
  String get nearbyAudienceAll => 'Ҳамма номзодлар';

  @override
  String get nearbyAudienceHighMatch => 'Фақат мослик 70% дан юқори';

  @override
  String get nearbyAudienceRecommended => 'тавсия етилади';

  @override
  String get nearbyAudienceRepresented => 'Фақат вакили бор номзодлар';

  @override
  String get nearbyPrivacyZoneNote =>
      'Зона маркази кунига бир марта тасодифий силжийди — шунинг учун сизнинг уйингизни ҳисоблаб бўлмайди.';

  @override
  String get nearbySettingsSave => 'Сақлаш';

  @override
  String nearbyEmptyTitle(int radius) {
    return '$radius km ichida hozircha nomzod yo‘q';
  }

  @override
  String get nearbyEmptyDescription =>
      'Радиусни кенгайтиринг ёки мезонларни бироз юмшатинг.';

  @override
  String nearbyExpandRadius(int radius) {
    return 'Radiusni $radius km ga kengaytirish';
  }

  @override
  String get nearbyChangeCriteria => 'Мезонларни ўзгартириш';

  @override
  String get nearbyNotifyTitle => 'Янги номзод пайдо бўлса хабар беринг';

  @override
  String get nearbyNotifySubtitle => 'Кунига бир марта, кўпи билан';

  @override
  String get profileEdit => 'Профилни таҳрирлаш';

  @override
  String get profileSettings => 'Профил созламалари';

  @override
  String profileIdentifier(String code) {
    return 'Foydalanuvchi raqami: $code';
  }

  @override
  String get profilePreview => 'Бошқалар кўриниши';

  @override
  String get profileCopyIdentifier => 'Фойдаланувчи рақамини нусхалаш';

  @override
  String get profileCompleteTitle => 'Профилингизни тўлдиринг';

  @override
  String get profileCompleteSubtitle => 'Аниқроқ жуфтлик топиш учун';

  @override
  String get profileMyPhotos => 'СУРАТЛАРИМ';

  @override
  String get profileMainPhoto => 'АСОСИЙ';

  @override
  String get profileAddPhoto => 'Сурат қўшиш';

  @override
  String profilePhotoSemantics(int index) {
    return 'Profil surati $index';
  }

  @override
  String get profilePhotoSourceTitle => 'Янги сурат';

  @override
  String get profilePhotoSourceSubtitle =>
      'Юклангандан сўнг сурат юз текширувидан ўтади.';

  @override
  String get profilePhotoCamera => 'Камерадан олиш';

  @override
  String get profilePhotoGallery => 'Галереядан танлаш';

  @override
  String get profilePhotoActionsTitle => 'Сурат';

  @override
  String get profilePhotoSetMain => 'Асосий қилиб белгилаш';

  @override
  String get profilePhotoReplace => 'Алмаштириш';

  @override
  String get profilePhotoDelete => 'Ўчириш';

  @override
  String get profilePhotoCancel => 'Бекор қилиш';

  @override
  String get profilePhotoDeleteTitle => 'Суратни ўчирасизми?';

  @override
  String get profilePhotoDeleteSubtitle =>
      'Сурат профилингиздан олиб ташланади. Ўрнига янгисини юклашингиз мумкин.';

  @override
  String get profileAboutSection => 'ЎЗИНГИЗ ҲАҚИНГИЗДА';

  @override
  String get profileNotFilled => 'Ҳали тўлдирилмаган';

  @override
  String get profileAdd => 'Қўшиш';

  @override
  String get profileEditShort => 'Таҳрирлаш';

  @override
  String get profilePhotoVerification => 'Расм текшируви';

  @override
  String get profilePhotoVerificationSubtitle =>
      'Асосий суратингиз камера орқали селфи билан солиштирилади';

  @override
  String get profileServices => 'Хизматлар';

  @override
  String get profileServicesSubtitle =>
      'Психолог, оилавий учрашув, текширув ва Премиум';

  @override
  String get profileIdentifierCopied => 'Фойдаланувчи рақами нусхаланди';

  @override
  String get profileActionComingSoon =>
      'Бу бўлим кейинги профил босқичида уланади';

  @override
  String get settingsTitle => 'Созламалар';

  @override
  String get settingsBack => 'Орқага';

  @override
  String get settingsAccountSection => 'Ҳисоб';

  @override
  String get settingsLanguage => 'Тил';

  @override
  String get settingsTheme => 'Мавзу';

  @override
  String get settingsLanguageSheetTitle => 'Тил';

  @override
  String get settingsThemeSheetTitle => 'Мавзу';

  @override
  String get settingsLanguageUzbekLatin => 'O‘zbek';

  @override
  String get settingsLanguageUzbekCyrillic => 'Ўзбек';

  @override
  String get settingsLanguageRussian => 'Русский';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsThemeSystem => 'Автоматик';

  @override
  String get settingsThemeLight => 'Ёруғ';

  @override
  String get settingsThemeDark => 'Қоронғи';

  @override
  String get settingsEditProfile => 'Профилни таҳрирлаш';

  @override
  String get settingsPhotoPrivacy => 'Расм махфийлиги';

  @override
  String get settingsPhotoPrivacyAll => 'Ҳаммага очиқ';

  @override
  String get settingsBlockedUsers => 'Блокланган фойдаланувчилар';

  @override
  String get settingsRecoveryQuestion => 'Ҳисобни тиклаш саволи';

  @override
  String get settingsPrivacyChatSection => 'Махфийлик ва суҳбат';

  @override
  String get settingsPrivacyVeil => 'Махфийлик ва парда тартиби';

  @override
  String get settingsChatLimits => 'Суҳбат лимитлари';

  @override
  String get settingsChatLimitValue => '72 соат';

  @override
  String get settingsParentLink => 'Ота-она улаш';

  @override
  String get settingsNotificationAppearanceSection => 'Билдиришнома ва кўриниш';

  @override
  String get settingsNotifications => 'Билдиришномалар';

  @override
  String get settingsNotificationsSubtitle =>
      'Янги лайк, мослик ва хабарлар ҳақида хабар берилади';

  @override
  String get settingsNotificationTypes => 'Билдиришнома турлари';

  @override
  String get settingsDocumentsSection => 'Ҳужжатлар';

  @override
  String get settingsPrivacyPolicy => 'Махфийлик сиёсати';

  @override
  String get settingsTerms => 'Фойдаланиш шартлари';

  @override
  String get settingsHelpInfoSection => 'Ёрдам ва маълумот';

  @override
  String get settingsServices => 'Хизматлар';

  @override
  String get settingsHelpCenter => 'Ёрдам маркази';

  @override
  String get settingsShareApp => 'Иловани улашиш';

  @override
  String get settingsLogout => 'Ҳисобдан чиқиш';

  @override
  String get settingsActionComingSoon => 'Бу созлама кейинги босқичда уланади';

  @override
  String get privacyPolicyLoadingLabel => 'Махфийлик сиёсати юкланмоқда';

  @override
  String get privacyPolicyLoadError =>
      'Махфийлик сиёсатини юклаб бўлмади. Интернет алоқасини текшириб, қайта уриниб кўринг.';

  @override
  String get termsOfServiceLoadingLabel => 'Фойдаланиш шартлари юкланмоқда';

  @override
  String get termsOfServiceLoadError =>
      'Фойдаланиш шартларини юклаб бўлмади. Интернет алоқасини текшириб, қайта уриниб кўринг.';

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

  @override
  String get profileEditTitle => 'Профилни таҳрирлаш';

  @override
  String get profileEditAvatarTitle => 'Профил сурати';

  @override
  String get profileEditChangePhoto => 'Суратни ўзгартириш';

  @override
  String get profilePhotoManagementTitle => 'Асосий сурат';

  @override
  String get profilePhotoManagementSubtitle =>
      'Профилингизда ва номзодлар рўйхатида биринчи шу сурат кўринади. Селфи текшируви ҳам шу сурат билан солиштирилади.';

  @override
  String get profilePhotoConfirm => 'Тасдиқлаш';

  @override
  String get profileFaceVerificationDone => 'Давом етиш';

  @override
  String get profileEditName => 'Исм';

  @override
  String get profileEditBirthYear => 'Туғилган йил';

  @override
  String get profileEditHeight => 'Бўй';

  @override
  String get profileEditWeight => 'Вазн';

  @override
  String get profileEditEducation => 'Малумоти';

  @override
  String get profileEditProfession => 'Касби';

  @override
  String get profileEditRegion => 'Вилоят';

  @override
  String get profileEditDistrict => 'Туман';

  @override
  String get profileEditMaritalStatus => 'Оилавий ҳолати';

  @override
  String get profileEditAboutSection => 'ЎЗИНГИЗ ҲАҚИНГИЗДА';

  @override
  String get profileEditAboutPlaceholder =>
      'Ўзингиз, қадриятларингиз ва келажак режаларингиз ҳақида қисқа ёзинг…';

  @override
  String get profileEditSave => 'Сақлаш';

  @override
  String get profileEditCancel => 'Бекор қилиш';

  @override
  String get profileEditSuccess => 'Профил муваффақиятли сақланди';

  @override
  String get profileEditFirstName => 'Исм';

  @override
  String get profileEditLastName => 'Фамилия';

  @override
  String get profileEditSelect => 'Танлаш';

  @override
  String get profileEditSelectOption => 'Танланг';

  @override
  String get profileEditProfessionOther => 'Бошқа';

  @override
  String get profileEditProfessionInputLabel => 'Касбингизни ёзинг';

  @override
  String get profileEditSearchPlaceholder => 'Қидириш...';

  @override
  String get profileEditRegionSearchHint => 'Вилоят қидириш...';

  @override
  String get profileEditDistrictSearchHint => 'Туман қидириш...';

  @override
  String profileEditDistrictRegionCaption(String region) {
    return '$region boʻyicha';
  }

  @override
  String get profileEditNoOptions => 'Малумот топилмади';

  @override
  String profileEditCm(int cm) {
    return '$cm sm';
  }

  @override
  String profileEditKg(int kg) {
    return '$kg kg';
  }

  @override
  String get profileEditSelectRegionFirst => 'Олдин вилоятни танланг';

  @override
  String get profileEditDiscardConfirmTitle => 'Ўзгаришларни бекор қиласизми?';

  @override
  String get profileEditDiscardConfirmMessage =>
      'Сақланмаган малумотлар йўқолади.';

  @override
  String get profileEditDiscard => 'Бекор қилиш';

  @override
  String get profileEditKeepEditing => 'Қолиш';

  @override
  String get profileEditUnsavedTitle => 'Ўзгаришлар сақланмади';

  @override
  String get profileEditUnsavedMessage =>
      'Чиқсангиз, киритилган ўзгаришлар йўқолади.';

  @override
  String get profileEditStayEditing => 'Таҳрирлашда қолиш';

  @override
  String get profileEditExit => 'Чиқиш';

  @override
  String get profileEditUpdatedTitle => 'Профил янгиланди';

  @override
  String get profileEditUpdatedMessage =>
      'Ўзгаришлар сақланди. Профилингиз номзодларга янгиланган кўринишда кўрсатилади.';

  @override
  String get profileEditUpdatedOk => 'Яхши';

  @override
  String get blockedUsersTitle => 'Блокланган профиллар';

  @override
  String get blockedUsersSubtitle =>
      'Блокланган профиллар сизни қидирувда кўрмайди ва ёзолмайди.';

  @override
  String get blockedUsersEmpty => 'Блокланган профиллар йўқ';

  @override
  String get blockedUsersEmptySubtitle =>
      'Сиз блоклаган барча профиллар шу йерда кўринади.';

  @override
  String get blockedUsersNote =>
      'Шикоят қилинган профил модератор кўригидан кейин автоматик блокланади — бу рўйхатда «Шикоятдан кейин» деб белгиланади.';

  @override
  String blockedAtDate(String date) {
    return 'Bloklangan $date';
  }

  @override
  String get blockedAfterComplaint => 'Шикоятдан кейин блокланган';

  @override
  String get unblockButton => 'Блокдан чиқариш';

  @override
  String get unblockSuccess => 'Фойдаланувчи блокдан чиқарилди';

  @override
  String get unblockConfirmTitle => 'Блокдан чиқарилсинми?';

  @override
  String get unblockConfirmMessage =>
      'Ушбу профил яна сизга хабар ёза олади ва профилингизни кўра олади.';

  @override
  String get cancel => 'Бекор қилиш';

  @override
  String get accountDeletionTitle => 'Ҳисобни ўчириш';

  @override
  String get accountDeletionWarningTitle => 'Бу амал қайтарилмайди';

  @override
  String get accountDeletionWarningMessage =>
      'Ҳисоб ўчирилгач профилингизни тиклаш имкони бўлмайди.';

  @override
  String get accountDeletionItemsTitle => 'НИМАЛАР ЎЧИРИЛАДИ';

  @override
  String get accountDeletionPhotos => 'Барча суратлар ва овозли таништирув';

  @override
  String get accountDeletionQuestionnaire =>
      'Сўровнома жавоблари ва мослик натижалари';

  @override
  String get accountDeletionChats => 'Суҳбатлар ва сақланган профиллар';

  @override
  String get accountDeletionRepresentative => 'Уланган вакил билан боғланиш';

  @override
  String get accountDeletionReasonTitle => 'САБАБ (ИХТИЁРИЙ)';

  @override
  String get accountDeletionReasonFoundMatch => 'Жуфтлик топдим';

  @override
  String get accountDeletionReasonNoTime => 'Ҳозирча вақтим йўқ';

  @override
  String get accountDeletionReasonPrivacy => 'Махфийлик хавотири';

  @override
  String get accountDeletionConfirm => 'Ҳисобни ўчириш';

  @override
  String get accountDeletionCancel => 'Бекор қилиш';
}
