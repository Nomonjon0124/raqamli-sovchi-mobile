import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/core/ui/widgets/app_toast.dart';

void main() {
  testWidgets('AppToast renders message inside SnackBar', (tester) async {
    const testMessage =
        "Yuz aniqlanmadi. Iltimos, kameraga to'g'ri qarab qayta urinib ko'ring.";

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  AppToast.show(
                    context,
                    message: testMessage,
                    type: ToastType.error,
                  );
                },
                child: const Text('Show Toast'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show Toast'));
    await tester.pumpAndSettle();

    expect(find.text(testMessage), findsOneWidget);
  });
}
