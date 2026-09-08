import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/features/profile/domain/entities/blocked_user.dart';
import 'package:raqamli_sovchi/features/profile/presentation/widgets/blocked_user_tile.dart';
import 'package:raqamli_sovchi/l10n/app_localizations.dart';

void main() {
  testWidgets('BlockedUserTile renders name, initials, and date', (
    tester,
  ) async {
    final user = BlockedUser(
      id: 'block-1',
      blocker: 'user-me',
      blocked: 'user-target',
      createdAt: DateTime(2026, 7, 28),
      blockedInfo: const BlockedUserInfo(
        id: 'user-target',
        profileId: 'profile-target',
        fullName: 'Aziz Karimov',
      ),
    );

    var unblockCalled = false;

    await tester.pumpWidget(
      _TestApp(
        child: BlockedUserTile(
          blockedUser: user,
          isUnblocking: false,
          onUnblock: () => unblockCalled = true,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Aziz Karimov'), findsOneWidget);
    expect(find.text('AK'), findsOneWidget);
    expect(find.text('Bloklangan 28.07.2026'), findsOneWidget);
    expect(find.text('Blokdan chiqarish'), findsOneWidget);

    await tester.tap(find.text('Blokdan chiqarish'));
    expect(unblockCalled, isTrue);
  });

  testWidgets(
    'BlockedUserTile renders complaint subtitle when reason is complaint',
    (tester) async {
      final user = BlockedUser(
        id: 'block-2',
        blocker: 'user-me',
        blocked: 'user-target',
        reason: 'complaint_approved',
        createdAt: DateTime(2026, 7, 28),
        blockedInfo: const BlockedUserInfo(
          id: 'user-target',
          profileId: 'profile-target',
          fullName: 'Rustam Toshev',
        ),
      );

      await tester.pumpWidget(
        _TestApp(
          child: BlockedUserTile(
            blockedUser: user,
            isUnblocking: false,
            onUnblock: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Rustam Toshev'), findsOneWidget);
      expect(find.text('RT'), findsOneWidget);
      expect(find.text('Shikoyatdan keyin bloklangan'), findsOneWidget);
    },
  );

  testWidgets(
    'BlockedUserTile shows progress indicator when isUnblocking is true',
    (tester) async {
      const user = BlockedUser(
        id: 'block-3',
        blocker: 'user-me',
        blocked: 'user-target',
        blockedInfo: BlockedUserInfo(
          id: 'user-target',
          profileId: 'profile-target',
          fullName: 'Dilnoza Saidova',
        ),
      );

      await tester.pumpWidget(
        _TestApp(
          child: BlockedUserTile(
            blockedUser: user,
            isUnblocking: true,
            onUnblock: () {},
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Blokdan chiqarish'), findsNothing);
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
