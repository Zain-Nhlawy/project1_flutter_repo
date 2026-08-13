class DepartmentPresenceModel {
  final Set<String> identifiers;

  const DepartmentPresenceModel({required this.identifiers});

  factory DepartmentPresenceModel.fromEvent(dynamic payload) {
    return DepartmentPresenceModel(identifiers: _identifiersFromValue(payload));
  }

  factory DepartmentPresenceModel.fromSnapshot(dynamic payload) {
    final identifiers = <String>{};
    _collectSnapshotIdentifiers(payload, identifiers);
    return DepartmentPresenceModel(identifiers: identifiers);
  }

  static const _identifierKeys = {
    'departmentMemberId',
    'memberId',
    'userId',
    'demoMemberId',
    'id',
  };

  static const _nestedIdentityKeys = {
    'departmentMember',
    'member',
    'user',
    'demoMember',
  };

  static const _snapshotKeys = {
    'onlineUsers',
    'onlineMembers',
    'usersOnline',
    'membersOnline',
    'connectedUsers',
    'connectedMembers',
    'onlineUserIds',
    'onlineMemberIds',
    'onlineDepartmentMemberIds',
  };

  static Set<String> _identifiersFromValue(dynamic value) {
    final identifiers = <String>{};
    _collectIdentifiers(value, identifiers);
    return identifiers;
  }

  static void _collectIdentifiers(dynamic value, Set<String> identifiers) {
    if (value is String) {
      if (value.isNotEmpty) identifiers.add(value);
      return;
    }

    if (value is List) {
      for (final item in value) {
        _collectIdentifiers(item, identifiers);
      }
      return;
    }

    if (value is! Map) return;

    for (final entry in value.entries) {
      final key = entry.key.toString();
      if (_identifierKeys.contains(key)) {
        final identifier = entry.value?.toString();
        if (identifier != null && identifier.isNotEmpty) {
          identifiers.add(identifier);
        }
      } else if (_nestedIdentityKeys.contains(key)) {
        _collectIdentifiers(entry.value, identifiers);
      }
    }
  }

  static void _collectSnapshotIdentifiers(
    dynamic value,
    Set<String> identifiers,
  ) {
    if (value is! Map) return;

    for (final entry in value.entries) {
      final key = entry.key.toString();
      if (_snapshotKeys.contains(key)) {
        _collectIdentifiers(entry.value, identifiers);
      } else if (key == 'data' || key == 'meta') {
        _collectSnapshotIdentifiers(entry.value, identifiers);
      }
    }
  }
}
