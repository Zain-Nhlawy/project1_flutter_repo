enum PasswordRequirement {
  minimumLength,
  lowercaseLetter,
  uppercaseLetter,
  digit,
  specialCharacter,
}

abstract final class PasswordValidator {
  static final RegExp _passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).{8,}$',
  );
  static final RegExp _lowercaseRegex = RegExp(r'[a-z]');
  static final RegExp _uppercaseRegex = RegExp(r'[A-Z]');
  static final RegExp _digitRegex = RegExp(r'\d');
  static final RegExp _specialCharacterRegex = RegExp(r'[@$!%*?&]');

  static bool isValid(String password) => _passwordRegex.hasMatch(password);

  static List<PasswordRequirement> missingRequirements(String password) {
    return [
      if (password.length < 8) PasswordRequirement.minimumLength,
      if (!_lowercaseRegex.hasMatch(password))
        PasswordRequirement.lowercaseLetter,
      if (!_uppercaseRegex.hasMatch(password))
        PasswordRequirement.uppercaseLetter,
      if (!_digitRegex.hasMatch(password)) PasswordRequirement.digit,
      if (!_specialCharacterRegex.hasMatch(password))
        PasswordRequirement.specialCharacter,
    ];
  }
}
