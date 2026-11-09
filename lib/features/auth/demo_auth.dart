abstract final class DemoAuth {
  static const verificationCode = '12345678';

  static bool isValidEmail(String value) =>
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim());

  static bool isValidCode(String value) => value.trim() == verificationCode;
}
