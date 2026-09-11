import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/features/chat/domain/entities/chat_message.dart';
import 'package:raqamli_sovchi/features/chat/presentation/widgets/chat_message_bubble.dart';

void main() {
  testWidgets('swiping a message left selects it for reply', (tester) async {
    var replySelected = false;
    final message = ChatMessage(
      id: 'message-1',
      chatRoomId: 'room-1',
      senderId: 'user-1',
      content: 'Salom',
      isRead: true,
      createdAt: DateTime.utc(2026),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChatMessageBubble(
            message: message,
            isMine: false,
            replyLabel: 'Reply',
            onReply: () => replySelected = true,
            onQuotedMessagePressed: () {},
          ),
        ),
      ),
    );

    await tester.dragFrom(
      tester.getCenter(find.text('Salom')),
      const Offset(-200, 0),
    );
    await tester.pumpAndSettle();

    expect(replySelected, isTrue);
  });
}
