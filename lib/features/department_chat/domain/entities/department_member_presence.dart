import '../../../department/domain/entities/department_member_entity.dart';

class DepartmentMemberPresence {
  const DepartmentMemberPresence._();

  static bool isOnline(
    DepartmentMemberEntity member,
    Set<String> onlineIdentifiers,
  ) {
    return identifiersOf(member).any(onlineIdentifiers.contains);
  }

  static Set<String> identifiersOf(DepartmentMemberEntity member) {
    return {member.id, member.demoMemberId, member.userId}
      ..removeWhere((identifier) => identifier.isEmpty);
  }
}
