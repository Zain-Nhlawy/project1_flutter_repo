import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project1/features/department/data/models/department_member_model.dart';
import 'package:project1/features/department/domain/entities/department_member_entity.dart';
import 'package:project1/features/department_chat/data/models/department_presence_model.dart';
import 'package:project1/features/department_chat/domain/entities/department_member_presence.dart';
import 'package:project1/features/department_chat/presentation/widgets/online_members_header.dart';
import 'package:project1/l10n/app_localizations.dart';

void main() {
  group('presence identity normalization', () {
    test('reads all supported identifiers from a presence event', () {
      final presence = DepartmentPresenceModel.fromEvent({
        'departmentMemberId': 'department-member-id',
        'demoMemberId': 'demo-member-id',
        'user': {'id': 'user-id'},
      });

      expect(
        presence.identifiers,
        containsAll({'department-member-id', 'demo-member-id', 'user-id'}),
      );
    });

    test('reads the initial online roster from a join response', () {
      final presence = DepartmentPresenceModel.fromSnapshot({
        'data': {
          'onlineMembers': [
            {'departmentMemberId': 'member-1'},
            {'userId': 'user-2'},
          ],
        },
      });

      expect(presence.identifiers, {'member-1', 'user-2'});
    });

    test('matches presence by department, demo, or user member ID', () {
      final member = _member(
        id: 'department-member-id',
        firstName: 'Alice',
        lastName: 'Adams',
      );

      expect(
        DepartmentMemberPresence.isOnline(member, {'department-member-id'}),
        isTrue,
      );
      expect(
        DepartmentMemberPresence.isOnline(member, {'demo-${member.id}'}),
        isTrue,
      );
      expect(
        DepartmentMemberPresence.isOnline(member, {'user-${member.id}'}),
        isTrue,
      );
      expect(DepartmentMemberPresence.identifiersOf(member), {
        'department-member-id',
        'demo-department-member-id',
        'user-department-member-id',
      });
    });
  });

  test('department members without profile photos remain valid', () {
    final member = DepartmentMemberModel.fromJson({
      'id': 'member-1',
      'departmentId': 'department-id',
      'jobTitle': 'Developer',
      'demoMember': {
        'id': 'demo-member-id',
        'user': {
          'id': 'user-id',
          'firstName': 'Alice',
          'lastName': 'Adams',
          'email': 'alice@example.com',
          'imagePath': null,
        },
      },
    });

    expect(member.imagePath, isEmpty);
  });

  testWidgets('shows the online count and member details', (tester) async {
    final members = [
      _member(id: 'member-1', firstName: 'Alice', lastName: 'Adams'),
      _member(id: 'member-2', firstName: 'Bob', lastName: 'Brown'),
    ];

    await tester.pumpWidget(_app(OnlineMembersHeader(members: members)));

    expect(find.text('2 online'), findsOneWidget);

    await tester.tap(find.text('2 online'));
    await tester.pumpAndSettle();

    expect(find.text('Online members'), findsOneWidget);
    expect(find.text('Alice Adams'), findsOneWidget);
    expect(find.text('Bob Brown'), findsOneWidget);
  });

  testWidgets('shows zero when no presence events have been received', (
    tester,
  ) async {
    await tester.pumpWidget(
      const _LocalizedTestApp(child: OnlineMembersHeader(members: [])),
    );

    expect(find.text('0 online'), findsOneWidget);
    await tester.tap(find.text('0 online'));
    await tester.pumpAndSettle();
    expect(find.text('Online members'), findsNothing);
  });
}

Widget _app(Widget child) => _LocalizedTestApp(child: child);

class _LocalizedTestApp extends StatelessWidget {
  final Widget child;

  const _LocalizedTestApp({required this.child});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );
  }
}

DepartmentMemberEntity _member({
  required String id,
  required String firstName,
  required String lastName,
}) {
  return DepartmentMemberEntity(
    id: id,
    departmentId: 'department-id',
    jobTitle: 'Developer',
    demoMemberId: 'demo-$id',
    userId: 'user-$id',
    firstName: firstName,
    lastName: lastName,
    email: '$firstName@example.com',
    imagePath: '',
  );
}
