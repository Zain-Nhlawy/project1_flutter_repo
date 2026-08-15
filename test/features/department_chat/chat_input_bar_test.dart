import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project1/features/department_chat/domain/entities/department_message_entity.dart';
import 'package:project1/features/department_chat/domain/entities/message_sender_entity.dart';
import 'package:project1/features/department_chat/domain/entities/message_type.dart';
import 'package:project1/features/department_chat/presentation/widgets/chat_input_bar.dart';

void main() {
  Widget buildChatInput({
    required ChatSubmitCallback onSubmit,
    DepartmentMessageEntity? replyingToMessage,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: ChatInputBar(
          replyingToMessage: replyingToMessage,
          onSubmit: onSubmit,
          onTyping: (_) {},
          onAttachmentSelected: (_) {},
          onRemoveAttachment: () {},
          onCancelReply: () {},
          onCancelEdit: () {},
        ),
      ),
    );
  }

  testWidgets('keeps focus while sending from the send button', (tester) async {
    final submission = Completer<bool>();

    await tester.pumpWidget(buildChatInput(onSubmit: (_) => submission.future));
    await tester.showKeyboard(find.byType(TextField));
    await tester.enterText(find.byType(TextField), 'Hello');

    await tester.tap(find.byIcon(Icons.send_rounded));
    await tester.pump();

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.focusNode, isNotNull);
    expect(field.focusNode!.hasFocus, isTrue);

    submission.complete(true);
    await tester.pump();
  });

  testWidgets('keeps focus when the keyboard send action is used', (
    tester,
  ) async {
    final submission = Completer<bool>();

    await tester.pumpWidget(buildChatInput(onSubmit: (_) => submission.future));
    await tester.showKeyboard(find.byType(TextField));
    await tester.enterText(find.byType(TextField), 'Hello');

    await tester.testTextInput.receiveAction(TextInputAction.send);
    await tester.pump();

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.focusNode, isNotNull);
    expect(field.focusNode!.hasFocus, isTrue);

    submission.complete(true);
    await tester.pump();
  });

  testWidgets('focuses the composer when a reply begins', (tester) async {
    Future<bool> submit(String _) async => true;

    await tester.pumpWidget(buildChatInput(onSubmit: submit));
    var field = tester.widget<TextField>(find.byType(TextField));
    expect(field.focusNode!.hasFocus, isFalse);

    await tester.pumpWidget(
      buildChatInput(onSubmit: submit, replyingToMessage: _replyMessage),
    );
    await tester.pump();

    field = tester.widget<TextField>(find.byType(TextField));
    expect(field.focusNode!.hasFocus, isTrue);
  });

  testWidgets('keeps focus when a sent reply clears reply mode', (
    tester,
  ) async {
    final submission = Completer<bool>();
    Future<bool> submit(String _) => submission.future;

    await tester.pumpWidget(
      buildChatInput(onSubmit: submit, replyingToMessage: _replyMessage),
    );
    await tester.showKeyboard(find.byType(TextField));
    await tester.enterText(find.byType(TextField), 'Reply text');
    await tester.tap(find.byIcon(Icons.send_rounded));
    await tester.pump();
    final editableTextBeforeReplyClears = tester.state<EditableTextState>(
      find.byType(EditableText),
    );

    await tester.pumpWidget(buildChatInput(onSubmit: submit));
    await tester.pump();

    var field = tester.widget<TextField>(find.byType(TextField));
    expect(field.focusNode!.hasFocus, isTrue);
    expect(
      tester.state<EditableTextState>(find.byType(EditableText)),
      same(editableTextBeforeReplyClears),
    );
    expect(tester.testTextInput.isVisible, isTrue);

    submission.complete(true);
    await tester.pump();
    await tester.pump();

    field = tester.widget<TextField>(find.byType(TextField));
    expect(field.focusNode!.hasFocus, isTrue);
    expect(tester.testTextInput.isVisible, isTrue);
  });
}

final _replyMessage = DepartmentMessageEntity(
  id: 'reply-message-id',
  departmentId: 'department-id',
  type: MessageType.text,
  content: 'Original message',
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
