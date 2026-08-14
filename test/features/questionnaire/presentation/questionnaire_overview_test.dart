import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/features/questionnaire/domain/entities/questionnaire.dart';
import 'package:raqamli_sovchi/features/questionnaire/presentation/widgets/questionnaire_overview.dart';
import 'package:raqamli_sovchi/l10n/app_localizations.dart';

void main() {
  testWidgets('keeps both overview actions fixed while content scrolls', (
    tester,
  ) async {
    const sections = [
      QuestionnaireSection(id: '1', name: 'One', questionCount: 6),
      QuestionnaireSection(id: '2', name: 'Two', questionCount: 6),
      QuestionnaireSection(id: '3', name: 'Three', questionCount: 6),
      QuestionnaireSection(id: '4', name: 'Four', questionCount: 6),
      QuestionnaireSection(id: '5', name: 'Five', questionCount: 6),
      QuestionnaireSection(id: '6', name: 'Six', questionCount: 6),
    ];
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('uz'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: QuestionnaireOverview(
          questionnaire: const Questionnaire(
            profileId: 'profile-1',
            sections: sections,
            questions: [
              QuestionnaireQuestion(
                id: 'q1',
                sectionId: '1',
                sectionName: 'One',
                text: 'Question?',
                order: 1,
                isTrapQuestion: false,
                options: [],
              ),
            ],
          ),
          onStart: () {},
          onLater: () {},
        ),
      ),
    );

    final start = find.text('Ha, so‘rovnomani boshlayman');
    final later = find.text('Keyinroq to‘ldiraman');
    final startTop = tester.getTopLeft(start).dy;
    final laterTop = tester.getTopLeft(later).dy;

    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -400),
    );
    await tester.pumpAndSettle();

    expect(tester.getTopLeft(start).dy, startTop);
    expect(tester.getTopLeft(later).dy, laterTop);
  });
}
