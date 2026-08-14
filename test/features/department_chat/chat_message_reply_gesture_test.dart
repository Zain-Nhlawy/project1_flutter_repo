import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project1/features/department_chat/domain/entities/department_message_entity.dart';
import 'package:project1/features/department_chat/domain/entities/message_sender_entity.dart';
import 'package:project1/features/department_chat/domain/entities/message_type.dart';
import 'package:project1/features/department_chat/presentation/widgets/chat_message_bubble.dart';

void main() {
  Widget buildBubble({required bool isMine, required VoidCallback onReply}) {
    return MaterialApp(
      home: Scaffold(
        body: ChatMessageBubble(
          message: _message,
          isMine: isMine,
          onReply: onReply,
          onEdit: () {},
          onDelete: () {},
        ),
      ),
    );
  }

  testWidgets('swiping a message to the left starts a reply', (tester) async {
    var replyCount = 0;
    await tester.pumpWidget(
      buildBubble(isMine: false, onReply: () => replyCount++),
    );

    await tester.drag(find.text('Hello'), const Offset(-180, 0));
    await tester.pumpAndSettle();

    expect(replyCount, 1);
    expect(find.byType(ChatMessageBubble), findsOneWidget);
  });

  testWidgets('left swipe distance is capped before snapping back', (
    tester,
  ) async {
    var replyCount = 0;
    await tester.pumpWidget(
      buildBubble(isMine: false, onReply: () => replyCount++),
    );
    final messageFinder = find.text('Hello');
    final startingX = tester.getCenter(messageFinder).dx;
    final gesture = await tester.startGesture(tester.getCenter(messageFinder));

    await gesture.moveBy(const Offset(-300, 0));
    await tester.pump();

    final dragDistance = startingX - tester.getCenter(messageFinder).dx;
    expect(dragDistance, greaterThan(0));
    expect(dragDistance, lessThanOrEqualTo(68.5));

    await gesture.up();
    await tester.pumpAndSettle();
    expect(replyCount, 1);
  });

  testWidgets('swiping a message to the right does not start a reply', (
    tester,
  ) async {
    var replyCount = 0;
    await tester.pumpWidget(
      buildBubble(isMine: false, onReply: () => replyCount++),
    );

    await tester.drag(find.text('Hello'), const Offset(180, 0));
    await tester.pumpAndSettle();

    expect(replyCount, 0);
  });

  testWidgets('long press menu no longer includes reply', (tester) async {
    await tester.pumpWidget(buildBubble(isMine: true, onReply: () {}));

    await tester.longPress(find.text('Hello'));
    await tester.pumpAndSettle();

    expect(find.text('Reply'), findsNothing);
    expect(find.text('Edit'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);
  });
}

final _message = DepartmentMessageEntity(
  id: 'message-id',
  departmentId: 'department-id',
  type: MessageType.text,
  content: 'Hello',
  isEdited: false,
  isDeleted: false,
  createdAt: DateTime(2026, 1, 1, 12),
  updatedAt: DateTime(2026, 1, 1, 12),
  sender: const MessageSenderEntity(
    id: 'sender-id',
    firstName: 'Alice',
    lastName: 'Adams',
  ),
);
