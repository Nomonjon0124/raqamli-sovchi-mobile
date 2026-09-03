import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/features/questionnaire/domain/entities/questionnaire.dart';
import 'package:raqamli_sovchi/features/questionnaire/presentation/widgets/questionnaire_result_view.dart';
import 'package:raqamli_sovchi/l10n/app_localizations.dart';

void main() {
  testWidgets('renders the profile-ready result UI without score details', (
    tester,
  ) async {
    var showCandidatesPressed = false;

    await tester.pumpWidget(
      _LocalizedTestApp(
        child: QuestionnaireResultView(
          result: const QuestionnaireResult(
            sections: [
              QuestionnaireSectionResult(
                sectionId: 'values',
                sectionName: 'Values',
                score: .75,
              ),
            ],
          ),
          onShowCandidates: () => showCandidatesPressed = true,
        ),
      ),
    );

    expect(find.text('Sizning profilingiz tayyor!'), findsOneWidget);
    expect(
      find.text('Sun’iy intellekt aniqlagan moslik endi ochiq.'),
      findsOneWidget,
    );
    expect(find.text('Samimiylik: yuqori'), findsOneWidget);
    expect(find.text('Niyati jiddiy'), findsOneWidget);
    expect(find.text('128 ta mos nomzod'), findsOneWidget);
    expect(find.text('Endi nima bo‘ladi?'), findsOneWidget);
    expect(find.text('AI moslik hisoblandi'), findsOneWidget);
    expect(find.text('Nomzodlar parda ostida'), findsOneWidget);
    expect(find.text('Aloqa faqat rozilik bilan'), findsOneWidget);
    expect(find.text('Values'), findsNothing);
    expect(find.text('an’anaviy'), findsNothing);

    await tester.tap(find.text('Mos nomzodlarni ko‘rish'));
    await tester.pump();

    expect(showCandidatesPressed, isTrue);
  });
}

final class _LocalizedTestApp extends StatelessWidget {
  const _LocalizedTestApp({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('uz'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    );
  }
}
