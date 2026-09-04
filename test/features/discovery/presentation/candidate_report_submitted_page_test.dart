import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/features/discovery/presentation/pages/candidate_report_submitted_page.dart';
import 'package:raqamli_sovchi/l10n/app_localizations.dart';

void main() {
  testWidgets('renders Figma report submitted page layout with details', (
    tester,
  ) async {
    final submittedDate = DateTime(2026, 4, 20, 20, 25);

    await tester.pumpWidget(
      _testApp(
        CandidateReportSubmittedPage(
          candidateName: 'Mohira R., 23',
          reportNumber: 'SH-24815',
          submittedAt: submittedDate,
        ),
      ),
    );

    expect(find.text('Shikoyat yuborildi'), findsOneWidget);
    expect(find.text('Natija haqida xabar beramiz.'), findsOneWidget);
    expect(find.text('Ariza raqami'), findsOneWidget);
    expect(find.text('#SH-24815'), findsOneWidget);
    expect(find.text('Yuborildi'), findsOneWidget);
    expect(find.text('20.04.2026 20:25'), findsOneWidget);
    expect(find.text('Holat'), findsOneWidget);
    expect(find.text('Ko‘rib chiqilmoqda'), findsOneWidget);

    expect(find.text('Suhbat tarixi dalil sifatida saqlandi'), findsOneWidget);
    expect(find.text('Moderator tekshiruvi'), findsOneWidget);
    expect(find.text('Qaror va xabarnoma'), findsOneWidget);
    expect(
      find.text(
        'Bu foydalanuvchi siz bilan bog‘lana olmaydi. Suhbat vaqtincha yopildi.',
      ),
      findsOneWidget,
    );
    expect(find.text('Yopish'), findsOneWidget);
  });

  testWidgets('invokes onClose when close button or back icon tapped', (
    tester,
  ) async {
    var closeCount = 0;

    await tester.pumpWidget(
      _testApp(
        CandidateReportSubmittedPage(
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
  });
}

Widget _testApp(Widget child) => MaterialApp(
  locale: const Locale('uz'),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: child,
);
