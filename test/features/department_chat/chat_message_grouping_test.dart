import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project1/features/department_chat/domain/entities/department_message_entity.dart';
import 'package:project1/features/department_chat/domain/entities/message_sender_entity.dart';
import 'package:project1/features/department_chat/domain/entities/message_type.dart';
import 'package:project1/features/department_chat/presentation/widgets/chat_message_bubble.dart';

void main() {
  testWidgets(
    'groups consecutive incoming messages with one name and trailing avatar',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                ChatMessageBubble(
                  key: const Key('first-message'),
                  message: _message('1', 'First'),
                  isMine: false,
                  isFirstInGroup: true,
                  isLastInGroup: false,
                ),
                ChatMessageBubble(
                  key: const Key('middle-message'),
                  message: _message('2', 'Middle'),
                  isMine: false,
                  isFirstInGroup: false,
                  isLastInGroup: false,
                ),
                ChatMessageBubble(
                  key: const Key('last-message'),
                  message: _message('3', 'Last'),
                  isMine: false,
                  isFirstInGroup: false,
                  isLastInGroup: true,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Alice Adams'), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);

      final middlePadding = tester.widget<Padding>(
        find
            .descendant(
              of: find.byKey(const Key('middle-message')),
              matching: find.byType(Padding),
            )
            .first,
      );
      expect(middlePadding.padding, const EdgeInsets.fromLTRB(12, 1, 12, 1));
    },
  );
}

DepartmentMessageEntity _message(String id, String content) {
  final timestamp = DateTime(2026, 1, 1, 12);
  return DepartmentMessageEntity(
    id: id,
    departmentId: 'department-id',
    type: MessageType.text,
    content: content,
    isEdited: false,
    isDeleted: false,
    createdAt: timestamp,
    updatedAt: timestamp,
    sender: const MessageSenderEntity(
      id: 'sender-id',
      firstName: 'Alice',
      lastName: 'Adams',
    ),
  );
}
