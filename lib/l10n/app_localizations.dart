import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_uz.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
    Locale('uz'),
  ];

  /// No description provided for @faceCaptureTitle.
  ///
  /// In uz, this message translates to:
  /// **'Bir marta selfi olamiz'**
  String get faceCaptureTitle;

  /// No description provided for @faceCaptureSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Asosiy suratingiz bilan solishtiramiz. Hech kimga ko‘rinmaydi va tekshiruvdan keyin o‘chiriladi.'**
  String get faceCaptureSubtitle;

  /// No description provided for @selfieCameraLabel.
  ///
  /// In uz, this message translates to:
  /// **'selfi kamera'**
  String get selfieCameraLabel;

  /// No description provided for @faceRuleOne.
  ///
  /// In uz, this message translates to:
  /// **'Yuzingizni doira ichiga joylashtiring.'**
  String get faceRuleOne;

  /// No description provided for @faceRuleTwo.
  ///
  /// In uz, this message translates to:
  /// **'Yuzingiz yaxshi ko‘rinsin — shu yetarli.'**
  String get faceRuleTwo;

  /// No description provided for @faceRuleThree.
  ///
  /// In uz, this message translates to:
  /// **'Telefonni ko‘z darajasida ushlang.'**
  String get faceRuleThree;

  /// No description provided for @takeSelfieLabel.
  ///
  /// In uz, this message translates to:
  /// **'Selfi olish'**
  String get takeSelfieLabel;

  /// No description provided for @aboutMeTitle.
  ///
  /// In uz, this message translates to:
  /// **'O‘zingiz haqingizda'**
  String get aboutMeTitle;

  /// No description provided for @aboutMeSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Ixtiyoriy. Qisqacha yozing — nomzodlar shuni o‘qiydi.'**
  String get aboutMeSubtitle;

  /// No description provided for @aboutMeHint.
  ///
  /// In uz, this message translates to:
  /// **'O‘zingiz, kasbingiz va oilaviy qadriyatlaringiz haqida 2–3 gap...'**
  String get aboutMeHint;

  /// No description provided for @aboutMeCounter.
  ///
  /// In uz, this message translates to:
  /// **'{count} / 300 belgi'**
  String aboutMeCounter(int count);

  /// No description provided for @mainPhotoSelectionHint.
  ///
  /// In uz, this message translates to:
  /// **'Asosiy suratni tanlang'**
  String get mainPhotoSelectionHint;

  /// No description provided for @mainPhotoSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Profilingizda birinchi shu surat ko‘rinadi va selfi bilan solishtiriladi.'**
  String get mainPhotoSubtitle;

  /// No description provided for @mainPhotoBadge.
  ///
  /// In uz, this message translates to:
  /// **'ASOSIY'**
  String get mainPhotoBadge;

  /// No description provided for @faceRetryHint.
  ///
  /// In uz, this message translates to:
  /// **'Selfi mos kelmadi. Qayta urinib ko‘ring.'**
  String get faceRetryHint;

  /// No description provided for @faceCameraError.
  ///
  /// In uz, this message translates to:
  /// **'Kamera ishga tushmadi.'**
  String get faceCameraError;

  /// No description provided for @onboardingSuccessTitle.
  ///
  /// In uz, this message translates to:
  /// **'Profillingiz tayyor!'**
  String get onboardingSuccessTitle;

  /// No description provided for @onboardingSuccessSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Hammasi saqlandi. Endi sizga mos nomzodlarni ko‘rishingiz mumkin.'**
  String get onboardingSuccessSubtitle;

  /// No description provided for @pledgeConfirmationTitle.
  ///
  /// In uz, this message translates to:
  /// **'Niyatingizni tasdiqlang'**
  String get pledgeConfirmationTitle;

  /// No description provided for @pledgeConfirmationSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Bu qadam majburiy. Tasdiqlagach profilingizda «Niyati jiddiy» belgisi paydo bo‘ladi.'**
  String get pledgeConfirmationSubtitle;

  /// No description provided for @pledgeConfirmationPointOne.
  ///
  /// In uz, this message translates to:
  /// **'Ma’lumotlarim to‘g‘ri va o‘zimga tegishli.'**
  String get pledgeConfirmationPointOne;

  /// No description provided for @pledgeConfirmationPointTwo.
  ///
  /// In uz, this message translates to:
  /// **'Niyatim jiddiy — oila qurish uchun keldim.'**
  String get pledgeConfirmationPointTwo;

  /// No description provided for @pledgeConfirmationPointThree.
  ///
  /// In uz, this message translates to:
  /// **'Suhbatdoshga hurmat bilan munosabatda bo‘laman.'**
  String get pledgeConfirmationPointThree;

  /// No description provided for @pledgeConfirmationButton.
  ///
  /// In uz, this message translates to:
  /// **'Qasamni tasdiqlash'**
  String get pledgeConfirmationButton;

  /// No description provided for @privacyPolicyAgreementSuffix.
  ///
  /// In uz, this message translates to:
  /// **' bilan tanishing'**
  String get privacyPolicyAgreementSuffix;

  /// No description provided for @aiTestBadge.
  ///
  /// In uz, this message translates to:
  /// **'AI MOSLIK TESTI'**
  String get aiTestBadge;

  /// No description provided for @aiTestTitle.
  ///
  /// In uz, this message translates to:
  /// **'30 ta savolga javob berasizmi?'**
  String get aiTestTitle;

  /// No description provided for @aiTestDescription.
  ///
  /// In uz, this message translates to:
  /// **'Javoblaringiz asosida har bir nomzod bilan qanchalik mos kelishingizni hisoblaymiz. Taxminan 8 daqiqa.'**
  String get aiTestDescription;

  /// No description provided for @aiTestPointOne.
  ///
  /// In uz, this message translates to:
  /// **'AI tahlili — 8 daqiqada tayyor'**
  String get aiTestPointOne;

  /// No description provided for @aiTestPointTwo.
  ///
  /// In uz, this message translates to:
  /// **'Mos juftlar avtomatik tanlanadi'**
  String get aiTestPointTwo;

  /// No description provided for @aiTestPointThree.
  ///
  /// In uz, this message translates to:
  /// **'Javoblaringiz hech kimga ko‘rsatilmaydi'**
  String get aiTestPointThree;

  /// No description provided for @startAiTest.
  ///
  /// In uz, this message translates to:
  /// **'Ha, testni boshlayman'**
  String get startAiTest;

  /// No description provided for @viewCandidatesLater.
  ///
  /// In uz, this message translates to:
  /// **'Keyinroq — avval nomzodlarni ko‘raman'**
  String get viewCandidatesLater;

  /// Application title.
  ///
  /// In uz, this message translates to:
  /// **'Raqamli Sovchi'**
  String get appTitle;

  /// No description provided for @loading.
  ///
  /// In uz, this message translates to:
  /// **'Yuklanmoqda...'**
  String get loading;

  /// No description provided for @splashSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Shoshilmasdan, oila bilan'**
  String get splashSubtitle;

  /// No description provided for @loginTitle.
  ///
  /// In uz, this message translates to:
  /// **'Xush kelibsiz'**
  String get loginTitle;

  /// No description provided for @loginHeadline.
  ///
  /// In uz, this message translates to:
  /// **'Shoshilmasdan,\noila bilan'**
  String get loginHeadline;

  /// No description provided for @loginSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Telefon raqamingiz bilan boshlaymiz'**
  String get loginSubtitle;

  /// No description provided for @phoneLabel.
  ///
  /// In uz, this message translates to:
  /// **'Telefon raqam'**
  String get phoneLabel;

  /// No description provided for @phoneError.
  ///
  /// In uz, this message translates to:
  /// **'Telefon raqamni toʻgʻri kiriting.'**
  String get phoneError;

  /// No description provided for @continueLabel.
  ///
  /// In uz, this message translates to:
  /// **'Davom etish'**
  String get continueLabel;

  /// No description provided for @orLabel.
  ///
  /// In uz, this message translates to:
  /// **'yoki'**
  String get orLabel;

  /// No description provided for @loginNote.
  ///
  /// In uz, this message translates to:
  /// **'Raqamingizni hech kim koʻrmaydi. Har bir profil qoʻlda tekshiriladi. Bu yerda faqat nikoh niyatidagilar qoladi.'**
  String get loginNote;

  /// No description provided for @otpTitle.
  ///
  /// In uz, this message translates to:
  /// **'Kodni kiriting'**
  String get otpTitle;

  /// Message shown after sending OTP to a phone number.
  ///
  /// In uz, this message translates to:
  /// **'{phone} raqamiga 4 xonali kod yubordik'**
  String otpSentTo(String phone);

  /// No description provided for @otpResend.
  ///
  /// In uz, this message translates to:
  /// **'Kod kelmadimi? 00:48 dan keyin qayta yuboramiz'**
  String get otpResend;

  /// No description provided for @confirmLabel.
  ///
  /// In uz, this message translates to:
  /// **'Tasdiqlash'**
  String get confirmLabel;

  /// No description provided for @candidateTypeTitle.
  ///
  /// In uz, this message translates to:
  /// **'Kim sifatida qidiryapsiz?'**
  String get candidateTypeTitle;

  /// No description provided for @candidateTypeSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Bu tanlov anketangiz qanday bo‘lishini belgilaydi. Jinsni qayta so‘ramaymiz.'**
  String get candidateTypeSubtitle;

  /// No description provided for @groomCandidateTitle.
  ///
  /// In uz, this message translates to:
  /// **'Kuyov nomzodi'**
  String get groomCandidateTitle;

  /// No description provided for @groomCandidateSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Erkakman, o‘zim uchun izlayapman'**
  String get groomCandidateSubtitle;

  /// No description provided for @brideCandidateTitle.
  ///
  /// In uz, this message translates to:
  /// **'Kelin nomzodi'**
  String get brideCandidateTitle;

  /// No description provided for @brideCandidateSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Ayolman, o‘zim uchun izlayapman'**
  String get brideCandidateSubtitle;

  /// No description provided for @representativeCandidateTitle.
  ///
  /// In uz, this message translates to:
  /// **'Vakil'**
  String get representativeCandidateTitle;

  /// No description provided for @representativeCandidateSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Yaqinim nomidan ariza to‘ldiraman'**
  String get representativeCandidateSubtitle;

  /// No description provided for @pledgeTitle.
  ///
  /// In uz, this message translates to:
  /// **'Bir-birimizga ishonch uchun'**
  String get pledgeTitle;

  /// No description provided for @pledgePointOne.
  ///
  /// In uz, this message translates to:
  /// **'Bu ilovadan faqat nikoh niyatida foydalanaman.'**
  String get pledgePointOne;

  /// No description provided for @pledgePointTwo.
  ///
  /// In uz, this message translates to:
  /// **'Ma’lumotlarim to‘g‘ri, suratlar o‘zimniki.'**
  String get pledgePointTwo;

  /// No description provided for @pledgePointThree.
  ///
  /// In uz, this message translates to:
  /// **'Suhbatda odob saqlayman. AI moderator nazoratiga roziman.'**
  String get pledgePointThree;

  /// No description provided for @pledgeAgreement.
  ///
  /// In uz, this message translates to:
  /// **'Roziman. Profilimda «Niyati jiddiy» belgisi ko‘rinsin.'**
  String get pledgeAgreement;

  /// No description provided for @pledgeStart.
  ///
  /// In uz, this message translates to:
  /// **'Anketani boshlash'**
  String get pledgeStart;

  /// No description provided for @onboardingProgress.
  ///
  /// In uz, this message translates to:
  /// **'{total} bosqichdan {current}-bosqich'**
  String onboardingProgress(Object current, Object total);

  /// No description provided for @birthDateTitle.
  ///
  /// In uz, this message translates to:
  /// **'Tug‘ilgan yilingiz'**
  String get birthDateTitle;

  /// No description provided for @birthDateHint.
  ///
  /// In uz, this message translates to:
  /// **'18 yoshdan kichik foydalanuvchilar ro‘yxatdan o‘ta olmaydi.'**
  String get birthDateHint;

  /// No description provided for @birthDateSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Yoshingiz nomzodlarga ko‘rinadi, aniq sana emas.'**
  String get birthDateSubtitle;

  /// No description provided for @identityTitle.
  ///
  /// In uz, this message translates to:
  /// **'Ismingiz va familiyangiz'**
  String get identityTitle;

  /// No description provided for @identitySubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Pasportdagidek yozing — nomzodlar shu ismni ko‘radi.'**
  String get identitySubtitle;

  /// No description provided for @firstNameLabel.
  ///
  /// In uz, this message translates to:
  /// **'Ismingiz'**
  String get firstNameLabel;

  /// No description provided for @lastNameLabel.
  ///
  /// In uz, this message translates to:
  /// **'Familiyangiz'**
  String get lastNameLabel;

  /// No description provided for @patronymicLabel.
  ///
  /// In uz, this message translates to:
  /// **'Otasining ismi (ixtiyoriy)'**
  String get patronymicLabel;

  /// No description provided for @professionTitle.
  ///
  /// In uz, this message translates to:
  /// **'Kasbingiz?'**
  String get professionTitle;

  /// No description provided for @professionOther.
  ///
  /// In uz, this message translates to:
  /// **'Boshqa'**
  String get professionOther;

  /// No description provided for @professionInputLabel.
  ///
  /// In uz, this message translates to:
  /// **'Kasbingizni yozing'**
  String get professionInputLabel;

  /// No description provided for @professionEmpty.
  ///
  /// In uz, this message translates to:
  /// **'Kasblar topilmadi.'**
  String get professionEmpty;

  /// No description provided for @representativeProfessionTitle.
  ///
  /// In uz, this message translates to:
  /// **'Nomzodning kasbi?'**
  String get representativeProfessionTitle;

  /// No description provided for @representativeProfessionInputLabel.
  ///
  /// In uz, this message translates to:
  /// **'Nomzodning kasbini yozing'**
  String get representativeProfessionInputLabel;

  /// No description provided for @educationTitle.
  ///
  /// In uz, this message translates to:
  /// **'Ma’lumotingiz qanday?'**
  String get educationTitle;

  /// No description provided for @heightTitle.
  ///
  /// In uz, this message translates to:
  /// **'Bo‘yingiz'**
  String get heightTitle;

  /// No description provided for @heightWeightTitle.
  ///
  /// In uz, this message translates to:
  /// **'Bo‘yingiz va vazningiz'**
  String get heightWeightTitle;

  /// No description provided for @heightLabel.
  ///
  /// In uz, this message translates to:
  /// **'Bo‘yi (sm)'**
  String get heightLabel;

  /// No description provided for @heightInputLabel.
  ///
  /// In uz, this message translates to:
  /// **'Bo‘yingiz'**
  String get heightInputLabel;

  /// No description provided for @heightUnit.
  ///
  /// In uz, this message translates to:
  /// **'sm'**
  String get heightUnit;

  /// No description provided for @weightLabel.
  ///
  /// In uz, this message translates to:
  /// **'Vazni (kg)'**
  String get weightLabel;

  /// No description provided for @weightInputLabel.
  ///
  /// In uz, this message translates to:
  /// **'Vazningiz'**
  String get weightInputLabel;

  /// No description provided for @weightUnit.
  ///
  /// In uz, this message translates to:
  /// **'kg'**
  String get weightUnit;

  /// No description provided for @decreaseHeightLabel.
  ///
  /// In uz, this message translates to:
  /// **'Bo‘yni kamaytirish'**
  String get decreaseHeightLabel;

  /// No description provided for @increaseHeightLabel.
  ///
  /// In uz, this message translates to:
  /// **'Bo‘yni oshirish'**
  String get increaseHeightLabel;

  /// No description provided for @decreaseWeightLabel.
  ///
  /// In uz, this message translates to:
  /// **'Vaznni kamaytirish'**
  String get decreaseWeightLabel;

  /// No description provided for @increaseWeightLabel.
  ///
  /// In uz, this message translates to:
  /// **'Vaznni oshirish'**
  String get increaseWeightLabel;

  /// No description provided for @locationTitle.
  ///
  /// In uz, this message translates to:
  /// **'Qayerda yashaysiz?'**
  String get locationTitle;

  /// No description provided for @regionLabel.
  ///
  /// In uz, this message translates to:
  /// **'Viloyat'**
  String get regionLabel;

  /// No description provided for @districtLabel.
  ///
  /// In uz, this message translates to:
  /// **'Tuman yoki shahar'**
  String get districtLabel;

  /// No description provided for @regionSheetTitle.
  ///
  /// In uz, this message translates to:
  /// **'Viloyatni tanlang'**
  String get regionSheetTitle;

  /// No description provided for @regionSheetCount.
  ///
  /// In uz, this message translates to:
  /// **'{count} ta hudud'**
  String regionSheetCount(Object count);

  /// No description provided for @districtSheetTitle.
  ///
  /// In uz, this message translates to:
  /// **'Tuman / shaharni tanlang'**
  String get districtSheetTitle;

  /// No description provided for @districtSheetSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'{region} · {count} ta tuman'**
  String districtSheetSubtitle(Object count, Object region);

  /// No description provided for @locationSearchPlaceholder.
  ///
  /// In uz, this message translates to:
  /// **'Tuman nomi bo‘yicha qidirish'**
  String get locationSearchPlaceholder;

  /// No description provided for @selectLabel.
  ///
  /// In uz, this message translates to:
  /// **'Tanlash'**
  String get selectLabel;

  /// No description provided for @unselectedValue.
  ///
  /// In uz, this message translates to:
  /// **'Tanlanmagan'**
  String get unselectedValue;

  /// No description provided for @selectRegionFirstValue.
  ///
  /// In uz, this message translates to:
  /// **'Avval viloyatni tanlang'**
  String get selectRegionFirstValue;

  /// No description provided for @healthStatusTitle.
  ///
  /// In uz, this message translates to:
  /// **'Sog‘liqlik darajangiz'**
  String get healthStatusTitle;

  /// No description provided for @healthStatusSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Bu ma’lumot faqat moslikni hisoblashda ishlatiladi.'**
  String get healthStatusSubtitle;

  /// No description provided for @healthHealthyLabel.
  ///
  /// In uz, this message translates to:
  /// **'Sog‘lom'**
  String get healthHealthyLabel;

  /// No description provided for @healthDisabilityLabel.
  ///
  /// In uz, this message translates to:
  /// **'Nogironligi bor'**
  String get healthDisabilityLabel;

  /// No description provided for @healthDisabilityHint.
  ///
  /// In uz, this message translates to:
  /// **'Keyingi qadamda qisqacha izohlashingiz mumkin'**
  String get healthDisabilityHint;

  /// No description provided for @maritalStatusTitle.
  ///
  /// In uz, this message translates to:
  /// **'Oilaviy holatingiz'**
  String get maritalStatusTitle;

  /// No description provided for @maritalStatusDivorcedHint.
  ///
  /// In uz, this message translates to:
  /// **'«Ajrashgan» tanlanganda farzandlar soni majburiy bo‘ladi.'**
  String get maritalStatusDivorcedHint;

  /// No description provided for @maritalStatusFirstMarriageDetail.
  ///
  /// In uz, this message translates to:
  /// **'Avval turmush qurmagan'**
  String get maritalStatusFirstMarriageDetail;

  /// No description provided for @maritalStatusDivorcedDetail.
  ///
  /// In uz, this message translates to:
  /// **'Farzandlar soni so‘raladi'**
  String get maritalStatusDivorcedDetail;

  /// No description provided for @childrenCountLabel.
  ///
  /// In uz, this message translates to:
  /// **'Farzandlaringiz soni'**
  String get childrenCountLabel;

  /// No description provided for @decreaseChildrenLabel.
  ///
  /// In uz, this message translates to:
  /// **'Farzandlar sonini kamaytirish'**
  String get decreaseChildrenLabel;

  /// No description provided for @increaseChildrenLabel.
  ///
  /// In uz, this message translates to:
  /// **'Farzandlar sonini oshirish'**
  String get increaseChildrenLabel;

  /// No description provided for @childrenNotLivingTitle.
  ///
  /// In uz, this message translates to:
  /// **'Farzandlar men bilan yashamaydi'**
  String get childrenNotLivingTitle;

  /// No description provided for @childrenNotLivingDetail.
  ///
  /// In uz, this message translates to:
  /// **'Profilda «farzandi bor» deb ko‘rsatiladi, tafsilot yozilmaydi'**
  String get childrenNotLivingDetail;

  /// No description provided for @photoTitle.
  ///
  /// In uz, this message translates to:
  /// **'Suratlaringizni qo‘shing'**
  String get photoTitle;

  /// No description provided for @photoHint.
  ///
  /// In uz, this message translates to:
  /// **'5 tagacha surat. Ularni faqat siz ruxsat bergan odam ko‘radi.'**
  String get photoHint;

  /// No description provided for @photoPrivacyHint.
  ///
  /// In uz, this message translates to:
  /// **'Kamida 1 ta surat kerak. Yuz aniq ko‘rinishi shart.'**
  String get photoPrivacyHint;

  /// No description provided for @photoSlotAddLabel.
  ///
  /// In uz, this message translates to:
  /// **'surat'**
  String get photoSlotAddLabel;

  /// No description provided for @photoSlotFilledLabel.
  ///
  /// In uz, this message translates to:
  /// **'surat {order} ✓'**
  String photoSlotFilledLabel(int order);

  /// No description provided for @addPhoto.
  ///
  /// In uz, this message translates to:
  /// **'Surat qo‘shish'**
  String get addPhoto;

  /// No description provided for @setMainPhoto.
  ///
  /// In uz, this message translates to:
  /// **'Asosiy qilish'**
  String get setMainPhoto;

  /// No description provided for @removePhoto.
  ///
  /// In uz, this message translates to:
  /// **'O‘chirish'**
  String get removePhoto;

  /// No description provided for @voiceTitle.
  ///
  /// In uz, this message translates to:
  /// **'Ovozli tanishtiruv'**
  String get voiceTitle;

  /// No description provided for @voiceHint.
  ///
  /// In uz, this message translates to:
  /// **'AAC/M4A formatda 30 soniyagacha yozing.'**
  String get voiceHint;

  /// No description provided for @voiceShortHint.
  ///
  /// In uz, this message translates to:
  /// **'10–15 soniya yetarli. Ovoz odam haqida suratdan ko‘ra ko‘proq narsani aytadi.'**
  String get voiceShortHint;

  /// No description provided for @startRecording.
  ///
  /// In uz, this message translates to:
  /// **'Yozishni boshlash'**
  String get startRecording;

  /// No description provided for @stopRecording.
  ///
  /// In uz, this message translates to:
  /// **'Yozishni to‘xtatish'**
  String get stopRecording;

  /// No description provided for @playRecording.
  ///
  /// In uz, this message translates to:
  /// **'Yozuvni eshitish'**
  String get playRecording;

  /// No description provided for @voiceSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Ixtiyoriy. 10–15 soniya yetarli — ovoz odam haqida ko‘proq narsani aytadi.'**
  String get voiceSubtitle;

  /// No description provided for @startRecordingHint.
  ///
  /// In uz, this message translates to:
  /// **'Yozishni boshlash uchun bosing'**
  String get startRecordingHint;

  /// No description provided for @recordedVoiceHint.
  ///
  /// In uz, this message translates to:
  /// **'Eshitib ko‘ring. Yoqmasa qayta yozing yoki o‘chiring — ovoz ixtiyoriy.'**
  String get recordedVoiceHint;

  /// No description provided for @reRecordVoice.
  ///
  /// In uz, this message translates to:
  /// **'Qayta yozish'**
  String get reRecordVoice;

  /// No description provided for @deleteVoice.
  ///
  /// In uz, this message translates to:
  /// **'O‘chirish'**
  String get deleteVoice;

  /// No description provided for @locationPermissionTitle.
  ///
  /// In uz, this message translates to:
  /// **'Joylashuvingiz'**
  String get locationPermissionTitle;

  /// No description provided for @locationPermissionSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Yaqin hududdagi nomzodlarni birinchi ko‘rsatish uchun joylashuv ruxsati kerak. Aniq manzil hech kimga ko‘rinmaydi.'**
  String get locationPermissionSubtitle;

  /// No description provided for @enableLocation.
  ///
  /// In uz, this message translates to:
  /// **'Joylashuvni yoqish'**
  String get enableLocation;

  /// No description provided for @skipLabel.
  ///
  /// In uz, this message translates to:
  /// **'O‘tkazib yuborish'**
  String get skipLabel;

  /// No description provided for @faceTitle.
  ///
  /// In uz, this message translates to:
  /// **'Yuzingizni tasdiqlang'**
  String get faceTitle;

  /// No description provided for @faceHint.
  ///
  /// In uz, this message translates to:
  /// **'Yuzingiz to‘g‘ri qaragan va ko‘zlaringiz ochiq holda selfie oling.'**
  String get faceHint;

  /// No description provided for @verifyFace.
  ///
  /// In uz, this message translates to:
  /// **'Yuzni tasdiqlash'**
  String get verifyFace;

  /// No description provided for @finishOnboarding.
  ///
  /// In uz, this message translates to:
  /// **'Yakunlash va profilni ochish'**
  String get finishOnboarding;

  /// No description provided for @representativeFlowMessage.
  ///
  /// In uz, this message translates to:
  /// **'Vakil oqimi alohida anketa bo‘lib, keyinroq ochiladi.'**
  String get representativeFlowMessage;

  /// No description provided for @representativeIntroTitle.
  ///
  /// In uz, this message translates to:
  /// **'Siz vakil sifatida kirdingiz'**
  String get representativeIntroTitle;

  /// No description provided for @representativeIntroSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Vakil — nomzodning yaqin qarindoshi: amma, xola, amaki yoki tog‘a. Siz uning nomidan anketa to‘ldirasiz va kelgan takliflarni ko‘rib chiqasiz.'**
  String get representativeIntroSubtitle;

  /// No description provided for @representativeConsentRequiredTitle.
  ///
  /// In uz, this message translates to:
  /// **'Nomzodning roziligi shart'**
  String get representativeConsentRequiredTitle;

  /// No description provided for @representativeConsentRequiredBody.
  ///
  /// In uz, this message translates to:
  /// **'Anketa to‘ldirilgach nomzodga SMS yuboriladi. U tasdiqlamaguncha profil hech kimga ko‘rinmaydi.'**
  String get representativeConsentRequiredBody;

  /// No description provided for @representativeIntroFootnote.
  ///
  /// In uz, this message translates to:
  /// **'Keyingi qadamlarda avval o‘zingiz haqingizda, so‘ng nomzod haqida ma’lumot so‘raymiz.'**
  String get representativeIntroFootnote;

  /// No description provided for @startLabel.
  ///
  /// In uz, this message translates to:
  /// **'Boshlash'**
  String get startLabel;

  /// No description provided for @representativeSelfSection.
  ///
  /// In uz, this message translates to:
  /// **'1-QISM · SIZ HAQINGIZDA'**
  String get representativeSelfSection;

  /// No description provided for @representativeSelfTitle.
  ///
  /// In uz, this message translates to:
  /// **'O‘zingiz haqingizda'**
  String get representativeSelfTitle;

  /// No description provided for @representativeSelfSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Nomzod rozilik so‘rovida shu ismni ko‘radi.'**
  String get representativeSelfSubtitle;

  /// No description provided for @representativeRelationTitle.
  ///
  /// In uz, this message translates to:
  /// **'Nomzodga kimsiz?'**
  String get representativeRelationTitle;

  /// No description provided for @representativeCandidateSection.
  ///
  /// In uz, this message translates to:
  /// **'2-QISM · NOMZOD HAQIDA'**
  String get representativeCandidateSection;

  /// No description provided for @representativeCandidateTypeTitle.
  ///
  /// In uz, this message translates to:
  /// **'Nomzod kim?'**
  String get representativeCandidateTypeTitle;

  /// No description provided for @representativeCandidateTypeSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Shundan keyingi barcha savollar nomzod haqida bo‘ladi — o‘zingiz haqingizda emas.'**
  String get representativeCandidateTypeSubtitle;

  /// No description provided for @representativeBrideTitle.
  ///
  /// In uz, this message translates to:
  /// **'Kelin'**
  String get representativeBrideTitle;

  /// No description provided for @representativeBrideSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Ayol nomzod'**
  String get representativeBrideSubtitle;

  /// No description provided for @representativeGroomTitle.
  ///
  /// In uz, this message translates to:
  /// **'Kuyov'**
  String get representativeGroomTitle;

  /// No description provided for @representativeGroomSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Erkak nomzod'**
  String get representativeGroomSubtitle;

  /// No description provided for @representativeCandidateIdentityTitle.
  ///
  /// In uz, this message translates to:
  /// **'Nomzodning ismi va familiyasi'**
  String get representativeCandidateIdentityTitle;

  /// No description provided for @representativeCandidateIdentitySubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Bu ma’lumotlarni nomzodning o‘zi tasdiqlaydi. Xato bo‘lsa, keyin tuzatish mumkin.'**
  String get representativeCandidateIdentitySubtitle;

  /// No description provided for @representativeBirthDateTitle.
  ///
  /// In uz, this message translates to:
  /// **'Nomzod tug‘ilgan yili'**
  String get representativeBirthDateTitle;

  /// No description provided for @representativeEducationTitle.
  ///
  /// In uz, this message translates to:
  /// **'Nomzodning ma’lumoti'**
  String get representativeEducationTitle;

  /// No description provided for @representativeHeightWeightTitle.
  ///
  /// In uz, this message translates to:
  /// **'Nomzodning bo‘yi va vazni'**
  String get representativeHeightWeightTitle;

  /// No description provided for @representativeHeightInputLabel.
  ///
  /// In uz, this message translates to:
  /// **'Nomzodning bo‘yi'**
  String get representativeHeightInputLabel;

  /// No description provided for @representativeWeightInputLabel.
  ///
  /// In uz, this message translates to:
  /// **'Nomzodning vazni'**
  String get representativeWeightInputLabel;

  /// No description provided for @representativeLocationTitle.
  ///
  /// In uz, this message translates to:
  /// **'Nomzod qayerda yashaydi?'**
  String get representativeLocationTitle;

  /// No description provided for @representativeHealthStatusTitle.
  ///
  /// In uz, this message translates to:
  /// **'Nomzodning sog‘liqlik darajasi'**
  String get representativeHealthStatusTitle;

  /// No description provided for @representativeMaritalStatusTitle.
  ///
  /// In uz, this message translates to:
  /// **'Nomzodning oilaviy holati'**
  String get representativeMaritalStatusTitle;

  /// No description provided for @representativeChildrenCountLabel.
  ///
  /// In uz, this message translates to:
  /// **'Nomzodning farzandlari soni'**
  String get representativeChildrenCountLabel;

  /// No description provided for @representativeChildrenNotLivingTitle.
  ///
  /// In uz, this message translates to:
  /// **'Farzandlar nomzod bilan yashamaydi'**
  String get representativeChildrenNotLivingTitle;

  /// No description provided for @representativePhotoTitle.
  ///
  /// In uz, this message translates to:
  /// **'Nomzodning suratlari'**
  String get representativePhotoTitle;

  /// No description provided for @representativePhotoHint.
  ///
  /// In uz, this message translates to:
  /// **'5 tagacha surat. Ularni faqat nomzod ruxsat bergan odam ko‘radi.'**
  String get representativePhotoHint;

  /// No description provided for @representativeMainPhotoSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Nomzod profilida birinchi shu surat ko‘rinadi.'**
  String get representativeMainPhotoSubtitle;

  /// No description provided for @representativeAboutTitle.
  ///
  /// In uz, this message translates to:
  /// **'Nomzod haqida'**
  String get representativeAboutTitle;

  /// No description provided for @representativeAboutSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Ixtiyoriy. Savollar nomzod haqida — o‘zingiz haqingizda emas.'**
  String get representativeAboutSubtitle;

  /// No description provided for @representativeAboutHint.
  ///
  /// In uz, this message translates to:
  /// **'Nomzodning kasbi, qiziqishlari va oilaviy qadriyatlari haqida 2–3 gap...'**
  String get representativeAboutHint;

  /// No description provided for @representativeVoiceTitle.
  ///
  /// In uz, this message translates to:
  /// **'Nomzodning ovozli izohi'**
  String get representativeVoiceTitle;

  /// No description provided for @representativeVoiceSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Ixtiyoriy. Nomzod keyin o‘zi qayta yozishi mumkin.'**
  String get representativeVoiceSubtitle;

  /// No description provided for @representativeLocationPermissionTitle.
  ///
  /// In uz, this message translates to:
  /// **'Nomzodning joylashuvi'**
  String get representativeLocationPermissionTitle;

  /// No description provided for @representativeLocationPermissionSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Ixtiyoriy. Aniq manzil hech kimga ko‘rinmaydi.'**
  String get representativeLocationPermissionSubtitle;

  /// No description provided for @representativeConsentSection.
  ///
  /// In uz, this message translates to:
  /// **'3-QISM · ROZILIK'**
  String get representativeConsentSection;

  /// No description provided for @representativeContactTitle.
  ///
  /// In uz, this message translates to:
  /// **'Nomzodning telefon raqami'**
  String get representativeContactTitle;

  /// No description provided for @representativeContactSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Shu raqamga rozilik so‘rovi yuboriladi. Nomzod tasdiqlamaguncha anketa hech kimga ko‘rinmaydi.'**
  String get representativeContactSubtitle;

  /// No description provided for @representativeContactLabel.
  ///
  /// In uz, this message translates to:
  /// **'Telefon raqami / email'**
  String get representativeContactLabel;

  /// No description provided for @representativeContactPhoneTab.
  ///
  /// In uz, this message translates to:
  /// **'Telefon raqam'**
  String get representativeContactPhoneTab;

  /// No description provided for @representativeContactEmailTab.
  ///
  /// In uz, this message translates to:
  /// **'Email manzil'**
  String get representativeContactEmailTab;

  /// No description provided for @representativeContactWarningTitle.
  ///
  /// In uz, this message translates to:
  /// **'Raqam nomzodniki bo‘lishi shart'**
  String get representativeContactWarningTitle;

  /// No description provided for @representativeContactWarningBody.
  ///
  /// In uz, this message translates to:
  /// **'O‘z raqamingizni kiritsangiz, rozilik haqiqiy hisoblanmaydi va profil bloklanadi.'**
  String get representativeContactWarningBody;

  /// No description provided for @representativeSendConsent.
  ///
  /// In uz, this message translates to:
  /// **'Rozilik so‘rovini yuborish'**
  String get representativeSendConsent;

  /// No description provided for @representativeCandidateNoApp.
  ///
  /// In uz, this message translates to:
  /// **'Nomzod ilovadan foydalanmaydi'**
  String get representativeCandidateNoApp;

  /// No description provided for @representativeConsentSentTitle.
  ///
  /// In uz, this message translates to:
  /// **'So‘rov yuborildi'**
  String get representativeConsentSentTitle;

  /// No description provided for @representativeConsentSentSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'{firstName} tasdiqlashi kutilmoqda. Tasdiqlangunga qadar anketa yashirin.'**
  String representativeConsentSentSubtitle(String firstName);

  /// No description provided for @representativeSmsSentTitle.
  ///
  /// In uz, this message translates to:
  /// **'Nomzodga SMS ketdi'**
  String get representativeSmsSentTitle;

  /// No description provided for @representativeSmsSentBody.
  ///
  /// In uz, this message translates to:
  /// **'{representativeName} sizning nomingizdan anketa to‘ldirdi. Rozimisiz?'**
  String representativeSmsSentBody(String representativeName);

  /// No description provided for @representativeConsentRevocation.
  ///
  /// In uz, this message translates to:
  /// **'Nomzod rozilikni istalgan vaqtda qaytarib olishi mumkin — shunda anketa darhol yashiriladi.'**
  String get representativeConsentRevocation;

  /// No description provided for @understoodLabel.
  ///
  /// In uz, this message translates to:
  /// **'Tushunarli'**
  String get understoodLabel;

  /// No description provided for @resendRequestLabel.
  ///
  /// In uz, this message translates to:
  /// **'So‘rovni qayta yuborish'**
  String get resendRequestLabel;

  /// No description provided for @representativePledgeTitle.
  ///
  /// In uz, this message translates to:
  /// **'Mas’uliyatni tasdiqlang'**
  String get representativePledgeTitle;

  /// No description provided for @representativePledgeSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Bu qadam majburiy. Siz boshqa odam nomidan ma’lumot kiritayapsiz.'**
  String get representativePledgeSubtitle;

  /// No description provided for @representativePledgePointOne.
  ///
  /// In uz, this message translates to:
  /// **'Nomzod haqidagi ma’lumotlar to‘g‘ri va uning roziligi bilan kiritildi.'**
  String get representativePledgePointOne;

  /// No description provided for @representativePledgePointTwo.
  ///
  /// In uz, this message translates to:
  /// **'Nomzodning shaxsiy suhbatlariga aralashmayman.'**
  String get representativePledgePointTwo;

  /// No description provided for @representativePledgePointThree.
  ///
  /// In uz, this message translates to:
  /// **'Taklif va so‘rovlarni nomzod manfaatida ko‘rib chiqaman.'**
  String get representativePledgePointThree;

  /// No description provided for @representativeReadyTitle.
  ///
  /// In uz, this message translates to:
  /// **'Profillingiz tayyor!'**
  String get representativeReadyTitle;

  /// No description provided for @representativeReadySubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Hammasi saqlandi. Endi sizga mos nomzodlarni ko‘rishingiz mumkin.'**
  String get representativeReadySubtitle;

  /// No description provided for @representativeSetCriteria.
  ///
  /// In uz, this message translates to:
  /// **'Qidiruv mezonlarini sozlash'**
  String get representativeSetCriteria;

  /// No description provided for @laterLabel.
  ///
  /// In uz, this message translates to:
  /// **'Keyinroq'**
  String get laterLabel;

  /// No description provided for @candidateConsentEyebrow.
  ///
  /// In uz, this message translates to:
  /// **'NOMZOD TELEFONIDA'**
  String get candidateConsentEyebrow;

  /// No description provided for @candidateConsentTitle.
  ///
  /// In uz, this message translates to:
  /// **'Sizning nomingizdan anketa to‘ldirildi'**
  String get candidateConsentTitle;

  /// No description provided for @candidateConsentBody.
  ///
  /// In uz, this message translates to:
  /// **'{representativeName} ({relation}) siz uchun anketa to‘ldirdi. Roziligingizsiz u hech kimga ko‘rinmaydi.'**
  String candidateConsentBody(String representativeName, String relation);

  /// No description provided for @candidateConsentApproveTitle.
  ///
  /// In uz, this message translates to:
  /// **'Rozilik bersangiz'**
  String get candidateConsentApproveTitle;

  /// No description provided for @candidateConsentApproveBody.
  ///
  /// In uz, this message translates to:
  /// **'Anketa faollashadi, takliflar kela boshlaydi. Keyin o‘zingiz tahrirlashingiz mumkin.'**
  String get candidateConsentApproveBody;

  /// No description provided for @candidateConsentRejectHint.
  ///
  /// In uz, this message translates to:
  /// **'Rad etsangiz anketa o‘chiriladi va vakilga xabar beriladi.'**
  String get candidateConsentRejectHint;

  /// No description provided for @agreeLabel.
  ///
  /// In uz, this message translates to:
  /// **'Roziman'**
  String get agreeLabel;

  /// No description provided for @rejectLabel.
  ///
  /// In uz, this message translates to:
  /// **'Rad etaman'**
  String get rejectLabel;

  /// No description provided for @backLabel.
  ///
  /// In uz, this message translates to:
  /// **'Orqaga'**
  String get backLabel;

  /// No description provided for @temporaryOtpHint.
  ///
  /// In uz, this message translates to:
  /// **'Vaqtinchalik adapter: 1234 kodidan foydalaning'**
  String get temporaryOtpHint;

  /// No description provided for @pinCreateTitle.
  ///
  /// In uz, this message translates to:
  /// **'Qisqa kod oʻylab toping'**
  String get pinCreateTitle;

  /// No description provided for @pinUnlockTitle.
  ///
  /// In uz, this message translates to:
  /// **'PIN-kodni kiriting'**
  String get pinUnlockTitle;

  /// No description provided for @pinHintCreate.
  ///
  /// In uz, this message translates to:
  /// **'Hisobingiz faqat sizniki boʻlib qolishi uchun. Har safar kirishda shu kodni terasiz.'**
  String get pinHintCreate;

  /// No description provided for @pinHintUnlock.
  ///
  /// In uz, this message translates to:
  /// **'Bu qurilma uchun yaratgan PIN-kodingizni kiriting.'**
  String get pinHintUnlock;

  /// No description provided for @unlockLabel.
  ///
  /// In uz, this message translates to:
  /// **'Ochish'**
  String get unlockLabel;

  /// No description provided for @signInAsDemo.
  ///
  /// In uz, this message translates to:
  /// **'Demo sifatida kirish'**
  String get signInAsDemo;

  /// No description provided for @homeTitle.
  ///
  /// In uz, this message translates to:
  /// **'Bosh sahifa'**
  String get homeTitle;

  /// No description provided for @homeMessage.
  ///
  /// In uz, this message translates to:
  /// **'Foundation keyingi feature uchun tayyor.'**
  String get homeMessage;

  /// No description provided for @logout.
  ///
  /// In uz, this message translates to:
  /// **'Chiqish'**
  String get logout;

  /// No description provided for @deleteAccount.
  ///
  /// In uz, this message translates to:
  /// **'Hisobni oʻchirish'**
  String get deleteAccount;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In uz, this message translates to:
  /// **'Hisobingiz oʻchirilsinmi?'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountMessage.
  ///
  /// In uz, this message translates to:
  /// **'Bu amal hisobingiz va unga bogʻliq profil maʼlumotlarini oʻchiradi. Amalni ortga qaytarib boʻlmaydi.'**
  String get deleteAccountMessage;

  /// No description provided for @deleteAccountCancel.
  ///
  /// In uz, this message translates to:
  /// **'Bekor qilish'**
  String get deleteAccountCancel;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In uz, this message translates to:
  /// **'Oʻchirish'**
  String get deleteAccountConfirm;

  /// No description provided for @retry.
  ///
  /// In uz, this message translates to:
  /// **'Qayta urinish'**
  String get retry;

  /// No description provided for @telegramWaiting.
  ///
  /// In uz, this message translates to:
  /// **'Telegramda telefon raqamingizni tasdiqlang, keyin ilovaga qayting.'**
  String get telegramWaiting;

  /// No description provided for @candidatesTabLabel.
  ///
  /// In uz, this message translates to:
  /// **'Nomzodlar'**
  String get candidatesTabLabel;

  /// No description provided for @messagesTabLabel.
  ///
  /// In uz, this message translates to:
  /// **'Xabarlar'**
  String get messagesTabLabel;

  /// No description provided for @servicesTabLabel.
  ///
  /// In uz, this message translates to:
  /// **'Xizmatlar'**
  String get servicesTabLabel;

  /// No description provided for @savedTabLabel.
  ///
  /// In uz, this message translates to:
  /// **'Saqlangan'**
  String get savedTabLabel;

  /// No description provided for @profileTabLabel.
  ///
  /// In uz, this message translates to:
  /// **'Profil'**
  String get profileTabLabel;

  /// No description provided for @candidatesPlaceholder.
  ///
  /// In uz, this message translates to:
  /// **'Hozircha nomzodlar sahifasi.'**
  String get candidatesPlaceholder;

  /// No description provided for @messagesPlaceholder.
  ///
  /// In uz, this message translates to:
  /// **'Hozircha xabarlar sahifasi.'**
  String get messagesPlaceholder;

  /// No description provided for @servicesPlaceholder.
  ///
  /// In uz, this message translates to:
  /// **'Hozircha xizmatlar sahifasi.'**
  String get servicesPlaceholder;

  /// No description provided for @servicesHeroTitle.
  ///
  /// In uz, this message translates to:
  /// **'Tanishuv yo‘lida\nyolg‘iz emassiz'**
  String get servicesHeroTitle;

  /// No description provided for @servicesHeroSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Psixolog, oilaviy uchrashuv va profil tekshiruvi — hammasi bir joyda.'**
  String get servicesHeroSubtitle;

  /// No description provided for @servicesHeroSupportValue.
  ///
  /// In uz, this message translates to:
  /// **'24/7'**
  String get servicesHeroSupportValue;

  /// No description provided for @servicesHeroSupportLabel.
  ///
  /// In uz, this message translates to:
  /// **'yordam'**
  String get servicesHeroSupportLabel;

  /// No description provided for @servicesHeroPsychologistsValue.
  ///
  /// In uz, this message translates to:
  /// **'12'**
  String get servicesHeroPsychologistsValue;

  /// No description provided for @servicesHeroPsychologistsLabel.
  ///
  /// In uz, this message translates to:
  /// **'psixolog'**
  String get servicesHeroPsychologistsLabel;

  /// No description provided for @servicesHeroPrivacyValue.
  ///
  /// In uz, this message translates to:
  /// **'Maxfiy'**
  String get servicesHeroPrivacyValue;

  /// No description provided for @servicesHeroPrivacyLabel.
  ///
  /// In uz, this message translates to:
  /// **'suhbat'**
  String get servicesHeroPrivacyLabel;

  /// No description provided for @servicesPopularSection.
  ///
  /// In uz, this message translates to:
  /// **'Eng ko‘p tanlanadi'**
  String get servicesPopularSection;

  /// No description provided for @servicePsychologistTitle.
  ///
  /// In uz, this message translates to:
  /// **'Oilaviy psixolog'**
  String get servicePsychologistTitle;

  /// No description provided for @servicePsychologistSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Nikohdan oldin suhbat'**
  String get servicePsychologistSubtitle;

  /// No description provided for @servicePsychologistRating.
  ///
  /// In uz, this message translates to:
  /// **'4.9'**
  String get servicePsychologistRating;

  /// No description provided for @servicePsychologistDescription.
  ///
  /// In uz, this message translates to:
  /// **'Kelishmovchilik sabablarini oldindan ko‘rasiz. Suhbat to‘liq maxfiy — hech kim bilmaydi.'**
  String get servicePsychologistDescription;

  /// No description provided for @servicePsychologistDuration.
  ///
  /// In uz, this message translates to:
  /// **'50 daqiqa'**
  String get servicePsychologistDuration;

  /// No description provided for @servicePsychologistFormat.
  ///
  /// In uz, this message translates to:
  /// **'Oflayn yoki uyda'**
  String get servicePsychologistFormat;

  /// No description provided for @servicePsychologistExperts.
  ///
  /// In uz, this message translates to:
  /// **'12 mutaxassis'**
  String get servicePsychologistExperts;

  /// No description provided for @servicePsychologistPrice.
  ///
  /// In uz, this message translates to:
  /// **'bitta sessiy'**
  String get servicePsychologistPrice;

  /// No description provided for @serviceViewAction.
  ///
  /// In uz, this message translates to:
  /// **'Ko‘rish'**
  String get serviceViewAction;

  /// No description provided for @servicesOtherSection.
  ///
  /// In uz, this message translates to:
  /// **'Boshqa xizmatlar'**
  String get servicesOtherSection;

  /// No description provided for @serviceMeetingTitle.
  ///
  /// In uz, this message translates to:
  /// **'Oilaviy uchrashuv'**
  String get serviceMeetingTitle;

  /// No description provided for @serviceMeetingSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Faqat vakillar taklif qiladi'**
  String get serviceMeetingSubtitle;

  /// No description provided for @serviceVerificationTitle.
  ///
  /// In uz, this message translates to:
  /// **'Profil tekshiruvi'**
  String get serviceVerificationTitle;

  /// No description provided for @serviceVerificationSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Selfi orqali tasdiqlash'**
  String get serviceVerificationSubtitle;

  /// No description provided for @servicePremiumTitle.
  ///
  /// In uz, this message translates to:
  /// **'Sovchi Premium'**
  String get servicePremiumTitle;

  /// No description provided for @servicePremiumSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Ko‘proq taklif va to‘liq moslik tahlili'**
  String get servicePremiumSubtitle;

  /// No description provided for @serviceBoostTitle.
  ///
  /// In uz, this message translates to:
  /// **'Yuqoriga ko‘tarish'**
  String get serviceBoostTitle;

  /// No description provided for @serviceBoostSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Profilingiz 24 soat davomida ro‘yxat boshida ko‘rinadi.'**
  String get serviceBoostSubtitle;

  /// No description provided for @servicesHowSection.
  ///
  /// In uz, this message translates to:
  /// **'Qanday ishlaydi'**
  String get servicesHowSection;

  /// No description provided for @servicesHowStepOneTitle.
  ///
  /// In uz, this message translates to:
  /// **'Xizmatni tanlaysiz'**
  String get servicesHowStepOneTitle;

  /// No description provided for @servicesHowStepOneSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Har biri haqida to‘liq ma’lumot bor'**
  String get servicesHowStepOneSubtitle;

  /// No description provided for @servicesHowStepTwoTitle.
  ///
  /// In uz, this message translates to:
  /// **'Vaqt va shaklni belgilaysiz'**
  String get servicesHowStepTwoTitle;

  /// No description provided for @servicesHowStepTwoSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Oflayn yoki uyingizda'**
  String get servicesHowStepTwoSubtitle;

  /// No description provided for @servicesHowStepThreeTitle.
  ///
  /// In uz, this message translates to:
  /// **'To‘laysiz va uchrashasiz'**
  String get servicesHowStepThreeTitle;

  /// No description provided for @servicesHowStepThreeSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Bekor qilsangiz pul qaytadi'**
  String get servicesHowStepThreeSubtitle;

  /// No description provided for @servicesOptionalNote.
  ///
  /// In uz, this message translates to:
  /// **'Hech bir xizmat majburiy emas — ularsiz ham ilovadan to‘liq foydalanasiz.'**
  String get servicesOptionalNote;

  /// No description provided for @servicesActionComingSoon.
  ///
  /// In uz, this message translates to:
  /// **'Bu xizmat keyingi bosqichda ulanadi'**
  String get servicesActionComingSoon;

  /// No description provided for @savedPlaceholder.
  ///
  /// In uz, this message translates to:
  /// **'Hozircha saqlanganlar sahifasi.'**
  String get savedPlaceholder;

  /// No description provided for @profilePlaceholder.
  ///
  /// In uz, this message translates to:
  /// **'Hozircha profil sahifasi.'**
  String get profilePlaceholder;

  /// No description provided for @notificationsActionLabel.
  ///
  /// In uz, this message translates to:
  /// **'Bildirishnomalar'**
  String get notificationsActionLabel;

  /// No description provided for @notificationsEmpty.
  ///
  /// In uz, this message translates to:
  /// **'Hozircha bildirishnomalar yo‘q'**
  String get notificationsEmpty;

  /// No description provided for @notificationsMarkAllRead.
  ///
  /// In uz, this message translates to:
  /// **'Barchasini o‘qilgan deb belgilash'**
  String get notificationsMarkAllRead;

  /// No description provided for @candidatesFilterMatches.
  ///
  /// In uz, this message translates to:
  /// **'Moslar'**
  String get candidatesFilterMatches;

  /// No description provided for @candidatesFilterRecommended.
  ///
  /// In uz, this message translates to:
  /// **'Tavsiyalar'**
  String get candidatesFilterRecommended;

  /// No description provided for @candidatesFilterNearby.
  ///
  /// In uz, this message translates to:
  /// **'Atrofdagilar'**
  String get candidatesFilterNearby;

  /// No description provided for @privatePhotoLabel.
  ///
  /// In uz, this message translates to:
  /// **'Maxfiy rasm'**
  String get privatePhotoLabel;

  /// No description provided for @matchLockedLabel.
  ///
  /// In uz, this message translates to:
  /// **'moslik yopiq'**
  String get matchLockedLabel;

  /// No description provided for @genericError.
  ///
  /// In uz, this message translates to:
  /// **'Nimadir xato ketdi.'**
  String get genericError;

  /// No description provided for @savedEmptyState.
  ///
  /// In uz, this message translates to:
  /// **'Hozircha saqlangan profil yo‘q.'**
  String get savedEmptyState;

  /// No description provided for @candidateDetailRequestPhotoPermission.
  ///
  /// In uz, this message translates to:
  /// **'Rasmni ko‘rish uchun ruxsat so‘rash'**
  String get candidateDetailRequestPhotoPermission;

  /// No description provided for @candidateDetailOptionsSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Nima qilmoqchisiz?'**
  String get candidateDetailOptionsSubtitle;

  /// No description provided for @candidateDetailSaveSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Keyin «Saqlangan» bo‘limidan topasiz'**
  String get candidateDetailSaveSubtitle;

  /// No description provided for @candidateDetailSaveToSaved.
  ///
  /// In uz, this message translates to:
  /// **'Saqlanganlarga qo‘shish'**
  String get candidateDetailSaveToSaved;

  /// No description provided for @candidateDetailShare.
  ///
  /// In uz, this message translates to:
  /// **'Profilni ulashish'**
  String get candidateDetailShare;

  /// No description provided for @candidateDetailShareSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Vakilingizga yoki oilangizga yuboring'**
  String get candidateDetailShareSubtitle;

  /// No description provided for @candidateDetailPhotoPermissionSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'So‘rov nomzodga va uning vakiliga boradi'**
  String get candidateDetailPhotoPermissionSubtitle;

  /// No description provided for @candidateDetailReport.
  ///
  /// In uz, this message translates to:
  /// **'Shikoyat qilish'**
  String get candidateDetailReport;

  /// No description provided for @candidateDetailReportSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Moderator 24 soat ichida ko‘radi'**
  String get candidateDetailReportSubtitle;

  /// No description provided for @candidateDetailBlock.
  ///
  /// In uz, this message translates to:
  /// **'Profilni bloklash'**
  String get candidateDetailBlock;

  /// No description provided for @candidateDetailBlockSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'U sizni boshqa ko‘rmaydi'**
  String get candidateDetailBlockSubtitle;

  /// No description provided for @candidateDetailCompatibilityTitle.
  ///
  /// In uz, this message translates to:
  /// **'Umumiy moslik'**
  String get candidateDetailCompatibilityTitle;

  /// No description provided for @candidateDetailVoiceIntro.
  ///
  /// In uz, this message translates to:
  /// **'Ovozli tanishtiruv · {duration}'**
  String candidateDetailVoiceIntro(String duration);

  /// No description provided for @candidateDetailVoiceDuration.
  ///
  /// In uz, this message translates to:
  /// **'12 sek'**
  String get candidateDetailVoiceDuration;

  /// No description provided for @candidateDetailSendProposal.
  ///
  /// In uz, this message translates to:
  /// **'Sovchi taklifi yuborish'**
  String get candidateDetailSendProposal;

  /// No description provided for @candidateDetailSave.
  ///
  /// In uz, this message translates to:
  /// **'Saqlash'**
  String get candidateDetailSave;

  /// No description provided for @candidateDetailUnsave.
  ///
  /// In uz, this message translates to:
  /// **'Saqlanganlardan olib tashlash'**
  String get candidateDetailUnsave;

  /// No description provided for @candidateDetailNoPhoto.
  ///
  /// In uz, this message translates to:
  /// **'Profil rasmi yo‘q'**
  String get candidateDetailNoPhoto;

  /// No description provided for @candidateDetailLastActivity.
  ///
  /// In uz, this message translates to:
  /// **'Oxirgi faollik: yaqinda'**
  String get candidateDetailLastActivity;

  /// No description provided for @candidateDetailCompatibilityUnavailableTitle.
  ///
  /// In uz, this message translates to:
  /// **'Moslik hisoblanmagan'**
  String get candidateDetailCompatibilityUnavailableTitle;

  /// No description provided for @candidateDetailCompatibilityUnavailableDescription.
  ///
  /// In uz, this message translates to:
  /// **'Nomzod 30 savollik so‘rovnomani hali to‘ldirmagan — shu sababli moslik foizi ko‘rsatilmaydi. Quyidagi ma’lumotlar nomzod anketasidan olingan.'**
  String get candidateDetailCompatibilityUnavailableDescription;

  /// No description provided for @candidateDetailBasicInformation.
  ///
  /// In uz, this message translates to:
  /// **'Asosiy ma’lumotlar'**
  String get candidateDetailBasicInformation;

  /// No description provided for @candidateDetailBirthYear.
  ///
  /// In uz, this message translates to:
  /// **'Tug‘ilgan yili'**
  String get candidateDetailBirthYear;

  /// No description provided for @candidateDetailBirthYearWithAge.
  ///
  /// In uz, this message translates to:
  /// **'{birthYear} · {age} yosh'**
  String candidateDetailBirthYearWithAge(int birthYear, int age);

  /// No description provided for @candidateDetailCity.
  ///
  /// In uz, this message translates to:
  /// **'Shahar'**
  String get candidateDetailCity;

  /// No description provided for @candidateDetailMaritalStatus.
  ///
  /// In uz, this message translates to:
  /// **'Oilaviy holati'**
  String get candidateDetailMaritalStatus;

  /// No description provided for @candidateDetailChildren.
  ///
  /// In uz, this message translates to:
  /// **'Farzandlari'**
  String get candidateDetailChildren;

  /// No description provided for @candidateDetailNoChildren.
  ///
  /// In uz, this message translates to:
  /// **'Yo‘q'**
  String get candidateDetailNoChildren;

  /// No description provided for @candidateDetailHasChildren.
  ///
  /// In uz, this message translates to:
  /// **'Bor'**
  String get candidateDetailHasChildren;

  /// No description provided for @candidateDetailChildrenCount.
  ///
  /// In uz, this message translates to:
  /// **'{count} ta'**
  String candidateDetailChildrenCount(int count);

  /// No description provided for @candidateDetailEducationAndWork.
  ///
  /// In uz, this message translates to:
  /// **'Ta’lim va ish'**
  String get candidateDetailEducationAndWork;

  /// No description provided for @candidateDetailEducation.
  ///
  /// In uz, this message translates to:
  /// **'Ma’lumoti'**
  String get candidateDetailEducation;

  /// No description provided for @candidateDetailProfession.
  ///
  /// In uz, this message translates to:
  /// **'Kasb'**
  String get candidateDetailProfession;

  /// No description provided for @candidateDetailLifestyle.
  ///
  /// In uz, this message translates to:
  /// **'Turmush tarzi'**
  String get candidateDetailLifestyle;

  /// No description provided for @candidateDetailHealthStatus.
  ///
  /// In uz, this message translates to:
  /// **'Sog‘lig‘i'**
  String get candidateDetailHealthStatus;

  /// No description provided for @candidateDetailIncompleteProfileTitle.
  ///
  /// In uz, this message translates to:
  /// **'Anketa to‘liq emas'**
  String get candidateDetailIncompleteProfileTitle;

  /// No description provided for @candidateDetailIncompleteProfileDescription.
  ///
  /// In uz, this message translates to:
  /// **'Nomzod ayrim ma’lumotlarni hali to‘ldirmagan. Sovchi taklifi yuborilganda unga anketani to‘ldirish eslatmasi boradi.'**
  String get candidateDetailIncompleteProfileDescription;

  /// No description provided for @candidateDetailAbout.
  ///
  /// In uz, this message translates to:
  /// **'Nomzod haqida'**
  String get candidateDetailAbout;

  /// No description provided for @candidateRequestPending.
  ///
  /// In uz, this message translates to:
  /// **'Jarayonda...'**
  String get candidateRequestPending;

  /// No description provided for @candidateRequestRetry.
  ///
  /// In uz, this message translates to:
  /// **'Qayta so‘rov yuborish'**
  String get candidateRequestRetry;

  /// No description provided for @candidateRequestRetryAt.
  ///
  /// In uz, this message translates to:
  /// **'Qayta so‘rov yuborish: {date}'**
  String candidateRequestRetryAt(Object date);

  /// No description provided for @candidateRequestChat.
  ///
  /// In uz, this message translates to:
  /// **'Suhbatlashish'**
  String get candidateRequestChat;

  /// No description provided for @candidateRequestForwarded.
  ///
  /// In uz, this message translates to:
  /// **'Vakilga yo‘naltirildi'**
  String get candidateRequestForwarded;

  /// No description provided for @photoRequestTitle.
  ///
  /// In uz, this message translates to:
  /// **'Rasm ko‘rish so‘rovi'**
  String get photoRequestTitle;

  /// No description provided for @photoRequestDescription.
  ///
  /// In uz, this message translates to:
  /// **'So‘rov nomzodga va uning vakiliga yuboriladi. Qaror faqat ularga tegishli.'**
  String get photoRequestDescription;

  /// No description provided for @photoRequestMessageHint.
  ///
  /// In uz, this message translates to:
  /// **'Xabar (ixtiyoriy)'**
  String get photoRequestMessageHint;

  /// No description provided for @photoRequestDurationLabel.
  ///
  /// In uz, this message translates to:
  /// **'So‘rov muddati'**
  String get photoRequestDurationLabel;

  /// No description provided for @photoRequestDurationValue.
  ///
  /// In uz, this message translates to:
  /// **'7 kun'**
  String get photoRequestDurationValue;

  /// No description provided for @photoRequestRejectLabel.
  ///
  /// In uz, this message translates to:
  /// **'Rad etilsa'**
  String get photoRequestRejectLabel;

  /// No description provided for @photoRequestRejectValue.
  ///
  /// In uz, this message translates to:
  /// **'qayta so‘rash 7 kundan keyin'**
  String get photoRequestRejectValue;

  /// No description provided for @photoRequestPrivacyNote.
  ///
  /// In uz, this message translates to:
  /// **'Rasm ochilsa, u faqat sizga ko‘rinadi va skrinshot bloklanadi.'**
  String get photoRequestPrivacyNote;

  /// No description provided for @photoRequestSubmit.
  ///
  /// In uz, this message translates to:
  /// **'So‘rov yuborish'**
  String get photoRequestSubmit;

  /// No description provided for @candidateProposalSentTitle.
  ///
  /// In uz, this message translates to:
  /// **'Taklif yuborildi'**
  String get candidateProposalSentTitle;

  /// No description provided for @candidateProposalSentDescription.
  ///
  /// In uz, this message translates to:
  /// **'{name} va uning vakili sizning taklifingizni ko‘radi. Javob kelganda xabar beramiz.'**
  String candidateProposalSentDescription(Object name);

  /// No description provided for @candidateProposalSentTimelineSent.
  ///
  /// In uz, this message translates to:
  /// **'Taklif yuborildi'**
  String get candidateProposalSentTimelineSent;

  /// No description provided for @candidateProposalSentTimelineReview.
  ///
  /// In uz, this message translates to:
  /// **'{name} ko‘rib chiqadi'**
  String candidateProposalSentTimelineReview(Object name);

  /// No description provided for @candidateProposalSentTimelineChat.
  ///
  /// In uz, this message translates to:
  /// **'Javob kelsa — suhbat ochiladi'**
  String get candidateProposalSentTimelineChat;

  /// No description provided for @candidateProposalSentQuotaLabel.
  ///
  /// In uz, this message translates to:
  /// **'Bu haftalik takliflar'**
  String get candidateProposalSentQuotaLabel;

  /// No description provided for @candidateProposalSentQuotaValue.
  ///
  /// In uz, this message translates to:
  /// **'2 / 3'**
  String get candidateProposalSentQuotaValue;

  /// No description provided for @candidateProposalSentNote.
  ///
  /// In uz, this message translates to:
  /// **'Javob kelmasa ham xafa bo‘lmang — bu tanlov masalasi. Yana {remaining} ta taklif qoldi.'**
  String candidateProposalSentNote(Object remaining);

  /// No description provided for @candidateProposalSentReturn.
  ///
  /// In uz, this message translates to:
  /// **'Nomzodlarga qaytish'**
  String get candidateProposalSentReturn;

  /// No description provided for @candidatePhotoPermissionSentTitle.
  ///
  /// In uz, this message translates to:
  /// **'Rasm ko‘rish uchun ruxsat so‘raldi'**
  String get candidatePhotoPermissionSentTitle;

  /// No description provided for @candidatePhotoPermissionSentDescription.
  ///
  /// In uz, this message translates to:
  /// **'{name} va uning vakiliga rasmni ko‘rish uchun so‘rov yuborildi. Javob kelganda xabar beramiz.'**
  String candidatePhotoPermissionSentDescription(Object name);

  /// No description provided for @candidatePhotoPermissionSentReturn.
  ///
  /// In uz, this message translates to:
  /// **'Profilga qaytish'**
  String get candidatePhotoPermissionSentReturn;

  /// No description provided for @candidateBlockDialogTitle.
  ///
  /// In uz, this message translates to:
  /// **'{candidateName} ni bloklaysizmi?'**
  String candidateBlockDialogTitle(String candidateName);

  /// No description provided for @candidateBlockDialogSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'U sizni ko‘rmaydi, siz ham uni ko‘rmaysiz. Bloklaganingizni o‘zi bilmaydi.'**
  String get candidateBlockDialogSubtitle;

  /// No description provided for @candidateBlockPointChatClosed.
  ///
  /// In uz, this message translates to:
  /// **'Suhbat yopiladi, yozishmalar saqlanadi'**
  String get candidateBlockPointChatClosed;

  /// No description provided for @candidateBlockPointRemovedSaved.
  ///
  /// In uz, this message translates to:
  /// **'Saqlanganlar ro‘yxatidan olib tashlanadi'**
  String get candidateBlockPointRemovedSaved;

  /// No description provided for @candidateBlockPointRepresentativeBlocked.
  ///
  /// In uz, this message translates to:
  /// **'Uning vakili ham siz bilan bog‘lana olmaydi'**
  String get candidateBlockPointRepresentativeBlocked;

  /// No description provided for @candidateBlockAction.
  ///
  /// In uz, this message translates to:
  /// **'Bloklash'**
  String get candidateBlockAction;

  /// No description provided for @candidateBlockCancel.
  ///
  /// In uz, this message translates to:
  /// **'Bekor qilish'**
  String get candidateBlockCancel;

  /// No description provided for @candidateBlockedTitle.
  ///
  /// In uz, this message translates to:
  /// **'Profil bloklandi'**
  String get candidateBlockedTitle;

  /// No description provided for @candidateBlockedSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'{candidateName} endi sizni ko‘rmaydi.'**
  String candidateBlockedSubtitle(String candidateName);

  /// No description provided for @candidateBlockedWhoLabel.
  ///
  /// In uz, this message translates to:
  /// **'Kim'**
  String get candidateBlockedWhoLabel;

  /// No description provided for @candidateBlockedTimeLabel.
  ///
  /// In uz, this message translates to:
  /// **'Bloklandi'**
  String get candidateBlockedTimeLabel;

  /// No description provided for @candidateBlockedStatusLabel.
  ///
  /// In uz, this message translates to:
  /// **'Holat'**
  String get candidateBlockedStatusLabel;

  /// No description provided for @candidateBlockedStatusValue.
  ///
  /// In uz, this message translates to:
  /// **'Bloklangan'**
  String get candidateBlockedStatusValue;

  /// No description provided for @candidateBlockedSettingsHint.
  ///
  /// In uz, this message translates to:
  /// **'U bloklaganingizni bilmaydi. Blokni Sozlamalar → Bloklangan profillar bo‘limidan olib tashlaysiz.'**
  String get candidateBlockedSettingsHint;

  /// No description provided for @candidateBlockedClose.
  ///
  /// In uz, this message translates to:
  /// **'Yopish'**
  String get candidateBlockedClose;

  /// No description provided for @candidateReportTitle.
  ///
  /// In uz, this message translates to:
  /// **'Nima bo‘ldi?'**
  String get candidateReportTitle;

  /// No description provided for @candidateReportSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Suhbat tarixi bizda saqlanadi, tekshirishga yordam beradi.'**
  String get candidateReportSubtitle;

  /// No description provided for @candidateReportTargetProfile.
  ///
  /// In uz, this message translates to:
  /// **'Shikoyat shu profil ustidan'**
  String get candidateReportTargetProfile;

  /// No description provided for @candidateReportReasonSection.
  ///
  /// In uz, this message translates to:
  /// **'Sabab'**
  String get candidateReportReasonSection;

  /// No description provided for @candidateReportReasonInappropriate.
  ///
  /// In uz, this message translates to:
  /// **'Odobsiz so‘z yoki rasm'**
  String get candidateReportReasonInappropriate;

  /// No description provided for @candidateReportReasonFake.
  ///
  /// In uz, this message translates to:
  /// **'Yolg‘on ma’lumot yoki soxta profil'**
  String get candidateReportReasonFake;

  /// No description provided for @candidateReportReasonNoMarriage.
  ///
  /// In uz, this message translates to:
  /// **'Nikoh niyati yo‘q'**
  String get candidateReportReasonNoMarriage;

  /// No description provided for @candidateReportReasonScam.
  ///
  /// In uz, this message translates to:
  /// **'Moliyaviy firibgarlik'**
  String get candidateReportReasonScam;

  /// No description provided for @candidateReportReasonAbusiveLanguage.
  ///
  /// In uz, this message translates to:
  /// **'Odobsiz so‘z'**
  String get candidateReportReasonAbusiveLanguage;

  /// No description provided for @candidateReportReasonFakeProfile.
  ///
  /// In uz, this message translates to:
  /// **'Soxta profil'**
  String get candidateReportReasonFakeProfile;

  /// No description provided for @candidateReportReasonFraud.
  ///
  /// In uz, this message translates to:
  /// **'Firibgarlik'**
  String get candidateReportReasonFraud;

  /// No description provided for @candidateReportReasonSpam.
  ///
  /// In uz, this message translates to:
  /// **'Spam va reklama'**
  String get candidateReportReasonSpam;

  /// No description provided for @candidateReportReasonFalseInformation.
  ///
  /// In uz, this message translates to:
  /// **'Noto‘g‘ri ma’lumot'**
  String get candidateReportReasonFalseInformation;

  /// No description provided for @candidateReportReasonThreat.
  ///
  /// In uz, this message translates to:
  /// **'Haqorat va tahdid'**
  String get candidateReportReasonThreat;

  /// No description provided for @candidateReportReasonNoSeriousIntent.
  ///
  /// In uz, this message translates to:
  /// **'Nikoh niyati yo‘q'**
  String get candidateReportReasonNoSeriousIntent;

  /// No description provided for @candidateReportReasonOther.
  ///
  /// In uz, this message translates to:
  /// **'Boshqa sabab'**
  String get candidateReportReasonOther;

  /// No description provided for @candidateReportNoteLabel.
  ///
  /// In uz, this message translates to:
  /// **'Qo‘shimcha izoh (ixtiyoriy)'**
  String get candidateReportNoteLabel;

  /// No description provided for @candidateReportNoteHint.
  ///
  /// In uz, this message translates to:
  /// **'Nima bo‘lganini qisqacha yozing...'**
  String get candidateReportNoteHint;

  /// No description provided for @candidateReportSubmitAction.
  ///
  /// In uz, this message translates to:
  /// **'Shikoyatni yuborish'**
  String get candidateReportSubmitAction;

  /// No description provided for @candidateReportSubmittedTitle.
  ///
  /// In uz, this message translates to:
  /// **'Shikoyat yuborildi'**
  String get candidateReportSubmittedTitle;

  /// No description provided for @candidateReportSubmittedSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Natija haqida xabar beramiz.'**
  String get candidateReportSubmittedSubtitle;

  /// No description provided for @candidateReportNumberLabel.
  ///
  /// In uz, this message translates to:
  /// **'Ariza raqami'**
  String get candidateReportNumberLabel;

  /// No description provided for @candidateReportSubmittedTimeLabel.
  ///
  /// In uz, this message translates to:
  /// **'Yuborildi'**
  String get candidateReportSubmittedTimeLabel;

  /// No description provided for @candidateReportStatusLabel.
  ///
  /// In uz, this message translates to:
  /// **'Holat'**
  String get candidateReportStatusLabel;

  /// No description provided for @candidateReportStatusUnderReview.
  ///
  /// In uz, this message translates to:
  /// **'Ko‘rib chiqilmoqda'**
  String get candidateReportStatusUnderReview;

  /// No description provided for @candidateReportStepHistoryPreserved.
  ///
  /// In uz, this message translates to:
  /// **'Suhbat tarixi dalil sifatida saqlandi'**
  String get candidateReportStepHistoryPreserved;

  /// No description provided for @candidateReportStepModeratorReview.
  ///
  /// In uz, this message translates to:
  /// **'Moderator tekshiruvi'**
  String get candidateReportStepModeratorReview;

  /// No description provided for @candidateReportStepDecision.
  ///
  /// In uz, this message translates to:
  /// **'Qaror va xabarnoma'**
  String get candidateReportStepDecision;

  /// No description provided for @candidateReportNotice.
  ///
  /// In uz, this message translates to:
  /// **'Bu foydalanuvchi siz bilan bog‘lana olmaydi. Suhbat vaqtincha yopildi.'**
  String get candidateReportNotice;

  /// No description provided for @surveyPromptTitle.
  ///
  /// In uz, this message translates to:
  /// **'Moslik foizi yopiq'**
  String get surveyPromptTitle;

  /// No description provided for @surveyPromptMessage.
  ///
  /// In uz, this message translates to:
  /// **'30 ta savolga javob bering — AI javoblaringizni tahlil qilib, har bir nomzod bilan moslik foizingizni avtomatik hisoblaydi.'**
  String get surveyPromptMessage;

  /// No description provided for @surveyPromptButton.
  ///
  /// In uz, this message translates to:
  /// **'Soʻrovnomani boshlash'**
  String get surveyPromptButton;

  /// No description provided for @mockCandidateMohira.
  ///
  /// In uz, this message translates to:
  /// **'Mohira R., 23'**
  String get mockCandidateMohira;

  /// No description provided for @mockCandidateZilola.
  ///
  /// In uz, this message translates to:
  /// **'Zilola K., 25'**
  String get mockCandidateZilola;

  /// No description provided for @mockCandidateNilufar.
  ///
  /// In uz, this message translates to:
  /// **'Nilufar A., 22'**
  String get mockCandidateNilufar;

  /// No description provided for @mockCandidateDilnoza.
  ///
  /// In uz, this message translates to:
  /// **'Dilnoza S., 27'**
  String get mockCandidateDilnoza;

  /// No description provided for @mockCityTashkent.
  ///
  /// In uz, this message translates to:
  /// **'Toshkent'**
  String get mockCityTashkent;

  /// No description provided for @mockCitySamarkand.
  ///
  /// In uz, this message translates to:
  /// **'Samarqand'**
  String get mockCitySamarkand;

  /// No description provided for @mockCityFergana.
  ///
  /// In uz, this message translates to:
  /// **'Fargʻona'**
  String get mockCityFergana;

  /// No description provided for @mockCityBukhara.
  ///
  /// In uz, this message translates to:
  /// **'Buxoro'**
  String get mockCityBukhara;

  /// No description provided for @messagesSegmentChats.
  ///
  /// In uz, this message translates to:
  /// **'Suhbatlar'**
  String get messagesSegmentChats;

  /// No description provided for @messagesSegmentRequests.
  ///
  /// In uz, this message translates to:
  /// **'Soʻrovlar'**
  String get messagesSegmentRequests;

  /// No description provided for @chatRoomsEmpty.
  ///
  /// In uz, this message translates to:
  /// **'Hozircha ochiq suhbatlar yoʻq'**
  String get chatRoomsEmpty;

  /// No description provided for @chatThreadOpen.
  ///
  /// In uz, this message translates to:
  /// **'Suhbatni ochish'**
  String get chatThreadOpen;

  /// No description provided for @chatParticipantFallback.
  ///
  /// In uz, this message translates to:
  /// **'Suhbatdosh'**
  String get chatParticipantFallback;

  /// No description provided for @chatSafetyNotice.
  ///
  /// In uz, this message translates to:
  /// **'Suhbatni Sunʼiy intellekt kuzatib turadi — odobsiz soʻz va rasm oʻtmaydi.'**
  String get chatSafetyNotice;

  /// No description provided for @chatIcebreakerGoal.
  ///
  /// In uz, this message translates to:
  /// **'Hayotingizdagi eng katta maqsadingiz nima?'**
  String get chatIcebreakerGoal;

  /// No description provided for @chatIcebreakerFamily.
  ///
  /// In uz, this message translates to:
  /// **'Oilada qanday anʼanani davom ettirishni xohlaysiz?'**
  String get chatIcebreakerFamily;

  /// No description provided for @chatIcebreakerBook.
  ///
  /// In uz, this message translates to:
  /// **'Sizni qaysi kitob eng koʻp ilhomlantiradi?'**
  String get chatIcebreakerBook;

  /// No description provided for @chatIcebreakerChange.
  ///
  /// In uz, this message translates to:
  /// **'Oʻz hayotingizda oʻzgartirmoqchi boʻlgan bir narsani ayting.'**
  String get chatIcebreakerChange;

  /// No description provided for @chatWriteMessage.
  ///
  /// In uz, this message translates to:
  /// **'Xabar yozing…'**
  String get chatWriteMessage;

  /// No description provided for @chatSendMessage.
  ///
  /// In uz, this message translates to:
  /// **'Xabarni yuborish'**
  String get chatSendMessage;

  /// No description provided for @chatReplyTo.
  ///
  /// In uz, this message translates to:
  /// **'Javob berish'**
  String get chatReplyTo;

  /// No description provided for @chatReplyCancel.
  ///
  /// In uz, this message translates to:
  /// **'Javobni bekor qilish'**
  String get chatReplyCancel;

  /// No description provided for @chatTyping.
  ///
  /// In uz, this message translates to:
  /// **'yozyapti…'**
  String get chatTyping;

  /// No description provided for @chatOpenTimeRemaining.
  ///
  /// In uz, this message translates to:
  /// **'Chat 72 soat ochiq'**
  String get chatOpenTimeRemaining;

  /// No description provided for @chatMoreActions.
  ///
  /// In uz, this message translates to:
  /// **'Qoʻshimcha amallar'**
  String get chatMoreActions;

  /// No description provided for @mockMessageMohiraName.
  ///
  /// In uz, this message translates to:
  /// **'Mohira R.'**
  String get mockMessageMohiraName;

  /// No description provided for @mockMessageZilolaName.
  ///
  /// In uz, this message translates to:
  /// **'Zilola K.'**
  String get mockMessageZilolaName;

  /// No description provided for @mockMessageNilufarName.
  ///
  /// In uz, this message translates to:
  /// **'Nilufar A.'**
  String get mockMessageNilufarName;

  /// No description provided for @mockMessageDilnozaName.
  ///
  /// In uz, this message translates to:
  /// **'Dilnoza S.'**
  String get mockMessageDilnozaName;

  /// No description provided for @mockMessageMohiraPreview.
  ///
  /// In uz, this message translates to:
  /// **'Vaqtingiz boʻlsa tanishsak.'**
  String get mockMessageMohiraPreview;

  /// No description provided for @mockMessageZilolaPreview.
  ///
  /// In uz, this message translates to:
  /// **'Taklifingiz koʻrildi'**
  String get mockMessageZilolaPreview;

  /// No description provided for @mockMessageNilufarPreview.
  ///
  /// In uz, this message translates to:
  /// **'Chat muddati tugadi'**
  String get mockMessageNilufarPreview;

  /// No description provided for @mockMessageDilnozaPreview.
  ///
  /// In uz, this message translates to:
  /// **'Hozircha javob kutilmoqda'**
  String get mockMessageDilnozaPreview;

  /// No description provided for @messageTimeYesterday.
  ///
  /// In uz, this message translates to:
  /// **'Kecha'**
  String get messageTimeYesterday;

  /// No description provided for @messageTimeMonday.
  ///
  /// In uz, this message translates to:
  /// **'Dush'**
  String get messageTimeMonday;

  /// No description provided for @messageTimeTuesday.
  ///
  /// In uz, this message translates to:
  /// **'Sesh'**
  String get messageTimeTuesday;

  /// No description provided for @savedFilterAll.
  ///
  /// In uz, this message translates to:
  /// **'Hammasi'**
  String get savedFilterAll;

  /// No description provided for @savedFilterInvited.
  ///
  /// In uz, this message translates to:
  /// **'Taklif yuborilgan'**
  String get savedFilterInvited;

  /// No description provided for @savedFilterWaiting.
  ///
  /// In uz, this message translates to:
  /// **'Javob kutilmoqda'**
  String get savedFilterWaiting;

  /// No description provided for @savedLimitLabel.
  ///
  /// In uz, this message translates to:
  /// **'{savedCount} / {limit} saqlangan'**
  String savedLimitLabel(int savedCount, int limit);

  /// No description provided for @savedPremiumCta.
  ///
  /// In uz, this message translates to:
  /// **'Premium — cheksiz'**
  String get savedPremiumCta;

  /// No description provided for @savedUpsellTitle.
  ///
  /// In uz, this message translates to:
  /// **'Yana {remaining} ta joy qoldi'**
  String savedUpsellTitle(int remaining);

  /// No description provided for @savedUpsellMessage.
  ///
  /// In uz, this message translates to:
  /// **'Bepul rejada 10 tagacha profil saqlanadi. Premium bilan cheklov yoʻq.'**
  String get savedUpsellMessage;

  /// No description provided for @questionnaireOptionalBadge.
  ///
  /// In uz, this message translates to:
  /// **'Ixtiyoriy qadam'**
  String get questionnaireOptionalBadge;

  /// No description provided for @questionnaireIntroTitle.
  ///
  /// In uz, this message translates to:
  /// **'{count} ta savol — {minutes} daqiqa'**
  String questionnaireIntroTitle(int count, int minutes);

  /// No description provided for @questionnaireIntroDescription.
  ///
  /// In uz, this message translates to:
  /// **'Javoblaringizni tahlil qilib, har bir nomzod bilan moslik foizingizni ko‘rsatamiz. Xohlamasangiz, keyinroq ham topshirasiz.'**
  String get questionnaireIntroDescription;

  /// No description provided for @questionnaireQuestionCount.
  ///
  /// In uz, this message translates to:
  /// **'{count} savol'**
  String questionnaireQuestionCount(int count);

  /// No description provided for @questionnaireWithoutTitle.
  ///
  /// In uz, this message translates to:
  /// **'So‘rovnomasiz nima bo‘ladi?'**
  String get questionnaireWithoutTitle;

  /// No description provided for @questionnaireWithoutBody.
  ///
  /// In uz, this message translates to:
  /// **'Profilingiz ishlaydi va nomzodlarni ko‘rasiz, lekin AI moslikni hisoblamaydi — foiz va bo‘limlar kesimidagi tahlil yopiq qoladi.'**
  String get questionnaireWithoutBody;

  /// No description provided for @questionnaireStart.
  ///
  /// In uz, this message translates to:
  /// **'Ha, so‘rovnomani boshlayman'**
  String get questionnaireStart;

  /// No description provided for @questionnaireLater.
  ///
  /// In uz, this message translates to:
  /// **'Keyinroq to‘ldiraman'**
  String get questionnaireLater;

  /// No description provided for @questionnaireEmpty.
  ///
  /// In uz, this message translates to:
  /// **'Hozircha savollar mavjud emas.'**
  String get questionnaireEmpty;

  /// No description provided for @questionnaireProgress.
  ///
  /// In uz, this message translates to:
  /// **'{current}/{total}'**
  String questionnaireProgress(int current, int total);

  /// No description provided for @questionnaireNext.
  ///
  /// In uz, this message translates to:
  /// **'Keyingi savol'**
  String get questionnaireNext;

  /// No description provided for @questionnaireSubmit.
  ///
  /// In uz, this message translates to:
  /// **'Javoblarni yuborish'**
  String get questionnaireSubmit;

  /// No description provided for @questionnaireAnalysisTitle.
  ///
  /// In uz, this message translates to:
  /// **'Javoblaringiz tahlil qilinmoqda'**
  String get questionnaireAnalysisTitle;

  /// No description provided for @questionnaireAnalysisBody.
  ///
  /// In uz, this message translates to:
  /// **'AI qadriyatlar, moliya va xarakter profilingizni tuzib, mos nomzodlarni tanlaydi.'**
  String get questionnaireAnalysisBody;

  /// No description provided for @questionnaireResultTitle.
  ///
  /// In uz, this message translates to:
  /// **'Sizning profilingiz tayyor!'**
  String get questionnaireResultTitle;

  /// No description provided for @questionnaireResultSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Sun’iy intellekt aniqlagan moslik endi ochiq.'**
  String get questionnaireResultSubtitle;

  /// No description provided for @questionnaireHonestyPill.
  ///
  /// In uz, this message translates to:
  /// **'Samimiylik: yuqori'**
  String get questionnaireHonestyPill;

  /// No description provided for @questionnaireSeriousPill.
  ///
  /// In uz, this message translates to:
  /// **'Niyati jiddiy'**
  String get questionnaireSeriousPill;

  /// No description provided for @questionnaireMatchedCandidates.
  ///
  /// In uz, this message translates to:
  /// **'{count} ta mos nomzod'**
  String questionnaireMatchedCandidates(int count);

  /// No description provided for @questionnaireMatchedCandidatesSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Moslik AI tomonidan hisoblandi'**
  String get questionnaireMatchedCandidatesSubtitle;

  /// No description provided for @questionnaireNextStepsTitle.
  ///
  /// In uz, this message translates to:
  /// **'Endi nima bo‘ladi?'**
  String get questionnaireNextStepsTitle;

  /// No description provided for @questionnaireAiMatchCalculatedTitle.
  ///
  /// In uz, this message translates to:
  /// **'AI moslik hisoblandi'**
  String get questionnaireAiMatchCalculatedTitle;

  /// No description provided for @questionnaireAiMatchCalculatedBody.
  ///
  /// In uz, this message translates to:
  /// **'Javoblaringiz asosida nomzodlar tanlandi.'**
  String get questionnaireAiMatchCalculatedBody;

  /// No description provided for @questionnaireCandidatesVeiledTitle.
  ///
  /// In uz, this message translates to:
  /// **'Nomzodlar parda ostida'**
  String get questionnaireCandidatesVeiledTitle;

  /// No description provided for @questionnaireCandidatesVeiledBody.
  ///
  /// In uz, this message translates to:
  /// **'Suratlar ikkala tomon roziligidan keyin ochiladi.'**
  String get questionnaireCandidatesVeiledBody;

  /// No description provided for @questionnaireConsentOnlyTitle.
  ///
  /// In uz, this message translates to:
  /// **'Aloqa faqat rozilik bilan'**
  String get questionnaireConsentOnlyTitle;

  /// No description provided for @questionnaireConsentOnlyBody.
  ///
  /// In uz, this message translates to:
  /// **'Suhbat vakil yoki oila ishtirokida boshlanadi.'**
  String get questionnaireConsentOnlyBody;

  /// No description provided for @questionnaireHonestyTitle.
  ///
  /// In uz, this message translates to:
  /// **'Samimiylik indeksi · yuqori'**
  String get questionnaireHonestyTitle;

  /// No description provided for @questionnaireHonestyBody.
  ///
  /// In uz, this message translates to:
  /// **'Tuzoq savollarga javoblaringiz izchil. Profil ishonchli deb belgilandi.'**
  String get questionnaireHonestyBody;

  /// No description provided for @questionnaireSeriousBadge.
  ///
  /// In uz, this message translates to:
  /// **'“Niyati jiddiy” belgisi berildi'**
  String get questionnaireSeriousBadge;

  /// No description provided for @questionnaireShowCandidates.
  ///
  /// In uz, this message translates to:
  /// **'Mos nomzodlarni ko‘rish'**
  String get questionnaireShowCandidates;

  /// No description provided for @questionnaireTraitTraditional.
  ///
  /// In uz, this message translates to:
  /// **'an’anaviy'**
  String get questionnaireTraitTraditional;

  /// No description provided for @questionnaireTraitBalanced.
  ///
  /// In uz, this message translates to:
  /// **'balansli'**
  String get questionnaireTraitBalanced;

  /// No description provided for @candidatesViewGrid.
  ///
  /// In uz, this message translates to:
  /// **'Katak ko‘rinishi'**
  String get candidatesViewGrid;

  /// No description provided for @candidatesViewMap.
  ///
  /// In uz, this message translates to:
  /// **'Xarita ko‘rinishi'**
  String get candidatesViewMap;

  /// No description provided for @nearbyPermissionTitle.
  ///
  /// In uz, this message translates to:
  /// **'Yaqin atrofdagi nomzodlar'**
  String get nearbyPermissionTitle;

  /// No description provided for @nearbyPermissionDescription.
  ///
  /// In uz, this message translates to:
  /// **'Joylashuvingiz aniq nuqta sifatida emas, taxminiy zona sifatida ishlatiladi.'**
  String get nearbyPermissionDescription;

  /// No description provided for @nearbyPermissionOpenSettings.
  ///
  /// In uz, this message translates to:
  /// **'Sozlamalarni ochish'**
  String get nearbyPermissionOpenSettings;

  /// No description provided for @nearbyPermissionEnableService.
  ///
  /// In uz, this message translates to:
  /// **'Joylashuvni yoqish'**
  String get nearbyPermissionEnableService;

  /// No description provided for @nearbyPermissionAllow.
  ///
  /// In uz, this message translates to:
  /// **'Joylashuvga ruxsat berish'**
  String get nearbyPermissionAllow;

  /// No description provided for @nearbyPermissionNotNow.
  ///
  /// In uz, this message translates to:
  /// **'Hozir emas'**
  String get nearbyPermissionNotNow;

  /// No description provided for @nearbyPermissionFootnote.
  ///
  /// In uz, this message translates to:
  /// **'«Hozir emas» ni tanlasangiz, Moslar va Tavsiyalar avvalgidek ishlaydi.'**
  String get nearbyPermissionFootnote;

  /// No description provided for @nearbyPermissionRuleHidden.
  ///
  /// In uz, this message translates to:
  /// **'Aniq manzilingiz hech kimga ko‘rsatilmaydi'**
  String get nearbyPermissionRuleHidden;

  /// No description provided for @nearbyPermissionRuleZone.
  ///
  /// In uz, this message translates to:
  /// **'Boshqalar sizni ~2 km li zona ichida ko‘radi'**
  String get nearbyPermissionRuleZone;

  /// No description provided for @nearbyPermissionRuleSettings.
  ///
  /// In uz, this message translates to:
  /// **'Istalgan vaqtda Sozlamalardan o‘chirasiz'**
  String get nearbyPermissionRuleSettings;

  /// No description provided for @nearbyUnknownZone.
  ///
  /// In uz, this message translates to:
  /// **'Yaqin zona'**
  String get nearbyUnknownZone;

  /// No description provided for @nearbyCandidateCount.
  ///
  /// In uz, this message translates to:
  /// **'{count} ta nomzod'**
  String nearbyCandidateCount(int count);

  /// No description provided for @nearbyZoneDistance.
  ///
  /// In uz, this message translates to:
  /// **'{zone} · ~{distance} km'**
  String nearbyZoneDistance(String zone, String distance);

  /// No description provided for @nearbyYou.
  ///
  /// In uz, this message translates to:
  /// **'Siz'**
  String get nearbyYou;

  /// No description provided for @nearbyAroundCount.
  ///
  /// In uz, this message translates to:
  /// **'Atrofingizda {count} ta nomzod'**
  String nearbyAroundCount(int count);

  /// No description provided for @nearbyShowAll.
  ///
  /// In uz, this message translates to:
  /// **'Barchasi'**
  String get nearbyShowAll;

  /// No description provided for @nearbyCloseMap.
  ///
  /// In uz, this message translates to:
  /// **'Xaritani yopish'**
  String get nearbyCloseMap;

  /// No description provided for @nearbyWithinRadius.
  ///
  /// In uz, this message translates to:
  /// **'{radius} km ichida'**
  String nearbyWithinRadius(int radius);

  /// No description provided for @nearbyRecenter.
  ///
  /// In uz, this message translates to:
  /// **'Joylashuvimga qaytish'**
  String get nearbyRecenter;

  /// No description provided for @nearbySettingsTitle.
  ///
  /// In uz, this message translates to:
  /// **'Radius va ko‘rinish'**
  String get nearbySettingsTitle;

  /// No description provided for @nearbySearchRadiusLabel.
  ///
  /// In uz, this message translates to:
  /// **'Radius'**
  String get nearbySearchRadiusLabel;

  /// No description provided for @nearbyRadiusRange.
  ///
  /// In uz, this message translates to:
  /// **'1–25 km'**
  String get nearbyRadiusRange;

  /// No description provided for @nearbyRadiusOption.
  ///
  /// In uz, this message translates to:
  /// **'{radius} km'**
  String nearbyRadiusOption(int radius);

  /// No description provided for @nearbyEntireRegion.
  ///
  /// In uz, this message translates to:
  /// **'Butun viloyat'**
  String get nearbyEntireRegion;

  /// No description provided for @nearbyEntireRegionUnavailable.
  ///
  /// In uz, this message translates to:
  /// **'Butun viloyat bo‘yicha qidiruv hozircha mavjud emas'**
  String get nearbyEntireRegionUnavailable;

  /// No description provided for @nearbyRadiusHint.
  ///
  /// In uz, this message translates to:
  /// **'Radius qanchalik katta bo‘lsa, moslik foizi shunchalik pasayadi.'**
  String get nearbyRadiusHint;

  /// No description provided for @nearbyVisibilityTitle.
  ///
  /// In uz, this message translates to:
  /// **'Meni Atrofdagilar ro‘yxatida ko‘rsatish'**
  String get nearbyVisibilityTitle;

  /// No description provided for @nearbyVisibilitySubtitle.
  ///
  /// In uz, this message translates to:
  /// **'O‘chirsangiz, siz ham hech kimni ko‘rmaysiz'**
  String get nearbyVisibilitySubtitle;

  /// No description provided for @nearbyAudienceTitle.
  ///
  /// In uz, this message translates to:
  /// **'Kim meni Atrofdagilarda ko‘ra oladi'**
  String get nearbyAudienceTitle;

  /// No description provided for @nearbyAudienceAll.
  ///
  /// In uz, this message translates to:
  /// **'Hamma nomzodlar'**
  String get nearbyAudienceAll;

  /// No description provided for @nearbyAudienceHighMatch.
  ///
  /// In uz, this message translates to:
  /// **'Faqat moslik 70% dan yuqori'**
  String get nearbyAudienceHighMatch;

  /// No description provided for @nearbyAudienceRecommended.
  ///
  /// In uz, this message translates to:
  /// **'tavsiya etiladi'**
  String get nearbyAudienceRecommended;

  /// No description provided for @nearbyAudienceRepresented.
  ///
  /// In uz, this message translates to:
  /// **'Faqat vakili bor nomzodlar'**
  String get nearbyAudienceRepresented;

  /// No description provided for @nearbyPrivacyZoneNote.
  ///
  /// In uz, this message translates to:
  /// **'Zona markazi kuniga bir marta tasodifiy siljiydi — shuning uchun sizning uyingizni hisoblab bo‘lmaydi.'**
  String get nearbyPrivacyZoneNote;

  /// No description provided for @nearbySettingsSave.
  ///
  /// In uz, this message translates to:
  /// **'Saqlash'**
  String get nearbySettingsSave;

  /// No description provided for @nearbyEmptyTitle.
  ///
  /// In uz, this message translates to:
  /// **'{radius} km ichida hozircha nomzod yo‘q'**
  String nearbyEmptyTitle(int radius);

  /// No description provided for @nearbyEmptyDescription.
  ///
  /// In uz, this message translates to:
  /// **'Radiusni kengaytiring yoki mezonlarni biroz yumshating.'**
  String get nearbyEmptyDescription;

  /// No description provided for @nearbyExpandRadius.
  ///
  /// In uz, this message translates to:
  /// **'Radiusni {radius} km ga kengaytirish'**
  String nearbyExpandRadius(int radius);

  /// No description provided for @nearbyChangeCriteria.
  ///
  /// In uz, this message translates to:
  /// **'Mezonlarni o‘zgartirish'**
  String get nearbyChangeCriteria;

  /// No description provided for @nearbyNotifyTitle.
  ///
  /// In uz, this message translates to:
  /// **'Yangi nomzod paydo bo‘lsa xabar bering'**
  String get nearbyNotifyTitle;

  /// No description provided for @nearbyNotifySubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Kuniga bir marta, ko‘pi bilan'**
  String get nearbyNotifySubtitle;

  /// No description provided for @profileEdit.
  ///
  /// In uz, this message translates to:
  /// **'Profilni tahrirlash'**
  String get profileEdit;

  /// No description provided for @profileSettings.
  ///
  /// In uz, this message translates to:
  /// **'Profil sozlamalari'**
  String get profileSettings;

  /// No description provided for @profileIdentifier.
  ///
  /// In uz, this message translates to:
  /// **'Foydalanuvchi raqami: {code}'**
  String profileIdentifier(String code);

  /// No description provided for @profilePreview.
  ///
  /// In uz, this message translates to:
  /// **'Boshqalar ko‘rinishi'**
  String get profilePreview;

  /// No description provided for @profileCopyIdentifier.
  ///
  /// In uz, this message translates to:
  /// **'Foydalanuvchi raqamini nusxalash'**
  String get profileCopyIdentifier;

  /// No description provided for @profileCompleteTitle.
  ///
  /// In uz, this message translates to:
  /// **'Profilingizni to‘ldiring'**
  String get profileCompleteTitle;

  /// No description provided for @profileCompleteSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Aniqroq juftlik topish uchun'**
  String get profileCompleteSubtitle;

  /// No description provided for @profileMyPhotos.
  ///
  /// In uz, this message translates to:
  /// **'SURATLARIM'**
  String get profileMyPhotos;

  /// No description provided for @profileMainPhoto.
  ///
  /// In uz, this message translates to:
  /// **'ASOSIY'**
  String get profileMainPhoto;

  /// No description provided for @profileAddPhoto.
  ///
  /// In uz, this message translates to:
  /// **'Surat qo‘shish'**
  String get profileAddPhoto;

  /// No description provided for @profilePhotoSemantics.
  ///
  /// In uz, this message translates to:
  /// **'Profil surati {index}'**
  String profilePhotoSemantics(int index);

  /// No description provided for @profilePhotoSourceTitle.
  ///
  /// In uz, this message translates to:
  /// **'Yangi surat'**
  String get profilePhotoSourceTitle;

  /// No description provided for @profilePhotoSourceSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Yuklangandan soʻng surat yuz tekshiruvidan oʻtadi.'**
  String get profilePhotoSourceSubtitle;

  /// No description provided for @profilePhotoCamera.
  ///
  /// In uz, this message translates to:
  /// **'Kameradan olish'**
  String get profilePhotoCamera;

  /// No description provided for @profilePhotoGallery.
  ///
  /// In uz, this message translates to:
  /// **'Galereyadan tanlash'**
  String get profilePhotoGallery;

  /// No description provided for @profilePhotoActionsTitle.
  ///
  /// In uz, this message translates to:
  /// **'Surat'**
  String get profilePhotoActionsTitle;

  /// No description provided for @profilePhotoSetMain.
  ///
  /// In uz, this message translates to:
  /// **'Asosiy qilib belgilash'**
  String get profilePhotoSetMain;

  /// No description provided for @profilePhotoReplace.
  ///
  /// In uz, this message translates to:
  /// **'Almashtirish'**
  String get profilePhotoReplace;

  /// No description provided for @profilePhotoDelete.
  ///
  /// In uz, this message translates to:
  /// **'Oʻchirish'**
  String get profilePhotoDelete;

  /// No description provided for @profilePhotoCancel.
  ///
  /// In uz, this message translates to:
  /// **'Bekor qilish'**
  String get profilePhotoCancel;

  /// No description provided for @profilePhotoDeleteTitle.
  ///
  /// In uz, this message translates to:
  /// **'Suratni oʻchirasizmi?'**
  String get profilePhotoDeleteTitle;

  /// No description provided for @profilePhotoDeleteSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Surat profilingizdan olib tashlanadi. Oʻrniga yangisini yuklashingiz mumkin.'**
  String get profilePhotoDeleteSubtitle;

  /// No description provided for @profileAboutSection.
  ///
  /// In uz, this message translates to:
  /// **'O‘ZINGIZ HAQINGIZDA'**
  String get profileAboutSection;

  /// No description provided for @profileNotFilled.
  ///
  /// In uz, this message translates to:
  /// **'Hali to‘ldirilmagan'**
  String get profileNotFilled;

  /// No description provided for @profileAdd.
  ///
  /// In uz, this message translates to:
  /// **'Qo‘shish'**
  String get profileAdd;

  /// No description provided for @profileEditShort.
  ///
  /// In uz, this message translates to:
  /// **'Tahrirlash'**
  String get profileEditShort;

  /// No description provided for @profilePhotoVerification.
  ///
  /// In uz, this message translates to:
  /// **'Rasm tekshiruvi'**
  String get profilePhotoVerification;

  /// No description provided for @profilePhotoVerificationSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Asosiy suratingiz kamera orqali selfi bilan solishtiriladi'**
  String get profilePhotoVerificationSubtitle;

  /// No description provided for @profileServices.
  ///
  /// In uz, this message translates to:
  /// **'Xizmatlar'**
  String get profileServices;

  /// No description provided for @profileServicesSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Psixolog, oilaviy uchrashuv, tekshiruv va Premium'**
  String get profileServicesSubtitle;

  /// No description provided for @profileIdentifierCopied.
  ///
  /// In uz, this message translates to:
  /// **'Foydalanuvchi raqami nusxalandi'**
  String get profileIdentifierCopied;

  /// No description provided for @profileActionComingSoon.
  ///
  /// In uz, this message translates to:
  /// **'Bu bo‘lim keyingi profil bosqichida ulanadi'**
  String get profileActionComingSoon;

  /// No description provided for @settingsTitle.
  ///
  /// In uz, this message translates to:
  /// **'Sozlamalar'**
  String get settingsTitle;

  /// No description provided for @settingsBack.
  ///
  /// In uz, this message translates to:
  /// **'Orqaga'**
  String get settingsBack;

  /// No description provided for @settingsAccountSection.
  ///
  /// In uz, this message translates to:
  /// **'Hisob'**
  String get settingsAccountSection;

  /// No description provided for @settingsEditProfile.
  ///
  /// In uz, this message translates to:
  /// **'Profilni tahrirlash'**
  String get settingsEditProfile;

  /// No description provided for @settingsPhotoPrivacy.
  ///
  /// In uz, this message translates to:
  /// **'Rasm maxfiyligi'**
  String get settingsPhotoPrivacy;

  /// No description provided for @settingsPhotoPrivacyAll.
  ///
  /// In uz, this message translates to:
  /// **'Hammaga ochiq'**
  String get settingsPhotoPrivacyAll;

  /// No description provided for @settingsBlockedUsers.
  ///
  /// In uz, this message translates to:
  /// **'Bloklangan foydalanuvchilar'**
  String get settingsBlockedUsers;

  /// No description provided for @settingsRecoveryQuestion.
  ///
  /// In uz, this message translates to:
  /// **'Hisobni tiklash savoli'**
  String get settingsRecoveryQuestion;

  /// No description provided for @settingsPrivacyChatSection.
  ///
  /// In uz, this message translates to:
  /// **'Maxfiylik va suhbat'**
  String get settingsPrivacyChatSection;

  /// No description provided for @settingsPrivacyVeil.
  ///
  /// In uz, this message translates to:
  /// **'Maxfiylik va parda tartibi'**
  String get settingsPrivacyVeil;

  /// No description provided for @settingsChatLimits.
  ///
  /// In uz, this message translates to:
  /// **'Suhbat limitlari'**
  String get settingsChatLimits;

  /// No description provided for @settingsChatLimitValue.
  ///
  /// In uz, this message translates to:
  /// **'72 soat'**
  String get settingsChatLimitValue;

  /// No description provided for @settingsParentLink.
  ///
  /// In uz, this message translates to:
  /// **'Ota-ona ulash'**
  String get settingsParentLink;

  /// No description provided for @settingsNotificationAppearanceSection.
  ///
  /// In uz, this message translates to:
  /// **'Bildirishnoma va ko‘rinish'**
  String get settingsNotificationAppearanceSection;

  /// No description provided for @settingsNotifications.
  ///
  /// In uz, this message translates to:
  /// **'Bildirishnomalar'**
  String get settingsNotifications;

  /// No description provided for @settingsNotificationsSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Yangi like, moslik va xabarlar haqida xabar beriladi'**
  String get settingsNotificationsSubtitle;

  /// No description provided for @settingsNotificationTypes.
  ///
  /// In uz, this message translates to:
  /// **'Bildirishnoma turlari'**
  String get settingsNotificationTypes;

  /// No description provided for @settingsDocumentsSection.
  ///
  /// In uz, this message translates to:
  /// **'Hujjatlar'**
  String get settingsDocumentsSection;

  /// No description provided for @settingsPrivacyPolicy.
  ///
  /// In uz, this message translates to:
  /// **'Maxfiylik siyosati'**
  String get settingsPrivacyPolicy;

  /// No description provided for @settingsTerms.
  ///
  /// In uz, this message translates to:
  /// **'Foydalanish shartlari'**
  String get settingsTerms;

  /// No description provided for @settingsHelpInfoSection.
  ///
  /// In uz, this message translates to:
  /// **'Yordam va ma’lumot'**
  String get settingsHelpInfoSection;

  /// No description provided for @settingsServices.
  ///
  /// In uz, this message translates to:
  /// **'Xizmatlar'**
  String get settingsServices;

  /// No description provided for @settingsHelpCenter.
  ///
  /// In uz, this message translates to:
  /// **'Yordam markazi'**
  String get settingsHelpCenter;

  /// No description provided for @settingsShareApp.
  ///
  /// In uz, this message translates to:
  /// **'Ilovani ulashish'**
  String get settingsShareApp;

  /// No description provided for @settingsLogout.
  ///
  /// In uz, this message translates to:
  /// **'Hisobdan chiqish'**
  String get settingsLogout;

  /// No description provided for @settingsActionComingSoon.
  ///
  /// In uz, this message translates to:
  /// **'Bu sozlama keyingi bosqichda ulanadi'**
  String get settingsActionComingSoon;

  /// No description provided for @privacyPolicyLoadingLabel.
  ///
  /// In uz, this message translates to:
  /// **'Maxfiylik siyosati yuklanmoqda'**
  String get privacyPolicyLoadingLabel;

  /// No description provided for @privacyPolicyLoadError.
  ///
  /// In uz, this message translates to:
  /// **'Maxfiylik siyosatini yuklab bo‘lmadi. Internet aloqasini tekshirib, qayta urinib ko‘ring.'**
  String get privacyPolicyLoadError;

  /// No description provided for @termsOfServiceLoadingLabel.
  ///
  /// In uz, this message translates to:
  /// **'Foydalanish shartlari yuklanmoqda'**
  String get termsOfServiceLoadingLabel;

  /// No description provided for @termsOfServiceLoadError.
  ///
  /// In uz, this message translates to:
  /// **'Foydalanish shartlarini yuklab bo‘lmadi. Internet aloqasini tekshirib, qayta urinib ko‘ring.'**
  String get termsOfServiceLoadError;

  /// User-facing error message selected by FailureType.name.
  ///
  /// In uz, this message translates to:
  /// **'{type, select, networkTimeout{Ulanish vaqti tugadi.} noInternet{Internet aloqasi yoʻq.} unauthorized{Sessiya tugagan.} cancelled{} forbidden{Kirish rad etildi.} notFound{Maʼlumot topilmadi.} validation{Kiritilgan maʼlumotni tekshiring.} configuration{Google orqali kirish ushbu build uchun sozlanmagan.} unsupported{Bu kirish usuli hali mavjud emas.} server{Serverda xatolik yuz berdi.} unknown{Nimadir xato ketdi.} other{Nimadir xato ketdi.}}'**
  String failureMessage(String type);

  /// No description provided for @profileEditTitle.
  ///
  /// In uz, this message translates to:
  /// **'Profilni tahrirlash'**
  String get profileEditTitle;

  /// No description provided for @profileEditAvatarTitle.
  ///
  /// In uz, this message translates to:
  /// **'Profil surati'**
  String get profileEditAvatarTitle;

  /// No description provided for @profileEditChangePhoto.
  ///
  /// In uz, this message translates to:
  /// **'Suratni oʻzgartirish'**
  String get profileEditChangePhoto;

  /// No description provided for @profilePhotoManagementTitle.
  ///
  /// In uz, this message translates to:
  /// **'Asosiy surat'**
  String get profilePhotoManagementTitle;

  /// No description provided for @profilePhotoManagementSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Profilingizda va nomzodlar roʻyxatida birinchi shu surat ko‘rinadi. Selfi tekshiruvi ham shu surat bilan solishtiriladi.'**
  String get profilePhotoManagementSubtitle;

  /// No description provided for @profilePhotoConfirm.
  ///
  /// In uz, this message translates to:
  /// **'Tasdiqlash'**
  String get profilePhotoConfirm;

  /// No description provided for @profileFaceVerificationDone.
  ///
  /// In uz, this message translates to:
  /// **'Davom etish'**
  String get profileFaceVerificationDone;

  /// No description provided for @profileEditName.
  ///
  /// In uz, this message translates to:
  /// **'Ism'**
  String get profileEditName;

  /// No description provided for @profileEditBirthYear.
  ///
  /// In uz, this message translates to:
  /// **'Tugʻilgan yil'**
  String get profileEditBirthYear;

  /// No description provided for @profileEditHeight.
  ///
  /// In uz, this message translates to:
  /// **'Boʻy'**
  String get profileEditHeight;

  /// No description provided for @profileEditWeight.
  ///
  /// In uz, this message translates to:
  /// **'Vazn'**
  String get profileEditWeight;

  /// No description provided for @profileEditEducation.
  ///
  /// In uz, this message translates to:
  /// **'Maʼlumoti'**
  String get profileEditEducation;

  /// No description provided for @profileEditProfession.
  ///
  /// In uz, this message translates to:
  /// **'Kasbi'**
  String get profileEditProfession;

  /// No description provided for @profileEditRegion.
  ///
  /// In uz, this message translates to:
  /// **'Viloyat'**
  String get profileEditRegion;

  /// No description provided for @profileEditDistrict.
  ///
  /// In uz, this message translates to:
  /// **'Tuman'**
  String get profileEditDistrict;

  /// No description provided for @profileEditMaritalStatus.
  ///
  /// In uz, this message translates to:
  /// **'Oilaviy holati'**
  String get profileEditMaritalStatus;

  /// No description provided for @profileEditAboutSection.
  ///
  /// In uz, this message translates to:
  /// **'OʻZINGIZ HAQINGIZDA'**
  String get profileEditAboutSection;

  /// No description provided for @profileEditAboutPlaceholder.
  ///
  /// In uz, this message translates to:
  /// **'Oʻzingiz, qadriyatlaringiz va kelajak rejalaringiz haqida qisqa yozing…'**
  String get profileEditAboutPlaceholder;

  /// No description provided for @profileEditSave.
  ///
  /// In uz, this message translates to:
  /// **'Saqlash'**
  String get profileEditSave;

  /// No description provided for @profileEditCancel.
  ///
  /// In uz, this message translates to:
  /// **'Bekor qilish'**
  String get profileEditCancel;

  /// No description provided for @profileEditSuccess.
  ///
  /// In uz, this message translates to:
  /// **'Profil muvaffaqiyatli saqlandi'**
  String get profileEditSuccess;

  /// No description provided for @profileEditFirstName.
  ///
  /// In uz, this message translates to:
  /// **'Ism'**
  String get profileEditFirstName;

  /// No description provided for @profileEditLastName.
  ///
  /// In uz, this message translates to:
  /// **'Familiya'**
  String get profileEditLastName;

  /// No description provided for @profileEditSelect.
  ///
  /// In uz, this message translates to:
  /// **'Tanlash'**
  String get profileEditSelect;

  /// No description provided for @profileEditSelectOption.
  ///
  /// In uz, this message translates to:
  /// **'Tanlang'**
  String get profileEditSelectOption;

  /// No description provided for @profileEditProfessionOther.
  ///
  /// In uz, this message translates to:
  /// **'Boshqa'**
  String get profileEditProfessionOther;

  /// No description provided for @profileEditProfessionInputLabel.
  ///
  /// In uz, this message translates to:
  /// **'Kasbingizni yozing'**
  String get profileEditProfessionInputLabel;

  /// No description provided for @profileEditSearchPlaceholder.
  ///
  /// In uz, this message translates to:
  /// **'Qidirish...'**
  String get profileEditSearchPlaceholder;

  /// No description provided for @profileEditRegionSearchHint.
  ///
  /// In uz, this message translates to:
  /// **'Viloyat qidirish...'**
  String get profileEditRegionSearchHint;

  /// No description provided for @profileEditDistrictSearchHint.
  ///
  /// In uz, this message translates to:
  /// **'Tuman qidirish...'**
  String get profileEditDistrictSearchHint;

  /// No description provided for @profileEditDistrictRegionCaption.
  ///
  /// In uz, this message translates to:
  /// **'{region} boʻyicha'**
  String profileEditDistrictRegionCaption(String region);

  /// No description provided for @profileEditNoOptions.
  ///
  /// In uz, this message translates to:
  /// **'Maʼlumot topilmadi'**
  String get profileEditNoOptions;

  /// No description provided for @profileEditCm.
  ///
  /// In uz, this message translates to:
  /// **'{cm} sm'**
  String profileEditCm(int cm);

  /// No description provided for @profileEditKg.
  ///
  /// In uz, this message translates to:
  /// **'{kg} kg'**
  String profileEditKg(int kg);

  /// No description provided for @profileEditSelectRegionFirst.
  ///
  /// In uz, this message translates to:
  /// **'Oldin viloyatni tanlang'**
  String get profileEditSelectRegionFirst;

  /// No description provided for @profileEditDiscardConfirmTitle.
  ///
  /// In uz, this message translates to:
  /// **'Oʻzgarishlarni bekor qilasizmi?'**
  String get profileEditDiscardConfirmTitle;

  /// No description provided for @profileEditDiscardConfirmMessage.
  ///
  /// In uz, this message translates to:
  /// **'Saqlanmagan maʼlumotlar yoʻqoladi.'**
  String get profileEditDiscardConfirmMessage;

  /// No description provided for @profileEditDiscard.
  ///
  /// In uz, this message translates to:
  /// **'Bekor qilish'**
  String get profileEditDiscard;

  /// No description provided for @profileEditKeepEditing.
  ///
  /// In uz, this message translates to:
  /// **'Qolish'**
  String get profileEditKeepEditing;

  /// No description provided for @profileEditUnsavedTitle.
  ///
  /// In uz, this message translates to:
  /// **'Oʻzgarishlar saqlanmadi'**
  String get profileEditUnsavedTitle;

  /// No description provided for @profileEditUnsavedMessage.
  ///
  /// In uz, this message translates to:
  /// **'Chiqsangiz, kiritilgan oʻzgarishlar yoʻqoladi.'**
  String get profileEditUnsavedMessage;

  /// No description provided for @profileEditStayEditing.
  ///
  /// In uz, this message translates to:
  /// **'Tahrirlashda qolish'**
  String get profileEditStayEditing;

  /// No description provided for @profileEditExit.
  ///
  /// In uz, this message translates to:
  /// **'Chiqish'**
  String get profileEditExit;

  /// No description provided for @profileEditUpdatedTitle.
  ///
  /// In uz, this message translates to:
  /// **'Profil yangilandi'**
  String get profileEditUpdatedTitle;

  /// No description provided for @profileEditUpdatedMessage.
  ///
  /// In uz, this message translates to:
  /// **'Oʻzgarishlar saqlandi. Profilingiz nomzodlarga yangilangan koʻrinishda koʻrsatiladi.'**
  String get profileEditUpdatedMessage;

  /// No description provided for @profileEditUpdatedOk.
  ///
  /// In uz, this message translates to:
  /// **'Yaxshi'**
  String get profileEditUpdatedOk;

  /// No description provided for @blockedUsersTitle.
  ///
  /// In uz, this message translates to:
  /// **'Bloklangan profillar'**
  String get blockedUsersTitle;

  /// No description provided for @blockedUsersSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Bloklangan profillar sizni qidiruvda ko‘rmaydi va yozolmaydi.'**
  String get blockedUsersSubtitle;

  /// No description provided for @blockedUsersEmpty.
  ///
  /// In uz, this message translates to:
  /// **'Bloklangan profillar yo‘q'**
  String get blockedUsersEmpty;

  /// No description provided for @blockedUsersEmptySubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Siz bloklagan barcha profillar shu yerda ko‘rinadi.'**
  String get blockedUsersEmptySubtitle;

  /// No description provided for @blockedUsersNote.
  ///
  /// In uz, this message translates to:
  /// **'Shikoyat qilingan profil moderator ko‘rigidan keyin avtomatik bloklanadi — bu ro‘yxatda «Shikoyatdan keyin» deb belgilanadi.'**
  String get blockedUsersNote;

  /// No description provided for @blockedAtDate.
  ///
  /// In uz, this message translates to:
  /// **'Bloklangan {date}'**
  String blockedAtDate(String date);

  /// No description provided for @blockedAfterComplaint.
  ///
  /// In uz, this message translates to:
  /// **'Shikoyatdan keyin bloklangan'**
  String get blockedAfterComplaint;

  /// No description provided for @unblockButton.
  ///
  /// In uz, this message translates to:
  /// **'Blokdan chiqarish'**
  String get unblockButton;

  /// No description provided for @unblockSuccess.
  ///
  /// In uz, this message translates to:
  /// **'Foydalanuvchi blokdan chiqarildi'**
  String get unblockSuccess;

  /// No description provided for @unblockConfirmTitle.
  ///
  /// In uz, this message translates to:
  /// **'Blokdan chiqarilsinmi?'**
  String get unblockConfirmTitle;

  /// No description provided for @unblockConfirmMessage.
  ///
  /// In uz, this message translates to:
  /// **'Ushbu profil yana sizga xabar yoza oladi va profilingizni ko‘ra oladi.'**
  String get unblockConfirmMessage;

  /// No description provided for @cancel.
  ///
  /// In uz, this message translates to:
  /// **'Bekor qilish'**
  String get cancel;

  /// No description provided for @accountDeletionTitle.
  ///
  /// In uz, this message translates to:
  /// **'Hisobni oʻchirish'**
  String get accountDeletionTitle;

  /// No description provided for @accountDeletionWarningTitle.
  ///
  /// In uz, this message translates to:
  /// **'Bu amal qaytarilmaydi'**
  String get accountDeletionWarningTitle;

  /// No description provided for @accountDeletionWarningMessage.
  ///
  /// In uz, this message translates to:
  /// **'Hisob oʻchirilgach profilingizni tiklash imkoni boʻlmaydi.'**
  String get accountDeletionWarningMessage;

  /// No description provided for @accountDeletionItemsTitle.
  ///
  /// In uz, this message translates to:
  /// **'NIMALAR OʻCHIRILADI'**
  String get accountDeletionItemsTitle;

  /// No description provided for @accountDeletionPhotos.
  ///
  /// In uz, this message translates to:
  /// **'Barcha suratlar va ovozli tanishtiruv'**
  String get accountDeletionPhotos;

  /// No description provided for @accountDeletionQuestionnaire.
  ///
  /// In uz, this message translates to:
  /// **'Soʻrovnoma javoblari va moslik natijalari'**
  String get accountDeletionQuestionnaire;

  /// No description provided for @accountDeletionChats.
  ///
  /// In uz, this message translates to:
  /// **'Suhbatlar va saqlangan profillar'**
  String get accountDeletionChats;

  /// No description provided for @accountDeletionRepresentative.
  ///
  /// In uz, this message translates to:
  /// **'Ulangan vakil bilan bogʻlanish'**
  String get accountDeletionRepresentative;

  /// No description provided for @accountDeletionReasonTitle.
  ///
  /// In uz, this message translates to:
  /// **'SABAB (IXTIYORIY)'**
  String get accountDeletionReasonTitle;

  /// No description provided for @accountDeletionReasonFoundMatch.
  ///
  /// In uz, this message translates to:
  /// **'Juftlik topdim'**
  String get accountDeletionReasonFoundMatch;

  /// No description provided for @accountDeletionReasonNoTime.
  ///
  /// In uz, this message translates to:
  /// **'Hozircha vaqtim yoʻq'**
  String get accountDeletionReasonNoTime;

  /// No description provided for @accountDeletionReasonPrivacy.
  ///
  /// In uz, this message translates to:
  /// **'Maxfiylik xavotiri'**
  String get accountDeletionReasonPrivacy;

  /// No description provided for @accountDeletionConfirm.
  ///
  /// In uz, this message translates to:
  /// **'Hisobni oʻchirish'**
  String get accountDeletionConfirm;

  /// No description provided for @accountDeletionCancel.
  ///
  /// In uz, this message translates to:
  /// **'Bekor qilish'**
  String get accountDeletionCancel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru', 'uz'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
    case 'uz':
      return AppLocalizationsUz();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
