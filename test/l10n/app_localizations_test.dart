import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/l10n/app_localizations.dart';

void main() {
  test('supports all four application locales', () {
    const uzbekCyrillic = Locale.fromSubtags(
      languageCode: 'uz',
      scriptCode: 'Cyrl',
    );

    expect(AppLocalizations.supportedLocales, hasLength(4));
    expect(
      AppLocalizations.supportedLocales,
      containsAll(const <Locale>[
        Locale('uz'),
        uzbekCyrillic,
        Locale('en'),
        Locale('ru'),
      ]),
    );
  });

  test('resolves localized auth and failure messages', () {
    final uz = lookupAppLocalizations(const Locale('uz'));
    final en = lookupAppLocalizations(const Locale('en'));
    final ru = lookupAppLocalizations(const Locale('ru'));
    final uzbekCyrillic = lookupAppLocalizations(
      const Locale.fromSubtags(languageCode: 'uz', scriptCode: 'Cyrl'),
    );

    expect(uz.continueLabel, 'Davom etish');
    expect(en.continueLabel, 'Continue');
    expect(ru.continueLabel, 'Продолжить');

    expect(uzbekCyrillic.localeName, 'uz_Cyrl');
    expect(uzbekCyrillic.settingsTitle, 'Созламалар');
    expect(uzbekCyrillic.settingsLanguage, 'Тил');
    expect(uzbekCyrillic.settingsThemeDark, 'Қоронғи');
    expect(uzbekCyrillic.aboutMeCounter(7), '7 / 300 белги');

    expect(uz.failureMessage('networkTimeout'), 'Ulanish vaqti tugadi.');
    expect(en.failureMessage('networkTimeout'), 'Connection timed out.');
    expect(ru.failureMessage('networkTimeout'), 'Время подключения истекло.');
    expect(
      uzbekCyrillic.failureMessage('networkTimeout'),
      'Уланиш вақти тугади.',
    );
  });
}
