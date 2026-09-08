import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/features/profile/presentation/pages/profile_location_picker_page.dart';
import 'package:raqamli_sovchi/features/profile/presentation/widgets/edit/profile_edit_status_sheets.dart';
import 'package:raqamli_sovchi/features/profile/presentation/widgets/edit/profile_reference_picker_sheet.dart';
import 'package:raqamli_sovchi/l10n/app_localizations.dart';

void main() {
  testWidgets('region picker filters items and returns selected region', (
    tester,
  ) async {
    ReferenceItem? selectedRegion;

    await tester.pumpWidget(
      _TestApp(
        child: Builder(
          builder: (context) {
            return TextButton(
              onPressed: () async {
                selectedRegion = await Navigator.of(context)
                    .push<ReferenceItem>(
                      MaterialPageRoute(
                        builder: (_) => const ProfileRegionPickerPage(
                          selectedId: 'reg-1',
                          regions: [
                            ReferenceItem(id: 'reg-1', name: 'Toshkent'),
                            ReferenceItem(id: 'reg-2', name: 'Fargʻona'),
                          ],
                        ),
                      ),
                    );
              },
              child: const Text('open'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Viloyat'), findsOneWidget);
    expect(find.text('Viloyat qidirish...'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'farg');
    await tester.pumpAndSettle();

    expect(find.text('Fargʻona'), findsOneWidget);
    expect(find.text('Toshkent'), findsNothing);

    await tester.tap(find.text('Fargʻona'));
    await tester.tap(find.text('Tanlash'));
    await tester.pumpAndSettle();

    expect(selectedRegion, const ReferenceItem(id: 'reg-2', name: 'Fargʻona'));
  });

  testWidgets('district picker shows selected region caption', (tester) async {
    await tester.pumpWidget(
      const _TestApp(
        child: ProfileDistrictPickerPage(
          regionName: 'Fargʻona viloyati',
          selectedId: 'dist-1',
          districts: [
            ReferenceItem(id: 'dist-1', name: 'Quva'),
            ReferenceItem(id: 'dist-2', name: 'Rishton'),
          ],
        ),
      ),
    );

    expect(find.text('Tuman'), findsOneWidget);
    expect(find.text('Fargʻona viloyati boʻyicha'), findsOneWidget);
    expect(find.text('Tuman qidirish...'), findsOneWidget);
    expect(find.text('Quva'), findsOneWidget);
  });

  testWidgets('unsaved changes sheet returns exit decision', (tester) async {
    bool? shouldExit;

    await tester.pumpWidget(
      _TestApp(
        child: Builder(
          builder: (context) {
            return TextButton(
              onPressed: () async {
                shouldExit = await showProfileUnsavedChangesSheet(context);
              },
              child: const Text('open'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Oʻzgarishlar saqlanmadi'), findsOneWidget);

    await tester.tap(find.text('Chiqish'));
    await tester.pumpAndSettle();

    expect(shouldExit, isTrue);
  });

  testWidgets(
    'ProfileReferencePickerSheet selects item and returns through onConfirm',
    (tester) async {
      ReferenceItem? confirmedItem;

      await tester.pumpWidget(
        _TestApp(
          child: Builder(
            builder: (context) {
              return TextButton(
                onPressed: () => ProfileReferencePickerSheet.show(
                  context: context,
                  title: 'Kasbi',
                  items: const [
                    ReferenceItem(id: '1', name: 'Dasturchi'),
                    ReferenceItem(id: '2', name: 'Shifokor'),
                  ],
                  selectedId: '1',
                  onConfirm: (item) => confirmedItem = item,
                ),
                child: const Text('open_sheet'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('open_sheet'));
      await tester.pumpAndSettle();

      expect(find.text('Kasbi'), findsOneWidget);
      expect(find.text('Dasturchi'), findsOneWidget);
      expect(find.text('Shifokor'), findsOneWidget);

      await tester.tap(find.text('Shifokor'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Tanlash'));
      await tester.pumpAndSettle();

      expect(confirmedItem, const ReferenceItem(id: '2', name: 'Shifokor'));
    },
  );

  testWidgets(
    'ProfileReferencePickerSheet supports Boshqa option with custom input',
    (tester) async {
      String? customProfession;

      await tester.pumpWidget(
        _TestApp(
          child: Builder(
            builder: (context) {
              return TextButton(
                onPressed: () => ProfileReferencePickerSheet.show(
                  context: context,
                  title: 'Kasbi',
                  items: const [ReferenceItem(id: '1', name: 'Dasturchi')],
                  selectedId: '1',
                  hasOther: true,
                  onConfirm: (_) {},
                  onConfirmCustom: (name) => customProfession = name,
                ),
                child: const Text('open_custom_sheet'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('open_custom_sheet'));
      await tester.pumpAndSettle();

      expect(find.text('Boshqa'), findsOneWidget);

      await tester.tap(find.text('Boshqa'));
      await tester.pumpAndSettle();

      expect(find.text('Kasbingizni yozing'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'Arxitektor');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Tanlash'));
      await tester.pumpAndSettle();

      expect(customProfession, 'Arxitektor');
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
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );
  }
}
