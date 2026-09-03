import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/features/onboarding/presentation/bloc/profile_onboarding_state.dart';
import 'package:raqamli_sovchi/features/onboarding/presentation/widgets/onboarding_reference_bottom_sheet.dart';
import 'package:raqamli_sovchi/l10n/app_localizations.dart';

void main() {
  testWidgets('reference list scroll expands its bottom sheet', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetViewInsets);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('uz'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SizedBox.expand(
            child: OnboardingReferenceBottomSheet(
              title: 'Viloyatni tanlang',
              status: ReferenceStatus.loaded,
              onRetry: () {},
              onConfirm: () {},
              confirmEnabled: false,
              listBuilder: (context, scrollController) => ListView.builder(
                controller: scrollController,
                itemCount: 30,
                itemBuilder: (context, index) => OnboardingReferenceOptionTile(
                  label: 'Hudud $index',
                  selected: false,
                  onPressed: () {},
                ),
              ),
            ),
          ),
        ),
      ),
    );

    final sheet = find.byWidgetPredicate(
      (widget) =>
          widget is Container &&
          widget.padding == const EdgeInsets.fromLTRB(24, 12, 24, 24),
    );
    final initialHeight = tester.getSize(sheet).height;

    await tester.drag(find.byType(ListView), const Offset(0, -400));
    await tester.pumpAndSettle();

    expect(tester.getSize(sheet).height, greaterThan(initialHeight));

    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    await tester.pumpAndSettle();

    expect(tester.getBottomRight(sheet).dy, lessThanOrEqualTo(544));
    expect(tester.takeException(), isNull);
  });
}
