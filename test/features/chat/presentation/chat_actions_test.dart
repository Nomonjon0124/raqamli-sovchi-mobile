import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/features/chat/presentation/widgets/chat_actions_bottom_sheet.dart';
import 'package:raqamli_sovchi/features/chat/presentation/widgets/chat_delete_dialog.dart';
import 'package:raqamli_sovchi/features/chat/presentation/widgets/chat_header.dart';
import 'package:raqamli_sovchi/l10n/app_localizations.dart';

void main() {
  testWidgets('shows chat actions and handles report/delete taps', (
    tester,
  ) async {
    var reportPressed = false;
    var deletePressed = false;

    await tester.pumpWidget(
      _testApp(
        Scaffold(
          body: ChatActionsBottomSheet(
            onReport: () => reportPressed = true,
            onDelete: () => deletePressed = true,
          ),
        ),
      ),
    );

    expect(find.text('Shikoyat qilish'), findsOneWidget);
    expect(find.text('Chatni oʻchirish'), findsOneWidget);
    await tester.tap(find.text('Shikoyat qilish'));
    await tester.tap(find.text('Chatni oʻchirish'));

    expect(reportPressed, isTrue);
    expect(deletePressed, isTrue);
  });

  testWidgets('delete dialog returns confirmation result', (tester) async {
    bool? result;
    await tester.pumpWidget(
      _testApp(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              result = await showDialog<bool>(
                context: context,
                builder: (_) =>
                    const ChatDeleteDialog(participantName: 'Mohira R.'),
              );
            },
            child: const Text('Open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(
      find.text('Mohira R. ni suhbatni oʻchirmoqchimisiz?'),
      findsOneWidget,
    );
    await tester.tap(find.text('Oʻchirish'));
    await tester.pumpAndSettle();

    expect(result, isTrue);
  });

  testWidgets('ChatHeader triggers onUserTap when user area is tapped', (
    tester,
  ) async {
    var userTapped = false;
    await tester.pumpWidget(
      _testApp(
        Scaffold(
          body: ChatHeader(
            name: 'Mohira R.',
            subtitle: 'Onlayn',
            isOnline: true,
            backLabel: 'Orqaga',
            moreLabel: 'Koʻproq',
            onBack: () {},
            onMore: () {},
            onUserTap: () => userTapped = true,
          ),
        ),
      ),
    );

    expect(find.text('Mohira R.'), findsOneWidget);
    await tester.tap(find.text('Mohira R.'));
    await tester.pumpAndSettle();

    expect(userTapped, isTrue);
  });
}

Widget _testApp(Widget child) => MaterialApp(
  locale: const Locale('uz'),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: child,
);
