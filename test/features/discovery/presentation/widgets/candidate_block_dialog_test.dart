import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/core/errors/either.dart';
import 'package:raqamli_sovchi/core/errors/failure.dart';
import 'package:raqamli_sovchi/features/discovery/presentation/widgets/candidate_block_dialog.dart';
import 'package:raqamli_sovchi/features/profile/application/use_cases/block_user.dart';
import 'package:raqamli_sovchi/features/profile/domain/entities/blocked_user.dart';
import 'package:raqamli_sovchi/features/profile/domain/repositories/blocked_user_repository.dart';
import 'package:raqamli_sovchi/l10n/app_localizations.dart';

void main() {
  testWidgets('renders Figma block dialog elements and cancels', (
    tester,
  ) async {
    final repository = _FakeBlockedUserRepository();
    final useCase = BlockUserUseCase(repository);

    await tester.pumpWidget(
      _TestApp(
        child: CandidateBlockDialog(
          candidateId: 'user-1',
          candidateName: 'Mohira R.',
          blockUserUseCase: useCase,
        ),
      ),
    );

    expect(find.text('Mohira R. ni bloklaysizmi?'), findsOneWidget);
    expect(
      find.text(
        'U sizni ko‘rmaydi, siz ham uni ko‘rmaysiz. Bloklaganingizni o‘zi bilmaydi.',
      ),
      findsOneWidget,
    );
    expect(find.text('Suhbat yopiladi, yozishmalar saqlanadi'), findsOneWidget);
    expect(
      find.text('Saqlanganlar ro‘yxatidan olib tashlanadi'),
      findsOneWidget,
    );
    expect(
      find.text('Uning vakili ham siz bilan bog‘lana olmaydi'),
      findsOneWidget,
    );
    expect(find.text('Bloklash'), findsOneWidget);
    expect(find.text('Bekor qilish'), findsOneWidget);

    await tester.tap(find.text('Bekor qilish'));
    await tester.pumpAndSettle();

    expect(repository.blockedUserId, isNull);
  });

  testWidgets('triggers block request and returns true on success', (
    tester,
  ) async {
    final repository = _FakeBlockedUserRepository(
      result: const Right(
        BlockedUser(id: 'b-1', blocker: 'me', blocked: 'user-1'),
      ),
    );
    final useCase = BlockUserUseCase(repository);

    bool? dialogResult;

    await tester.pumpWidget(
      _TestApp(
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              dialogResult = await CandidateBlockDialog.show(
                context,
                candidateId: 'user-1',
                candidateName: 'Mohira R.',
                blockUserUseCase: useCase,
              );
            },
            child: const Text('Open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.text('Mohira R. ni bloklaysizmi?'), findsOneWidget);

    await tester.tap(find.text('Bloklash'));
    await tester.pumpAndSettle();

    expect(repository.blockedUserId, 'user-1');
    expect(dialogResult, isTrue);
  });
}

final class _FakeBlockedUserRepository implements BlockedUserRepository {
  _FakeBlockedUserRepository({this.result});

  Either<Failure, BlockedUser>? result;
  String? blockedUserId;
  String? reason;

  @override
  Future<Either<Failure, BlockedUser>> blockUser({
    required String blockedUserId,
    String? reason,
  }) async {
    this.blockedUserId = blockedUserId;
    this.reason = reason;
    return result ??
        Right(
          BlockedUser(
            id: 'block-1',
            blocker: 'me',
            blocked: blockedUserId,
            reason: reason,
          ),
        );
  }
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
      home: Scaffold(body: Center(child: child)),
    );
  }
}
