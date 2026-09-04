import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/features/discovery/presentation/pages/candidate_blocked_page.dart';
import 'package:raqamli_sovchi/l10n/app_localizations.dart';

void main() {
  testWidgets('renders Figma blocked page layout with candidate details', (
    tester,
  ) async {
    final blockedDate = DateTime(2026, 9, 3, 20, 16);

    await tester.pumpWidget(
      _TestApp(
        child: CandidateBlockedPage(
          candidateName: 'Mohira R., 23',
          blockedAt: blockedDate,
        ),
      ),
    );

    expect(find.text('Profil bloklandi'), findsOneWidget);
    expect(find.text('Mohira R., 23 endi sizni ko‘rmaydi.'), findsOneWidget);
    expect(find.text('Kim'), findsOneWidget);
    expect(find.text('Mohira R., 23'), findsOneWidget);
    expect(find.text('Bloklandi'), findsOneWidget);
    expect(find.text('03.09.2026 20:16'), findsOneWidget);
    expect(find.text('Holat'), findsOneWidget);
    expect(find.text('Bloklangan'), findsOneWidget);

    expect(find.text('Suhbat yopiladi, yozishmalar saqlanadi'), findsOneWidget);
    expect(
      find.text('Saqlanganlar ro‘yxatidan olib tashlanadi'),
      findsOneWidget,
    );
    expect(
      find.text('Uning vakili ham siz bilan bog‘lana olmaydi'),
      findsOneWidget,
    );
    expect(
      find.text(
        'U bloklaganingizni bilmaydi. Blokni Sozlamalar → Bloklangan profillar bo‘limidan olib tashlaysiz.',
      ),
      findsOneWidget,
    );
    expect(find.text('Yopish'), findsOneWidget);
  });

  testWidgets(
    'invokes onClose or pops when back button and close button tapped',
    (tester) async {
      var closeCount = 0;

      await tester.pumpWidget(
        _TestApp(
          child: CandidateBlockedPage(
            candidateName: 'Mohira R., 23',
            onClose: () => closeCount++,
          ),
        ),
      );

      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();
      expect(closeCount, 1);

      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();
      expect(closeCount, 2);
    },
  );
}

final class _TestApp extends StatelessWidget {
  const _TestApp({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('uz'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    );
  }
}
