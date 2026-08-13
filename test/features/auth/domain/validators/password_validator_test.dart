import 'package:flutter_test/flutter_test.dart';
import 'package:project1/features/auth/domain/validators/password_validator.dart';

void main() {
  group('PasswordValidator', () {
    test('accepts a password that satisfies the password policy', () {
      expect(PasswordValidator.isValid('Password1!'), isTrue);
    });

    test('rejects passwords that do not satisfy the password policy', () {
      const invalidPasswords = [
        'Pass1!',
        'PASSWORD1!',
        'password1!',
        'Password!',
        'Password1',
        'Password1#',
      ];

      for (final password in invalidPasswords) {
        expect(
          PasswordValidator.isValid(password),
          isFalse,
          reason: '$password should not satisfy the password policy',
        );
      }
    });

    test('reports each missing password requirement', () {
      expect(PasswordValidator.missingRequirements('password'), [
        PasswordRequirement.uppercaseLetter,
        PasswordRequirement.digit,
        PasswordRequirement.specialCharacter,
      ]);
    });
  });
}
