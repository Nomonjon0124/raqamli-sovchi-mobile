import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/errors/failure.dart';

final class AppLocalizations {
  const AppLocalizations(this.locale);

  final Locale locale;

  static const delegate = _AppLocalizationsDelegate();
  static const supportedLocales = [Locale('uz'), Locale('en')];

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  bool get _isEnglish => locale.languageCode == 'en';

  String get appTitle => _isEnglish ? 'Digital Matchmaker' : 'Raqamli Sovchi';
  String get loading => _isEnglish ? 'Loading...' : 'Yuklanmoqda...';
  String get loginTitle => _isEnglish ? 'Welcome' : 'Xush kelibsiz';
  String get loginSubtitle => _isEnglish
      ? 'Start with a safe demo session.'
      : 'Xavfsiz demo sessiya bilan boshlang.';
  String get signInAsDemo =>
      _isEnglish ? 'Sign in as demo user' : 'Demo sifatida kirish';
  String get homeTitle => _isEnglish ? 'Home' : 'Bosh sahifa';
  String get homeMessage => _isEnglish
      ? 'Foundation is ready for the next feature.'
      : 'Foundation keyingi feature uchun tayyor.';
  String get logout => _isEnglish ? 'Log out' : 'Chiqish';
  String get retry => _isEnglish ? 'Retry' : 'Qayta urinish';

  String failureMessage(FailureType type) {
    return switch (type) {
      FailureType.networkTimeout =>
        _isEnglish ? 'Connection timed out.' : 'Ulanish vaqti tugadi.',
      FailureType.noInternet =>
        _isEnglish ? 'No internet connection.' : 'Internet aloqasi yo‘q.',
      FailureType.unauthorized =>
        _isEnglish ? 'Session expired.' : 'Sessiya tugagan.',
      FailureType.forbidden =>
        _isEnglish ? 'Access denied.' : 'Kirish rad etildi.',
      FailureType.notFound =>
        _isEnglish ? 'Data was not found.' : 'Ma’lumot topilmadi.',
      FailureType.validation =>
        _isEnglish
            ? 'Please check your input.'
            : 'Kiritilgan ma’lumotni tekshiring.',
      FailureType.server || FailureType.unknown =>
        _isEnglish ? 'Something went wrong.' : 'Nimadir xato ketdi.',
    };
  }
}

final class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLocales.any(
    (supported) => supported.languageCode == locale.languageCode,
  );

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
